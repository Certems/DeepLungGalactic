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
    String tag = "";    //Helps identify groups of buttons to be removed specifically

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
            line(pos.x, pos.y, pos.x +dim.x/2.0 *cos(thetaStart), pos.y +dim.y/2.0 *sin(thetaStart));
            line(pos.x, pos.y, pos.x +dim.x/2.0 *cos(thetaStop) , pos.y +dim.y/2.0 *sin(thetaStop));
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
            float theta= findAngle(new PVector(mouseX, mouseY), pos);
            boolean withinRadius = (dist <= dim.x/2.0);
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
            if(relatedOutpost.drillAngChosen){
                relatedOutpost.miningSlider.isVisible = false;}
            else{
                relatedOutpost.miningSlider.isVisible = true;}
            cManager.cFlightControls.loadButtons_screen_outpostMining(relatedOutpost);    //Load relevent buttons
        }
        if(buttonType == "flight_outpost_dismissDestroyed"){
            //pass
        }
        if(buttonType == "flight_goToLaunch"){
            cManager.cFlightControls.screen_selection     = false;  //Change booleans
            cManager.cFlightControls.screen_probeControls = false;  //
            cManager.cFlightControls.screen_probeLaunch   = true;   //
            cManager.cFlightControls.screen_outpostMining = false;  //
            cManager.cFlightControls.angularLauncher.isVisible = !cManager.cFlightControls.angularLauncher.isVisible;   //Make selector visible, so clicks register
            cManager.cFlightControls.loadButtons_screen_probeLaunch();    //Load relevent buttons
        }
        if(buttonType == "flight_launch_fireProbe"){
            cManager.cFlightControls.launchProbe(cManager.cSolarMap.probes, new PVector(0,0), cManager.cFlightControls.angularLauncher.getTheta(cManager.cFlightControls.angularLauncher_pos), cManager.cFlightControls.angularLauncher.getSpeed(cManager.cFlightControls.angularLauncher_pos, cManager.cFlightControls.angularLauncher_dim));
            
            // --> Go To Selection Copy         ### VERY SMALL BRAIN WAY OF DOING THIS, BUT IM TOO TIRED TO THINK OF THE CORRECT WAY ATM ;) #####
            cManager.cFlightControls.screen_selection     = true;   //Change booleans
            cManager.cFlightControls.screen_probeControls = false;  //
            cManager.cFlightControls.screen_probeLaunch   = false;  //
            cManager.cFlightControls.screen_outpostMining = false;  //
            cManager.cFlightControls.angularLauncher.isVisible = false;
            if(relatedOutpost != null){
                relatedOutpost.miningSlider.isVisible = false;}         //##### BIT OF A BODGE, BUT RESPECTABLE ####
            cManager.cFlightControls.loadButtons_screen_selection();    //Load relevent buttons
            // --> Go To Selection Copy         ### VERY SMALL BRAIN WAY OF DOING THIS, BUT IM TOO TIRED TO THINK OF THE CORRECT WAY ATM ;) #####
        }
        if(buttonType == "flight_goToSelection"){
            cManager.cFlightControls.screen_selection     = true;   //Change booleans
            cManager.cFlightControls.screen_probeControls = false;  //
            cManager.cFlightControls.screen_probeLaunch   = false;  //
            cManager.cFlightControls.screen_outpostMining = false;  //
            cManager.cFlightControls.angularLauncher.isVisible = false;
            if(relatedOutpost != null){
                relatedOutpost.miningSlider.isVisible = false;}         //##### BIT OF A BODGE, BUT RESPECTABLE ####
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
        if(buttonType == "flight_outpost_mining_drillToggle"){
            relatedOutpost.isDrilling = !relatedOutpost.isDrilling;
            if(!relatedOutpost.drillAngChosen){   //If a dig angle hasnt been chosen yet...
                //Lock in the drill angle AND calculate the drill targets
                relatedOutpost.angleOffset = relatedOutpost.findAngleOffset(cManager.cFlightControls.miningSlider_pos, cManager.cFlightControls.miningSlider_dim); //**Only time the angle offset is ever changed
                relatedOutpost.calcDrillTargets();
                //Then disable the slider
                relatedOutpost.miningSlider.isVisible = false;
                relatedOutpost.drillAngChosen = true;
            }
        }
        if(buttonType == "flight_outpost_mining_mineralTankInfoReveal"){
            //pass
        }
        if(buttonType == "flight_outpost_mining_audioQuick"){
            probe generatedProbe = new probe(relatedOutpost.linkedBody.pos, new PVector(0,0), new PVector(0,0));
            generatedProbe.scanDim = new PVector(2.0*relatedOutpost.linkedBody.radius, 2.0*relatedOutpost.linkedBody.radius);   //### MAY NOT BE NEEDED ##
            cManager.cSensorArray.recordReadings(generatedProbe, 3);
            cManager.cSensorArray.cDataType = 3;
        }
        if(buttonType == "flight_outpost_mining_mineralQuick"){
            probe generatedProbe = new probe(relatedOutpost.linkedBody.pos, new PVector(0,0), new PVector(0,0));
            generatedProbe.scanDim = new PVector(2.0*relatedOutpost.linkedBody.radius, 2.0*relatedOutpost.linkedBody.radius);
            cManager.cSensorArray.recordReadings(generatedProbe, 2);
            cManager.cSensorArray.cDataType = 2;
        }
        if(buttonType == "flight_outpost_mining_transportMinerals"){
            relatedOutpost.transportMineralsToShip(cManager.cStockRecords);
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
        if(buttonType == "tools_popWheelMain"){
            cManager.cToolArray.wheel_main.active = !cManager.cToolArray.wheel_main.active;
            if(cManager.cToolArray.wheel_main.active){
                cManager.cToolArray.loadButtons_wheel_main();}
            else{
                cManager.cToolArray.removeButtons("wheelGroup");}
        }
        if(buttonType == "tools_switchRadioStation"){
            println("Switching Station...");
            //pass
        }
        if(buttonType == "tools_cartography_zoomOut"){
            cManager.cToolArray.cartoMap.resetZoom();
        }
        if(buttonType == "tools_goToSelection"){
            cManager.cToolArray.screen_selection    = true;  //Change booleans
            cManager.cToolArray.screen_settings     = false; //
            cManager.cToolArray.screen_cartographer = false; //
            cManager.cToolArray.wheel_main.resetOrdering();
            cManager.cToolArray.loadButtons_screen_selection();    //Load relevent buttons
        }
        if(buttonType == "wheel_cartography_goToMode"){
            relatedWheel.linked_disp = 0;
            cManager.cToolArray.removeButtons("wheelGroup");
            cManager.cToolArray.loadButtons_wheel_main();
        }
        if(buttonType == "wheel_cartography_goToIcon"){
            relatedWheel.linked_disp = 1;
            cManager.cToolArray.removeButtons("wheelGroup");
            cManager.cToolArray.loadButtons_wheel_main();
        }
        if(buttonType == "wheel_cartography_icon_goBack"){
            //## MAY NEED ADJUSTMENT IF ORDERS CHANGE ##
            cManager.cToolArray.wheel_main.linked_disp = -1;    //Changes the disp of the wheel just before to -1
            cManager.cToolArray.removeButtons("wheelGroup");
            cManager.cToolArray.loadButtons_wheel_main();
        }
        if(buttonType == "wheel_cartography_icon_selectCircle"){
            println("Setting carto. icon to circle");
            cManager.cToolArray.cartoMap.selectedIcon = "circle";
        }
        if(buttonType == "wheel_cartography_icon_selectTriangle"){
            println("Setting carto. icon to triangle");
            cManager.cToolArray.cartoMap.selectedIcon = "triangle";
        }
        if(buttonType == "wheel_cartography_icon_selectSquare"){
            println("Setting carto. icon to square");
            cManager.cToolArray.cartoMap.selectedIcon = "square";
        }
        if(buttonType == "wheel_cartography_icon_selectExclaim"){
            println("Setting carto. icon to exclaim");
            cManager.cToolArray.cartoMap.selectedIcon = "exclaim";
        }
        if(buttonType == "wheel_cartography_mode_goBack"){
            //## MAY NEED ADJUSTMENT IF ORDERS CHANGE ##
            cManager.cToolArray.wheel_main.linked_disp = -1;    //Changes the disp of the wheel just before to -1
            cManager.cToolArray.removeButtons("wheelGroup");
            cManager.cToolArray.loadButtons_wheel_main();
        }
        if(buttonType == "wheel_cartography_mode_selectPlace"){
            println("Setting carto. mode to place");
            cManager.cToolArray.cartoMap.selectedMode = "place";
        }
        if(buttonType == "wheel_cartography_mode_selectRemove"){
            println("Setting carto. mode to remove");
            cManager.cToolArray.cartoMap.selectedMode = "remove";
        }
        if(buttonType == "wheel_cartography_mode_selectZoom"){
            println("Setting carto. mode to zoom");
            cManager.cToolArray.cartoMap.selectedMode = "zoom";
        }
        if(buttonType == "stocks_goToSelection"){
            cManager.cStockRecords.screen_selection    = true;  //Change booleans
            cManager.cStockRecords.screen_stockGraphs  = false; //
            cManager.cStockRecords.loadButtons_screen_selection();    //Load relevent buttons
        }
        if(buttonType == "stocks_goToStockGraph"){
            cManager.cStockRecords.screen_selection    = false;  //Change booleans
            cManager.cStockRecords.screen_stockGraphs  = true;   //
            cManager.cStockRecords.loadButtons_screen_stockGraph(relatedItem);    //Load relevent buttons
        }
        if(buttonType == "stocks_buyItem"){
            relatedItem.quantity = 5.0;
            cManager.cStockRecords.stageItem(relatedItem);
        }
        if(buttonType == "stocks_sellItem"){
            relatedItem.quantity = -5.0;
            cManager.cStockRecords.stageItem(relatedItem);
        }
        if(buttonType == "stocks_commitStagedItems"){
            cManager.cStockRecords.commitStaged();
        }
        if(buttonType == "stocks_incrementInvIndOffset"){
            cManager.cStockRecords.invIndOffset++;
            if(cManager.cStockRecords.invIndOffset >= cManager.cStockRecords.ship_inventory.size()){
                cManager.cStockRecords.invIndOffset = 0;}
            cManager.cStockRecords.loadButtons_screen_selection();
        }
        if(buttonType == ""){
            //pass
        }
        //...
    }
    void playSound(){
        /*
        Performs the job of the button

        If you want silence for certain clicks e.g zoom, then leave a blank if statement

        #######################################
        ### MAKE SENSOR & BACK SOFTER SOUNDS ##
        #######################################
        */
        if(buttonType == "flight_launch_fireProbe"){
            sound_flight_probe_launched.play();}
        else if(buttonType == "flight_goToSelection"){
            sound_general_button_back.play();}
        else if(buttonType == "flight_incrementProbeIndOffset"){
            sound_general_scroller.play();}
        else if(buttonType == "flight_incrementOutpostIndOffset"){
            sound_general_scroller.play();}   //## "" ____> + NEED TO ACTUALLY ADD THIS INTO GAME
        else if(buttonType == "flight_outpost_mining_drillToggle"){
            sound_general_click_active.play();}
        else if(buttonType == "tools_switchRadioStation"){
            sound_general_click_active.play();}   //## NEEDS A CLICKY, REAL SOUND ##
        else if(buttonType == "tools_goToSelection"){
            sound_general_button_back.play();}
        else if(buttonType == "wheel_cartography_icon_goBack"){
            sound_general_button_back.play();}
        else if(buttonType == "wheel_cartography_mode_goBack"){
            sound_general_button_back.play();}
        else if(buttonType == "stocks_goToSelection"){
            sound_general_button_back.play();}
        else if(buttonType == "stocks_commitStagedItems"){
            sound_stocks_commitStaged_active.play();}       //## ADD INACTIVE SOUND HERE TOO
        else if(buttonType == "stocks_incrementInvIndOffset"){
            sound_general_scroller.play();}
        else{
            sound_general_click_active.play();}
    }
}