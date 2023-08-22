float stdDigQuantity = 0.5;             //Standard dig quantity -> what dig multipliers are applied to to determine quantity dug

class outpost{
    /*
    A stationary form of a probe
    These are created when a probe lands on a planet, and they have a pos relative to a planet BEFORE rotations 
    are applied, so when ACTUAL POSITIONS are asked for, this object must first ask its linked planet what its 
    rotation is
    Note that this approach also makes mining very easy, as the actual mining occurs in a stationary frame, but when viewed 
    can be seen to be rotating

    Mining works as follows;
    1. The outpost can set an angle (within a range) relative to the normal that they want to drill at
    2. The drill then will calculate which tiles in the planet the drillhead will pass through
    3. These coordinates on the planet (that will be drilled) are then added to 'drillTargets'
    4. The drill will then work through this list, mining at a speed relative to the [material type] and the [quantity] of material there
    5. All drilled material will be added to cargoTank, and will be removed from planet (so mineral scans will show empty space)
    *Note; Once the drill angle has been chosen on the slider, and drilling has commenced, it cannot be changed
    */
    int ID = floor(random(1000000,9999999));

    boolean locked         = false; //Locking stops drilling, but makes you immune to aliens (resistance wont go down)
    boolean drillAngChosen = false;
    boolean isDrilling     = false;
    boolean isTransporting = false;
    int drillCounter  = 0;
    int drillInterval = 5;  //How many frames before a drillStep occurs
    int transportCounter  = 0;
    int transportInterval = 60;
    
    PVector pos;            //Will stay constant, even though the planet it is on is rotating -> this is a relative pos
    PVector drillPoint;     //FINAL point for the drill, where it is travelling to (starting FROM pos)
    PVector statusCol = activeCol;

    spaceBody linkedBody;   //The body this outpost is stationed on

    ArrayList<PVector> drillTargets = new ArrayList<PVector>();
    cargoTank cCargo = new cargoTank(5000.0);
    float angleOffsetRange = PI/16.0;       //Max absolute angle offset from the normal that is allow
    float angleOffset = PI/20.0;
    float drillPower  = 1.0;                //Relates quantity drilled to the material type

    float resistance = 100.0;   //How much it can resist chase from aliens -> this number is wittled down

    interactable miningSlider = new interactable("slider");

    outpost(PVector pos, spaceBody linkedBody){
        this.pos = pos;
        this.linkedBody = linkedBody;
    }

    //## FOR BUGFIXING
    void displayTargets(){
        float nodeSize = 10.0;
        pushStyle();
        fill(180,180,180);
        for(int j=0; j<linkedBody.mineralSet.size(); j++){
            for(int i=0; i<linkedBody.mineralSet.get(j).size(); i++){
                if(linkedBody.mineralSet.get(j).get(i) != null){
                    ellipse(nodeSize*(i+1), nodeSize*(j+1), nodeSize, nodeSize);
                }
            }
        }
        for(int i=0; i<drillTargets.size(); i++){
            float factor = 1.0 -float(i)/drillTargets.size();
            fill(255,60,60, 200.0*factor +50.0);
            ellipse(nodeSize*drillTargets.get(i).x +nodeSize, nodeSize*drillTargets.get(i).y +nodeSize, nodeSize, nodeSize);
            textSize(15);
            fill(0,0,0);
            textAlign(CENTER, CENTER);
            text(i,nodeSize*drillTargets.get(i).x +nodeSize, nodeSize*drillTargets.get(i).y +nodeSize);
        }
        float AuToPixelSF = nodeSize/linkedBody.mineralCellWidth;
        for(int i=0; i<linkedBody.alienNests.size(); i++){
            PVector position   = new PVector(linkedBody.alienNests.get(i).pos.x*AuToPixelSF +linkedBody.radius*AuToPixelSF, linkedBody.alienNests.get(i).pos.y*AuToPixelSF +linkedBody.radius*AuToPixelSF);
            PVector dimensions = new PVector(2.0*linkedBody.alienNests.get(i).size*AuToPixelSF, 2.0*linkedBody.alienNests.get(i).size*AuToPixelSF);
            fill(98, 50, 168);
            if(linkedBody.alienNests.get(i).isDrilled){
                fill(250,40,40);}
            noStroke();
            ellipse(position.x, position.y, dimensions.x, dimensions.y);
        }
        popStyle();
    }
    //## FOR BUGFIXING

    void calcAlienAttack(){
        /*
        Changes the outpost's resistance according to the nests located nearby
        This is checked roughly every 2 seconds => base resistanceLoss scaling off this
        
        1. Finds nests in range
        2. Finds distance to those nests
        3. Calculates culative resistance loss
        4. Adjust for loss
        */
        if(!locked){
            float resistanceSF = 3.4;
            float resistanceLoss = 0.0;
            //1&2
            float agroRange = 0.8*linkedBody.radius;
            for(int i=0; i<linkedBody.alienNests.size(); i++){
                float dist = vec_mag(vec_dir(pos, linkedBody.alienNests.get(i).pos));
                if(dist <= agroRange){
                    //3
                    resistanceLoss += resistanceSF*(1.0 -(dist/agroRange));
                }
            }
            //4
            resistance -= resistanceLoss;
        }
    }
    boolean nestsInRange(){
        boolean inRange = false;
        float agroRange = 0.8*linkedBody.radius;
        for(int i=0; i<linkedBody.alienNests.size(); i++){
            float dist = vec_mag(vec_dir(pos, linkedBody.alienNests.get(i).pos));
            if(dist <= agroRange){
                inRange = true;
                break;
            }
        }
        return inRange;
    }
    void calcDestruction(solarMap cSolarMap){
        if(resistance <= 0.0){
            cSolarMap.destroyOutpost(this);
            cManager.cFlightControls.generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
        }
    }
    void updateNestsDrilled(){
        /*
        Checks if a nest has been drilled
        Marked as you go, so same nest cannot be drilled twice
        Applies the chase multiplier if hasnt been drilled
        */
        if(drillTargets.size() > 0){       //If drilling has ACTUALLY started
            for(int i=0; i<linkedBody.alienNests.size(); i++){
                if(!linkedBody.alienNests.get(i).isDrilled){
                    PVector cDrillTargetCoord = new PVector(drillTargets.get(0).x*linkedBody.mineralCellWidth -linkedBody.radius, drillTargets.get(0).y*linkedBody.mineralCellWidth -linkedBody.radius);   //Coord (in relative coords to body centre) of CURRENT drill target
                    PVector drillDir = vec_unitDir(pos, drillPoint);
                    PVector perp_p1 = new PVector(linkedBody.alienNests.get(i).pos.x -linkedBody.alienNests.get(i).size*drillDir.y, linkedBody.alienNests.get(i).pos.y +linkedBody.alienNests.get(i).size*drillDir.x); //Find the line perpendicular to the drill, that spans the width of alien nest
                    PVector perp_q1 = new PVector(linkedBody.alienNests.get(i).pos.x +linkedBody.alienNests.get(i).size*drillDir.y, linkedBody.alienNests.get(i).pos.y -linkedBody.alienNests.get(i).size*drillDir.x);
                    boolean drillColliding = checkLineLineCollision(pos, cDrillTargetCoord, perp_p1, perp_q1);  //...With this nest
                    if(drillColliding){
                        linkedBody.alienNests.get(i).isDrilled = true;
                        linkedBody.alienNests.get(i).chase *= linkedBody.alienNests.get(i).drillFactor;
                    }
                }
            }
        }
    }
    void calcDrilling(){
        if(isDrilling){
            if(drillCounter >= drillInterval){
                drillStep();
                drillCounter = 0;}
            drillCounter++;
        }
    }
    PVector getRealPos(){
        /*
        Returns the PHYSICAL location this outpost is at, NOT its RELATIVE position
        */
        PVector newPos = new PVector(pos.x +linkedBody.pos.x, pos.y +linkedBody.pos.y);
        //## ACCOUNT FOR ROTATION NOW ##
        return newPos;
    }
    void setDrillDestination(){
        /*
        Places the drill target destination in the direction specified by;
        [normal angle] + [offset angle]
        Note; The distance in the given direction will overshoot the planet to ensure there are no problems
        */
        PVector normalDir   = new PVector(-pos.x/linkedBody.radius, -pos.y/linkedBody.radius);
        PVector adjustedDir = vec_rotate(normalDir, angleOffset);
        float mag = 3.0*linkedBody.radius;  //*Making sure to overshoot enough
        drillPoint = new PVector(pos.x +mag*adjustedDir.x, pos.y +mag*adjustedDir.y);
    }
    void calcDrillTargets(){
        /*
        0. Set drill destination
        1. Go through all minerals in the body
        2. Go through each of their sides and check for Line-Line collision (other line being drill)
        3. Mark all successful collisions
        4. Now order the minerals (by distance from centres should be enough)
        5. Add to the drillTarget list
        */
        drillTargets.clear();
        ArrayList<PVector> drillVecBuffer = new ArrayList<PVector>();
        //0
        setDrillDestination();
        //1
        for(int j=0; j<linkedBody.mineralSet.size(); j++){
            for(int i=0; i<linkedBody.mineralSet.get(j).size(); i++){
                if(linkedBody.mineralSet.get(j).get(i) != null){
                    boolean collisionOccurs = false;
                    //2 -> All relative to centre of the circle
                    PVector tileCentrePos = new PVector((i+0.5)*linkedBody.mineralCellWidth, (j+0.5)*linkedBody.mineralCellWidth);      //For the given tile
                    PVector p1 = new PVector(tileCentrePos.x -linkedBody.mineralCellWidth/2.0 -linkedBody.radius, tileCentrePos.y -linkedBody.mineralCellWidth/2.0 -linkedBody.radius);   //Top-Left, Going around CW
                    PVector p2 = new PVector(tileCentrePos.x +linkedBody.mineralCellWidth/2.0 -linkedBody.radius, tileCentrePos.y -linkedBody.mineralCellWidth/2.0 -linkedBody.radius);
                    PVector p3 = new PVector(tileCentrePos.x +linkedBody.mineralCellWidth/2.0 -linkedBody.radius, tileCentrePos.y +linkedBody.mineralCellWidth/2.0 -linkedBody.radius);
                    PVector p4 = new PVector(tileCentrePos.x -linkedBody.mineralCellWidth/2.0 -linkedBody.radius, tileCentrePos.y +linkedBody.mineralCellWidth/2.0 -linkedBody.radius);
                    //Top
                    if( checkLineLineCollision(p1, p2, pos, drillPoint) ){
                        collisionOccurs = true;}
                    //Right
                    if( checkLineLineCollision(p2, p3, pos, drillPoint) ){
                        collisionOccurs = true;}
                    //Bottom
                    if( checkLineLineCollision(p3, p4, pos, drillPoint) ){
                        collisionOccurs = true;}
                    //Left
                    if( checkLineLineCollision(p4, p1, pos, drillPoint) ){
                        collisionOccurs = true;}
                    //3
                    if(collisionOccurs){
                        drillVecBuffer.add(new PVector(i,j));
                    }
                }
            }
        }
        //4 -> Sorted into ASCENDING order
        ArrayList<Integer> distBuffer = new ArrayList<Integer>();
        for(int i=0; i<drillVecBuffer.size(); i++){
            float dist = findDrillDist( drillVecBuffer.get(i) );
            if(distBuffer.size() == 0){                 //If the list is empty, start it off with this
                distBuffer.add(i);}                     //
            else{
                boolean distSorted = false;
                for(int j=0; j<distBuffer.size(); j++){
                    if(dist < findDrillDist( drillVecBuffer.get(distBuffer.get(j)) )){       //If it is less than the max, place within list early
                        distSorted = true;              //
                        distBuffer.add(j, i);           //
                        break;                          //
                    }
                }
                if(!distSorted){                        //If is the largest so far, add to the end
                    distBuffer.add(i);}                 //
            }
        }
        //5
        for(int i=0; i<distBuffer.size(); i++){
            drillTargets.add( drillVecBuffer.get(distBuffer.get(i)) );
        }
    }
    float findDrillDist(PVector mineralCoord){
        /*
        Distance of a mineralCoord from the outpost's position
        */
        PVector tilePos = new PVector(linkedBody.mineralCellWidth*mineralCoord.x -linkedBody.radius, linkedBody.mineralCellWidth*mineralCoord.y -linkedBody.radius);
        return vec_mag(vec_dir(pos, tilePos));
    }
    void drillStep(){
        /*
        Performs one 'drill action', which will result in a certain amount of material being 
        drill up (depends on material type)
        Once the material is entirely drilled, a step will drill the next target
        Once all targets are drilled, nothing will occur

        0. Check able to drill
        1. Remove some material
        2.      Count any overcount                     -> May ignore for now, possibly include in future
        3.      Mine into next section by overcount     -  seems unnecessary for the time being
        4. Add material to cargTank if there is space
        5. Remove drill target if it contains no more material
        */
        //0
        if(drillTargets.size() > 0){
            //1
            mineral givenMineral = linkedBody.mineralSet.get( int(drillTargets.get(0).y) ).get( int(drillTargets.get(0).x) );       //WANT parse by reference
            float drillQuantity  = min(drillPower*(1.0*givenMineral.digDifficulty)*stdDigQuantity, givenMineral.quantity);    //Cannot over dig, Any excess dig is ignored
            givenMineral.quantity -= drillQuantity;
            //... Do this at some other point, not particularly necessary ...
            //4
            mineral collectedMineral = generateCopy_mineral(givenMineral);
            collectedMineral.quantity = min(cCargo.spaceRemaining(), drillQuantity);
            cCargo.storeMineral(collectedMineral);
            //5
            if(givenMineral.quantity <= 0.0){
                drillTargets.remove(0);}
        }
    }
    float findAngleOffset(PVector pos, PVector dim){
        /*
        Uses the givenSlider to find a related angle offset
        Ensures the offset is in the given range
        */
        float percent = miningSlider.findPercentage(pos, dim);
        float convertedPercent = 2.0*(percent-0.5);  //**Converts to a value from -1 to 1
        return angleOffsetRange*convertedPercent;
    }
    void transportMineralsToShip(stockRecords cStockRecords){
        transportCounter++;
        if(transportCounter >= transportInterval){
            transportStep(cStockRecords);
            transportCounter = 0;
        }
    }
    void transportStep(stockRecords cStockRecords){
        float transportRate = 100.0;
        if(locked){
            transportRate *= 0.5;}
        if(cCargo.storedMinerals.size() > 0){
            //println("step transporting...");
            item givenItem = mineralToItem(cCargo.storedMinerals.get(0));
            float movedQuantity = min(transportRate, cCargo.storedMinerals.get(0).quantity);
            givenItem.quantity = movedQuantity;
            cStockRecords.addItem(givenItem, cStockRecords.ship_inventory);
            mineral mineralRemoval = generateCopy_mineral(cCargo.storedMinerals.get(0));
            mineralRemoval.quantity = -movedQuantity;
            cCargo.storeMineral(mineralRemoval);
        }
    }

    void lockOutpost(){
        locked = true;
        isDrilling = false;
    }
}

class cargoTank{
    ArrayList<mineral> storedMinerals = new ArrayList<mineral>();   //Quantity and type held here
    float sizeOfTank;   //Total quantity that can be held

    cargoTank(float sizeOfTank){
        this.sizeOfTank = sizeOfTank;
    }

    void display(PVector pos, PVector dim){
        /*
        Display in a stacked arrangment, grouping each material, shown 
        as a fraction of the total capacity required
        pos = top-left
        dim = full width+height
        */
        float unitToPixelConversion = (dim.y) / (sizeOfTank);
        pushStyle();
        rectMode(CORNERS);
        //Minerals
        noStroke();
        float runningHeight = 0.0;
        for(int i=0; i<storedMinerals.size(); i++){
            float sectionHeight = storedMinerals.get(i).quantity*unitToPixelConversion;
            fill(storedMinerals.get(i).colour.x, storedMinerals.get(i).colour.y, storedMinerals.get(i).colour.z);
            rect(pos.x, pos.y +dim.y -(runningHeight +sectionHeight), pos.x +dim.x, pos.y +dim.y -(runningHeight));
            runningHeight += sectionHeight;
        }
        //Background
        imageMode(CORNER);
        image(texture_flight_mining_mineralTank, pos.x, pos.y);
        popStyle();
    }
    void display_simple(PVector pos, PVector dim){
        /*
        Display in a stacked arrangment, grouping each material, shown 
        as a fraction of the total capacity required
        pos = top-left
        dim = full width+height
        */
        float unitToPixelConversion = (dim.y) / (sizeOfTank);
        pushStyle();
        rectMode(CORNERS);
        //Background
        fill(90,90,90);
        stroke(50,50,50);
        strokeWeight(5);
        rect(pos.x, pos.y, pos.x +dim.x, pos.y +dim.y);
        //Minerals
        noStroke();
        float runningHeight = 0.0;
        for(int i=0; i<storedMinerals.size(); i++){
            float sectionHeight = storedMinerals.get(i).quantity*unitToPixelConversion;
            fill(storedMinerals.get(i).colour.x, storedMinerals.get(i).colour.y, storedMinerals.get(i).colour.z);
            rect(pos.x, pos.y +dim.y -(runningHeight +sectionHeight), pos.x +dim.x, pos.y +dim.y -(runningHeight));
            runningHeight += sectionHeight;
        }
        popStyle();
    }
    void storeMineral(mineral cMineral){
        /*
        Tries to store the given material
        If all space is used, then remaining material is dumped
        Will add to an original material if this is a duplicate (common occurance)
        */
        boolean duplicateFound = false;
        for(int i=0; i<storedMinerals.size(); i++){
            if(cMineral.name == storedMinerals.get(i).name){
                //Duplicate => sum quantities
                storedMinerals.get(i).quantity += cMineral.quantity;
                if(storedMinerals.get(i).quantity <= 0){
                    storedMinerals.remove(i);}
                duplicateFound = true;
                break;
            }
        }
        if(!duplicateFound && (cMineral.quantity > 0)){
            storedMinerals.add(cMineral);
        }
    }
    float spaceRemaining(){
        /*
        Returns how many units of material can still be stored in this cargoTank
        */
        float quantityUsed = 0.0;
        for(int i=0; i<storedMinerals.size(); i++){
            quantityUsed += storedMinerals.get(i).quantity;}
        return (sizeOfTank -quantityUsed);
    }
}