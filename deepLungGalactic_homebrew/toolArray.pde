class toolArray{
    /*
    ---------
    |   |   |
    |--------
    |   | X |
    ---------
    A panel that shows;
    . Settings -> pauses the game
    . Menu
    . Cartographer feature -> To manually plot the map

    The screens are;
    Selection -> Settings
              -> Cartographer



    ########
    ####
    CHANGE THE ZOOM TO BE A RECTANGULAR ZOOM, 
    SHOWS ALL IN ITS REGION
    ####
    ########
    */
    boolean screen_selection    = true;
    boolean screen_settings     = false;
    boolean screen_cartographer = false;

    ArrayList<button> buttonSet = new ArrayList<button>();
    
    PVector cornerPos;  //Top-Left corner defining the origin from which items in this panel are drawn
    PVector panelDim;   //The dimensions of this panel, which must contain all the panel's information

    PVector settings_dim;
    PVector settings_pos;
    PVector cartographer_dim;
    PVector cartographer_pos;
    PVector wheelLoad_dim;
    PVector wheelLoad_pos;
    PVector zoomOutButton_dim;
    PVector zoomOutButton_pos;
    PVector radio_dim;
    PVector radio_pos;
    PVector back_dim;
    PVector back_pos;
    PVector timer_dim;
    PVector timer_pos;
    PVector quit_dim;
    PVector quit_pos;
    PVector creditsIcon_dim;
    PVector creditsIcon_pos;
    PVector manualIcon_dim;
    PVector manualIcon_pos;

    cartography_main_wheel wheel_main;
    cartographyMap cartoMap;

    toolArray(PVector cornerPos, PVector panelDim){
        this.cornerPos = cornerPos;
        this.panelDim  = panelDim;

        settings_dim = new PVector(panelDim.x/2.0, panelDim.y/6.0);
        settings_pos = new PVector(cornerPos.x +panelDim.x/2.0 -settings_dim.x/2.0, cornerPos.y +0.15*panelDim.y -settings_dim.y/2.0);
        cartographer_dim = new PVector(panelDim.x/2.0, panelDim.y/6.0);
        cartographer_pos = new PVector(cornerPos.x +panelDim.x/2.0 -cartographer_dim.x/2.0, cornerPos.y +0.4*panelDim.y -cartographer_dim.y/2.0);
        wheelLoad_dim = new PVector(panelDim.y/8.0, panelDim.y/8.0);
        wheelLoad_pos = new PVector(cornerPos.x +0.05*panelDim.x, cornerPos.y +0.8*panelDim.y);
        zoomOutButton_dim = new PVector(0.12*panelDim.y, 0.15*panelDim.y);
        zoomOutButton_pos = new PVector(cornerPos.x +0.02*panelDim.x, cornerPos.y +0.1*panelDim.y);
        radio_dim = new PVector(panelDim.x/2.0, panelDim.y/6.0);
        radio_pos = new PVector(cornerPos.x +panelDim.x/2.0 -radio_dim.x/2.0, cornerPos.y +0.65*panelDim.y -radio_dim.y/2.0);
        back_dim  = new PVector(0.15*panelDim.x, 0.15*panelDim.x);
        back_pos  = new PVector(cornerPos.x +0.8*panelDim.x, cornerPos.y +panelDim.y -0.2*panelDim.x);
        timer_dim = new PVector(panelDim.x/3.0, panelDim.y/8.0);
        timer_pos = new PVector(cornerPos.x +panelDim.x/2.0, cornerPos.y +0.9*panelDim.y -timer_dim.y/2.0);
        quit_dim  = new PVector(panelDim.x/3.0, panelDim.y/5.0);
        quit_pos  = new PVector(cornerPos.x +panelDim.x/2.0 -quit_dim.x/2.0, cornerPos.y +0.4*panelDim.y -quit_dim.y/2.0);
        creditsIcon_dim = new PVector(panelDim.y/5.0, panelDim.y/5.0);
        creditsIcon_pos = new PVector(cornerPos.x +0.08*panelDim.x, cornerPos.y +panelDim.y -1.1*creditsIcon_dim.y);
        manualIcon_dim  = new PVector(panelDim.y/5.0, panelDim.y/5.0);
        manualIcon_pos  = new PVector(creditsIcon_pos.x +1.6*creditsIcon_dim.x, cornerPos.y +panelDim.y -1.1*manualIcon_dim.y);

        init_mainWheel();
        init_cartographyMap();

        loadButtons_screen_selection();
    }

    void display(){
        display_background();
        if(screen_selection){
            display_selection();}
        if(screen_settings){
            display_settings();}
        if(screen_cartographer){
            display_cartographer();}
        display_buttonBounds();
    }
    void display_background(){
        pushStyle();
        rectMode(CORNER);
        fill(20,20,20);
        noStroke();
        rect(cornerPos.x, cornerPos.y, panelDim.x, panelDim.y);
        popStyle();
    }
    //Selection
    void display_selection(){
        display_backgroundAnimation();
        display_settingsIcon();
        display_cartographerIcon();
        display_radioIcon();
        display_timer();
    }
    void display_backgroundAnimation(){
        //pass
    }
    void display_settingsIcon(){
        pushStyle();
        imageMode(CORNER);
        image(texture_tools_selection_settings, settings_pos.x, settings_pos.y);
        popStyle();
    }
    void display_settingsIcon_simple(){
        pushStyle();
        fill(90,90,90);
        noStroke();
        rectMode(CORNER);
        rect(settings_pos.x, settings_pos.y, settings_dim.x, settings_dim.y);

        fill(0,0,0);
        textSize(20);
        textAlign(CENTER, CENTER);
        text("Settings", settings_pos.x +settings_dim.x/2.0, settings_pos.y +settings_dim.y/2.0);
        popStyle();
    }
    void display_cartographerIcon(){
        pushStyle();
        imageMode(CORNER);
        image(texture_tools_selection_cartographer, cartographer_pos.x, cartographer_pos.y);
        popStyle();
    }
    void display_cartographerIcon_simple(){
        pushStyle();
        fill(90,90,90);
        noStroke();
        rectMode(CORNER);
        rect(cartographer_pos.x, cartographer_pos.y, cartographer_dim.x, cartographer_dim.y);

        fill(0,0,0);
        textSize(20);
        textAlign(CENTER, CENTER);
        text("Cartographer", cartographer_pos.x +cartographer_dim.x/2.0, cartographer_pos.y +cartographer_dim.y/2.0);
        popStyle();
    }
    void display_radioIcon(){
        pushStyle();
        imageMode(CORNER);
        image(texture_tools_selection_radio, radio_pos.x, radio_pos.y);
        popStyle();
    }
    void display_radioIcon_simple(){
        pushStyle();
        fill(90,90,90);
        noStroke();
        rectMode(CORNER);
        rect(radio_pos.x, radio_pos.y, radio_dim.x, radio_dim.y);

        fill(0,0,0);
        textSize(20);
        textAlign(CENTER, CENTER);
        text("Radio", radio_pos.x +radio_dim.x/2.0, radio_pos.y +radio_dim.y/2.0);
        popStyle();
    }
    void display_timer(){
        pushStyle();

        textAlign(CENTER, CENTER);
        textSize(0.8*timer_dim.y);
        fill(255,255,255);
        PVector timeInMins = convertFromSecondsToMinutes(roundToXdp(cManager.cOutroScreen.timer/60.0, 1));
        text(str(timeInMins.x) +" : "+str(timeInMins.y), timer_pos.x, timer_pos.y);       //### CONVERT TO MINUTE CLOCK ###

        popStyle();
    }
    PVector convertFromSecondsToMinutes(float givenSeconds){
        /*
        Takes a set amount of seconds, converts it to;
        [mins] [secs]
        X         Y
        */
        return new PVector(int(floor(givenSeconds/60.0)), int(floor(givenSeconds%60.0)));
    }
    //Settings
    void display_settings(){
        display_exitGameIcon();
        display_creditsIcon();
        display_manualIcon();
        display_backIcon();
        //....
    }
    void display_backIcon(){
        pushStyle();
        imageMode(CORNER);
        image(texture_general_button_back ,back_pos.x, back_pos.y);
        popStyle();
    }
    void display_backIcon_simple(){
        pushStyle();
        textSize(20);
        textAlign(CENTER, CENTER);
        text("Back", back_pos.x +back_dim.x/2.0, back_pos.y +back_dim.y/2.0);
        popStyle();
    }
    void display_exitGameIcon(){
        pushStyle();
        imageMode(CORNER);
        image(texture_tools_selection_settings_icon, quit_pos.x, quit_pos.y);
        popStyle();
    }
    void display_exitGameIcon_simple(){
        pushStyle();
        rectMode(CORNER);
        fill(80,80,80,100);
        noStroke();
        rect(quit_pos.x, quit_pos.y, quit_dim.x, quit_dim.y);
        fill(230,230,230);
        textSize(quit_dim.x/10.0);
        textAlign(CENTER, CENTER);
        text("Exit Game", quit_pos.x +quit_dim.x/2.0, quit_pos.y +quit_dim.y/2.0);
        popStyle();
    }
    void display_creditsIcon(){
        pushStyle();
        imageMode(CORNER);
        image(texture_tools_selection_settings_creditsIcon, creditsIcon_pos.x, creditsIcon_pos.y);
        popStyle();
    }
    void display_creditsIcon_simple(){
        pushStyle();
        rectMode(CORNER);
        fill(80,80,80,100);
        noStroke();
        rect(creditsIcon_pos.x, creditsIcon_pos.y, creditsIcon_dim.x, creditsIcon_dim.y);
        popStyle();
    }
    void display_manualIcon(){
        pushStyle();
        imageMode(CORNER);
        image(texture_tools_selection_settings_manualIcon, manualIcon_pos.x, manualIcon_pos.y);
        popStyle();
    }
    void display_manualIcon_simple(){
        pushStyle();
        rectMode(CORNER);
        fill(80,80,80,100);
        noStroke();
        rect(manualIcon_pos.x, manualIcon_pos.y, manualIcon_dim.x, manualIcon_dim.y);
        popStyle();
    }
    //Cartographer
    void display_cartographer(){
        display_cartographyMap();
        display_zoomButtons();
        if(wheel_main.active){
            display_wheel_main();}
        display_wheelLoad_main();
        display_backIcon();
        //...
    }
    void display_cartographyMap(){
        cartoMap.display();
    }
    void display_zoomButtons(){
        pushStyle();
        imageMode(CORNER);
        image(texture_tools_cartography_resetZoom, zoomOutButton_pos.x, zoomOutButton_pos.y);
        popStyle();
    }
    void display_zoomButtons_simple(){
        pushStyle();
        rectMode(CORNER);
        noFill();
        stroke(200,200,200);
        strokeWeight(4);
        //Zoom Out
        rect(zoomOutButton_pos.x, zoomOutButton_pos.y, zoomOutButton_dim.x, zoomOutButton_dim.y);
        popStyle();
    }
    void display_wheelLoad_main(){
        pushStyle();
        imageMode(CORNER);
        image(texture_tools_cartography_toggleWheel, wheelLoad_pos.x, wheelLoad_pos.y);
        popStyle();
    }
    void display_wheelLoad_main_simple(){
        pushStyle();
        fill(180,180,180);
        ellipse(wheelLoad_pos.x, wheelLoad_pos.y, wheelLoad_dim.x, wheelLoad_dim.y);
        popStyle();
    }
    void display_wheel_main(){
        wheel_main.display();
    }
    void display_PLACEHOLDER(){
        pushStyle();
        textSize(40);
        textAlign(CENTER, CENTER);
        text("Placeholder", cornerPos.x +panelDim.x/2.0, cornerPos.y +panelDim.y/2.0);
        popStyle();
    }
    //##BUG FIXING##
    void display_buttonBounds(){
        for(int i=0; i<buttonSet.size(); i++){
            buttonSet.get(i).displayOutline();
        }
    }
    //##BUG FIXING##


    void calc(){
        if(screen_cartographer){
            cartoMap.calc();
        }
    }
    void tools_mousePressed(){
        if(screen_cartographer){
            cartoMap.performClickAction();
        }
    }
    void tools_mouseReleased(){
        if(screen_cartographer){
            cartoMap.performClickReleaseAction();
        }
    }


    void init_mainWheel(){
        wheel_main = new cartography_main_wheel( new PVector(cornerPos.x +panelDim.x/2.0, cornerPos.y +panelDim.y/2.0), 0.4*panelDim.y );
    }
    void init_cartographyMap(){
        cartoMap = new cartographyMap(this, fullMapRadius);
    }


    void loadButtons_screen_selection(){
        buttonSet.clear();
        button newButton0 = new button(settings_pos     , settings_dim      , "rect", "tools_goToSettings");
        button newButton1 = new button(cartographer_pos , cartographer_dim  , "rect", "tools_goToCartographer");
        button newButton2 = new button(radio_pos        , radio_dim         , "rect", "tools_switchRadioStation");
        buttonSet.add(newButton0);buttonSet.add(newButton1);buttonSet.add(newButton2);
    }
    void loadButtons_screen_settings(){
        buttonSet.clear();
        button newButton0 = new button(quit_pos       , quit_dim       , "rect", "tools_quitGame");
        button newButton1 = new button(creditsIcon_pos, creditsIcon_dim, "rect", "tools_goToCredits");
        button newButton2 = new button(manualIcon_pos , manualIcon_dim , "rect", "tools_goToManual");
        button newButton3 = new button(back_pos, back_dim, "rect", "tools_goToSelection");
        buttonSet.add(newButton0);buttonSet.add(newButton1);buttonSet.add(newButton2);buttonSet.add(newButton3);
    }
    void loadButtons_screen_cartographer(){
        buttonSet.clear();
        button newButton0 = new button(back_pos, back_dim, "rect", "tools_goToSelection");
        button newButton1 = new button(wheelLoad_pos, wheelLoad_dim, "circ", "tools_popWheelMain");
        button newButton2 = new button(zoomOutButton_pos, zoomOutButton_dim, "rect", "tools_cartography_zoomOut");
        buttonSet.add(newButton0);buttonSet.add(newButton1);buttonSet.add(newButton2);
    }
    void loadButtons_wheel_main(){
        //NO clear, as it loaded IN ADDITION
        ArrayList<button> externalButtonSet = wheel_main.getButtonSet();
        println("External size -> ",externalButtonSet.size());
        for(int i=0; i<externalButtonSet.size(); i++){
            externalButtonSet.get(i).tag = "wheelGroup";    //Buttons are tagged to help delete them if needed
            buttonSet.add(externalButtonSet.get(i));
        }
    }
    void removeButtons(String tag){
        /*
        Removes all buttons of the given tag from the current button set
        */
        println("Removing buttons with tag= ",tag);
        for(int i=buttonSet.size()-1; i>=0; i--){
            if(buttonSet.get(i).tag == tag){
                buttonSet.remove(i);
            }
        }
    }
}


class cartographyMap{
    /*
    Stores placed cartographer icons
    Can be zoomed in and out of
 
           -------------
       ---              ----
    X----                    ---|   Visible = Smaller rectangular (some aspect ratio as panel display area) region
    | X---------                |   Map     = Large circular region   
    | |        |                |
    | ----------                |
    |                           |
    |                           |
    |----                   ----|
         ----            ----
              ----------

    visibleScale 1.0 => show the 'fullDim'
                 2.0 => width and height are half of the 'fullDim' presets

    Note; Everything is stored in terms of AU, and only converted to pixels as 
        things are displayed
    Also Note; Within the map and everything around (including vis box) is dealt with 
        on a TYPICAL AXIS, and does NOT USE the PROCESSING STYLE AXIS (+ve Y is down)
    */
    toolArray cToolArray;

    ArrayList<icon> icons = new ArrayList<icon>();

    String selectedIcon = "";
    String selectedMode = "";
    float mapRadius;
    float aspectRatio;
    
    PVector fullDim    = new PVector(0,0);  //In AU, kept constant -> Largest posible visible region (can see everything)
    PVector visiblePos = new PVector(0,0);  //Top-Left corner -> in AU -> (0,0) = centre of the map, where ship is
    float visibleScale = 1.0;               //What percentage of the full panelDim is given as visible

    boolean isZooming  = false;
    PVector clickStart = new PVector(0,0);  //For zooming, where zoom begins
    PVector clickEnd   = new PVector(0,0);  //For zomming, where zoom ends

    float minorInterval = 5.0;  //In AU, how often minor intervals are recorded --> Counting starts from origin
    float majorInterval = 20.0;  //In AU, make sure this is a multiple of the MINOR interval lengths

    cartographyMap(toolArray cToolArray, float mapRadius){
        this.cToolArray = cToolArray;
        this.mapRadius  = mapRadius;
        aspectRatio  = (cToolArray.panelDim.x) / (cToolArray.panelDim.y);
        fullDim      = new PVector(2.0*mapRadius*aspectRatio, 2.0*mapRadius);      //## MAYBE SHOULD BE NEGATIVE NOT POSITIVE

        resetZoom();
    }

    void displayMini(PVector origin, float scale){
        pushStyle();
        
        //Map bounds
        noFill();
        stroke(255,255,255);
        strokeWeight(3);
        ellipse(origin.x, origin.y, 2.0*cManager.cSolarMap.mapRadius*scale, 2.0*cManager.cSolarMap.mapRadius*scale);

        //Center
        fill(50,250,50);
        noStroke();
        ellipse(origin.x, origin.y, 5.0, 5.0);

        //Icons
        noFill();
        stroke(200,100,100);
        strokeWeight(2);
        for(int i=0; i<icons.size(); i++){
            ellipse(origin.x +icons.get(i).pos.x*scale, origin.y +icons.get(i).pos.y*scale, 5.0, 5.0);
        }

        popStyle();
    }
    void display(){
        /*
        Displays visible region in the given dimensions, with its origin top-left corner 
        located at pos

        ############################################################
        ## WILL HAVE TO ACCOUNT FOR PLANET ROTATION AT SOME POINT ##
        ############################################################
        */
        display_axis();
        display_icons();
        if(isZooming){
            display_zoomArea();}
        //...
    }
    void calc(){
        if(isZooming){
            updateClickEnd();}
    }
    void display_axis(){
        /*
        Displays coords in a scaling axis that either;
        . Follows X/Y strictly, in a bright white colour
        OR
        . Sticks to approporiate side of screen, in a faded white colour
        
        Make sure to do same for both axes
        1. Find fixed Y value -> based off [sticking or floating]
        2. Draw background axis line in
        3. Find 1st interval that appears, the distance between each, then draw & label all

        ######
        ## Do a MAJOR and MINOR interval, so display is much clearer
        ######
        */
        //1
        float fixed_X = calcFixedAxis(false);
        float fixed_Y = calcFixedAxis(true);
        //2
        pushMatrix();
        pushStyle();
        translate(cToolArray.cornerPos.x, cToolArray.cornerPos.y);

        stroke(255,255,255,200);
        strokeWeight(4);

        line(0.0, fixed_Y, cToolArray.panelDim.x, fixed_Y);
        line(fixed_X, 0.0, fixed_X, cToolArray.panelDim.y);

        popStyle();
        popMatrix();
        //3
        float intervalThickness = cToolArray.panelDim.y/30.0;
        float interval_loc_X = -getPixels((visiblePos.x) % (minorInterval));  //All in pixels
        float interval_loc_Y =  getPixels((visiblePos.y) % (minorInterval));  //
        float intervalSeparation = getPixels(minorInterval);                  //
        int counterMax = 1000;
        int counter = 0;
        pushStyle();
        fill(200,200,200);
        stroke(220,220,220);
        strokeWeight(1);
        textAlign(CENTER, CENTER);
        textSize( min(0.4*intervalSeparation, cToolArray.panelDim.y/15.0) );
        while(counter < counterMax){                //For X

            line(cToolArray.cornerPos.x +interval_loc_X, cToolArray.cornerPos.y +fixed_Y +intervalThickness, cToolArray.cornerPos.x +interval_loc_X, cToolArray.cornerPos.y +fixed_Y -intervalThickness);
            text(str( roundToXdp( minorInterval*(counter) +visiblePos.x -((visiblePos.x) % (minorInterval)), 1 ) ), cToolArray.cornerPos.x +interval_loc_X, cToolArray.cornerPos.y +fixed_Y +intervalThickness);

            interval_loc_X += intervalSeparation;
            if(interval_loc_X > cToolArray.panelDim.x){
                break;}
            counter++;
        }
        counter = 0;
        while(counter < counterMax){                //For Y

            line(cToolArray.cornerPos.x +fixed_X +intervalThickness, cToolArray.cornerPos.y +interval_loc_Y, cToolArray.cornerPos.x +fixed_X -intervalThickness, cToolArray.cornerPos.y +interval_loc_Y);
            text(str( roundToXdp( -minorInterval*(counter) +visiblePos.y -((visiblePos.y) % (minorInterval)), 1 ) ), cToolArray.cornerPos.x +fixed_X +2.0*intervalThickness, cToolArray.cornerPos.y +interval_loc_Y);

            interval_loc_Y += intervalSeparation;
            if(interval_loc_Y > cToolArray.panelDim.y){
                break;}
            counter++;
        }
        popStyle();
    }
    void display_icons(){
        /*
        Displays icons in viewable range
        */
        for(int i=0; i<icons.size(); i++){
            if( iconInView(icons.get(i)) ){
                icons.get(i).display(this, visiblePos);
            }
        }
    }
    void display_zoomArea(){
        PVector dir = vec_dir(clickStart, clickEnd);
        float newVisScale = fullDim.x / getUnit(dir.x);
        pushStyle();
        rectMode(CORNER);
        fill(3, 252, 65, 80);
        stroke(250,250,250);
        strokeWeight(2);
        
        rect(clickStart.x, clickStart.y, getPixels(fullDim.x/newVisScale), getPixels(fullDim.y/newVisScale));
        
        popStyle();
    }
    float calcFixedAxis(boolean isXaxis){
        float fixed = 0.0;
        if(isXaxis){
            float distToAxis_X = visiblePos.y;  //Distance from top-left corner of visible box to the axis
            fixed = getPixels(distToAxis_X);    //Assumes fixing to floating position (Overwritten if wrong)
            if(distToAxis_X < 0.0){
                //=>Fix to top of panel
                fixed = 0.0;}
            if(distToAxis_X > fullDim.y/visibleScale){
                //=> Fix to bottom of panel
                fixed = cToolArray.panelDim.y;}
        }
        else{
            float distToAxis_Y = -visiblePos.x;  //Distance from top-left corner of visible box to the axis
            fixed = getPixels(distToAxis_Y);    //Assumes fixing to floating position (Overwritten if wrong)
            if(distToAxis_Y < 0.0){
                //=>Fix to top of panel
                fixed = 0.0;}
            if(distToAxis_Y > fullDim.x/visibleScale){
                //=> Fix to bottom of panel
                fixed = cToolArray.panelDim.x;}
        }
        return fixed;
    }
    void resetZoom(){
        visiblePos   = new PVector(-mapRadius*aspectRatio, mapRadius);      //## MAYBE SHOULD BE NEGATIVE NOT POSITIVE
        visibleScale = 1.0;
    }
    void performClickAction(){
        boolean withinX = (cToolArray.cornerPos.x < mouseX) && (mouseX < cToolArray.cornerPos.x +cToolArray.panelDim.x);
        boolean withinY = (cToolArray.cornerPos.y < mouseY) && (mouseY < cToolArray.cornerPos.y +cToolArray.panelDim.y);
        boolean withinPanel   = withinX && withinY;
        if(withinPanel){
            boolean wheelInactive = !cManager.cToolArray.wheel_main.active;
            boolean outsideButtonRange = !checkIfInButtonRange();
            if(wheelInactive && outsideButtonRange){
                println("Performing click action...");
                if(selectedMode == "place"){
                    performClickPlace();}
                if(selectedMode == "remove"){
                    performClickRemove();}
                if(selectedMode == "zoom"){
                    performClickZoom();}
            }
        }
    }
    void performClickReleaseAction(){
        boolean wheelInactive = !cManager.cToolArray.wheel_main.active;
        boolean withinX = (cToolArray.cornerPos.x < mouseX) && (mouseX < cToolArray.cornerPos.x +cToolArray.panelDim.x);
        boolean withinY = (cToolArray.cornerPos.y < mouseY) && (mouseY < cToolArray.cornerPos.y +cToolArray.panelDim.y);
        boolean withinPanel   = withinX && withinY;
        if(wheelInactive && withinPanel){
            if(isZooming){
                performClickReleaseZoom();}
            //....
        }
    }
    void performClickPlace(){
        println("Click action -> place...");

        PVector relativePos_mouse = new PVector(mouseX -cToolArray.cornerPos.x, mouseY -cToolArray.cornerPos.y);
        PVector fromVis_unit  = new PVector(getUnit(relativePos_mouse.x), getUnit(relativePos_mouse.y));    //Units in from top-left corner of visible box
        PVector clickPos_unit = new PVector(visiblePos.x +fromVis_unit.x, visiblePos.y -fromVis_unit.y);    //Position of click, from centre of map
        float iconSize = 10.0;
        if(selectedIcon == "circle"){
            circle newIcon = new circle(clickPos_unit, iconSize);
            icons.add(newIcon);
        }
        if(selectedIcon == "triangle"){
            triangle newIcon = new triangle(clickPos_unit, iconSize);
            icons.add(newIcon);
        }
        if(selectedIcon == "square"){
            square newIcon = new square(clickPos_unit, iconSize);
            icons.add(newIcon);
        }
        if(selectedIcon == "exclaim"){
            exclaim newIcon = new exclaim(clickPos_unit, iconSize);
            icons.add(newIcon);
        }
    }
    void performClickRemove(){
        /*
        Only removes one at a time
        Could change to remove multiple if there is overlap, but I see no point in doing that, this gives more control
        */
        println("Click action -> remove...");
        PVector relativePos_mouse = new PVector(mouseX -cToolArray.cornerPos.x, mouseY -cToolArray.cornerPos.y);
        PVector fromVis_unit  = new PVector(getUnit(relativePos_mouse.x), getUnit(relativePos_mouse.y));    //Units in from top-left corner of visible box
        PVector clickPos_unit = new PVector(visiblePos.x +fromVis_unit.x, visiblePos.y -fromVis_unit.y);    //Position of click, from centre of map
        for(int i=0; i<icons.size(); i++){
            float dist = vec_mag(vec_dir(clickPos_unit, icons.get(i).pos));
            float iconRadius = visibleScale*icons.get(i).size/2.0;
            if(dist <= iconRadius){  //**Icon size == full width or diameter
                icons.remove(i);
                break;
            }
        }
    }
    void performClickZoom(){
        println("Click PRESS action -> zoom...");
        clickStart = new PVector(mouseX, mouseY);
        isZooming = true;
    }
    void performClickReleaseZoom(){
        println("Click RELEASE action -> zoom...");

        PVector relativePos_start = new PVector(clickStart.x -cToolArray.cornerPos.x, clickStart.y -cToolArray.cornerPos.y);
        PVector fromVis_unit  = new PVector(getUnit(relativePos_start.x), getUnit(relativePos_start.y));    //Units in from top-left corner of visible box
        PVector clickPos_unit = new PVector(visiblePos.x +fromVis_unit.x, visiblePos.y -fromVis_unit.y);    //Position of click, from centre of map

        PVector dir = vec_dir(clickStart, clickEnd);
        float newVisScale = min(fullDim.x / getUnit(dir.x), fullDim.y / getUnit(dir.y));
        visiblePos   = new PVector(clickPos_unit.x, clickPos_unit.y);
        visibleScale = newVisScale;

        clickEnd = new PVector(clickStart.x, clickStart.y);
        isZooming = false;
    }
    void updateClickEnd(){
        clickEnd = new PVector(mouseX, mouseY);
    }
    boolean checkIfInButtonRange(){
        boolean buttonsInRange = false;
        for(int i=0; i<cToolArray.buttonSet.size(); i++){
            if(cToolArray.buttonSet.get(i).inButtonRange(new PVector(mouseX, mouseY))){
                buttonsInRange = true;
                break;
            }
        }
        return buttonsInRange;
    }
    boolean iconInView(icon givenIcon){
        /*
        Checks if an icon is within the viewable screen
        */
        boolean withinX = (visiblePos.x                         <= givenIcon.pos.x) && (givenIcon.pos.x < visiblePos.x +getUnit(givenIcon.size) +fullDim.x/visibleScale);
        boolean withinY = (visiblePos.y -fullDim.y/visibleScale <= givenIcon.pos.y) && (givenIcon.pos.y < visiblePos.y +getUnit(givenIcon.size));
        if(withinX && withinY){
            return true;}
        else{
            return false;}
    }
    float getPixels(float unit){
        /*
        Converts a given number of AU units to an approporiate number of pixels
        This depends on the visibleScale
        */
        float unitCoverage  = (fullDim.x) / (visibleScale);    //In AU
        float pixelCoverage = cToolArray.panelDim.x; //Just for clarity
        float scaleFactor   = ((pixelCoverage) / (unitCoverage));
        return unit*scaleFactor;
    }
    float getUnit(float pixel){
        /*
        Converts a given number of pixels to an approporiate unit value
        This depends on the visibleScale
        */
        float unitCoverage  = (fullDim.x) / (visibleScale);    //In AU
        float pixelCoverage = cToolArray.panelDim.x; //Just for clarity
        float scaleFactor   = ((unitCoverage) / (pixelCoverage));
        return pixel*scaleFactor;
    }
}
class icon{
    PVector pos;
    String name;
    float size;
    
    icon(PVector pos, float size){
        this.size = size;
        this.pos  = pos;
    }

    void display(cartographyMap cartoMap, PVector visiblePos){
        //Overwrite this
    }
}
class circle extends icon{
    //pass

    circle(PVector pos, float size){
        super(pos, size);
        name = "circle";
    }

    @Override
    void display(cartographyMap cartoMap, PVector visiblePos){
        PVector fromVis_pixel = new PVector(cartoMap.getPixels(pos.x -visiblePos.x), cartoMap.getPixels(-pos.y +visiblePos.y));
        pushStyle();

        noFill();
        stroke(200,120,40);
        strokeWeight(4);
        ellipse(cartoMap.cToolArray.cornerPos.x +fromVis_pixel.x, cartoMap.cToolArray.cornerPos.y +fromVis_pixel.y, size*cartoMap.visibleScale, size*cartoMap.visibleScale);

        popStyle();
    }
}
class triangle extends icon{
    //pass

    triangle(PVector pos, float size){
        super(pos, size);
        name = "triangle";
    }

    @Override
    void display(cartographyMap cartoMap, PVector visiblePos){
        PVector fromVis_pixel = new PVector(cartoMap.getPixels(pos.x -visiblePos.x), cartoMap.getPixels(-pos.y +visiblePos.y));
        pushStyle();

        noFill();
        stroke(40,200,120);
        strokeWeight(4);
        ellipse(cartoMap.cToolArray.cornerPos.x +fromVis_pixel.x, cartoMap.cToolArray.cornerPos.y +fromVis_pixel.y, size*cartoMap.visibleScale, size*cartoMap.visibleScale);

        popStyle();
    }
}
class square extends icon{
    //pass

    square(PVector pos, float size){
        super(pos, size);
        name = "square";
    }

    @Override
    void display(cartographyMap cartoMap, PVector visiblePos){
        PVector fromVis_pixel = new PVector(cartoMap.getPixels(pos.x -visiblePos.x), cartoMap.getPixels(-pos.y +visiblePos.y));
        pushStyle();

        noFill();
        stroke(120,40,200);
        strokeWeight(4);
        rectMode(CENTER);
        rect(cartoMap.cToolArray.cornerPos.x +fromVis_pixel.x, cartoMap.cToolArray.cornerPos.y +fromVis_pixel.y, size*cartoMap.visibleScale, size*cartoMap.visibleScale);

        popStyle();
    }
}
class exclaim extends icon{
    //pass

    exclaim(PVector pos, float size){
        super(pos, size);
        name = "exclaim";
    }

    @Override
    void display(cartographyMap cartoMap, PVector visiblePos){
        PVector fromVis_pixel = new PVector(cartoMap.getPixels(pos.x -visiblePos.x), cartoMap.getPixels(-pos.y +visiblePos.y));
        pushStyle();

        fill(250,50,50);
        stroke(250,50,50);
        strokeWeight(4);
        ellipse(cartoMap.cToolArray.cornerPos.x +fromVis_pixel.x, cartoMap.cToolArray.cornerPos.y +fromVis_pixel.y, size*cartoMap.visibleScale, size*cartoMap.visibleScale);

        popStyle();
    }
}