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

    float resolvingPower = 40.0;   //Number of readings that will be taken in each direction OR the density of the heat grid formulated
    float sensorZoom = 1.0;        //Multiplier applied to the NORMALISATION of the given sensor reading -> Therefore when switching types, should still be roughly correct suze as is not a flat scale but affects the norm.
    int cDataType   = 1;           //Initialised
    int maxDataType = 5;

    sensorArray(PVector cornerPos, PVector panelDim){
        this.cornerPos = cornerPos;
        this.panelDim  = panelDim;

        generate2Darray();
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
            generate2Darray();
        }
        if(dataType == 2){
            //pass
        }
        if(dataType == 3){
            //pass
        }
        if(dataType == 4){
            recordReadings_distance(cManager.cSolarMap, cProbe);
        }
        if(dataType == 5){
            //pass
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

    void display_sensorData(ArrayList<ArrayList<Float>> sensorReadings, int dataType){
        /*
        Takes a set of sensor readings (for whichever data is being collected -> all boil down to values)
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
            float valMax = getLargestElem(sensorReadings);    //Largest value in the whole array              --> DO FOR N DIM ARRAYU
            float valMin = getSmallestElem(sensorReadings);    // Smallest "" ""
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
                        plotSymbol = convertValueToSymbol(sensorReadings.get(data_y_coord).get(data_x_coord));
                        plotColour= convertValueToColour(sensorReadings.get(data_y_coord).get(data_x_coord));}
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
            //pass
        }
        if(dataType == 3){
            /*
            Sound readings as scalar values about the probe
            => disp. on a line (circle in reality)
            */
            //pass
        }
        if(dataType == 4){
            /*
            Expects a 1D array

            Distance readings as scalar values about the probe
            => disp. on a line (circle in reality)
            */
            if(sensorReadings.size() > 0){
                float border        = panelDim.x/20.0;
                float intervalJump  = (panelDim.x-2.0*border) / (sensorReadings.get(0).size());
                float normalisation = findDataNormalisation(dataType, sensorReadings);  //### Look for largest value, and normalise all values so they fit on the graph ###
                pushStyle();
                stroke(255,255,255);
                strokeWeight(2);
                noFill();
                line(cornerPos.x +border, cornerPos.y +panelDim.y/2.0, cornerPos.x +panelDim.x -border, cornerPos.y +panelDim.y/2.0);
                for(int i=0; i<sensorReadings.get(0).size(); i++){
                    line(cornerPos.x +border +i*intervalJump, panelDim.y/2.0, cornerPos.x +border +i*intervalJump, panelDim.y/2.0 -normalisation*sensorZoom*sensorReadings.get(0).get(i));
                }
                popStyle();
            }
        }
        if(dataType == 5){
            /*
            Gravitational readings in a GRID around the probe
            => disp. as grid, #### MAYBE SOMETHING ELSE AS WELL ####
            */
            //pass
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


    String convertValueToSymbol(float value){
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
    PVector convertValueToColour(float value){
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