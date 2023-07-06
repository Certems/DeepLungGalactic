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

    ArrayList<button> buttonSet = new ArrayList<button>();
    ArrayList<probeDispCell> probeCellSet = new ArrayList<probeDispCell>();

    PVector cornerPos;  //Top-Left corner defining the origin from which items in this panel are drawn
    PVector panelDim;   //The dimensions of this panel, which must contain all the panel's information

    PVector launchButton_pos;
    PVector launchButton_dim;
    PVector backButton_pos;
    PVector backButton_dim;
    PVector scroller_dim;
    PVector scroller_pos;
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

    int probeSetIndOffset = 0;          //Offsets the index that the probeSet is first drawn at, so it can be scrolled through
    float probeCell_cellNumber = 6.0;   //Number of visible cells on screen at once

    flightControls(PVector cornerPos, PVector panelDim){
        this.cornerPos = cornerPos;
        this.panelDim  = panelDim;

        launchButton_pos = new PVector(cornerPos.x +0.625*panelDim.x, cornerPos.y + panelDim.y/2.0);
        launchButton_dim = new PVector(2.0*panelDim.y/5.0, 2.0*panelDim.y/5.0);
        backButton_dim   = new PVector(0.15*panelDim.x,0.15*panelDim.y);
        backButton_pos   = new PVector(cornerPos.x +0.80*panelDim.x, cornerPos.y +0.80*panelDim.y);
        scroller_dim = new PVector(panelDim.y/7.0, panelDim.y/7.0);
        scroller_pos = new PVector(cornerPos.x +0.88*panelDim.x, cornerPos.y +0.05*panelDim.y);
        fuel_dim     = new PVector(panelDim.x*0.07, panelDim.y*0.9);
        fuel_pos     = new PVector(cornerPos.x +panelDim.x*0.001, (cornerPos.y +panelDim.y -fuel_dim.y)/2.0);
        thrustCtrl_dim = new PVector(0.2*panelDim.x, 0.325*panelDim.y);
        thrustCtrl_spacing = panelDim.y/4.0;
        thrustCtrl_fwd_pos = new PVector(cornerPos.x +0.1*panelDim.x, 0.05*panelDim.y                                        );
        thrustCtrl_bck_pos = new PVector(cornerPos.x +0.1*panelDim.x, 0.05*panelDim.y +(thrustCtrl_dim.y +thrustCtrl_spacing));
        dynaVec_dim = new PVector(0.62*panelDim.x, 0.2*panelDim.y);
        dynaVec_pos = new PVector(cornerPos.x +0.35*panelDim.x, cornerPos.y +0.01*panelDim.y);
        dynaVec_spacing = 0.05*panelDim.x;
        scanSel_dim = new PVector(0.2*panelDim.x, 0.25*panelDim.y);
        scanSel_pos = new PVector(cornerPos.x +0.55*panelDim.x, cornerPos.y +0.36*panelDim.y);
        scanEngage_dim = new PVector(0.2*panelDim.x, 0.25*panelDim.y);
        scanEngage_pos = new PVector(cornerPos.x +0.75*panelDim.x, cornerPos.y +0.36*panelDim.y);
    }

    void display(solarMap cSolarMap){
        display_background();
        if(screen_selection){
            display_selection();}
        if(screen_probeControls){
            display_probeControls(buttonSet.get(0).relatedProbe);}
        if(screen_probeLaunch){
            display_probeLaunch();}
        display_buttonBounds();
    }
    void calc(){
        //pass
    }
    void flight_mousePressed(){
        //pass
    }
    void flight_mouseReleased(){
        //pass
    }

    void display_background(){
        pushStyle();
        rectMode(CORNER);
        fill(20,20,30);
        noStroke();
        rect(cornerPos.x, cornerPos.y, panelDim.x, panelDim.y);
        popStyle();
    }
    void display_selection(){
        display_probeSet();
        display_probeScroller();
    }
    void display_probeSet(){
        /*
        Shows all current probes, as well as recently destroyed probes (which 
        can be dismissed to remove them from the list)
        */
        for(int i=0; i<probeCell_cellNumber; i++){
            int givenProbeInd = i +probeSetIndOffset;
            if(givenProbeInd < probeCellSet.size()){
                probeCellSet.get(givenProbeInd).display();
            }
            else{
                break;
            }
        }
    }
    void display_probeScroller(){
        pushStyle();
        fill(50,50,50);
        noStroke();
        ellipse(scroller_pos.x +scroller_dim.x/2.0, scroller_pos.y +scroller_dim.y/2.0, scroller_dim.x, scroller_dim.y);

        textAlign(CENTER, CENTER);
        fill(255,255,255);
        textSize(20);
        text("Scroller", scroller_pos.x +scroller_dim.x/2.0, scroller_pos.y +scroller_dim.y/2.0);
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
        float fuelProp = 0.8;    //Proportion of fuel remaining -> Get from
        rect(fuel_pos.x, fuel_pos.y +(1.0-fuelProp)*fuel_dim.y, fuel_pos.x +fuel_dim.x, fuel_pos.y +fuel_dim.y);

        popStyle();
    }
    void display_probeThrustControls(){
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
        pushStyle();

        rectMode(CORNER);
        //Bounding box
        //fill(120,120,120, 40);
        //stroke(20,20,20);
        //rect(dynaVec_pos.x, dynaVec_pos.y, dynaVec_dim.x, dynaVec_dim.y);

        fill(60,60,60);
        stroke(100,100,100);
        strokeWeight(1);
        float elementWidth = (dynaVec_dim.x -2.0*dynaVec_spacing)/3.0;
        float propPercent = 0.8;
        float propWidth   = propPercent*elementWidth;
        float propOffset  = ((1.0 -propPercent)*elementWidth)/2.0;
        //Elem 1
        rect(dynaVec_pos.x                                                 , dynaVec_pos.y, elementWidth, 2.0*dynaVec_dim.y/3.0);
        rect(dynaVec_pos.x +propOffset                                     , dynaVec_pos.y +2.0*dynaVec_dim.y/3.0, propWidth, 1.0*dynaVec_dim.y/3.0);
        //Elem 2
        rect(dynaVec_pos.x +1.0*(elementWidth +dynaVec_spacing)            , dynaVec_pos.y, elementWidth, 2.0*dynaVec_dim.y/3.0);
        rect(dynaVec_pos.x +1.0*(elementWidth +dynaVec_spacing) +propOffset, dynaVec_pos.y +2.0*dynaVec_dim.y/3.0, propWidth, 1.0*dynaVec_dim.y/3.0);
        //Elem 2
        rect(dynaVec_pos.x +2.0*(elementWidth +dynaVec_spacing)            , dynaVec_pos.y, elementWidth, 2.0*dynaVec_dim.y/3.0);
        rect(dynaVec_pos.x +2.0*(elementWidth +dynaVec_spacing) +propOffset, dynaVec_pos.y +2.0*dynaVec_dim.y/3.0, propWidth, 1.0*dynaVec_dim.y/3.0);

        popStyle();
    }
    void display_probeScanSel(probe givenProbe){
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
        display_backButton();
    }
    void display_probeAngularLaunchDisp(){
        pushStyle();
        textSize(40);
        text("Ang screen", panelDim.x/2.0, panelDim.y/2.0);
        popStyle();
    }
    //##BUG FIXING##
    void display_buttonBounds(){
        for(int i=0; i<buttonSet.size(); i++){
            buttonSet.get(i).displayOutline();
        }
    }
    //##BUG FIXING##


    void generateProbeCellSet(ArrayList<probe> probes){
        /*
        Generate the set of cells for probes, from each probe
        Should be re-run if;
        .Probes added
        .Probes destroyed
        .List is scrolled
        */
        float leftBorder = 5.0;                                                     //Distance cells start from the left side of the panel
        float border     = 10.0;                                                    //Space between cells
        float cellHeight = (panelDim.y -(probeCell_cellNumber+1)*border) / (probeCell_cellNumber);      //The height of each box containing probe info
        float sizeOfText = cellHeight/2.0;
        float sizeOfIcon = cellHeight/3.0;
        PVector startPos = new PVector(cornerPos.x +leftBorder, cornerPos.y);   //Coord for starting the drawing of cells
        probeCellSet.clear();
        for(int i=0; i<probes.size(); i++){
            PVector relPos = new PVector(startPos.x, startPos.y +cellHeight*(i-probeSetIndOffset) +border*(i-probeSetIndOffset+1));
            float cellWidth = panelDim.x/2.0;                                   //Changes depending on info amount
            probeDispCell newProbeCell = new probeDispCell(probes.get(i), sizeOfText, sizeOfIcon, new PVector(relPos.x, relPos.y), new PVector(cellWidth, cellHeight));
            probeCellSet.add(newProbeCell);
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
        generateProbeCellSet(cManager.cSolarMap.probes);
    }


    void loadButtons_screen_selection(){
        /*
        Loads buttons for the given screen, this has;
        . All probes listed, clickable
        . Button to launch new probes, clickable
        */
        buttonSet.clear();
        for(int i=probeSetIndOffset; i<probeSetIndOffset +probeCell_cellNumber; i++){
            if(i < probeCellSet.size()){   //If valid
                button newButton = new button(probeCellSet.get(i).pos, probeCellSet.get(i).dim, "rect", "flight_probe_goToControls");
                newButton.relatedProbe = probeCellSet.get(i).cProbe;
                buttonSet.add(newButton);
            }
        }
        button newButton0 = new button( scroller_pos, scroller_dim, "circ", "flight_incrementProbeIndOffset");
        button newButton1 = new button(launchButton_pos, launchButton_dim, "circ", "flight_goToLaunch");
        buttonSet.add(newButton0);buttonSet.add(newButton1);
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
        button newButton0 = new button(backButton_pos, backButton_dim, "rect", "flight_goToSelection");
        buttonSet.add(newButton0);
    }
}

class probeDispCell{
    /*
    Contains all relevent information to display a cell in the probe list 
    for a specific cell
    */
    probe cProbe;
    PVector pos;    //Corner position
    PVector dim;

    String infoText;
    float sizeOfText;

    float sizeOfIcon;

    probeDispCell(probe cProbe, float sizeOfText, float sizeOfIcon, PVector pos, PVector dim){
        this.cProbe = cProbe;
        this.pos    = pos;
        this.dim    = dim;
        this.sizeOfText = sizeOfText;
        this.sizeOfIcon = sizeOfIcon;

        infoText = str(cProbe.ID);
    }

    void display(){
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
        fill(20,255,20);
        ellipse(pos.x +sizeOfIcon/2.0, pos.y +sizeOfIcon/2.0, sizeOfIcon, sizeOfIcon);
        popStyle();
    }
}


/*
######################################
##
## NEED TO RETRIEVE PROBE INFO FROM THE BUTTON WHEN CLICKED -> NEEDS SPECIFICITY
##      MAYBE HAVE PARSED AS AN ARGUEMENT ???
##
######################################
*/