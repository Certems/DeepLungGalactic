class button{
    /*
    A clickable shape (rectangles or circles) that executes a command when activated, 
    based off the 'string type' it is given
    Buttons should be placed behind other drawn assets by mirroring their positions and 
    dimensions -> parse by reference
    Some buttons can load in other sets of buttons
    */
    String shapeType;   //"rect" or "circ"
    String buttonType;

    PVector pos;    //Top-left corner
    PVector dim;    //Full width and height
    float thetaStart = 0.0; //Used for certain button types (arcs, ...)
    float thetaStop  = 0.0; //

    //Specifics -> Add more variables as more specifics are required
    probe relatedProbe     = null; //Used to refer to specifics for THIS button
    outpost relatedOutpost = null; //
    wheel relatedWheel     = null; //
    item relatedItem       = null; //

    button(PVector pos, PVector dim, String shapeType, String buttonType){
        this.pos = pos;
        this.dim = dim;
        this.shapeType  = shapeType;
        this.buttonType = buttonType;
    }

    void displayOutline(){
        /*
        Shows an outline of clickable space
        */
        pushStyle();
        noFill();
        stroke(10,255,10);
        strokeWeight(3);
        if(shapeType == "rect"){
            rectMode(CORNER);
            rect(pos.x, pos.y, dim.x, dim.y);
        }
        if(shapeType == "circ"){
            ellipse(pos.x +dim.x/2.0, pos.y +dim.y/2.0, dim.x, dim.y);
        }
        if(shapeType == "arc"){
            arc(pos.x, pos.y, dim.x, dim.y, thetaStart, thetaStop);  //*Note here, dim specifies RADIUS not DIAMETER (unlike the circle)
        }
        popStyle();
    }
    boolean inButtonRange(PVector selectPos){
        /*
        Checks if the selection position (normally mouse position) is within the button bounds
        */
        if(shapeType == "rect"){
            boolean withinX = ((pos.x <= selectPos.x) && (selectPos.x < pos.x +dim.x));
            boolean withinY = ((pos.y <= selectPos.y) && (selectPos.y < pos.y +dim.y));
            return (withinX && withinY);
        }
        else if(shapeType == "circ"){
            float dist = vec_mag(vec_dir(new PVector(pos.x +dim.x/2.0, pos.y +dim.y/2.0), new PVector(mouseX, mouseY)));
            return (dist <= dim.x/2.0);
        }
        else if(shapeType == "arc"){
            float dist = vec_mag(vec_dir(pos, new PVector(mouseX, mouseY)));
            float theta= findMouseAngle(pos);
            boolean withinRadius = (dist <= dim.x);
            boolean withinAngle  = (thetaStart <= theta) && (theta < thetaStop);
            return (withinRadius && withinAngle);
        }
        else{
            return false;
        }
    }
    void activate(){
        /*
        Performs the job of the button
        */
        if(buttonType == "flight_probe_goToControls"){
            cManager.cFlightControls.screen_selection     = false;  //Change booleans
            cManager.cFlightControls.screen_probeControls = true;   //
            cManager.cFlightControls.screen_probeLaunch   = false;  //
            cManager.cFlightControls.screen_outpostMining = false;  //
            cManager.cFlightControls.loadButtons_screen_probeControls(relatedProbe);    //Load relevent buttons
        }
        if(buttonType == "flight_probe_dismissDestroyed"){
            //######################################################################
            //## MAYBE TAKE YOU TO A SCREEN TO SEE A REPORT ON HOW THE PROBE DIED ##
            //######################################################################
            cManager.cSolarMap.dismissProbe(relatedProbe);
            cManager.cFlightControls.generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
            cManager.cFlightControls.loadButtons_screen_selection();    //## MAYBE KEEP, MAYBE REMOVE
        }
        if(buttonType == "flight_outpost_goToMining"){
            cManager.cFlightControls.screen_selection     = false;  //Change booleans
            cManager.cFlightControls.screen_probeControls = false;  //
            cManager.cFlightControls.screen_probeLaunch   = false;  //
            cManager.cFlightControls.screen_outpostMining = true;   //
            cManager.cFlightControls.loadButtons_screen_outpostMining();    //Load relevent buttons
        }
        if(buttonType == "flight_outpost_dismissDestroyed"){
            //pass
        }
        if(buttonType == "flight_goToLaunch"){
            cManager.cFlightControls.screen_selection     = false;  //Change booleans
            cManager.cFlightControls.screen_probeControls = false;  //
            cManager.cFlightControls.screen_probeLaunch   = true;   //
            cManager.cFlightControls.screen_outpostMining = false;  //
            cManager.cFlightControls.loadButtons_screen_probeLaunch();    //Load relevent buttons
        }
        if(buttonType == "flight_goToSelection"){
            cManager.cFlightControls.screen_selection     = true;  //Change booleans
            cManager.cFlightControls.screen_probeControls = false; //
            cManager.cFlightControls.screen_probeLaunch   = false; //
            cManager.cFlightControls.screen_outpostMining = false;  //
            cManager.cFlightControls.loadButtons_screen_selection();    //Load relevent buttons
        }
        if(buttonType == "flight_incrementProbeIndOffset"){
            cManager.cFlightControls.probeSetIndOffset++;
            if(cManager.cFlightControls.probeSetIndOffset >= cManager.cSolarMap.probes.size() +cManager.cSolarMap.destroyed_probes.size()){
                cManager.cFlightControls.probeSetIndOffset = 0;}
            cManager.cFlightControls.generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
            cManager.cFlightControls.loadButtons_screen_selection();
        }
        if(buttonType == "flight_incrementOutpostIndOffset"){
            cManager.cFlightControls.outpostSetIndOffset++;
            if(cManager.cFlightControls.outpostSetIndOffset >= cManager.cSolarMap.outposts.size() +cManager.cSolarMap.destroyed_outposts.size()){
                cManager.cFlightControls.outpostSetIndOffset = 0;}
            cManager.cFlightControls.generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
            cManager.cFlightControls.loadButtons_screen_selection();
        }
        if(buttonType == "flight_changeSensorDataType"){
            relatedProbe.dataType++;
            if(relatedProbe.dataType > cManager.cSensorArray.maxDataType){
                relatedProbe.dataType = 1;}
        }
        if(buttonType == "flight_searchSensorDataType"){
            /*
            1. Get data for given type, give to sensor
            2. Change sensor type
            */
            cManager.cSensorArray.recordReadings(relatedProbe, relatedProbe.dataType);
            cManager.cSensorArray.cDataType = relatedProbe.dataType;
        }
        if(buttonType == "flight_thrustForward"){
            //####
            //## MAKE WORK AS A CLICK AND HOLD BASED SYSTEM --> MAYBE NEW OBJECT TYPE -> INTERACTABLE NOT A BUTTON
            //####
            float thrust = 0.01;                            //## MAKE THIS PROBE SPECIFIC ## -> In AU
            PVector dir = vec_unitVec(relatedProbe.vel);    //## CHANGE TO BE A DIRECTION IT IS FACING, HELD SEPARATELY, ROATATES ##
            relatedProbe.vel.x += thrust*dir.x;
            relatedProbe.vel.y += thrust*dir.x;
        }
        if(buttonType == "flight_thrustBack"){
            //####
            //## MAKE WORK AS A CLICK AND HOLD BASED SYSTEM --> MAYBE NEW OBJECT TYPE -> INTERACTABLE NOT A BUTTON
            //####
            float thrust = 0.01;                            //## MAKE THIS PROBE SPECIFIC ## -> In AU
            PVector dir = vec_unitVec(relatedProbe.vel);    //## CHANGE TO BE A DIRECTION IT IS FACING, HELD SEPARATELY, ROATATES ##
            relatedProbe.vel.x -= thrust*dir.x;
            relatedProbe.vel.y -= thrust*dir.x;
        }
        if(buttonType == "flight_outpost_mining_drillContinue"){
            //pass
        }
        if(buttonType == "flight_outpost_mining_drillStop"){
            //pass
        }
        if(buttonType == "flight_outpost_mining_mineralTankInfoReveal"){
            //pass
        }
        if(buttonType == "flight_outpost_mining_audioQuick"){
            //pass
        }
        if(buttonType == "flight_outpost_mining_mineralQuick"){
            //pass
        }
        if(buttonType == "tools_goToSettings"){
            cManager.cToolArray.screen_selection    = false;  //Change booleans
            cManager.cToolArray.screen_settings     = true;   //
            cManager.cToolArray.screen_cartographer = false;  //
            cManager.cToolArray.loadButtons_screen_settings();    //Load relevent buttons
        }
        if(buttonType == "tools_goToCartographer"){
            cManager.cToolArray.screen_selection    = false;  //Change booleans
            cManager.cToolArray.screen_settings     = false;  //
            cManager.cToolArray.screen_cartographer = true;   //
            cManager.cToolArray.loadButtons_screen_cartographer();    //Load relevent buttons
        }
        if(buttonType == "tools_switchRadioStation"){
            println("Switching Station...");
            //pass
        }
        if(buttonType == "tools_goToSelection"){
            cManager.cToolArray.screen_selection    = true;  //Change booleans
            cManager.cToolArray.screen_settings     = false; //
            cManager.cToolArray.screen_cartographer = false; //
            cManager.cToolArray.loadButtons_screen_selection();    //Load relevent buttons
        }
        if(buttonType == "stocks_goToSelection"){
            cManager.cStockRecords.screen_selection    = true;  //Change booleans
            cManager.cStockRecords.screen_stockGraphs  = false; //
            cManager.cStockRecords.loadButtons_screen_selection();    //Load relevent buttons
        }
        if(buttonType == "stocks_goToStockGraph"){
            cManager.cStockRecords.screen_selection    = false;  //Change booleans
            cManager.cStockRecords.screen_stockGraphs  = true;   //
            cManager.cStockRecords.loadButtons_screen_stockGraph();    //Load relevent buttons
        }
        if(buttonType == "stocks_buyItem"){
            cManager.cStockRecords.stageItem(relatedItem);
        }
        if(buttonType == "stocks_sellItem"){
            cManager.cStockRecords.stageItem(relatedItem);
        }
        if(buttonType == "stocks_incrementInvIndOffset"){
            cManager.cStockRecords.invIndOffset++;
            if(cManager.cStockRecords.invIndOffset >= cManager.cStockRecords.ship_inventory.size()){
                cManager.cStockRecords.invIndOffset = 0;}
            cManager.cStockRecords.loadButtons_screen_selection();
        }
        if(buttonType == "wheel_cartography_goToMode"){
            relatedWheel.linked_disp = 0;
        }
        if(buttonType == "wheel_cartography_goToIcon"){
            relatedWheel.linked_disp = 1;
        }
        if(buttonType == ""){
            //pass
        }
        //...
    }
}