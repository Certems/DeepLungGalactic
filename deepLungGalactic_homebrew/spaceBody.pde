class spaceBody{
    /*
    Planets, comets, asteroids, etc that can be encountered
    Probes are NOT considered spaceBodies
    Most spaceBodies will have very small rotations that should be kept track of by the 
    player (through repeated sensor readings) to ensure drilling occurs where expected
    *All bodies are circular (as of the current state of the game)
    */
    PVector pos;
    PVector vel;
    PVector acc;

    float radius;
    float angMomentum;
    float coreTempMax = 5000.0;
    float coreTemp;         //Central temperature of body's core
    String tempFalloffType; //How the temperature of the core is reflected as a function of distance

    ArrayList<alienNest> alienNests = new ArrayList<alienNest>();
    ArrayList<ArrayList<mineral>> mineralSet = new ArrayList<ArrayList<mineral>>();
    int sizeOfMineralDepo = 20;     //How many cells in width and height of the bounding box for the body
    float mineralCellWidth;         //Size in terms of AU of each cell
    float mass;
    float planetStrengthOffset;

    spaceBody(PVector pos, PVector vel, PVector acc, float radius, float radiusMax, float angMomentum){
        this.pos = pos;
        this.vel = vel;
        this.acc = acc;
        this.radius = radius;
        this.angMomentum = angMomentum;
        planetStrengthOffset = random(0.0, 1.5);
        coreTemp = coreTempMax*(radius/radiusMax);
        tempFalloffType = "r^-2";
        mineralCellWidth = (2.0*radius) / (sizeOfMineralDepo);
        mass = 1.0*pow(radius, 3);
        
        generateAlienNests( floor(random(0.0, 5.0)) );
        generateMinerals(floor(random(5,8)));
    }

    PVector calcGravity(PVector point){
        /*
        Calculates the gravitational force produced (by this body only) at a given point
        There is another function which sums the combiend gravity from all spaceBodies

        ################################################
        ## ALMOST 100% WILL REQUIRE LOGARITHMIC MATHS ##
        ################################################
        
        Also, is not actually force, force on the probe will come by multiplying by ITS mass
        */
        PVector uDir = vec_unitDir(point, pos);  //Towards the planet
        float mag = getGravityMag(point, pos, mass);
        PVector force = new PVector(mag*uDir.x, mag*uDir.y);
        return force;
    }
    float calcRemainingWealth(stockRecords cStockRecords){
        float totalValue = 0.0;
        for(int j=0; j<mineralSet.size(); j++){
            for(int i=0; i<mineralSet.get(j).size(); i++){
                if(mineralSet.get(j).get(i) != null){
                    totalValue += mineralSet.get(j).get(i).quantity*cStockRecords.stockExchange.getValue( mineralSet.get(j).get(i).name ).get(0);
                }
            }
        }
        return totalValue;
    }
    void generateAlienNests(int nestNumber){
        alienNests.clear();
        float nestSizeMax = 0.15;
        for(int i=0; i<nestNumber; i++){
            float theta     = random(0.0, 2.0*PI);
            float spawnDist = random(0.1*radius, 0.9*radius);
            float nestSize  = random(0.1*nestSizeMax, nestSizeMax);
            alienNest newNest = new alienNest( new PVector(spawnDist*cos(theta), spawnDist*sin(theta)), nestSize, nestSizeMax);
            alienNests.add(newNest);
        }
    }
    void generateMinerals(int nodeNumber){
        /*
        ####
        ## ADD TYPES, SO CAN ALTER SPAWN CONDITIONS BASED ON THE VARIETY OF SPACE BODY THIS IS
        ####
        Use continuous functions to generate a map from 0.0 to 1.0 values.
        These are then binned to form a grid of minerals within the body, which is stored and adjusted permenantly
        Mining is also kept discrete within these boxes

        Method 1;
        0. Init as empty
        1. Create X nodes within the bounding box
        2. From each, expand out radial values decreasing (varying strength and range)
        3. Place each into binned areas
        4. Trim zones outside the planet perimeter
        5. Add minerals to the system, rather than placeholder values
        */
        ArrayList<ArrayList<Float>> mineralSet_gen_t = new ArrayList<ArrayList<Float>>(); //Used only for generation --> type
        ArrayList<ArrayList<Float>> mineralSet_gen_q = new ArrayList<ArrayList<Float>>(); //Used only for generation --> quantity
        //0
        for(int j=0; j<sizeOfMineralDepo; j++){
            mineralSet_gen_t.add(new ArrayList<Float>());
            mineralSet_gen_q.add(new ArrayList<Float>());
            for(int i=0; i<sizeOfMineralDepo; i++){
                mineralSet_gen_t.get(j).add(0.0);
                mineralSet_gen_q.get(j).add(0.0);
            }
        }
        //1
        float intervalJump = mineralCellWidth;
        for(int p=0; p<nodeNumber; p++){
            //2
            float range     = random(0.2*radius, 0.8*radius);
            float strength  = random(0.0, 2.0) +planetStrengthOffset;
            float quantity  = random(60.0, 100.0);
            PVector nodeCentre = new PVector(random(0, 2.0*radius), random(0, 2.0*radius));
            //3
            for(int j=0; j<mineralSet_gen_t.size(); j++){
                for(int i=0; i<mineralSet_gen_t.get(j).size(); i++){
                    PVector rawCoord = new PVector(i*intervalJump, j*intervalJump);     //From binned coord, takes centre of the box value -> relative to centre of the body-
                    float newValue_t = strength*calcFalloff("r^-2", nodeCentre, rawCoord);   //Use raw coord
                    float oldValue_t = mineralSet_gen_t.get(j).get(i);
                    mineralSet_gen_t.get(j).remove(i);
                    mineralSet_gen_t.get(j).add(i, newValue_t +oldValue_t);

                    float newValue_q = quantity*calcFalloff("r^-2", nodeCentre, rawCoord);   //Use raw coord
                    float oldValue_q = mineralSet_gen_q.get(j).get(i);
                    mineralSet_gen_q.get(j).remove(i);
                    mineralSet_gen_q.get(j).add(i, newValue_q +oldValue_q);
                }
            }
        }
        //4
        mineralSet.clear();
        for(int j=0; j<mineralSet_gen_t.size(); j++){
            mineralSet.add( new ArrayList<mineral>() );
            for(int i=0; i<mineralSet_gen_t.get(j).size(); i++){
                PVector rawCoord = new PVector((i+0.5)*intervalJump, (j+0.5)*intervalJump);
                float dist = vec_mag(vec_dir(rawCoord, new PVector(radius, radius)));
                boolean insideBody = (dist < radius);  //If is within circlular zone inside bounding box
                //5
                mineral givenMineral;
                if(insideBody){
                    givenMineral = convertValueToMineral(mineralSet_gen_t.get(j).get(i)); //## CONVERT VALUE TO MINERAL USING LIST, SO IS GENERAL
                    givenMineral.quantity = mineralSet_gen_q.get(j).get(i);}
                else{
                    givenMineral = null;}
                mineralSet.get(j).add(givenMineral);
            }
        }
    }
    mineral convertValueToMineral(float value){
        /*
        Larger values will => larger quantities due to additive nature of generatation currently
        #####################################################################################
        ### CONVERT TO DICTIONARY USAGE --> WILL REQUIRE GENERATION VALUES TO BE ADJUSTED ###
        #####################################################################################
        */
        if(value < 0.5){
            forbicite newMineral = new forbicite();
            return newMineral;}
        else if(value < 0.9){
            crestulin newMineral = new crestulin();
            return newMineral;}
        else if(value < 1.5){
            traen04 newMineral = new traen04();
            return newMineral;}
        else if(value < 2.1){
            tickline newMineral = new tickline();
            return newMineral;}
        else if(value < 3.5){
            gaiaite newMineral = new gaiaite();
            return newMineral;}
        else if(value < 4.0){
            chronosilicate newMineral = new chronosilicate();
            return newMineral;}
        else if(value < 5.3){
            astridium newMineral = new astridium();
            return newMineral;}
        else{
            hyperflex newMineral = new hyperflex();
            return newMineral;}
    }
    boolean isCollidingWithBody(PVector point, float relief){
        /*
        Checks if a point is within the circular zone of this celestial body
        Used for collision
        "relief" is the radius around the point that will also trigger a collision
        ##############################################
        ## MAY HAVE PROBLEMS WITH LOGARITHMIC MATHS ##
        ##############################################
        */
        float dist = vec_mag(vec_dir(point, pos));
        return ( dist <= (radius+relief) );
    }


    //## BUG FIXING ##
    void displayMineralProfile(){
        PVector startPos = new PVector(width/4.0, height/4.0);
        float cellSize = 15.0;
        pushStyle();
        textSize(cellSize);
        textAlign(CENTER, CENTER);
        for(int j=0; j<mineralSet.size(); j++){
            for(int i=0; i<mineralSet.get(j).size(); i++){
                if(mineralSet.get(j).get(i) != null){
                    fill(mineralSet.get(j).get(i).colour.x, mineralSet.get(j).get(i).colour.y, mineralSet.get(j).get(i).colour.z, mineralSet.get(j).get(i).calcTransparency());
                    text("%", startPos.x +i*cellSize, startPos.y +j*cellSize);
                }
            }
        }
        popStyle();
    }
    //## BUG FIXING ##
}

float getGravityMag(PVector p1, PVector p2, float m2){
    //My own adjusted version for gameplay purposes, much more close range
    float constant = 1.5*pow(10, -5);       //WAS 2 NOw ...
    float dist     = vec_mag(vec_dir(p1, p2));
    return constant*m2*exp(-0.05*pow(dist,2));   //**Adjust values
}

class alienNest{
    /*
    Where aliens attack from
    The proximity of this to an outpost determines how quickly it will 'chase' the outpost (+a bit of randomness)

    Digging through a nest will play a sound and dramatically increase a nest's chase speed
    
    pos  = relative position to the centre of the body it is located on
    size = determines how quickly they chase outposts
    */
    boolean isDrilled = false;

    PVector pos;
    float size;
    float chase = 0.0;

    float tempMax = 2000.0;
    float temp = 0.0;
    float drillFactor = 3.0;    //Once drilled, the chase of this nest will be multipled by this factor (can only be applied ONCE)

    alienNest(PVector pos, float size, float sizeMax){
        this.pos = pos;
        this.size = size;

        temp = tempMax*(size/sizeMax);
        calcInitChase();
    }

    void calcInitChase(){
        /*
        This is the initial chase
        This is only set at creation
        Once this nest is drilled through, the current chase will be multiplied and left alone

        chase*(1/dist) => outpost progress
        */
        float modifier = 0.01;
        chase = modifier*size;
    }
}