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
    
    PVector pos;            //Will stay constant, even though the planet it is on is rotating -> this is a relative pos
    PVector drillPoint;     //FINAL point for the drill, where it is travelling to
    PVector statusCol = activeCol;

    spaceBody linkedBody;   //The body this outpost is stationed on

    ArrayList<PVector> drillTargets = new ArrayList<PVector>();
    cargoTank cCargo = new cargoTank(5000.0);
    float angleOffsetRange = PI/6.0;            //Max absolute angle offset from the normal that is allow

    outpost(PVector pos, spaceBody linkedBody){
        this.pos = pos;
        this.linkedBody = linkedBody;
    }

    //## FOR BUGFIXING
    void displayTargets(){
        float nodeSize = 15.0;
        pushStyle();
        for(int j=0; j<linkedBody.mineralSet.size(); j++){
            for(int i=0; i<linkedBody.mineralSet.get(j).size(); i++){
                if(linkedBody.mineralSet.get(j).get(i) != null){
                    fill(255,255,255);
                    ellipse(odeSize*i, nodeSize*j, nodeSize, nodeSize);
                }
            }
        }
        for(int i=0; i<drillTarget.size(); i++){
            fill(255,100,100);
            ellipse(nodeSize*drillTarget.get(i).x, nodeSize*drillTarget.get(i).y, nodeSize, nodeSize);
        }
        popStyle();
    }
    //## FOR BUGFIXING

    
    PVector getRealPos(){
        /*
        Returns the PHYSICAL location this outpost is at, NOT its RELATIVE position
        */
        PVector newPos = new PVector(pos.x +linkedBody.pos.x, pos.y +linkedBody.pos.y);
        //## ACCOUNT FOR ROTATION NOW ##
        return newPos;
    }
    void calcDrillTargets(){
        /*
        1. Go through all minerals in the body
        2. Go through each of their sides and check for Line-Line collision (other line being drill)
        3. Mark all successful collisions
        4. Now order the minerals (by distance from centres should be enough)
        5. Add to the drillTarget list
        */
        drillTargets.clear();
        ArrayList<PVector> drillTargetBuffer = new ArrayList<PVector>();
        //1
        boolean collisionOccurs = false;
        for(int j=0; j<linkedBody.mineralSet.size(); j++){
            for(int i=0; i<linkedBody.mineralSet.get(j).size(); i++){
                if(linkedBody.mineralSet.get(j).get(i) != null){
                    //2
                    PVector p1 = new PVector(); //Top-Left, Going around CW
                    PVector p2 = new PVector();
                    PVector p3 = new PVector();
                    PVector p4 = new PVector();
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
                        drillTargetBuffer.add(new PVector(i,j));
                    }
                }
            }
        }
        //4
        ArrayList<Float> distBuffer = new ArrayList<Float>();
        for(int i=0; i<drillTargetBuffer.size(); i++){
            float dist = .. at j;
            boolean isSorted = false;
            for(int j=0; j<distBuffer.size(); j++){             //Add to list in correct place (smallest to largest)
                if(dist < ... at distBuffer.get(j)){                   //
                    distBuffer.add(j, j);                    //
                    isSorted = true;                            //
                    break;                                      //
                }                                               //
            }                                                   //
            if(i == 0 || !isSorted){        //Initialise
                distBuffer.add(dist);}      //
        }
        //5
        for(int i=0; i<distBuffer){
            drillTarget.add( drillTargetBuffer.get(distBuffer.get(i)) );
        }
    }
    void drillStep(){
        /*
        Performs one 'drill action', which will result in a certain amount of material being 
        drill up (depends on material type)
        Once the material is entirely drilled, a step will drill the next target
        Once all targets are drilled, nothing will occur

        1. Remove some material
        2. Count any overcount
        3. Mine into next section by overcount
        */
        //pass
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
        //pass
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
                duplicateFound = true;
                break;
            }
        }
        if(!duplicateFound){
            storedMinerals.add(cMineral);
        }
    }
}