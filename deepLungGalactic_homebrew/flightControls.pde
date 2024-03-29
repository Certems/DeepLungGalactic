class flightControls{
    /*
    ---------
    |   | X |
    |--------
    |   |   |
    ---------
    A panel showing;
    -> The probes currently launched
     --> See controls for probe, current fuel level
     --> Option to take each reading type available (some may be destroyed by probe condition)
     --> Option to go back
    -> Option to launch new probes

    Screen names;
    selection -> probeControls
              -> probeLaunch
    ...
    */
    boolean screen_selection     = true;
    boolean screen_probeControls = false;
    boolean screen_probeLaunch   = false;
    boolean screen_outpostMining = false;

    ArrayList<button> buttonSet        = new ArrayList<button>();
    ArrayList<dispCell> probeCellSet   = new ArrayList<dispCell>();
    ArrayList<dispCell> outpostCellSet = new ArrayList<dispCell>();

    PVector cornerPos;  //Top-Left corner defining the origin from which items in this panel are drawn
    PVector panelDim;   //The dimensions of this panel, which must contain all the panel's information

    //Selection
    PVector launchButton_pos;
    PVector launchButton_dim;
    PVector backButton_pos;
    PVector backButton_dim;
    PVector scrollerProbe_dim;
    PVector scrollerProbe_pos;
    PVector scrollerOutpost_dim;
    PVector scrollerOutpost_pos;
    //Controls
    PVector fuel_dim;
    PVector fuel_pos;
    PVector thrustCtrl_dim;         //For EACH sections
    float thrustCtrl_spacing;       //Spacing between the two elements
    PVector thrustCtrl_fwd_pos;     //Top left corner
    PVector thrustCtrl_bck_pos;     //Top left corner
    PVector dynaVec_dim;     //Dimension for ALL items in the dynamics vectors
    PVector dynaVec_pos;     //The starting CORNER from which all other positions are seeded
    float dynaVec_spacing;   //Spacing between each item
    PVector scanSel_dim;         //Dim for both halves of the scanner selector
    PVector scanSel_pos;         //Pos of the TOP LEFT CORNER of the scanner selector setup
    PVector scanEngage_dim;      //
    PVector scanEngage_pos;      //
    //Launch
    PVector launchRelease_dim;  //
    PVector launchRelease_pos;  //
    PVector angularLauncher_dim;        //Make circular, same in x and y
    PVector angularLauncher_pos;        //Centre position
    interactable angularLauncher = new interactable("angSelector");
    //Mining
    PVector drillToggle_dim;        //
    PVector drillToggle_pos;        //
    PVector mineralTank_dim;    //
    PVector mineralTank_pos;    //
    PVector audioQuick_dim;         //
    PVector audioQuick_pos;         //
    PVector mineralQuick_dim;   //
    PVector mineralQuick_pos;   //
    PVector tempQuick_dim;          //
    PVector tempQuick_pos;          //
    PVector transport_dim;      //
    PVector transport_pos;      //
    PVector miningSlider_dim;       //
    PVector miningSlider_pos;       //
    PVector lock_dim;           //
    PVector lock_pos;           //
    PVector lockIndicator_dim;      //
    PVector lockIndicator_pos;      //
    PVector miningPos_dim;      //
    PVector miningPos_pos;      //

    int probeSetIndOffset   = 0;      //Offsets the index that the probeSet is first drawn at, so it can be scrolled through
    int outpostSetIndOffset = 0;      //
    float cellNumber = 6.0; //Number of visible cells on screen at once

    flightControls(PVector cornerPos, PVector panelDim){
        this.cornerPos = cornerPos;
        this.panelDim  = panelDim;

        launchButton_pos = new PVector(cornerPos.x +0.625*panelDim.x, cornerPos.y + panelDim.y/2.0);
        launchButton_dim = new PVector(2.0*panelDim.y/5.0, 2.0*panelDim.y/5.0);
        backButton_dim   = new PVector(0.15*panelDim.x,0.15*panelDim.x);
        backButton_pos   = new PVector(cornerPos.x +0.80*panelDim.x, cornerPos.y +panelDim.y -0.2*panelDim.x);
        scrollerProbe_dim     = new PVector(panelDim.y/7.0, panelDim.y/7.0);
        scrollerProbe_pos     = new PVector(cornerPos.x +0.78*panelDim.x, cornerPos.y +0.05*panelDim.y);
        scrollerOutpost_dim   = new PVector(panelDim.y/7.0, panelDim.y/7.0);
        scrollerOutpost_pos   = new PVector(cornerPos.x +0.88*panelDim.x, cornerPos.y +0.05*panelDim.y);
        fuel_dim         = new PVector(panelDim.x*0.07, panelDim.y*0.9);
        fuel_pos         = new PVector(cornerPos.x +panelDim.x*0.001, (cornerPos.y +panelDim.y -fuel_dim.y)/2.0);
        thrustCtrl_dim   = new PVector(0.2*panelDim.x, 0.325*panelDim.y);
        thrustCtrl_spacing = panelDim.y/4.0;
        thrustCtrl_fwd_pos = new PVector(cornerPos.x +0.1*panelDim.x, 0.05*panelDim.y                                        );
        thrustCtrl_bck_pos = new PVector(cornerPos.x +0.1*panelDim.x, 0.05*panelDim.y +(thrustCtrl_dim.y +thrustCtrl_spacing));
        dynaVec_dim     = new PVector(0.5*panelDim.x, 0.15*panelDim.y);
        dynaVec_pos     = new PVector(cornerPos.x +0.4*panelDim.x, cornerPos.y +0.05*panelDim.y);
        scanSel_dim     = new PVector(0.2*panelDim.x, 0.25*panelDim.y);
        scanSel_pos     = new PVector(cornerPos.x +0.35*panelDim.x, cornerPos.y +0.7*panelDim.y);
        scanEngage_dim  = new PVector(0.2*panelDim.x, 0.25*panelDim.y);
        scanEngage_pos  = new PVector(cornerPos.x +0.55*panelDim.x, cornerPos.y +0.7*panelDim.y);
        launchRelease_dim   = new PVector(0.15*panelDim.x, 0.15*panelDim.y);
        launchRelease_pos   = new PVector(cornerPos.x +0.80*panelDim.x, cornerPos.y +0.40*panelDim.y);
        angularLauncher_dim = new PVector(0.80*panelDim.y, 0.80*panelDim.y);
        angularLauncher_pos = new PVector(cornerPos.x +0.45*panelDim.x, cornerPos.y +0.5*panelDim.y);
        drillToggle_dim     = new PVector(0.15*panelDim.x,0.15*panelDim.y);
        drillToggle_pos     = new PVector(cornerPos.x +0.8*panelDim.x,cornerPos.y +0.4*panelDim.y);
        mineralTank_dim     = new PVector(0.2*panelDim.x, 0.8*panelDim.y);
        mineralTank_pos     = new PVector(cornerPos.x +0.06*panelDim.x, cornerPos.y +0.1*panelDim.y);
        audioQuick_dim      = new PVector(0.1*panelDim.x,0.1*panelDim.x);
        audioQuick_pos      = new PVector(cornerPos.x +0.54*panelDim.x,cornerPos.y +0.75*panelDim.y);
        mineralQuick_dim    = new PVector(0.1*panelDim.x,0.1*panelDim.x);
        mineralQuick_pos    = new PVector(cornerPos.x +0.42*panelDim.x,cornerPos.y +0.75*panelDim.y);
        tempQuick_dim       = new PVector(0.1*panelDim.x,0.1*panelDim.x);
        tempQuick_pos       = new PVector(cornerPos.x +0.3*panelDim.x,cornerPos.y +0.75*panelDim.y);
        transport_dim       = new PVector(0.1*panelDim.x,0.1*panelDim.x);
        transport_pos       = new PVector(cornerPos.x +0.66*panelDim.x,cornerPos.y +0.75*panelDim.y);
        miningSlider_dim    = new PVector(panelDim.x/3.0, panelDim.y/10.0);
        miningSlider_pos    = new PVector( cornerPos.x +(panelDim.x -miningSlider_dim.x)/2.0, cornerPos.y +0.1*panelDim.y );
        lock_dim            = new PVector(0.1*panelDim.x,0.1*panelDim.x);
        lock_pos            = new PVector(cornerPos.x +0.3*panelDim.x,cornerPos.y +0.4*panelDim.y);
        lockIndicator_dim   = new PVector(0.1*panelDim.x, 0.1*panelDim.x);
        lockIndicator_pos   = new PVector(cornerPos.x +0.54*panelDim.x,cornerPos.y +0.4*panelDim.y);
        miningPos_dim       = new PVector(panelDim.x/6.0, panelDim.y/5.0);
        miningPos_pos       = new PVector(miningSlider_pos.x +1.1*miningSlider_dim.x, miningSlider_pos.y);

        loadButtons_screen_selection();
    }

    void display(solarMap cSolarMap){
        display_background();
        if(screen_selection){
            display_selection();}
        if(screen_probeControls){
            display_probeControls(buttonSet.get(0).relatedProbe);}
        if(screen_probeLaunch){
            display_probeLaunch();}
        if(screen_outpostMining){
            display_outpostMining(buttonSet.get(0).relatedOutpost);}
        //display_buttonBounds();   //## BUG FIXING ##
    }
    void calc(){
        //pass
    }
    void flight_mousePressed(){
        angularLauncher.findClickPoints(angularLauncher_pos, angularLauncher_dim);
        checkOutpostInteractables_clicks(cManager.cSolarMap.outposts);
    }
    void flight_mouseReleased(){
        if(screen_probeControls){
            stopProbeThrust();}
        //...
    }

    void stopProbeThrust(){
        /*
        Whenever you are in the probe control panel, and you release you finger from the screen, 
        the probe will stop thrusting --> will either be the intended effect or pointless (but not harmful)
        */
        buttonSet.get(0).relatedProbe.thrustingFwd = false;
        buttonSet.get(0).relatedProbe.thrustingBck = false;
    }

    void checkOutpostInteractables_clicks(ArrayList<outpost> outposts){
        for(int i=0; i<outposts.size(); i++){
            outposts.get(i).miningSlider.findClickPoints(miningSlider_pos, miningSlider_dim);      //## VERY INNEFFICIENT, ONLY NEEDS TO CHECK THE OUTPOST THAT WAS CLICKED
        }
    }

    void display_background(){
        pushStyle();
        rectMode(CORNER);
        fill(20,20,20);
        noStroke();
        rect(cornerPos.x, cornerPos.y, panelDim.x, panelDim.y);
        popStyle();
    }
    void display_selection(){
        display_probeSet();
        display_outpostSet();
        display_probeScroller();
        display_outpostScroller();
        display_launchButton();
    }
    void display_launchButton(){
        pushStyle();
        imageMode(CENTER);
        image(texture_flight_selection_button_launchButton, launchButton_pos.x +launchButton_dim.x/2.0, launchButton_pos.y +launchButton_dim.y/2.0);
        popStyle();
    }
    void display_launchButton_simple(){
        pushStyle();
        fill(90,90,90);
        noStroke();
        ellipse(launchButton_pos.x +launchButton_dim.x/2.0, launchButton_pos.y +launchButton_dim.y/2.0, launchButton_dim.x, launchButton_dim.y);
        popStyle();
    }
    void display_probeSet(){
        /*
        Shows all current probes, as well as recently destroyed probes (which 
        can be dismissed to remove them from the list)
        */
        for(int i=0; i<cellNumber; i++){
            int givenProbeInd = i +probeSetIndOffset;
            if(givenProbeInd < probeCellSet.size()){
                probeCellSet.get(givenProbeInd).display();
            }
            else{
                break;
            }
        }
    }
    void display_outpostSet(){
        /*
        Shows all current probes, as well as recently destroyed probes (which 
        can be dismissed to remove them from the list)
        */
        for(int i=0; i<cellNumber; i++){
            int givenOutpostInd = i +outpostSetIndOffset;
            if(givenOutpostInd < outpostCellSet.size()){
                outpostCellSet.get(givenOutpostInd).display();
            }
            else{
                break;
            }
        }
    }
    void display_probeScroller(){
        pushStyle();
        imageMode(CENTER);
        image(texture_general_button_scroller, scrollerProbe_pos.x +scrollerProbe_dim.x/2.0, scrollerProbe_pos.y +scrollerProbe_dim.y/2.0);
        popStyle();
    }
    void display_probeScroller_simple(){
        pushStyle();
        fill(50,50,50);
        noStroke();
        ellipse(scrollerProbe_pos.x +scrollerProbe_dim.x/2.0, scrollerProbe_pos.y +scrollerProbe_dim.y/2.0, scrollerProbe_dim.x, scrollerProbe_dim.y);

        textAlign(CENTER, CENTER);
        fill(255,255,255);
        textSize(20);
        text("ScrollerProbe", scrollerProbe_pos.x +scrollerProbe_dim.x/2.0, scrollerProbe_pos.y +scrollerProbe_dim.y/2.0);
        popStyle();
    }
    void display_outpostScroller(){
        pushStyle();
        imageMode(CENTER);
        image(texture_general_button_scroller, scrollerOutpost_pos.x +scrollerOutpost_dim.x/2.0, scrollerOutpost_pos.y +scrollerOutpost_dim.y/2.0);
        popStyle();
    }
    void display_outpostScroller_simple(){
        pushStyle();
        fill(50,50,50);
        noStroke();
        ellipse(scrollerOutpost_pos.x +scrollerOutpost_dim.x/2.0, scrollerOutpost_pos.y +scrollerOutpost_dim.y/2.0, scrollerOutpost_dim.x, scrollerOutpost_dim.y);

        textAlign(CENTER, CENTER);
        fill(255,255,255);
        textSize(20);
        text("ScrollerOutpost", scrollerOutpost_pos.x +scrollerOutpost_dim.x/2.0, scrollerOutpost_pos.y +scrollerOutpost_dim.y/2.0);
        popStyle();
    }
    void display_probeControls(probe givenProbe){
        display_probeFuel(givenProbe);
        display_probeThrustControls();
        display_probeVectors(givenProbe);
        display_probeScanSel(givenProbe);
        display_probeScanEngage();
        display_backButton();
    }
    void display_backButton(){
        pushStyle();
        imageMode(CORNER);
        image(texture_general_button_back, backButton_pos.x, backButton_pos.y);
        popStyle();
    }
    void display_backButton_simple(){
        pushStyle();
        rectMode(CORNER);
        fill(30,30,30);
        noStroke();
        rect(backButton_pos.x, backButton_pos.y, backButton_dim.x, backButton_dim.y);

        fill(255,255,255);
        textAlign(CENTER, CENTER);
        textSize(20);
        text("Back", backButton_pos.x +backButton_dim.x/2.0, backButton_pos.y +backButton_dim.y/2.0);
        popStyle();
    }
    void display_probeFuel(probe givenProbe){
        pushStyle();

        //Back-face
        rectMode(CORNER);
        fill(10,10,10);
        stroke(100,100,100);
        strokeWeight(2);
        rect(fuel_pos.x, fuel_pos.y, fuel_dim.x, fuel_dim.y);

        //Front-face
        rectMode(CORNERS);
        fill(230,10,10);
        stroke(100,100,100);
        strokeWeight(2);
        float fuelProp = givenProbe.fuel;    //Proportion of fuel remaining -> Get from
        rect(fuel_pos.x, fuel_pos.y +(1.0-fuelProp)*fuel_dim.y, fuel_pos.x +fuel_dim.x, fuel_pos.y +fuel_dim.y);

        popStyle();
    }
    void display_probeThrustControls(){
        pushStyle();
        imageMode(CORNER);
        image(texture_flight_controls_thrustCtrl_fwd, thrustCtrl_fwd_pos.x, thrustCtrl_fwd_pos.y);
        image(texture_flight_controls_thrustCtrl_bck, thrustCtrl_bck_pos.x, thrustCtrl_bck_pos.y);
        popStyle();
    }
    void display_probeThrustControls_simple(){
        pushStyle();

        rectMode(CORNER);
        fill(60,60,60);
        stroke(100,100,100);
        strokeWeight(3);
        //Elem 1
        rect(thrustCtrl_fwd_pos.x, thrustCtrl_fwd_pos.y, thrustCtrl_dim.x, thrustCtrl_dim.y);
        //Elem 2
        rect(thrustCtrl_bck_pos.x, thrustCtrl_bck_pos.y, thrustCtrl_dim.x, thrustCtrl_dim.y);

        popStyle();
    }
    void display_probeVectors(probe givenProbe){
        float border      = dynaVec_dim.y/5.0;
        float coordOffset = dynaVec_dim.x/6.0;

        pushStyle();
        rectMode(CORNER);        
        //Backgrounds
        fill(60,60,60);
        stroke(100,100,100);
        strokeWeight(1);
        rect(dynaVec_pos.x, dynaVec_pos.y                             , dynaVec_dim.x, dynaVec_dim.y);
        rect(dynaVec_pos.x, dynaVec_pos.y +1.0*(dynaVec_dim.y +border), dynaVec_dim.x, dynaVec_dim.y);
        rect(dynaVec_pos.x, dynaVec_pos.y +2.0*(dynaVec_dim.y +border), dynaVec_dim.x, dynaVec_dim.y);
        //Titles
        textSize(0.5*dynaVec_dim.y);
        textAlign(LEFT, CENTER);
        fill(250,200,200);
        text("Pos;",dynaVec_pos.x, dynaVec_pos.y +dynaVec_dim.y/2.0);
        fill(200,250,200);
        text("Vel;",dynaVec_pos.x, dynaVec_pos.y +dynaVec_dim.y/2.0 +1.0*(dynaVec_dim.y +border));
        fill(200,200,250);
        text("Acc;",dynaVec_pos.x, dynaVec_pos.y +dynaVec_dim.y/2.0 +2.0*(dynaVec_dim.y +border));
        //Coords
        String posFormatted = "("+str(roundToXdp(givenProbe.pos.x, 1))+" , "+str(roundToXdp(givenProbe.pos.y, 1))+")";
        String velFormatted = "("+str(roundToXdp(givenProbe.vel.x, 2))+" , "+str(roundToXdp(givenProbe.vel.y, 2))+")";
        String accFormatted = "("+str(roundToXdp(givenProbe.acc.x, 2))+" , "+str(roundToXdp(givenProbe.acc.y, 2))+")";
        textSize(0.5*dynaVec_dim.y);
        textAlign(CENTER, CENTER);
        fill(250,200,200);
        text(posFormatted, dynaVec_pos.x +(dynaVec_dim.x +coordOffset)/2.0, dynaVec_pos.y +dynaVec_dim.y/2.0);
        fill(200,250,200);
        text(velFormatted, dynaVec_pos.x +(dynaVec_dim.x +coordOffset)/2.0, dynaVec_pos.y +dynaVec_dim.y/2.0 +1.0*(dynaVec_dim.y +border));
        fill(200,200,250);
        text(accFormatted, dynaVec_pos.x +(dynaVec_dim.x +coordOffset)/2.0, dynaVec_pos.y +dynaVec_dim.y/2.0 +2.0*(dynaVec_dim.y +border));

        popStyle();
    }
    void display_probeScanSel(probe givenProbe){
        /*
        Displays which data type would like to be selected AND an area to click to begin the scan for this data type
        This will then result in the sensor (on the left) displaying the given info (AFTER the button has been clicked)
        */
        pushStyle();
        imageMode(CORNER);
        image(texture_flight_controls_scanSel, scanSel_pos.x, scanSel_pos.y);

        textSize(scanSel_dim.x/3.0);
        textAlign(CENTER, CENTER);
        fill(255);
        text(givenProbe.dataType, scanSel_pos.x +scanSel_dim.x/2.0, scanSel_pos.y +scanSel_dim.y/2.0);

        popStyle();
    }
    void display_probeScanSel_simple(probe givenProbe){
        /*
        Displays which data type would like to be selected AND an area to click to begin the scan for this data type
        This will then result in the sensor (on the left) displaying the given info (AFTER the button has been clicked)
        */
        pushStyle();

        //Bounding box
        //rectMode(CORNER);
        //fill(120,120,120, 40);
        //stroke(20,20,20);
        //rect(scanSel_pos.x, scanSel_pos.y, scanSel_dim.x, scanSel_dim.y);

        rectMode(CORNER);
        stroke(30,30,30);
        strokeWeight(2);
        fill(70,70,70);
        rect(scanSel_pos.x, scanSel_pos.y, scanSel_dim.x, scanSel_dim.y);

        textSize(scanSel_dim.x/3.0);
        textAlign(CENTER, CENTER);
        fill(255);
        text(givenProbe.dataType, scanSel_pos.x +scanSel_dim.x/2.0, scanSel_pos.y +scanSel_dim.y/2.0);

        popStyle();
    }
    void display_probeScanEngage(){
        /*
        Displays which data type would like to be selected AND an area to click to begin the scan for this data type
        This will then result in the sensor (on the left) displaying the given info (AFTER the button has been clicked)
        */
        pushStyle();
        imageMode(CORNER);
        image(texture_flight_controls_scanEngage, scanEngage_pos.x, scanEngage_pos.y);
        popStyle();
    }
    void display_probeScanEngage_simple(){
        /*
        Displays which data type would like to be selected AND an area to click to begin the scan for this data type
        This will then result in the sensor (on the left) displaying the given info (AFTER the button has been clicked)
        */
        pushStyle();

        //Bounding box
        //rectMode(CORNER);
        //fill(120,120,120, 40);
        //stroke(20,20,20);
        //rect(scanEngage_pos.x, scanEngage_pos.y, scanEngage_dim.x, scanEngage_dim.y);

        rectMode(CORNER);
        stroke(30,30,30);
        strokeWeight(2);
        fill(70,70,70);
        rect(scanEngage_pos.x, scanEngage_pos.y, scanEngage_dim.x, scanEngage_dim.y);

        popStyle();
    }
    void display_probeLaunch(){
        display_probeAngularLaunchDisp();
        display_launchReleaseButton();
        display_backButton();
    }
    void display_probeAngularLaunchDisp(){
        if(angularLauncher.isVisible){
            angularLauncher.display(angularLauncher_pos, angularLauncher_dim);}
    }
    void display_launchReleaseButton(){
        pushStyle();
        imageMode(CORNER);
        image(texture_flight_launch_launchRelease, launchRelease_pos.x, launchRelease_pos.y);
        popStyle();
    }
    void display_launchReleaseButton_simple(){
        pushStyle();
        rectMode(CORNER);
        stroke(30,30,30);
        strokeWeight(2);
        fill(70,70,70);
        rect(launchRelease_pos.x, launchRelease_pos.y, launchRelease_dim.x, launchRelease_dim.y);
        popStyle();
    }
    void display_outpostMining(outpost cOutpost){
        display_position(cOutpost);
        display_drillToggle();
        display_mineralTanks(cOutpost);
        display_audioQuick();
        display_mineralQuick();
        display_tempQuick();
        display_transportMinerals();
        display_lock();
        display_lockIndicator(cOutpost);
        display_miningSlider(cOutpost);
        display_backButton();

        //## BUG FIXING
        //pushStyle();
        //fill(255,255,255);
        //textSize(30);
        //text(cOutpost.resistance, mouseX, mouseY);
        //text(str(cOutpost.locked), mouseX, mouseY +30.0);
        //popStyle();
        //## BUG FIXING
    }
    void display_position(outpost cOutpost){
        pushStyle();

        rectMode(CORNER);
        fill(80,80,80, 150);
        rect(miningPos_pos.x, miningPos_pos.y, miningPos_dim.x, miningPos_dim.y);

        textAlign(CENTER, CENTER);
        textSize(panelDim.x/35.0);
        fill(230,230,230);
        text("("+str(roundToXdp(cOutpost.linkedBody.pos.x,1))+" ,"+str(roundToXdp(-cOutpost.linkedBody.pos.y,1))+")", miningPos_pos.x +miningPos_dim.x/2.0, miningPos_pos.y +1.0*miningPos_dim.y/3.0);
        fill(230,200,200);
        text("("+str(roundToXdp(cOutpost.pos.x           ,1))+" ,"+str(roundToXdp(-cOutpost.pos.y,1))           +")", miningPos_pos.x +miningPos_dim.x/2.0, miningPos_pos.y +2.0*miningPos_dim.y/3.0);
        popStyle();
    }
    void display_drillToggle(){
        pushStyle();
        imageMode(CORNER);
        image(texture_flight_mining_drillToggle, drillToggle_pos.x, drillToggle_pos.y);
        popStyle();
    }
    void display_drillToggle_simple(){
        pushStyle();
        rectMode(CORNER);
        stroke(30,30,30);
        strokeWeight(2);
        fill(70,70,70);
        rect(drillToggle_pos.x, drillToggle_pos.y, drillToggle_dim.x, drillToggle_dim.y);
        popStyle();
    }
    void display_mineralTanks(outpost cOutpost){
        cOutpost.cCargo.display(mineralTank_pos, mineralTank_dim);
    }
    void display_audioQuick(){
        pushStyle();
        imageMode(CENTER);
        image(texture_flight_mining_audioQuick, audioQuick_pos.x +audioQuick_dim.x/2.0, audioQuick_pos.y +audioQuick_dim.y/2.0);
        popStyle();
    }
    void display_audioQuick_simple(){
        pushStyle();
        stroke(30,30,30);
        strokeWeight(2);
        fill(70,70,70);
        ellipse(audioQuick_pos.x +audioQuick_dim.x/2.0, audioQuick_pos.y +audioQuick_dim.y/2.0, audioQuick_dim.x, audioQuick_dim.y);
        popStyle();
    }
    void display_mineralQuick(){
        pushStyle();
        imageMode(CENTER);
        image(texture_flight_mining_mineralQuick, mineralQuick_pos.x +mineralQuick_dim.x/2.0, mineralQuick_pos.y +mineralQuick_dim.y/2.0);
        popStyle();
    }
    void display_mineralQuick_simple(){
        pushStyle();
        stroke(30,30,30);
        strokeWeight(2);
        fill(70,70,70);
        ellipse(mineralQuick_pos.x +mineralQuick_dim.x/2.0, mineralQuick_pos.y +mineralQuick_dim.y/2.0, mineralQuick_dim.x, mineralQuick_dim.y);
        popStyle();
    }
    void display_tempQuick(){
        pushStyle();
        imageMode(CENTER);
        image(texture_flight_mining_tempQuick, tempQuick_pos.x +tempQuick_dim.x/2.0, tempQuick_pos.y +tempQuick_dim.y/2.0); //## GIVE THIS A TEXTURE ##
        popStyle();
    }
    void display_tempQuick_simple(){
        pushStyle();
        stroke(30,30,30);
        strokeWeight(2);
        fill(70,70,70);
        ellipse(tempQuick_pos.x +tempQuick_dim.x/2.0, tempQuick_pos.y +tempQuick_dim.y/2.0, tempQuick_dim.x, tempQuick_dim.y);
        popStyle();
    }
    void display_transportMinerals(){
        pushStyle();
        imageMode(CENTER);
        image(texture_flight_mining_transport, transport_pos.x +transport_dim.x/2.0, transport_pos.y +transport_dim.y/2.0);
        popStyle();
    }
    void display_transportMinerals_simple(){
        pushStyle();
        stroke(30,30,30);
        strokeWeight(2);
        fill(70,70,70);
        ellipse(transport_pos.x +transport_dim.x/2.0, transport_pos.y +transport_dim.y/2.0, transport_dim.x, transport_dim.y);
        popStyle();
    }
    void display_lock(){
        pushStyle();
        imageMode(CENTER);
        image(texture_flight_mining_lock, lock_pos.x +lock_dim.x/2.0, lock_pos.y +lock_dim.y/2.0);     //## GIVE THIS A TEXTURE ##
        popStyle();
    }
    void display_lock_simple(){
        pushStyle();
        stroke(30,30,30);
        strokeWeight(2);
        fill(70,70,70);
        ellipse(lock_pos.x +lock_dim.x/2.0, lock_pos.y +lock_dim.y/2.0, lock_dim.x, lock_dim.y);
        popStyle();
    }
    void display_lockIndicator(outpost cOutpost){
        if(cOutpost.locked){
            pushStyle();
            imageMode(CENTER);
            image(texture_flight_mining_lockIndicator, lockIndicator_pos.x +lockIndicator_dim.x/2.0, lockIndicator_pos.y +lockIndicator_dim.y/2.0);     //## GIVE THIS A TEXTURE ##
            popStyle();
        }
    }
    void display_lockIndicator_simple(outpost cOutpost){
        if(cOutpost.locked){
            pushStyle();
            stroke(30,30,30);
            strokeWeight(2);
            fill(70,70,70);
            ellipse(lockIndicator_pos.x +lockIndicator_dim.x/2.0, lockIndicator_pos.y +lockIndicator_dim.y/2.0, lockIndicator_dim.x, lockIndicator_dim.y);
            popStyle();
        }
    }
    void display_miningSlider(outpost cOutpost){
        if(cOutpost.miningSlider.isVisible){
            cOutpost.miningSlider.display(miningSlider_pos, miningSlider_dim);
            pushStyle();
            fill(20,20,20);
            textAlign(CENTER, CENTER);
            textSize(miningSlider_dim.y/2.0);
            text(str( floor(degrees(cOutpost.angleOffsetRange))) +"°", miningSlider_pos.x +miningSlider_dim.x -0.1*miningSlider_dim.x, miningSlider_pos.y +0.5*miningSlider_dim.y);
            text(str(-floor(degrees(cOutpost.angleOffsetRange))) +"°", miningSlider_pos.x                     +0.1*miningSlider_dim.x, miningSlider_pos.y +0.5*miningSlider_dim.y);
            popStyle();}
    }
    //##BUG FIXING##
    void display_buttonBounds(){
        for(int i=0; i<buttonSet.size(); i++){
            buttonSet.get(i).displayOutline();
        }
    }
    //##BUG FIXING##


    void generateCellSet(ArrayList<probe> probes, ArrayList<probe> destroyed_probes, ArrayList<outpost> outposts, ArrayList<outpost> destroyed_outposts){
        /*
        Generate the set of cells for probes, from each probe
        Should be re-run if;
        .Probes added
        .Probes destroyed
        .List is scrolled
        */
        probeCellSet.clear();
        generateProbeCellSet(probes, destroyed_probes);          // These can also be run indiviudally if only certain sets are changed too
        generateOutpostCellSet(outposts, destroyed_outposts);    //
    }
    void generateProbeCellSet(ArrayList<probe> probes, ArrayList<probe> destroyed_probes){
        float leftBorder = 5.0;                                                     //Distance cells start from the left side of the panel
        float border     = 10.0;                                                    //Space between cells
        float cellHeight = (panelDim.y -(cellNumber+1)*border) / (cellNumber);      //The height of each box containing probe info
        float sizeOfText = cellHeight/2.0;
        float sizeOfIcon = cellHeight/3.0;
        PVector startPos = new PVector(cornerPos.x +leftBorder, cornerPos.y);   //Coord for starting the drawing of cells
        probeCellSet.clear();
        //Alive
        for(int i=0; i<probes.size(); i++){
            PVector relPos = new PVector(startPos.x, startPos.y +cellHeight*(i-probeSetIndOffset) +border*(i-probeSetIndOffset+1));
            float cellWidth = panelDim.x/4.0;                                   //Changes depending on info amount
            dispCell newCell = new dispCell(sizeOfText, sizeOfIcon, new PVector(relPos.x, relPos.y), new PVector(cellWidth, cellHeight));
            newCell.cProbe = probes.get(i);
            newCell.initialise();
            probeCellSet.add(newCell);
        }
        //Destroyed
        for(int j=0; j<destroyed_probes.size(); j++){
            int i = j +cManager.cSolarMap.probes.size();
            PVector relPos = new PVector(startPos.x, startPos.y +cellHeight*(i-probeSetIndOffset) +border*(i-probeSetIndOffset+1));
            float cellWidth = panelDim.x/4.0;                                   //Changes depending on info amount
            dispCell newCell = new dispCell(sizeOfText, sizeOfIcon, new PVector(relPos.x, relPos.y), new PVector(cellWidth, cellHeight));
            newCell.cProbe = destroyed_probes.get(j);
            newCell.initialise();
            probeCellSet.add(newCell);
        }
    }
    void generateOutpostCellSet(ArrayList<outpost> outposts, ArrayList<outpost> destroyed_outposts){
        float outpostOffset = 0.3*panelDim.x;
        float leftBorder = 5.0;                                                     //Distance cells start from the left side of the panel
        float border     = 10.0;                                                    //Space between cells
        float cellHeight = (panelDim.y -(cellNumber+1)*border) / (cellNumber);      //The height of each box containing probe info
        float sizeOfText = cellHeight/2.0;
        float sizeOfIcon = cellHeight/3.0;
        PVector startPos = new PVector(cornerPos.x +leftBorder +outpostOffset, cornerPos.y);   //Coord for starting the drawing of cells
        outpostCellSet.clear();
        //Alive
        for(int i=0; i<outposts.size(); i++){
            PVector relPos = new PVector(startPos.x, startPos.y +cellHeight*(i-outpostSetIndOffset) +border*(i-outpostSetIndOffset+1));
            float cellWidth = panelDim.x/4.0;                                   //Changes depending on info amount
            dispCell newCell = new dispCell(sizeOfText, sizeOfIcon, new PVector(relPos.x, relPos.y), new PVector(cellWidth, cellHeight));
            newCell.cOutpost = outposts.get(i);
            newCell.initialise();
            outpostCellSet.add(newCell);
        }
        //Destroyed
        for(int j=0; j<destroyed_outposts.size(); j++){
            int i = j + cManager.cSolarMap.outposts.size();
            PVector relPos = new PVector(startPos.x, startPos.y +cellHeight*(i-probeSetIndOffset) +border*(i-probeSetIndOffset+1));
            float cellWidth = panelDim.x/4.0;                                   //Changes depending on info amount
            dispCell newCell = new dispCell(sizeOfText, sizeOfIcon, new PVector(relPos.x, relPos.y), new PVector(cellWidth, cellHeight));
            newCell.cOutpost = destroyed_outposts.get(j);
            newCell.initialise();
            outpostCellSet.add(newCell);
        }
    }


    void launchProbe(ArrayList<probe> probes, PVector launchLoc, float theta, float speed){
        /*
        Launches a probe from the target location [(0,0) for the ship] at a 
        given angle and initial speed
        Assumes launch has no initial acc
        */
        probe newProbe = new probe( new PVector(launchLoc.x, launchLoc.y), new PVector(speed*cos(theta), speed*sin(theta)), new PVector(0,0) );   //In AU units
        probes.add(newProbe);
        generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
    }


    void loadButtons_screen_selection(){
        /*
        Loads buttons for the given screen, this has;
        . All probes listed, clickable
        . Button to launch new probes, clickable

        ####
        ## MOVE PROBE AND OUTPOST BUTTON LOA=DING INTO ANOTHER FUNCTION TO CLEAN UP
        ####
        */
        buttonSet.clear();
        //Probes
        for(int i=probeSetIndOffset; i<probeSetIndOffset +cellNumber; i++){
            if(i < probeCellSet.size()){   //If valid
                if(i < cManager.cSolarMap.probes.size()){
                    //For ALIVE probes
                    button newButton = new button(probeCellSet.get(i).pos, probeCellSet.get(i).dim, "rect", "flight_probe_goToControls");
                    newButton.relatedProbe = probeCellSet.get(i).cProbe;
                    buttonSet.add(newButton);
                }
                else{
                    //For DESTROYED probes
                    button newButton = new button(probeCellSet.get(i).pos, probeCellSet.get(i).dim, "rect", "flight_probe_dismissDestroyed");
                    newButton.relatedProbe = probeCellSet.get(i).cProbe;
                    buttonSet.add(newButton);
                }
            }
        }
        //Outposts
        for(int i=outpostSetIndOffset; i<outpostSetIndOffset +cellNumber; i++){
            if(i < outpostCellSet.size()){   //If valid
                if(i < cManager.cSolarMap.outposts.size()){
                    //For ALIVE probes
                    button newButton = new button(outpostCellSet.get(i).pos, outpostCellSet.get(i).dim, "rect", "flight_outpost_goToMining");
                    newButton.relatedOutpost = outpostCellSet.get(i).cOutpost;
                    buttonSet.add(newButton);
                }
                else{
                    //For DESTROYED probes
                    button newButton = new button(outpostCellSet.get(i).pos, outpostCellSet.get(i).dim, "rect", "flight_outpost_dismissDestroyed");
                    newButton.relatedOutpost = outpostCellSet.get(i).cOutpost;
                    buttonSet.add(newButton);
                }
            }
        }
        button newButton0 = new button( scrollerProbe_pos  , scrollerProbe_dim  , "circ", "flight_incrementProbeIndOffset");
        button newButton1 = new button( scrollerOutpost_pos, scrollerOutpost_dim, "circ", "flight_incrementOutpostIndOffset");
        button newButton2 = new button(launchButton_pos, launchButton_dim, "circ", "flight_goToLaunch");
        buttonSet.add(newButton0);buttonSet.add(newButton1);buttonSet.add(newButton2);
    }
    void loadButtons_screen_probeControls(probe givenProbe){
        /*
        Loads buttons for the given screen, this has;
        . Thrust fwd/bck buttons, clickable (click and holdable)
        . Back button (to selection screen), clickable
        . Other information such as fuel, velocity, position, etc, NOT clickable
        */
        buttonSet.clear();
        button newButton0 = new button(thrustCtrl_fwd_pos, thrustCtrl_dim, "rect", "flight_thrustForward");     //##### MAKE UP AND DOWN THRUST
        button newButton1 = new button(thrustCtrl_bck_pos, thrustCtrl_dim, "rect", "flight_thrustBack");        //##### MAKE UP AND DOWN THRUST
        button newButton2 = new button(scanSel_pos, scanSel_dim, "rect", "flight_changeSensorDataType");
        button newButton3 = new button(scanEngage_pos, scanEngage_dim, "rect", "flight_searchSensorDataType");
        button newButton4 = new button(backButton_pos, backButton_dim, "rect", "flight_goToSelection");
        newButton0.relatedProbe = givenProbe;newButton1.relatedProbe = givenProbe;newButton2.relatedProbe = givenProbe;newButton3.relatedProbe = givenProbe;
        buttonSet.add(newButton0);buttonSet.add(newButton1);buttonSet.add(newButton2);buttonSet.add(newButton3);buttonSet.add(newButton4);
    }
    void loadButtons_screen_probeLaunch(){
        /*
        Loads buttons for the given screen, this has;
        . Launch direction controls, interactive
        . Launch velocity slider, interactive
        . Back button (to selection), clickable
        */
        buttonSet.clear();
        button newButton0 = new button(backButton_pos   , backButton_dim   , "rect", "flight_goToSelection");
        button newButton1 = new button(launchRelease_pos, launchRelease_dim, "rect", "flight_launch_fireProbe");
        buttonSet.add(newButton0);buttonSet.add(newButton1);
    }
    void loadButtons_screen_outpostMining(outpost givenOutpost){
        /*
        Loads buttons for the given screen, this has;
        . Launch direction controls, interactive
        . Launch velocity slider, interactive
        . Back button (to selection), clickable
        */
        buttonSet.clear();
        button newButton0 = new button(drillToggle_pos  , drillToggle_dim   , "rect", "flight_outpost_mining_drillToggle");
        button newButton1 = new button(mineralTank_pos  , mineralTank_dim   , "rect", "flight_outpost_mining_mineralTankInfoReveal");
        button newButton2 = new button(audioQuick_pos   , audioQuick_dim    , "circ", "flight_outpost_mining_audioQuick");
        button newButton3 = new button(mineralQuick_pos , mineralQuick_dim  , "circ", "flight_outpost_mining_mineralQuick");
        button newButton4 = new button(tempQuick_pos    , tempQuick_dim     , "circ", "flight_outpost_mining_tempQuick");
        button newButton5 = new button(transport_pos    , transport_dim     , "circ", "flight_outpost_mining_transportMinerals");
        button newButton6 = new button(lock_pos         , lock_dim          , "rect", "flight_outpost_mining_lockOutpost");
        button newButton7 = new button(backButton_pos   , backButton_dim    , "rect", "flight_goToSelection");
        newButton0.relatedOutpost = givenOutpost;newButton1.relatedOutpost = givenOutpost;newButton2.relatedOutpost = givenOutpost;newButton3.relatedOutpost = givenOutpost;newButton4.relatedOutpost = givenOutpost;newButton5.relatedOutpost = givenOutpost;newButton6.relatedOutpost = givenOutpost;newButton7.relatedOutpost = givenOutpost;
        buttonSet.add(newButton0);buttonSet.add(newButton1);buttonSet.add(newButton2);buttonSet.add(newButton3);buttonSet.add(newButton4);buttonSet.add(newButton5);buttonSet.add(newButton6);buttonSet.add(newButton7);
    }
}

class dispCell{
    /*
    Contains all relevent information to display a cell in the probe list 
    for a specific cell
    */
    probe cProbe     = null;    //Initialise when created
    outpost cOutpost = null;

    PVector pos;    //Corner position
    PVector dim;

    String infoText;
    float sizeOfText;

    float sizeOfIcon;

    dispCell(float sizeOfText, float sizeOfIcon, PVector pos, PVector dim){
        this.pos    = pos;
        this.dim    = dim;
        this.sizeOfText = sizeOfText;
        this.sizeOfIcon = sizeOfIcon;

        infoText = "";
    }

    void initialise(){
        /*
        For initialising AFTER the probe/oupost/... is given to it after its initial creation
        */
        generate_infoText();
    }
    void generate_infoText(){
        if(cProbe != null){
            infoText = str(cProbe.ID);}
        if(cOutpost != null){
            infoText = str(cOutpost.ID);}
    }
    void display(){
        /*
        IndNumber used to specify which location this cell appears in in the list
        StartPos refers to where the 1st cell is drawn from -> all others relative to that
        */
        pushStyle();
        //Bounding rect
        imageMode(CORNER);
        image(texture_flight_selection_probe_selectionBox, pos.x, pos.y, dim.x, dim.y);

        //Info text
        fill(255,255,255);
        textAlign(LEFT,CENTER);
        textSize(sizeOfText);
        text(infoText, pos.x, pos.y +sizeOfText);

        //Status icon
        fill(0,0,0);    //**Bug fixer basically
        if(cProbe != null){
            fill(cProbe.statusCol.x, cProbe.statusCol.y, cProbe.statusCol.z);}
        if(cOutpost != null){
            fill(cOutpost.statusCol.x, cOutpost.statusCol.y, cOutpost.statusCol.z);}
        ellipse(pos.x +sizeOfIcon/2.0, pos.y +sizeOfIcon/2.0, sizeOfIcon, sizeOfIcon);
        popStyle();
    }
    void display_simple(){
        /*
        IndNumber used to specify which location this cell appears in in the list
        StartPos refers to where the 1st cell is drawn from -> all others relative to that
        */
        pushStyle();
        //Bounding rect
        fill(80,80,80,180);
        noStroke();
        rectMode(CORNER);
        rect(pos.x, pos.y, dim.x, dim.y);

        //Info text
        fill(255,255,255);
        textAlign(LEFT,CENTER);
        textSize(sizeOfText);
        text(infoText, pos.x, pos.y +sizeOfText);

        //Status icon
        fill(0,0,0);    //**Bug fixer basically
        if(cProbe != null){
            fill(cProbe.statusCol.x, cProbe.statusCol.y, cProbe.statusCol.z);}
        if(cOutpost != null){
            fill(cOutpost.statusCol.x, cOutpost.statusCol.y, cOutpost.statusCol.z);}
        ellipse(pos.x +sizeOfIcon/2.0, pos.y +sizeOfIcon/2.0, sizeOfIcon, sizeOfIcon);
        popStyle();
    }
}

/*
###
DUPLICATE LIKELY FROM DISCEPANCY BETWEEN 
SET OF PROBES AND THE DISPCELL SET
##


--> NO, IS FROM DESTROYED PROBES NOT STARTING AT THE END OF PROBES
*/