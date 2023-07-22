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
    PVector radio_dim;
    PVector radio_pos;
    PVector back_dim;
    PVector back_pos;

    cartography_main_wheel wheel_main;

    toolArray(PVector cornerPos, PVector panelDim){
        this.cornerPos = cornerPos;
        this.panelDim  = panelDim;

        settings_dim = new PVector(panelDim.x/2.0, panelDim.y/6.0);
        settings_pos = new PVector(cornerPos.x +panelDim.x/2.0 -settings_dim.x/2.0, cornerPos.y +0.2*panelDim.y -settings_dim.y/2.0);
        cartographer_dim = new PVector(panelDim.x/2.0, panelDim.y/6.0);
        cartographer_pos = new PVector(cornerPos.x +panelDim.x/2.0 -cartographer_dim.x/2.0, cornerPos.y +0.5*panelDim.y -cartographer_dim.y/2.0);
        radio_dim = new PVector(panelDim.x/2.0, panelDim.y/6.0);
        radio_pos = new PVector(cornerPos.x +panelDim.x/2.0 -radio_dim.x/2.0, cornerPos.y +0.8*panelDim.y -radio_dim.y/2.0);
        back_dim = new PVector(panelDim.x/6.0, panelDim.y/8.0);
        back_pos = new PVector(cornerPos.x +0.75*panelDim.x, cornerPos.y +0.75*panelDim.y);

        wheel_main = new cartography_main_wheel( new PVector(cornerPos.x +panelDim.x/2.0, cornerPos.y +panelDim.y/2.0), 0.4*panelDim.y );
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
    void display_cartographer(){
        display_wheel_main();
        display_backIcon();
        //...
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
        //pass
    }
    void tools_mouseReleased(){
        //pass
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
        buttonSet.add(newButton0);
    }
}