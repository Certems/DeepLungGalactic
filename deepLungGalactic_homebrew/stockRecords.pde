class stockRecords{
    /*
    ---------
    |   |   |
    |--------
    | X |   |
    ---------
    A panel that shows a scrollable list of materials that have been gathered, 
    indicating how much of each is owned, the prices it sells for and the prices 
    it can be brought for.

    Screens involved are;
    selection -> StockGraphs
    */
    ArrayList<button> buttonSet = new ArrayList<button>();

    boolean screen_selection   = true;
    boolean screen_stockGraphs = false;
    
    PVector cornerPos;  //Top-Left corner defining the origin from which items in this panel are drawn
    PVector panelDim;   //The dimensions of this panel, which must contain all the panel's information

    stringDictionary shipInventory;
    int invIndOffset = 0;
    float inv_leftBorder;
    float inv_border;
    float inv_cellNumber;
    PVector inv_dim;
    float inv_sizeOfText;


    PVector backButton_dim;
    PVector backButton_pos;
    PVector scroller_dim;
    PVector scroller_pos;

    stockRecords(PVector cornerPos, PVector panelDim){
        this.cornerPos = cornerPos;
        this.panelDim  = panelDim;

        inv_leftBorder = 5.0;                                                     //Distance cells start from the left side of the panel
        inv_border     = 10.0;                                                    //Space between cells
        inv_cellNumber = 7.0;                                                     //Number of visible cells on screen at once
        inv_dim = new PVector(panelDim.x/2.0, (panelDim.y -(inv_cellNumber+1)*inv_border) / (inv_cellNumber));
        inv_sizeOfText = inv_dim.y/2.0;

        backButton_dim = new PVector(0.15*panelDim.x,0.15*panelDim.y);
        backButton_pos = new PVector(cornerPos.x +0.80*panelDim.x, cornerPos.y +0.80*panelDim.y);
        scroller_dim = new PVector(panelDim.y/7.0, panelDim.y/7.0);
        scroller_pos = new PVector(cornerPos.x +0.88*panelDim.x, cornerPos.y +0.05*panelDim.y);

        initShipInventory();
    }

    //Display
    void display(){
        display_background();
        if(screen_selection){
            display_selection();}
        if(screen_stockGraphs){
            display_stockGraph();}
        display_buttonBounds();
    }
    void display_background(){
        pushStyle();
        rectMode(CORNER);
        fill(20,30,20);
        noStroke();
        rect(cornerPos.x, cornerPos.y, panelDim.x, panelDim.y);
        popStyle();
    }
    //--- Display Selection
    void display_selection(){
        display_shipInventory();
        display_invScroller();
    }
    void display_shipInventory(){
        /*
        Shows all resources avaialble, how much of each you own and how much 
        each can be sold and brought for
        */
        for(int i=0; i<shipInventory.size(); i++){
            int givenInvInd = i+invIndOffset;
            if(givenInvInd < shipInventory.size()){
                pushStyle();
                fill(80,80,80,180);
                noStroke();
                rectMode(CORNER);
                rect(cornerPos.x +inv_leftBorder, cornerPos.y +inv_border*(i+1) +inv_dim.y*(i), inv_dim.x, inv_dim.y);

                fill(255,255,255);
                textAlign(LEFT,CENTER);
                textSize(inv_sizeOfText);
                String infoText_name  = shipInventory.keys.get(givenInvInd);
                String infoText_value = str(shipInventory.values.get(givenInvInd));
                boolean onLastLine = (i == int(inv_cellNumber)-1);
                boolean moreInvRemaining = (shipInventory.size()-1 > givenInvInd);
                if(onLastLine && moreInvRemaining){
                    infoText_name = "...";}
                text(infoText_name,  cornerPos.x +inv_leftBorder                 ,cornerPos.y +inv_border*(i+1) +inv_dim.y*(i) +inv_sizeOfText);
                text(infoText_value, cornerPos.x +inv_leftBorder +inv_dim.x/2.0 , cornerPos.y +inv_border*(i+1) +inv_dim.y*(i) +inv_sizeOfText);}
            else{
                break;}
        }
    }
    void display_invScroller(){
        pushStyle();
        fill(50,50,50);
        noStroke();
        ellipse(scroller_pos.x +scroller_dim.x/2.0, scroller_pos.y +scroller_dim.y/2.0, scroller_dim.x, scroller_dim.y);

        fill(255,255,255);
        textAlign(CENTER, CENTER);
        textSize(20);
        text("Scroller", scroller_pos.x +scroller_dim.x/2.0, scroller_pos.y +scroller_dim.y/2.0);
        popStyle();
    }
    //--- Display Graphs
    void display_stockGraph(){
        display_backButton();
        display_graph_data();
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
    void display_graph_data(){
        display_graph_increasing();
        display_graph_decreasing();
    }
    void display_graph_increasing(){
        pushStyle();
        fill(255,255,255);
        textAlign(CENTER, CENTER);
        textSize(20);
        text("Increasing", cornerPos.x +panelDim.x/2.0, cornerPos.y +panelDim.y/2.0);
        popStyle();
    }
    void display_graph_decreasing(){
        pushStyle();
        fill(255,255,255);
        textAlign(CENTER, CENTER);
        textSize(20);
        text("Decreasing", cornerPos.x +panelDim.x/2.0, cornerPos.y +panelDim.y/2.0);
        popStyle();
    }
    //##BUG FIXING##
    void display_buttonBounds(){
        for(int i=0; i<buttonSet.size(); i++){
            buttonSet.get(i).displayOutline();
        }
    }
    //##BUG FIXING##


    //Calculations
    void calc(){
        //pass
    }


    //Input
    void stocks_mousePressed(){
        //pass
    }
    void stocks_mouseReleased(){
        //pass
    }


    void initShipInventory(){
        ArrayList<String> keySet  = new ArrayList<String>();
        ArrayList<Float> valueSet = new ArrayList<Float>();

        keySet.add("Crestulin");keySet.add("Forbicite");keySet.add("Traen-04"); keySet.add("Grain Powder"); keySet.add("Octo-Dilitic");keySet.add("Crestulin");keySet.add("Forbicite");keySet.add("Traen-04"); keySet.add("Grain Powder"); keySet.add("Octo-Dilitic");
        valueSet.add(100.0);    valueSet.add(100.0);    valueSet.add(100.0);    valueSet.add(100.0);        valueSet.add(100.0);       valueSet.add(100.0);    valueSet.add(100.0);    valueSet.add(100.0);    valueSet.add(100.0);        valueSet.add(100.0);
        //...

        shipInventory = new stringDictionary(keySet, valueSet);
    }


    void loadButtons_screen_selection(){
        buttonSet.clear();
        for(int i=0; i<inv_cellNumber; i++){
            int givenInd = invIndOffset +i;
            if(givenInd < shipInventory.size()){   //If valid
                button newButton = new button( new PVector(cornerPos.x +inv_leftBorder, cornerPos.y +i*inv_dim.y +(i+1)*inv_border), inv_dim, "rect", "stocks_goToStockGraph");
                buttonSet.add(newButton);
            }
        }
        button newButton0 = new button( scroller_pos, scroller_dim, "circ", "stocks_incrementInvIndOffset");
        buttonSet.add(newButton0);
    }
    void loadButtons_screen_stockGraph(){
        buttonSet.clear();
        button newButton0 = new button(backButton_pos, backButton_dim, "rect", "stocks_goToSelection");
        buttonSet.add(newButton0);
    }
}