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

    cartography_main_wheel wheel_main;
    cartographyMap cartoMap;

    toolArray(PVector cornerPos, PVector panelDim){
        this.cornerPos = cornerPos;
        this.panelDim  = panelDim;

        settings_dim = new PVector(panelDim.x/2.0, panelDim.y/6.0);
        settings_pos = new PVector(cornerPos.x +panelDim.x/2.0 -settings_dim.x/2.0, cornerPos.y +0.2*panelDim.y -settings_dim.y/2.0);
        cartographer_dim = new PVector(panelDim.x/2.0, panelDim.y/6.0);
        cartographer_pos = new PVector(cornerPos.x +panelDim.x/2.0 -cartographer_dim.x/2.0, cornerPos.y +0.5*panelDim.y -cartographer_dim.y/2.0);
        wheelLoad_dim = new PVector(panelDim.y/8.0, panelDim.y/8.0);
        wheelLoad_pos = new PVector(cornerPos.x +0.05*panelDim.x, cornerPos.y +0.8*panelDim.y);
        zoomOutButton_dim = new PVector(0.12*panelDim.y, 0.15*panelDim.y);
        zoomOutButton_pos = new PVector(cornerPos.x +0.02*panelDim.x, cornerPos.y +0.1*panelDim.y);
        radio_dim = new PVector(panelDim.x/2.0, panelDim.y/6.0);
        radio_pos = new PVector(cornerPos.x +panelDim.x/2.0 -radio_dim.x/2.0, cornerPos.y +0.8*panelDim.y -radio_dim.y/2.0);
        back_dim  = new PVector(panelDim.x/6.0, panelDim.y/8.0);
        back_pos  = new PVector(cornerPos.x +0.75*panelDim.x, cornerPos.y +0.75*panelDim.y);

        init_mainWheel();
        init_cartographyMap();
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
    }
    void display_backgroundAnimation(){
        //pass
    }
    void display_settingsIcon(){
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
    //Settings
    void display_settings(){
        display_exitGameIcon();
        display_backIcon();
        //....
    }
    void display_backIcon(){
        pushStyle();
        textSize(20);
        textAlign(CENTER, CENTER);
        text("Back", back_pos.x +back_dim.x/2.0, back_pos.y +back_dim.y/2.0);
        popStyle();
    }
    void display_exitGameIcon(){
        pushStyle();
        textSize(40);
        textAlign(CENTER, CENTER);
        text("Exit Game", cornerPos.x +panelDim.x/2.0, cornerPos.y +panelDim.y/2.0);
        popStyle();
    }
    //Cartographer
    void display_cartographer(){
        display_zoomButtons();
        if(wheel_main.active){
            display_wheel_main();}
        display_wheelLoad_main();
        display_backIcon();
        //...
    }
    void display_zoomButtons(){
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
        //pass
    }
    void tools_mousePressed(){
        cartoMap.performClickAction();
    }
    void tools_mouseReleased(){
        //pass
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
        button newButton0 = new button(back_pos, back_dim, "rect", "tools_goToSelection");
        buttonSet.add(newButton0);
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

    ####
    ## DO RED CHECKERED BORDER OUTSIDE KNOWN REGION OF MAP --> BASKET WEAVE TYPE BEAT
    ####
    */
    toolArray cToolArray;

    ArrayList<icon> icons = new ArrayList<icon>();

    String selectedIcon = "";
    String selectedMode = "";
    float mapRadius;
    PVector visibleDim = new PVector(1.0, 1.0*(height/width));  //Full width & height
    PVector visiblePos = new PVector(0,0);                      //Top-Left corner

    cartographyMap(toolArray cToolArray, float mapRadius){
        this.cToolArray = cToolArray;
        this.mapRadius  = mapRadius;
    }

    void display(PVector pos, PVector dim){
        /*
        Displays visible region in the given dimensions, with its origin top-left corner 
        located at pos

        ############################################################
        ## WILL HAVE TO ACCOUNT FOR PLANET ROTATION AT SOME POINT ##
        ############################################################
        */
        display_icons();
        display_mapBorder();
    }
    void display_icons(){
        /*
        Displays icons in viewable range
        */
        for(int i=0; i<icons.size(); i++){
            if( iconInView(icons.get(i)) ){
                icons.get(i).display();
            }
        }
    }
    void display_mapBorder(){
        /*
        Displays any map border in viewable range
        */
        //pass
    }
    void resetZoom(){
        visiblePos = new PVector();
        visibleDim = new PVector();
    }
    void performClickAction(){
        if(selectedMode == "place"){
            performClickPlace();}
        if(selectedMode == "remove"){
            performClickRemove();}
        if(selectedMode == "zoom");{
            PVector startClickPos = new PVector(mouseX, mouseY);
            performClickZoom();}
    }
    void performClickPlace(){
        float pixelToUnitConversion = ((2.0*mapRadius)*(visibleDim.x/cToolArray.panelDim.x))/visibleDim.x;
        float iconSize = 10.0;
        PVector clickUnitPos = new PVector( (mouseX -cToolArray.cornerPos.x)*pixelToUnitConversion, (mouseY -cToolArray.cornerPos.y)*pixelToUnitConversion );   //The position, in units, where the mouse is relative to the screen
        PVector iconPos = new PVector(visiblePos.x +clickUnitPos.x, visiblePos.y +clickUnitPos.y);
        if(selectedIcon == "circle"){
            circle newIcon = new circle(iconPos, iconSize);
            icons.add(newIcon);
        }
        if(selectedIcon == "triangle"){
            triangle newIcon = new triangle(iconPos, iconSize);
            icons.add(newIcon);
        }
        if(selectedIcon == "square"){
            square newIcon = new square(iconPos, iconSize);
            icons.add(newIcon);
        }
        if(selectedIcon == "exclaim"){
            exclaim newIcon = new exclaim(iconPos, iconSize);
            icons.add(newIcon);
        }
    }
    void performClickRemove(){
        /*
        Only removes one at a time
        Could change to remove multiple if there is overlap, but I see no point in doing that, this gives more control
        */
        float pixelToUnitConversion = ((2.0*mapRadius)*(visibleDim.x/cToolArray.panelDim.x))/visibleDim.x;
        PVector clickUnitPos = new PVector( (mouseX -cToolArray.cornerPos.x)*pixelToUnitConversion, (mouseY -cToolArray.cornerPos.y)*pixelToUnitConversion );
        PVector clickPos = new PVector(visiblePos.x +clickUnitPos.x, visiblePos.y +clickUnitPos.y);
        for(int i=0; i<icons.size(); i++){
            float dist = vec_mag(vec_dir(clickPos, icons.get(i).pos));
            if(dist <= icons.get(i).size/2.0){  //**Icon size == full width or diameter
                icons.remove(i);
                break;
            }
        }
    }
    void performClickZoom(){
        //pass
    }
    boolean iconInView(icon givenIcon){
        /*
        Checks if an icon is within the viewable screen
        
        ####################################################
        ## SIZE NEEDS TO CHANGE AS YOU ARE MORE ZOOMED IN ##
        ####################################################
        */
        boolean withinX = (visiblePos.x -givenIcon.size <= givenIcon.pos.x) && (givenIcon.pos.x < visiblePos.x +givenIcon.size +visibleDim.x);  //## MAKE SURE THE  +- SIZE IS WORKING OK ----> MAY BE OTHER WAY AROUND ###########
        boolean withinY = (visiblePos.y -givenIcon.size <= givenIcon.pos.y) && (givenIcon.pos.y < visiblePos.y +givenIcon.size +visibleDim.y);  //#########
        if(withinX && withinY){
            return true;}
        else{
            return false;}
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

    void display(){
        //Overwrite this
    }
}
class circle extends icon{
    //pass

    circle(PVector pos, float size){
        super(pos, size);
        name = "circle";
    }

    //pass
}
class triangle extends icon{
    //pass

    triangle(PVector pos, float size){
        super(pos, size);
        name = "triangle";
    }

    //pass
}
class square extends icon{
    //pass

    square(PVector pos, float size){
        super(pos, size);
        name = "square";
    }

    //pass
}
class exclaim extends icon{
    //pass

    exclaim(PVector pos, float size){
        super(pos, size);
        name = "exclaim";
    }

    //pass
}