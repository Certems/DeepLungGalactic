class manager{
    solarMap cSolarMap = new solarMap(fullMapRadius);

    sensorArray cSensorArray        = new sensorArray(      new PVector(0,0),                   new PVector(width/2.0, height/2.0) );
    flightControls cFlightControls  = new flightControls(   new PVector(width/2.0,0),           new PVector(width/2.0, height/2.0) );
    stockRecords cStockRecords      = new stockRecords(     new PVector(0,height/2.0),          new PVector(width/2.0, height/2.0) );
    toolArray cToolArray            = new toolArray(        new PVector(width/2.0,height/2.0),  new PVector(width/2.0, height/2.0) );

    manager(){
        //pass
    }

    void display(){
        /*
        Note here; Each panel will individually discriminate if certain parts need to be redrawn each 
            frame, so the manager can just ask them to draw what they respectively consider important
        => Micro-management later in program
        */
        cSensorArray.display();
        cFlightControls.display(cSolarMap);
        cStockRecords.display();
        cToolArray.display();

        //cSolarMap.display( new PVector(width/2.0, height/2.0) );    //### For Bug-Fixing ###
        //if(cSolarMap.outposts.size() > 0){                          //
        //    cSolarMap.outposts.get(0).displayTargets();}            //
    }
    void calc(){
        cSolarMap.calc();
        cSensorArray.calc();
        cStockRecords.calc();
        cToolArray.calc();
    }
    void manager_mousePressed(){
        /*
        ################################
        ## COULD HAVE A QUADRANT CHECK HERE, SO ONLY CHECKS RELEVENT CLASS
        ###############################
        */
        checkButtonsClicked();
        cSensorArray.sensor_mousePressed();
        cFlightControls.flight_mousePressed();
        cStockRecords.stocks_mousePressed();
        cToolArray.tools_mousePressed();
    }
    void manager_mouseReleased(){
        /*
        #################################
        ## COULD HAVE A QUADRANT CHECK HERE, SO ONLY CHECKS RELEVENT CLASS
        ###########################
        */
        cSensorArray.sensor_mouseReleased();
        cFlightControls.flight_mouseReleased();
        cStockRecords.stocks_mouseReleased();
        cToolArray.tools_mouseReleased();
    }

    void checkButtonsClicked(){
        /*
        Called when mouse is pressed to check each AVAILABLE panel (maybe could be temporarily disabled??? --> Although, 
        disabled probably just means remove all buttons and relevent graphics)

        1. Collect all buttons together
        2. Check all for matches, and activate all who meet the requirement
        */
        println("Checking for buttons clicked...");
        //1
        ArrayList<button> collatedButtons = new ArrayList<button>();
        for(int i=0; i<cSensorArray.buttonSet.size(); i++){
            collatedButtons.add( cSensorArray.buttonSet.get(i) );}
        for(int i=0; i<cFlightControls.buttonSet.size(); i++){
            collatedButtons.add( cFlightControls.buttonSet.get(i) );}
        for(int i=0; i<cStockRecords.buttonSet.size(); i++){
            collatedButtons.add( cStockRecords.buttonSet.get(i) );}
        for(int i=0; i<cToolArray.buttonSet.size(); i++){
            collatedButtons.add( cToolArray.buttonSet.get(i) );}
        //2
        for(int i=0; i<collatedButtons.size(); i++){
            if( collatedButtons.get(i).inButtonRange( new PVector(mouseX, mouseY) ) ){
                collatedButtons.get(i).activate();
                println("Button clicked!");
            }
        }
    }
}