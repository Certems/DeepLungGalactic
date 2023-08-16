class sensorArray{
    /*
    ---------
    | X |   |
    |-------|
    |   |   |
    ---------
    A panel showing;
    1- Temperature readings AROUND the selected probe
    2- Mineral scans AROUND the given probe
    3- Sound  scans "" ""
    4- Distance scans "" ""
    5- Gravitational scans "" "" --> Important; Will be very hard to grasp environment without this as probes are being pulled wildly --> MAYBE MAKE MUCH MORE VISUAL-> Graph on axis + something else
    */
    ArrayList<button> buttonSet = new ArrayList<button>();
    
    PVector cornerPos;  //Top-Left corner defining the origin from which items in this panel are drawn
    PVector panelDim;   //The dimensions of this panel, which must contain all the panel's information

    ArrayList<ArrayList<Float>> sensorData = new ArrayList<ArrayList<Float>>();

    float resolvingPower = 30.0;   //Number of readings that will be taken in each direction OR the density of the heat grid formulated
    float sensorZoom = 1.0;        //Multiplier applied to the NORMALISATION of the given sensor reading -> Therefore when switching types, should still be roughly correct suze as is not a flat scale but affects the norm.
    int cDataType   = 0;           //Initialised
    int maxDataType = 5;

    //40 resPwr for distance
    //30 for temp sensor maybe

    sensorArray(PVector cornerPos, PVector panelDim){
        this.cornerPos = cornerPos;
        this.panelDim  = panelDim;
    }

    void display(){
        /*
        #######################################################################################
        ## NEEDS TO BE CONVERTED TO COMPOSE METHOD, DRAWING WHAT IS NEEDED, ONLY WHEN NEEDED ##
        #######################################################################################

        --> Could move to all translates and then remove the cornerPos needed in each display section
        */
        display_background();
        display_sensorData(sensorData, cDataType);

        //displayArray();   //## MINERAL BUG FIXING
    }
    void calc(){
        //pass
    }
    void sensor_mousePressed(){
        //pass
    }
    void sensor_mouseReleased(){
        //pass
    }


    void generate2Darray(){
        sensorData.clear();
        for(int j=0; j<30; j++){
            sensorData.add( new ArrayList<Float>() );
            for(int i=0; i<30; i++){
                sensorData.get(j).add( sqrt(pow(i,2) +pow(j,2)) / sqrt(900+900) );
            }
        }
    }


    void display_background(){
        pushStyle();
        rectMode(CORNER);
        fill(30,20,20);
        noStroke();
        rect(cornerPos.x, cornerPos.y, panelDim.x, panelDim.y);
        popStyle();
    }

    void recordReadings(probe cProbe, int dataType){
        /*
        Records data for the given data type, for the given probe
        */
        if(dataType == 1){
            //generate2Darray();
            recordReadings_temperature(cManager.cSolarMap, cProbe);
        }
        if(dataType == 2){
            recordReadings_mineral(cManager.cSolarMap, cProbe);
        }
        if(dataType == 3){
            recordReadings_sound(cManager.cSolarMap, cProbe);
        }
        if(dataType == 4){
            recordReadings_distance(cManager.cSolarMap, cProbe);
        }
        if(dataType == 5){
            recordReadings_gravity(cManager.cSolarMap, cProbe);
        }
    }

    void recordReadings_distance(solarMap cSolarMap, probe cProbe){
        /*
        Outputs a 1D array

        1. Use resolving power to find ang. interval to record at
        2. Move points outwards until bodies reached OR hit max distance
        3. Record distance of those points from initial launch location
        */
        ArrayList<dart> sensorDarts = new ArrayList<dart>();
        //1
        float angInterval = (2.0*PI) / (resolvingPower);
        for(int i=0; i<resolvingPower; i++){
            dart newDart = new dart(new PVector(cProbe.pos.x, cProbe.pos.y), new PVector(cos(i*angInterval), sin(i*angInterval)), -1.0);
            sensorDarts.add(newDart);
        }
        //2
        boolean allDartsResolved = false;
        while(!allDartsResolved){
            allDartsResolved = true;
            for(int i=0; i<sensorDarts.size(); i++){
                if(!sensorDarts.get(i).resolved){
                    float dist = vec_mag(vec_dir(sensorDarts.get(i).pos, cProbe.pos));
                    //Move the dart if unresolved
                    sensorDarts.get(i).move();
                    //If too far away, resolve it [Lost Contact]    -->Only do these if NOT YET resolved, NO double counting type beat
                    if(dist > cSolarMap.mapRadius/2.0){ //**Note; Ship always in centre of map
                        sensorDarts.get(i).resolved = true;
                        //Stored data left as [Unfound] -> -1.0
                    }
                    //If collides, resolve it [Reached Target]      -->"" ""
                    for(int j=0; j<cSolarMap.spaceBodies.size(); j++){
                        if( cSolarMap.spaceBodies.get(j).isCollidingWithBody(sensorDarts.get(i).pos, 0.0) ){
                            sensorDarts.get(i).resolved = true;
                            sensorDarts.get(i).storedData = dist;
                            break;
                        }
                    }
                }
            }
            for(int i=0; i<sensorDarts.size(); i++){
                if(!sensorDarts.get(i).resolved){
                    allDartsResolved = false;
                    break;
                }
            }
        }
        //3
        sensorData.clear();                         //Creates a 1D array
        sensorData.add(new ArrayList<Float>());     //
        for(int i=0; i<sensorDarts.size(); i++){
            sensorData.get(0).add( sensorDarts.get(i).storedData );
        }
    }
    void recordReadings_temperature(solarMap cSolarMap, probe cProbe){
        /*
        1. Create a blank area (in sensorData) of specified size (may be different to resolution the world works on)
        2. Add a temp -> noise close to 0 for general space
        3.1 Add a temp  -> temp of planets CORE with BOUNDING BOX in range
        3.2             -> temp from nests
        3.3             -> temp added together

        Temp of planets stored in planets
        */
        sensorData.clear();
        //1 && 2
        for(int j=0; j<resolvingPower; j++){
            sensorData.add(new ArrayList<Float>());
            for(int i=0; i<resolvingPower; i++){
                float newValue = random(0.0, cSolarMap.temp_noiseRange);
                sensorData.get(j).add(newValue);
            }
        }
        //3
        //Check all bodies
        for(int p=0; p<cSolarMap.spaceBodies.size(); p++){
            //If bounding boxes cross
            PVector expandedScanDim = new PVector(1.2*cProbe.scanDim.x, 1.2*cProbe.scanDim.y);
            PVector planetDim = new PVector(2.0*cSolarMap.spaceBodies.get(p).radius, 2.0*cSolarMap.spaceBodies.get(p).radius);
            boolean boundsCross = checkRectRectCollision(cProbe.pos, expandedScanDim, cSolarMap.spaceBodies.get(p).pos, planetDim); //Bounds of viewable screen and planet(+ some change for expanded heat range)
            if(boundsCross){
                //Evaluate across whole screen
                float sizeOfX_Interval = cProbe.scanDim.x/sensorData.get(0).size();
                float sizeOfY_Interval = cProbe.scanDim.y/sensorData.size();
                for(int j=0; j<sensorData.size(); j++){
                    for(int i=0; i<sensorData.get(j).size(); i++){
                        PVector targetPos = new PVector(cProbe.pos.x -cProbe.scanDim.x/2.0 +i*sizeOfX_Interval, cProbe.pos.y -cProbe.scanDim.y/2.0 +j*sizeOfY_Interval);
                        float nestTemp = 0.0;
                        float coreTemp = 0.0;
                        float oldValue = sensorData.get(j).get(i);
                        //3.1 -> Through all nests
                        for(int z=0; z<cSolarMap.spaceBodies.get(p).alienNests.size(); z++){
                            nestTemp = cSolarMap.spaceBodies.get(p).alienNests.get(z).temp*calcFalloff("r^-3", new PVector(cSolarMap.spaceBodies.get(p).pos.x +cSolarMap.spaceBodies.get(p).alienNests.get(z).pos.x, cSolarMap.spaceBodies.get(p).pos.y +cSolarMap.spaceBodies.get(p).alienNests.get(z).pos.y), targetPos);}
                        //3.2 -> For planet core
                        coreTemp = cSolarMap.spaceBodies.get(p).coreTemp*calcFalloff(cSolarMap.spaceBodies.get(p).tempFalloffType, cSolarMap.spaceBodies.get(p).pos, targetPos);
                        //3.3 -> Bring all together
                        sensorData.get(j).remove(i);
                        sensorData.get(j).add(i, oldValue +nestTemp +coreTemp);
                    }
                }
            }
        }
    }
    void recordReadings_mineral(solarMap cSolarMap, probe cProbe){
        /*
        1. Create req. space in sensorData ("" "") -> Set a default of zero materials everywhere
        2. Add mineral -> from planets in the bounding area
            -> mined out areas will have been removed from the source therefore no problems
        3. Add noise readings
        */
        sensorData.clear();
        //1
        for(int j=0; j<resolvingPower; j++){
            sensorData.add(new ArrayList<Float>());
            for(int i=0; i<resolvingPower; i++){
                float newValue = 0.0;
                sensorData.get(j).add(newValue);
            }
        }
        //2
        //Check all bodies
        for(int p=0; p<cSolarMap.spaceBodies.size(); p++){
            //If bounding boxes cross
            PVector expandedScanDim = new PVector(1.2*cProbe.scanDim.x, 1.2*cProbe.scanDim.y);
            PVector planetDim = new PVector(2.0*cSolarMap.spaceBodies.get(p).radius, 2.0*cSolarMap.spaceBodies.get(p).radius);
            boolean boundsCross = checkRectRectCollision(new PVector(cProbe.pos.x -expandedScanDim.x/2.0, cProbe.pos.y -expandedScanDim.y/2.0), expandedScanDim, new PVector(cSolarMap.spaceBodies.get(p).pos.x -planetDim.x/2.0, cSolarMap.spaceBodies.get(p).pos.y -planetDim.y/2.0), planetDim); //Bounds of viewable screen and planet(+ some change for expanded heat range)
            if(boundsCross){
                //### NEW VERSION --> OVER SCANNER DIM ###
                //Go through each space in the displayed sensor
                float scannerResWidth = cProbe.scanDim.x / resolvingPower;
                for(int j=0; j<resolvingPower; j++){
                    for(int i=0; i<resolvingPower; i++){
                        //Check if it is in the bounding -> if so, continue checks
                        //Point in question is in the bounding box of the planet
                        PVector tilePos = new PVector(cProbe.pos.x -cProbe.scanDim.x/2.0 +i*scannerResWidth, cProbe.pos.y -cProbe.scanDim.y/2.0 +j*scannerResWidth);
                        boolean withinX = (cSolarMap.spaceBodies.get(p).pos.x -cSolarMap.spaceBodies.get(p).radius <= tilePos.x) && (tilePos.x < cSolarMap.spaceBodies.get(p).pos.x +cSolarMap.spaceBodies.get(p).radius);
                        boolean withinY = (cSolarMap.spaceBodies.get(p).pos.y -cSolarMap.spaceBodies.get(p).radius <= tilePos.y) && (tilePos.y < cSolarMap.spaceBodies.get(p).pos.y +cSolarMap.spaceBodies.get(p).radius);
                        if(withinX && withinY){
                            //Bin the coord into spaces of the planet's cells
                            PVector tilePlanetCoord = new PVector(tilePos.x -cSolarMap.spaceBodies.get(p).pos.x +cSolarMap.spaceBodies.get(p).radius, tilePos.y -cSolarMap.spaceBodies.get(p).pos.y +cSolarMap.spaceBodies.get(p).radius);    //Gives the tile's coord in terms of the top-right corner of the planet -> can then be binned
                            PVector tilePlanetCoordBinned = new PVector(floor(tilePlanetCoord.x/cSolarMap.spaceBodies.get(p).mineralCellWidth), floor(tilePlanetCoord.y/cSolarMap.spaceBodies.get(p).mineralCellWidth));
                            //################################################################################################################################################
                            //## ABSOLUETLY HUGE, ENORMAS, GARGANTUAN BODGE, BUT SHOULD WORK FOR NOW AND ONLY OCCURS IN EDGE CASES WHEN PLANETS ARE CLOSE TO BORDER I THINK ##
                            //################################################################################################################################################
                            if((tilePlanetCoordBinned.x >= 0.0) && (tilePlanetCoordBinned.y >= 0.0)){
                                //Check if is a mineral or null space
                                if(cSolarMap.spaceBodies.get(p).mineralSet.get( int(tilePlanetCoordBinned.y) ).get( int(tilePlanetCoordBinned.x) ) != null){
                                    //If is a mineral space, then add its reading
                                    float mineralTypeComp  = mineralDict.getValue( cSolarMap.spaceBodies.get(p).mineralSet.get( int(tilePlanetCoordBinned.y) ).get( int(tilePlanetCoordBinned.x) ) );
                                    float transparencyComp = cSolarMap.spaceBodies.get(p).mineralSet.get( int(tilePlanetCoordBinned.y) ).get( int(tilePlanetCoordBinned.x) ).calcTransparency() /255.0;
                                    float associatedValue = mineralTypeComp +transparencyComp;
                                    sensorData.get(j).remove(i);
                                    sensorData.get(j).add(i, associatedValue );
                                }
                            }
                        }
                    }
                }


                //## OLD VERSION --> OVER BODY DIM
                //Evaluate across the whole bound of the body WITHIN sensor range
                //### WILL LATER NEED TO ACCOUNT FOR ROTATION ###
                //Go through all cells for the body
                /*
                for(int j=0; j<cSolarMap.spaceBodies.get(p).mineralSet.size(); j++){
                    for(int i=0; i<cSolarMap.spaceBodies.get(p).mineralSet.get(j).size(); i++){
                        //If the point is part of the body (NOT just leftover from bounding box)
                        if(cSolarMap.spaceBodies.get(p).mineralSet.get(j).get(i) != null){
                            PVector bodyPoint = new PVector(cSolarMap.spaceBodies.get(p).pos.x -cSolarMap.spaceBodies.get(p).radius +i*cSolarMap.spaceBodies.get(p).mineralCellWidth, cSolarMap.spaceBodies.get(p).pos.y -cSolarMap.spaceBodies.get(p).radius +j*cSolarMap.spaceBodies.get(p).mineralCellWidth);  //Centre point of the cell on the body
                            boolean withinX = (cProbe.pos.x -cProbe.scanDim.x/2.0 <= bodyPoint.x) && (bodyPoint.x < cProbe.pos.x +cProbe.scanDim.x/2.0);
                            boolean withinY = (cProbe.pos.y -cProbe.scanDim.y/2.0 <= bodyPoint.y) && (bodyPoint.y < cProbe.pos.y +cProbe.scanDim.y/2.0);
                            boolean pointInSensorRange = (withinX && withinY);
                            if(pointInSensorRange){
                                //If appears on the sensor, them find the binned coord that it appears in for the sensor
                                PVector scanCellDim = new PVector(cProbe.scanDim.x /resolvingPower, cProbe.scanDim.y /resolvingPower);
                                PVector binnedCoord = new PVector(floor(abs(cProbe.pos.x -cProbe.scanDim.x/2.0 -bodyPoint.x)/scanCellDim.x), floor(abs(cProbe.pos.y -cProbe.scanDim.y/2.0 -bodyPoint.y)/scanCellDim.y));    //From prev. step, this value should be within grid range
                                println(binnedCoord);
                                //Add mineral VALUE to this point -> display will convert this to COLOUR ---> ################ ACREFUL FOR NOISE -> FLOOR IN DISPLAY ############ OOORRR ADD NOISE AFTER
                                float mineralTypeComp  = mineralDict.getValue( cSolarMap.spaceBodies.get(p).mineralSet.get(j).get(i) );
                                float transparencyComp = cSolarMap.spaceBodies.get(p).mineralSet.get(j).get(i).calcTransparency() /255.0;
                                float associatedValue = mineralTypeComp +transparencyComp;
                                sensorData.get( int(binnedCoord.y) ).remove( int(binnedCoord.x) );
                                sensorData.get( int(binnedCoord.y) ).add( int(binnedCoord.x), associatedValue );
                            }
                        }
                    }
                }
                */


            }
        }
        //3
        for(int j=0; j<sensorData.size(); j++){
            for(int i=0; i<sensorData.get(j).size(); i++){
                float newValue = random(0.0, 40.0);  //## ADD A NOISE RANGE FOR MIENRALS SCANS ### ++ DO NOISE AT THE END #############################
                if(sensorData.get(j).get(i) == 0.0){    //If is an empty spot, give some noise
                    sensorData.get(j).remove(i);
                    sensorData.get(j).add(i, newValue);
                }
            }
        }
    }
    void recordReadings_sound(solarMap cSolarMap, probe cProbe){
        /*
        'Listens' for sound around the probe
        The sound is randomised and is related to the proximity of alien squads nearby (spawned by alien clusters)
        The data for each waveform can be pulled directly from a .mp4 file

        0.0 = no intenisty
        1.0 = max intenisty
        */
        //####
        //## THIS JUST GENERATES POINTLESS DATA, IN REALITY BASE OFF OF ALIENS & RECORDED SOUND
        //####
        sensorData.clear();
        sensorData.add(new ArrayList<Float>());
        float variation = 0.07;
        float angInterval = (3*2.0*PI) / (resolvingPower);
        for(int i=0; i<resolvingPower; i++){
            float sinVal = abs(sin(i*angInterval)) / ((i+1)*(angInterval));
            float varVal = random(0.0, variation);
            sensorData.get(0).add(sinVal +varVal);
        }
    }
    void recordReadings_gravity(solarMap cSolarMap, probe cProbe){
        /*
        1. Create req. space in sensorData ("" "") -> Set a default of zero materials everywhere
        2. Go through all points in sensor range and take gravity readings from all planets added
            -> may be too intensive, if so do a distance reading first to reduce pool size
        3. Add noise readings
        */
        sensorData.clear();
        //1
        for(int j=0; j<resolvingPower; j++){
            sensorData.add(new ArrayList<Float>());
            for(int i=0; i<resolvingPower; i++){
                float newValue = 0.0;
                sensorData.get(j).add(newValue);
            }
        }
        //2
        //Go through all sensor spaces
        PVector sensorCellDim = new PVector((cProbe.scanDim.x)/(resolvingPower), (cProbe.scanDim.y)/(resolvingPower));
        for(int j=0; j<sensorData.size(); j++){
            for(int i=0; i<sensorData.get(j).size(); i++){
                PVector point = new PVector(cProbe.pos.x -cProbe.scanDim.x/2.0 +i*sensorCellDim.x, cProbe.pos.y -cProbe.scanDim.y/2.0 +j*sensorCellDim.y);
                PVector summedForce = cSolarMap.calcGravity(point);
                float value = convertVecToValue_gravity(summedForce);
                sensorData.get(j).remove(i);
                sensorData.get(j).add(i, value);
            }
        }
        //3
        /*
        for(int j=0; j<sensorData.size(); j++){
            for(int i=0; i<sensorData.get(j).size(); i++){
                float randVal = random(-0.1, 0.1);
                float oldValue = sensorData.get(j).get(i);
                float newValue = oldValue + floor(oldValue)*randVal;    //Either adds on or takes away a bit of MAGNITUDE, but NEVER DIRECTION
                sensorData.get(j).remove(i);
                sensorData.get(j).add(i, newValue);
            }
        }
        */
    }

    void display_sensorData(ArrayList<ArrayList<Float>> sensorReadings, int dataType){
        /*
        Takes a set of sensor readings (for whichever data is being collected -> all boil down to values)


        ####################################################################################################
        ## SPLIT INTO SEPARATE FUNCTIONS FOR CHRIST SAKE, JUST PUT INTO DIFFERENT "display...." TYBE BEAT ##
        ####################################################################################################

        */
        if(dataType == 1){
            /*
            Expects a 2D array

            Temperature readings in a GRID around the probe
            => disp. as grid
            */
            float border    = panelDim.x/30.0;
            int asciiBorder = 2;
            float xInterval = (panelDim.x -2.0*border) / (sensorReadings.get(0).size() +2.0*asciiBorder);
            float yInterval = (panelDim.y -2.0*border) / (sensorReadings.size() +2.0*asciiBorder);
            for(int j=0; j<sensorReadings.size() +2*asciiBorder; j++){
                for(int i=0; i<sensorReadings.get(0).size() +2*asciiBorder; i++){
                    int data_x_coord = i-asciiBorder;
                    int data_y_coord = j-asciiBorder;
                    String plotSymbol;
                    PVector plotColour;
                    pushStyle();
                    textAlign(CENTER, CENTER);    //## PROBAQBLY MORE EFFICIENT TO LEQVE OUTSIDE IN ANOTHER NESTED POP-PUSH ##
                    boolean isValidX = (0 <= data_x_coord) && (data_x_coord < sensorReadings.get(0).size());
                    boolean isValidY = (0 <= data_y_coord) && (data_y_coord < sensorReadings.size());
                    if(isValidX && isValidY){   //For DATA
                        plotSymbol = convertValueToSymbol_temperature(sensorReadings.get(data_y_coord).get(data_x_coord) / cManager.cSolarMap.temp_maxValue);
                        plotColour= convertValueToColour_temperature(sensorReadings.get(data_y_coord).get(data_x_coord) / cManager.cSolarMap.temp_maxValue);}
                    else{   //For BORDERS
                        plotSymbol = "p";
                        plotColour= new PVector(70,70,70);}
                    fill(plotColour.x, plotColour.y, plotColour.z);
                    text(plotSymbol, cornerPos.x +border +i*xInterval, cornerPos.y + border +j*yInterval);
                    popStyle();
                }
            }
        }
        if(dataType == 2){
            /*
            Mineral readings in a GRID around the probe
            => disp. as grid
            */
            float border    = panelDim.x/30.0;
            int asciiBorder = 2;
            float xInterval = (panelDim.x -2.0*border) / (sensorReadings.get(0).size() +2.0*asciiBorder);
            float yInterval = (panelDim.y -2.0*border) / (sensorReadings.size() +2.0*asciiBorder);
            for(int j=0; j<sensorReadings.size() +2*asciiBorder; j++){
                for(int i=0; i<sensorReadings.get(0).size() +2*asciiBorder; i++){
                    int data_x_coord = i-asciiBorder;
                    int data_y_coord = j-asciiBorder;
                    String plotSymbol;
                    PVector plotColour;
                    float mineralValue     = 0.0;
                    float plotTransparency = 250.0;
                    pushStyle();
                    textAlign(CENTER, CENTER);    //## PROBAQBLY MORE EFFICIENT TO LEQVE OUTSIDE IN ANOTHER NESTED POP-PUSH ##
                    boolean isValidX = (0 <= data_x_coord) && (data_x_coord < sensorReadings.get(0).size());
                    boolean isValidY = (0 <= data_y_coord) && (data_y_coord < sensorReadings.size());
                    if(isValidX && isValidY){   //For DATA
                        mineralValue     = floor(sensorReadings.get(data_y_coord).get(data_x_coord));
                        plotTransparency = 250.0*(sensorReadings.get(data_y_coord).get(data_x_coord) - mineralValue);
                        plotSymbol = convertValueToSymbol_mineral(mineralValue);
                        plotColour = convertValueToColour_mineral(mineralValue);}
                    else{   //For BORDERS
                        plotSymbol = "o";
                        plotColour= new PVector(70,70,70);}
                    fill(plotColour.x, plotColour.y, plotColour.z, plotTransparency);
                    text(plotSymbol, cornerPos.x +border +i*xInterval, cornerPos.y + border +j*yInterval);
                    popStyle();
                }
            }
        }
        if(dataType == 3){
            /*
            Sound readings as scalar values about the probe
            => disp. on a line for intensity of different frequencies -> only able to hear the sound in this mode
            */
            float border        = panelDim.x/20.0;
            float intervalJump  = (panelDim.x-2.0*border) / (sensorReadings.get(0).size());
            float normalisation = panelDim.y/2.0;
            pushStyle();
            stroke(255,255,255);
            strokeWeight(2);
            noFill();
            line(cornerPos.x +border, cornerPos.y +panelDim.y/2.0, cornerPos.x +panelDim.x -border, cornerPos.y +panelDim.y/2.0);
            for(int i=0; i<sensorReadings.get(0).size(); i++){
                ellipse(cornerPos.x +border +i*intervalJump, panelDim.y/2.0 -normalisation*sensorZoom*sensorReadings.get(0).get(i), 10,10);
                //println(normalisation*sensorZoom*sensorReadings.get(0).get(i));
            }
            popStyle();
        }
        if(dataType == 4){
            /*
            Expects a 1D array

            Distance readings as scalar values about the probe
            => disp. on a line (circle in reality)
            */
            if(sensorReadings.size() > 0){                  //#### NOT REALLY NEEDED ANYMORE, AS INITIALISES AS NO DATA -> CORRECT SIZE GENERATED WHEN SCANNED ##############
                float border        = panelDim.x/20.0;
                float intervalJump  = (panelDim.x-2.0*border) / (sensorReadings.get(0).size());
                float normalisation = 1.0*cManager.cSolarMap.mapRadius;//2,0* for full coverage, 1.0* => good readablity but also nay over-reach    //findDataNormalisation(dataType, sensorReadings);  //### Look for largest value, and normalise all values so they fit on the graph ###
                pushStyle();
                stroke(255,255,255);
                strokeWeight(2);
                noFill();
                line(cornerPos.x +border, cornerPos.y +panelDim.y/2.0, cornerPos.x +panelDim.x -border, cornerPos.y +panelDim.y/2.0);
                for(int i=0; i<sensorReadings.get(0).size(); i++){
                    line(cornerPos.x +border +i*intervalJump, panelDim.y/2.0, cornerPos.x +border +i*intervalJump, panelDim.y/2.0 -(panelDim.y/2.0)*(sensorReadings.get(0).get(i)/normalisation)*sensorZoom );
                }
                popStyle();
            }
        }
        if(dataType == 5){
            /*
            2D input

            Gravitational readings in a GRID around the probe
            => disp. as grid
            */
            float border    = panelDim.x/30.0;
            int asciiBorder = 2;
            float xInterval = (panelDim.x -2.0*border) / (sensorReadings.get(0).size() +2.0*asciiBorder);
            float yInterval = (panelDim.y -2.0*border) / (sensorReadings.size() +2.0*asciiBorder);
            for(int j=0; j<sensorReadings.size() +2*asciiBorder; j++){
                for(int i=0; i<sensorReadings.get(0).size() +2*asciiBorder; i++){
                    int data_x_coord = i-asciiBorder;
                    int data_y_coord = j-asciiBorder;
                    //###################################################
                    //## -> MAKE SYMBOL BASED ON DIRECTION OF FLOW     ##
                    //##    -> SHADE OF WHITE BASED ON MAGNITUDE       ##
                    //###################################################
                    String plotSymbol;
                    PVector plotColour;
                    pushStyle();
                    textAlign(CENTER, CENTER);    //## PROBAQBLY MORE EFFICIENT TO LEQVE OUTSIDE IN ANOTHER NESTED POP-PUSH ##
                    boolean isValidX = (0 <= data_x_coord) && (data_x_coord < sensorReadings.get(0).size());
                    boolean isValidY = (0 <= data_y_coord) && (data_y_coord < sensorReadings.size());
                    if(isValidX && isValidY){   //For DATA
                        //println(sensorReadings.get(data_y_coord).get(data_x_coord));
                        plotSymbol = convertValueToSymbol_gravity(sensorReadings.get(data_y_coord).get(data_x_coord));
                        plotColour = convertValueToColour_gravity(sensorReadings.get(data_y_coord).get(data_x_coord));}
                    else{   //For BORDERS
                        plotSymbol = "o";
                        plotColour= new PVector(70,70,70);}
                    fill(plotColour.x, plotColour.y, plotColour.z);
                    text(plotSymbol, cornerPos.x +border +i*xInterval, cornerPos.y + border +j*yInterval);
                    popStyle();
                }
            }
        }
    }
    float findDataNormalisation(float dataType, ArrayList<ArrayList<Float>> dataset){
        float normValue = 0.0;  //Multiplier to all data collected to make it fit on the scale
        if(dataset.size() > 0){
            if(dataType == 1){
                //pass
            }
            if(dataType == 2){
                //pass
            }
            if(dataType == 3){
                //pass
            }
            if(dataType == 4){
                if(dataset.get(0).size() > 0){
                    float maxValue = dataset.get(0).get(0);
                    for(int i=0; i<dataset.size(); i++){
                        float dataValue = dataset.get(0).get(i);
                        if(dataValue > maxValue){
                            maxValue = dataValue;}
                    }
                    normValue = (0.45*panelDim.y) / (maxValue);
                }
            }
            if(dataType == 5){
                //pass
            }
        }
        return normValue;
    }


    /*
    -----------------------------------
    Temperature is encoded as such;
        The value recorded in the 2D array can be immediately interpretted
        as the raw temperature of the location
    -----------------------------------
    */
    String convertValueToSymbol_temperature(float value){
        /*
        Temperature readings
        Interpolates between AN ESTABLISHED max and min (for the universe)
        */
        String newSymbol = "";
        /*
        if(value <= 1.0){
            newSymbol = "@";}
        if(value < 0.9){
            newSymbol = "&";}
        if(value < 0.8){
            newSymbol = "0";}
        if(value < 0.7){
            newSymbol = "#";}
        if(value < 0.5){
            newSymbol = "+";}
        if(value < 0.3){
            newSymbol = "*";}
        if(value < 0.1){
            newSymbol = "";}
        */
        newSymbol = "%";
        return newSymbol;
    }
    PVector convertValueToColour_temperature(float value){
        /*
        Temperature readings
        Interpolates between AN ESTABLISHED max and min (for the universe)
        Interpolates between blue and red, THROUGH green and yellow

        0.0 as min, 1.0 as max

        ######################################
        ## MAY WANT TO FLOOR THESE SLIGHTLY ##
        ######################################
        */
        PVector newColour = new PVector(0,0,0);
        float greenCutoff = 0.5;    //Determines where the 'Green' value is reached -> an approx. midpoint
        if(value < greenCutoff){    //Blue system
            float relTheta = (value*PI) / (greenCutoff*2.0);
            newColour.y =      255*sin(relTheta);
            newColour.z = 255 -255*sin(relTheta);
        }
        else{                       //Red system
            float relTheta = ((value-greenCutoff)*PI) / ((1.0-greenCutoff)*2.0);
            newColour.x =      255*sin(relTheta);
            newColour.y = 255 -255*sin(relTheta);
        }
        return newColour;
    }
    /*
    -----------------------------------
    Minerals are encoded as such;
        The value recorded has two components; (1) an integer value corresponding 
        to a mineral type [as can be seen in the mineralDict], and (2) a decimal 
        part in range (0.0, 0.98) that corresponds to the [shortened] percentage 
        of quantity compared to the quantityCutoff [defined in mineral calcTransparency()] 
        , and hence gives the transparency of the material when *255.0 for displaying.
        Colours for minerals are directly viewed from the mienralDict, using the 
        colours defined in the mineral's class
    -----------------------------------
    */
    String convertValueToSymbol_mineral(float value){
        /*
        Mineral readings
        */
        return "%";
    }
    PVector convertValueToColour_mineral(float value){
        /*
        Mineral readings
        Bin into sections for each mineral type
        0.0 as min, 1.0 as max
        */
        mineral givenMineral = mineralDict.getKey(value);
        PVector newColour = new PVector(40,40,40);
        if(givenMineral != null){
            newColour = givenMineral.colour;}
        return newColour;
    }
    /*
    -----------------------------------
    Gravity is encoded as such;
        The value in the reading is composed of two sections; (1)The integer component 
        is the rounded magnitude of the force [possibly multiplied by some factor to 
        account for the scales involved ????????????], and (2) The decimal part shows the 
        truncated [to have 3.dp e.g 3.14 => 0.314] angle the force acts along from the 
        X-axis. This can result in noteable inaccuracy but that is simply a defect in the 
        probe's cheaply made sensor setup ;)
    -----------------------------------
    */
    float convertVecToValue_gravity(PVector gravityVec){
        float magComp = floor(vec_mag(gravityVec));
        float angComp = 0.1*findAngle(gravityVec, new PVector(0,0));    //Always < 10.0 => *0.1 is fine (so is always a decimal)
        float value = magComp +angComp;
        return value;
    }
    String convertValueToSymbol_gravity(float value){
        /*
        Depicts direction to some small degree
        Rest is assumed knowledge by user's brain knowing gravity pulls objects towards large masses
        */
        float angComp = 10.0*( value -floor(value) );   //Convert to decimal only, then account for 0.1 * reduction
        String symbol = " ";
        float thetaBorder = PI/8.0;
        if(      ((3.0*PI/4.0 -thetaBorder <= angComp) && (angComp < 3.0*PI/4.0 +thetaBorder)) || ((7.0*PI/4.0 -thetaBorder <= angComp) && (angComp < 7.0*PI/4.0 +thetaBorder)) ){
            symbol = "/";}
        else if( ((    PI/4.0 -thetaBorder <= angComp) && (angComp <     PI/4.0 +thetaBorder)) || ((5.0*PI/4.0 -thetaBorder <= angComp) && (angComp < 5.0*PI/4.0 +thetaBorder)) ){
            symbol = "\\";}
        else if( ((    PI/2.0 -thetaBorder <= angComp) && (angComp <     PI/2.0 +thetaBorder)) || ((3.0*PI/2.0 -thetaBorder <= angComp) && (angComp < 3.0*PI/2.0 +thetaBorder)) ){
            symbol = "|";}
        else if( ((       0.0 -thetaBorder <= angComp) && (angComp <        0.0 +thetaBorder)) || ((    PI/1.0 -thetaBorder <= angComp) && (angComp <     PI/1.0 +thetaBorder)) ){
            symbol = "_";}
        else{
            symbol = "+";}
        return symbol;
    }
    PVector convertValueToColour_gravity(float value){
        /*
        Shades of white used -> to determine magnitude
        */
        float magComp = floor(value);
        float gravityMax = 300.0;   //Max value the sensor is capable of processing -> colour in relation to this
        float ratio = magComp/gravityMax;
        return new PVector(255.0*ratio, 255.0*ratio, 255.0*ratio);
    }

    //For BUGFIXING #######
    void displayArray(){
        println("###");
        if(sensorData.size() == 30){
            PVector startPos = new PVector(mouseX, mouseY);
            float cellSize = 6.0;
            pushStyle();
            textSize(cellSize);
            textAlign(CENTER, CENTER);
            for(int j=0; j<sensorData.size(); j++){
                println("");
                for(int i=0; i<sensorData.get(j).size(); i++){
                    print( sensorData.get(j).get(i) );
                    fill(90,90,90);
                    if(sensorData.get(j).get(i) == 1.0){
                        fill(255,0,0);}
                    if(sensorData.get(j).get(i) == 2.0){
                        fill(0,255,0);}
                    if(sensorData.get(j).get(i) == 3.0){
                        fill(0,0,255);}
                    text("%", startPos.x +i*cellSize, startPos.y +j*cellSize);
                }
            }
            popStyle();
        }
    }
    //For BUGFIXING #######
}

class dart{
    /*
    Just tracks a position moving in a given direction
    Used for measuring values at given distances in given directions
    Adds a desired 'graininess' to values

    'startingData' gives a way to initialise data as UNFOUND, specific to the context of the reading
    e.g; For distance, -1.0 => unfound,   for temperature, 99999 => unfound,     ....

    Note; resolved variable here referes to the dart reaching some destination, for reference
        by the function using the dart; e.g dart has collided with a planet
    */
    boolean resolved = false;
    float storedData;

    PVector pos;
    PVector dir;    //Unit vector
    float moveDist = 0.02;  //Speed in AU

    dart(PVector pos, PVector dir, float startingData){
        this.pos = pos;
        this.dir = dir;
        this.storedData = startingData;
    }

    void move(){
        /*
        Progresses the dart forward
        */
        pos.x += moveDist*dir.x;
        pos.y += moveDist*dir.y;
    }
}

/*

###
###
 Drilling in wrong direction, X and Y flipped somewhere????????
Fix the cargo container showing materials too

 ALSO, ADD AN --[ICON FOR THE OUTPOST]-- ON THE SCANNER WHEN VIEWED FROM QUICK-MINERAL

 ADD ALIEN INTERACTIONS + ACTUAL WORKING SOUND STUFF
###
###
*/