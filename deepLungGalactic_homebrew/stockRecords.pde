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

    float moneyOwned = 100.0;
    float stockExchange_res = 20.0;     //How far back the stock exchange will record -> Last X price changes
    stringArrayDictionary stockExchange;
    ArrayList<item> staged_items = new ArrayList<item>();
    ArrayList<item> ship_inventory = new ArrayList<item>();
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
    PVector stockDetail_dim;
    PVector stockDetail_pos;
    float stockDetail_offset;
    PVector stockDetail_commit_dim;
    PVector stockDetail_commit_pos;
    PVector moneyDisp_dim;
    PVector moneyDisp_pos;

    stockRecords(PVector cornerPos, PVector panelDim){
        this.cornerPos = cornerPos;
        this.panelDim  = panelDim;

        inv_leftBorder = 5.0;                                                     //Distance cells start from the left side of the panel
        inv_border     = 10.0;                                                    //Space between cells
        inv_cellNumber = 7.0;                                                     //Number of visible cells on screen at once
        inv_dim = new PVector(panelDim.x/2.0, (panelDim.y -(inv_cellNumber+1)*inv_border) / (inv_cellNumber));
        inv_sizeOfText = inv_dim.y/2.0;

        backButton_dim = new PVector(0.15*panelDim.x,0.15*panelDim.x);
        backButton_pos = new PVector(cornerPos.x +0.80*panelDim.x, cornerPos.y +panelDim.y -0.2*panelDim.x);
        scroller_dim = new PVector(panelDim.y/7.0, panelDim.y/7.0);
        scroller_pos = new PVector(cornerPos.x +0.88*panelDim.x, cornerPos.y +0.83*panelDim.y);
        stockDetail_dim = new PVector(0.2*panelDim.x, 0.45*panelDim.y);
        stockDetail_pos = new PVector(cornerPos.x +0.75*panelDim.x, cornerPos.y +0.2*panelDim.y);
        stockDetail_offset = panelDim.x/32.0;
        stockDetail_commit_dim = new PVector(panelDim.y/7.0, panelDim.y/7.0);
        stockDetail_commit_pos = new PVector(cornerPos.x +0.74*panelDim.x, cornerPos.y +0.83*panelDim.y);
        moneyDisp_dim = new PVector(panelDim.y/13.0, panelDim.y/13.0);
        moneyDisp_pos = new PVector(cornerPos.x +0.85*panelDim.x, cornerPos.y +0.1*panelDim.y);

        initShipInventory();
        initStockExchange();
        initStockRecords(30);

        loadButtons_screen_selection();
    }

    //Display
    void display(){
        display_background();
        if(screen_selection){
            display_selection();}
        if(screen_stockGraphs){
            display_stockGraph(buttonSet.get(0).relatedItem);}
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
        if(staged_items.size() > 0){
            display_stagedDetails();}
        display_money();
    }
    void display_shipInventory(){
        /*
        Shows all resources avaialble, how much of each you own and how much 
        each can be sold and brought for
        */
        for(int i=0; i<ship_inventory.size(); i++){
            int givenInvInd = i+invIndOffset;
            if(givenInvInd < ship_inventory.size()){
                pushStyle();
                imageMode(CORNER);
                image(texture_stocks_selection_inv, cornerPos.x +inv_leftBorder, cornerPos.y +inv_border*(i+1) +inv_dim.y*(i));

                fill(255,255,255);
                textAlign(LEFT,CENTER);
                textSize(inv_sizeOfText);
                String infoText_name  = ship_inventory.get(givenInvInd).name;
                String infoText_value = str(floor(ship_inventory.get(givenInvInd).quantity));
                boolean onLastLine = (i == int(inv_cellNumber)-1);
                boolean moreInvRemaining = (ship_inventory.size()-1 > givenInvInd);
                if(onLastLine && moreInvRemaining){
                    infoText_name = "...";}
                textAlign(LEFT);
                text(infoText_name,  cornerPos.x +inv_leftBorder                 ,cornerPos.y +inv_border*(i+1) +inv_dim.y*(i) +inv_sizeOfText);
                textAlign(CENTER);
                text(infoText_value, cornerPos.x +inv_leftBorder +inv_dim.x/2.0 , cornerPos.y +inv_border*(i+1) +inv_dim.y*(i) +inv_sizeOfText);}
            else{
                break;}
        }
    }
    void display_shipInventory_simple(){
        /*
        Shows all resources avaialble, how much of each you own and how much 
        each can be sold and brought for
        */
        for(int i=0; i<ship_inventory.size(); i++){
            int givenInvInd = i+invIndOffset;
            if(givenInvInd < ship_inventory.size()){
                pushStyle();
                fill(80,80,80,180);
                noStroke();
                rectMode(CORNER);
                rect(cornerPos.x +inv_leftBorder, cornerPos.y +inv_border*(i+1) +inv_dim.y*(i), inv_dim.x, inv_dim.y);

                fill(255,255,255);
                textAlign(LEFT,CENTER);
                textSize(inv_sizeOfText);
                String infoText_name  = ship_inventory.get(givenInvInd).name;
                String infoText_value = str(ship_inventory.get(givenInvInd).quantity);
                boolean onLastLine = (i == int(inv_cellNumber)-1);
                boolean moreInvRemaining = (ship_inventory.size()-1 > givenInvInd);
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
        imageMode(CENTER);
        image(texture_general_button_scroller, scroller_pos.x +scroller_dim.x/2.0, scroller_pos.y +scroller_dim.y/2.0);
        popStyle();
    }
    void display_invScroller_simple(){
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
    void display_stagedDetails(){
        /*
        Displays a breakdown of the cost + and - summed
        AS WELL AS the increase or decrease of each item beside it

        ###############################
        ## SEPARATE THESE A BIT MORE ##
        ###############################
        */
        pushStyle();
        //Backdrop
        imageMode(CORNER);
        image(texture_stocks_selection_stockDetail, stockDetail_pos.x, stockDetail_pos.y);
        float sizeOfText = stockDetail_dim.y/7.0;
        textSize(sizeOfText);
        textAlign(LEFT,CENTER);
        //Positive
        String positiveValue = str(calcPositiveCost(staged_items));
        fill(80,255,80);
        text(positiveValue, stockDetail_pos.x +sizeOfText/2.0, stockDetail_pos.y +0.0*stockDetail_dim.y/3.0 +sizeOfText/2.0);
        //Negative
        String negativeValue = str(calcNegativeCost(staged_items));
        fill(255,80,80);
        text(negativeValue, stockDetail_pos.x +sizeOfText/2.0, stockDetail_pos.y +1.0*stockDetail_dim.y/3.0 +sizeOfText/2.0);
        //Total
        String totalValue = str(calcTotalCost(staged_items));
        fill(255,255,255);
        text(totalValue, stockDetail_pos.x +sizeOfText/2.0, stockDetail_pos.y +2.0*stockDetail_dim.y/3.0 +sizeOfText/2.0);
        //Commit button
        imageMode(CENTER);
        image(texture_stocks_selection_stockDetail_commit, stockDetail_commit_pos.x +stockDetail_commit_dim.x/2.0, stockDetail_commit_pos.y +stockDetail_commit_dim.y/2.0);
        //fill(60,60,60);
        //noStroke();
        //ellipse(stockDetail_commit_pos.x +stockDetail_commit_dim.x/2.0, stockDetail_commit_pos.y +stockDetail_commit_dim.y/2.0, stockDetail_commit_dim.x, stockDetail_commit_dim.y);
        //fill(255,255,255);
        //textAlign(CENTER, CENTER);
        //textSize(stockDetail_commit_dim.x/4.0);
        //text("Commit", stockDetail_commit_pos.x +stockDetail_commit_dim.x/2.0, stockDetail_commit_pos.y +stockDetail_commit_dim.y/2.0);
        //Quantity changes
        textSize(15);           //########## MAKE RELATIVE ############
        textAlign(LEFT,CENTER);
        for(int i=0; i<inv_cellNumber; i++){
            int givenInvInd = i +invIndOffset;
            if(givenInvInd < ship_inventory.size()){
                for(int j=0; j<staged_items.size(); j++){
                    if(staged_items.get(j).name == ship_inventory.get(givenInvInd).name){
                        fill(80,255,80);
                        if(staged_items.get(j).quantity < 0.0){
                            fill(255,80,80);}
                        text(staged_items.get(j).quantity, cornerPos.x +inv_leftBorder +inv_dim.x +stockDetail_offset, cornerPos.y +inv_border*(i+1) +inv_dim.y*(i) +inv_sizeOfText);
                    }
                }
            }
            else{
                break;
            }
        }
        popStyle();
    }
    void display_stagedDetails_simple(){
        /*
        Displays a breakdown of the cost + and - summed
        AS WELL AS the increase or decrease of each item beside it

        ###############################
        ## SEPARATE THESE A BIT MORE ##
        ###############################
        */
        pushStyle();
        //Backdrop
        stroke(120,120,120);
        fill(180,180,180,40);
        rectMode(CORNER);
        rect(stockDetail_pos.x, stockDetail_pos.y, stockDetail_dim.x, stockDetail_dim.y);
        float sizeOfText = stockDetail_dim.y/7.0;
        textSize(sizeOfText);
        textAlign(LEFT,CENTER);
        //Positive
        String positiveValue = str(calcPositiveCost(staged_items));
        fill(80,255,80);
        text(positiveValue, stockDetail_pos.x +sizeOfText/2.0, stockDetail_pos.y +0.0*stockDetail_dim.y/3.0 +sizeOfText/2.0);
        //Negative
        String negativeValue = str(calcNegativeCost(staged_items));
        fill(255,80,80);
        text(negativeValue, stockDetail_pos.x +sizeOfText/2.0, stockDetail_pos.y +1.0*stockDetail_dim.y/3.0 +sizeOfText/2.0);
        //Total
        String totalValue = str(calcTotalCost(staged_items));
        fill(255,255,255);
        text(totalValue, stockDetail_pos.x +sizeOfText/2.0, stockDetail_pos.y +2.0*stockDetail_dim.y/3.0 +sizeOfText/2.0);
        //Commit button
        fill(60,60,60);
        noStroke();
        ellipse(stockDetail_commit_pos.x +stockDetail_commit_dim.x/2.0, stockDetail_commit_pos.y +stockDetail_commit_dim.y/2.0, stockDetail_commit_dim.x, stockDetail_commit_dim.y);
        fill(255,255,255);
        textAlign(CENTER, CENTER);
        textSize(stockDetail_commit_dim.x/4.0);
        text("Commit", stockDetail_commit_pos.x +stockDetail_commit_dim.x/2.0, stockDetail_commit_pos.y +stockDetail_commit_dim.y/2.0);
        //Quantity changes
        textSize(15);           //########## MAKE RELATIVE ############
        textAlign(LEFT,CENTER);
        for(int i=0; i<inv_cellNumber; i++){
            int givenInvInd = i +invIndOffset;
            if(givenInvInd < ship_inventory.size()){
                for(int j=0; j<staged_items.size(); j++){
                    if(staged_items.get(j).name == ship_inventory.get(givenInvInd).name){
                        fill(80,255,80);
                        if(staged_items.get(j).quantity < 0.0){
                            fill(255,80,80);}
                        text(staged_items.get(j).quantity, cornerPos.x +inv_leftBorder +inv_dim.x +stockDetail_offset, cornerPos.y +inv_border*(i+1) +inv_dim.y*(i) +inv_sizeOfText);
                    }
                }
            }
            else{
                break;
            }
        }
        popStyle();
    }
    void display_money(){
        pushStyle();
        textAlign(CENTER, CENTER);
        textSize(moneyDisp_dim.x);
        fill(255,255,255);
        text("$"+str(roundToXdp(moneyOwned, 1)), moneyDisp_pos.x, moneyDisp_pos.y);
        popStyle();
    }
    //--- Display Graphs
    void display_stockGraph(item givenItem){
        display_backButton();
        display_graph_data(givenItem);
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
    void display_graph_data(item givenItem){
        /*
        Takes data from stock exchange, plots it 
        
        1. Find max, min, X interval
        2. Set Y interval based on this ??????? REDO EXPLAINATION
        3. Plot

        ##############################
        ## BREAK THIS UP A BIT MORE ##
        ##############################
        */
        ArrayList<Float> graphData = new ArrayList<Float>();
        graphData = stockExchange.getValue(givenItem.name);
        //1
        float maxVal = graphData.get( findMax(graphData) );
        float minVal = graphData.get( findMin(graphData) );
        int labelledNumber = 5;
        PVector graphDim = new PVector(0.8*panelDim.x, 0.8*panelDim.y);
        float xInterval  = graphDim.x /stockExchange_res;
        //2
        float yInterval = graphDim.y/labelledNumber;
        float pixelsToUnitsConversion = abs(maxVal - minVal) / (graphDim.y);
        //3
        pushStyle();
        //Lines
        noFill();
        stroke(180,180,180);
        strokeWeight(3);
        line(cornerPos.x +(panelDim.x -graphDim.x)/2.0, cornerPos.y +(panelDim.y +graphDim.y)/2.0, cornerPos.x +(panelDim.x +graphDim.x)/2.0, cornerPos.y +(panelDim.y +graphDim.y)/2.0); //X-axis
        line(cornerPos.x +(panelDim.x -graphDim.x)/2.0, cornerPos.y +(panelDim.y -graphDim.y)/2.0, cornerPos.x +(panelDim.x -graphDim.x)/2.0, cornerPos.y +(panelDim.y +graphDim.y)/2.0); //Y-axis
        //Axis labels
        fill(255,255,255);
        textSize(15);
        textAlign(RIGHT);
        for(int i=0; i<=labelledNumber; i++){
            text(str(roundToXdp(maxVal -pixelsToUnitsConversion*i*yInterval, 1)), cornerPos.x +(panelDim.x -graphDim.x)/2.0, cornerPos.y +(panelDim.y -graphDim.y)/2.0 +i*yInterval);
        }
        PVector timeDispOffset = new PVector(graphDim.x/30.0, graphDim.y/10.0);
        text("t=0",cornerPos.x +(panelDim.x +graphDim.x)/2.0 +timeDispOffset.x, cornerPos.y +(panelDim.y +graphDim.y)/2.0 +timeDispOffset.y);
        noFill();
        strokeWeight(3);
        for(int i=0; i<graphData.size(); i++){
            stroke(255,255,255, 140);
            ellipse(cornerPos.x +(panelDim.x +graphDim.x)/2.0 -i*xInterval, cornerPos.y +(panelDim.y +graphDim.y)/2.0 -(graphData.get(i) -minVal)*(1.0/pixelsToUnitsConversion),10,10); //####### MAKE RELATIVE
            if(i > 0){
                stroke(100,200,100);
                if(graphData.get(i-1) < graphData.get(i)){
                    stroke(200,100,100);}
                line(cornerPos.x +(panelDim.x +graphDim.x)/2.0 -(i-1)*xInterval, cornerPos.y +(panelDim.y +graphDim.y)/2.0 -(graphData.get(i-1) -minVal)*(1.0/pixelsToUnitsConversion), cornerPos.x +(panelDim.x +graphDim.x)/2.0 -i*xInterval, cornerPos.y +(panelDim.y +graphDim.y)/2.0 -(graphData.get(i) -minVal)*(1.0/pixelsToUnitsConversion));}
        }
        //Alligner lines
        stroke(235, 207, 52, 90);
        strokeWeight(3);
        line(cornerPos.x +(panelDim.x +graphDim.x)/2.0, cornerPos.y +(panelDim.y +graphDim.y)/2.0 -(graphData.get(0) -minVal)*(1.0/pixelsToUnitsConversion), cornerPos.x +(panelDim.x -graphDim.x)/2.0, cornerPos.y +(panelDim.y +graphDim.y)/2.0 -(graphData.get(0) -minVal)*(1.0/pixelsToUnitsConversion));   //X align
        line(cornerPos.x +(panelDim.x +graphDim.x)/2.0, cornerPos.y +(panelDim.y +graphDim.y)/2.0 -(graphData.get(0) -minVal)*(1.0/pixelsToUnitsConversion), cornerPos.x +(panelDim.x +graphDim.x)/2.0, cornerPos.y +(panelDim.y +graphDim.y)/2.0);                                                             //Y align
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
        addItem(new item_probeCore(6.0), ship_inventory);
        //addItem(new item_forbicite(23.3), ship_inventory);
        //addItem(new item_crestulin(120.0), ship_inventory);
        //addItem(new item_traen04(23.3), ship_inventory);
        //addItem(new item_tickline(23.3), ship_inventory);
        //addItem(new item_gaiaite(23.3), ship_inventory);
        //addItem(new item_chronosilicate(23.3), ship_inventory);
        //addItem(new item_astridium(23.3), ship_inventory);
        //addItem(new item_hyperflex(23.3), ship_inventory);
    }
    void initStockExchange(){
        /*
        -Item names
        -Add empty space in lists
        -Prices of item (base price)
        */
        ArrayList<String> keys = new ArrayList<String>();
        ArrayList<ArrayList<Float>> values = new ArrayList<ArrayList<Float>>();

        keys.add("crestulin");             keys.add("forbicite");             keys.add("traen04");               keys.add("probeCore");             keys.add("tickline");              keys.add("gaiaite");               keys.add("chronosilicate");        keys.add("astridium");             keys.add("hyperflex");
        values.add(new ArrayList<Float>());values.add(new ArrayList<Float>());values.add(new ArrayList<Float>());values.add(new ArrayList<Float>());values.add(new ArrayList<Float>());values.add(new ArrayList<Float>());values.add(new ArrayList<Float>());values.add(new ArrayList<Float>());values.add(new ArrayList<Float>());
        values.get(0).add(1.2);            values.get(1).add(0.6);            values.get(2).add(3.3);            values.get(3).add(82.0);           values.get(4).add(1.0);            values.get(5).add(2.3);            values.get(6).add(4.0);            values.get(7).add(5.7);            values.get(8).add(1.3);

        stockExchange = new stringArrayDictionary(keys, values);
    }
    void initStockRecords(int evolveNumber){
        for(int i=0; i<evolveNumber; i++){
            stockExchange_evolvePrice();
        }
    }
    void stockExchange_evolvePrice(){
        /*
        Change prices, based on randomness +historic figures
        Try to make it bounce about the base price -> tend to base at inf.
        Will also remove prices to fit history res. requirement

        1. Go through all items
        2. Adjust by random amount
        3. Add as new entry
        4. Remove entries larger than the resolution
        */
        //1
        for(int i=0; i<stockExchange.size(); i++){
            println(i);
            //2
            float randFactor = random(-0.15, 0.15);                                             //Percentage INCREASE or DECREASE, NOT a multiplier
            float newPrice = stockExchange.values.get(i).get(0)*(1.0 +randFactor);
            //3
            stockExchange.values.get(i).add(0, newPrice);                                       //Add to start
            //4
            int resolutionDifference = stockExchange.values.get(i).size() -floor(stockExchange_res);
            for(int j=0; j<resolutionDifference; j++){                                          //Will let it naturally come up to speed of the new resolution, BUT instantly cut it short -> Which is a good thing
                stockExchange.values.get(i).remove( stockExchange.values.get(i).size() -1 );}   //Remove from end
        }
    }
    float findItemCount(item givenItem){
        /*
        Returns quantity of given item in ship inventory
        */
        float quantityCount = -1.0;
        for(int i=0; i<ship_inventory.size(); i++){
            if(ship_inventory.get(i).name == givenItem.name){
                quantityCount = ship_inventory.get(i).quantity;
                break;
            }
        }
        return quantityCount;
    }
    void addItem(item givenItem, ArrayList<item> itemList){
        /*
        Adds/Removes X quantity of the given item (X is specified in the quantity supplied, which can be negative to reduce the amount)
        Checks if item already exists
        If it does, (1)increase its quantity, if not (2)create a new space
        */
        boolean itemAlreadyExists = false;
        for(int i=0; i<itemList.size(); i++){
            if(givenItem.name == itemList.get(i).name){
                //1
                itemAlreadyExists = true;
                itemList.get(i).quantity += givenItem.quantity;
                if(itemList.get(i).quantity <= 0){
                    if(itemList.get(i).name != "probeCore"){    //**DO NOT remove probe cores, so they can be brought again
                        //All gone => remove space
                        itemList.remove(i);
                    }
                }
                break;
            }
        }
        if( (!itemAlreadyExists) && (givenItem.quantity > 0) ){
            itemList.add( generateCopy_item(givenItem) );
            itemList.get( itemList.size()-1 ).quantity = givenItem.quantity;
            if(screen_selection){
                loadButtons_screen_selection();}
        }
    }
    void stageItem(item givenItem){
        /*
        Prepares the item to be brought or sold
        If possible, when committed, all staged items will be brought and sold

        +ve => Wants to BUY FROM COMPANY
        -ve => Wants to SELL OWNED
        */
        boolean itemAlreadyExists = false;
        for(int i=0; i<staged_items.size(); i++){
            if(givenItem.name == staged_items.get(i).name){
                //1
                itemAlreadyExists = true;
                staged_items.get(i).quantity += givenItem.quantity;
                if(staged_items.get(i).quantity == 0.0){
                    staged_items.remove(i);}
                break;
            }
        }
        if(!itemAlreadyExists){
            staged_items.add( generateCopy_item(givenItem) );
            staged_items.get( staged_items.size()-1 ).quantity = givenItem.quantity;    //Because copy is generated with 0 quantity
        }
    }
    void commitStaged(){
        /*
        Will attempt to buy/sell all staged items and finalise the agreement

        1.   Find total cost
        2.1. Verify you can pay cost
        2.2. Verify you have the items available for the transaction
        3.   Adjust money, adjust inventory, empty staged
        */
        boolean hasAllItems = true;
        //1
        float totalCost = calcTotalCost(staged_items);
        //2.1
        boolean canAfford = (moneyOwned >= totalCost);
        if(canAfford){
            //2.2
            //For each item staged
            for(int i=0; i<staged_items.size(); i++){
                boolean enoughOfGiven = false;
                //Check all items currently held
                for(int j=0; j<ship_inventory.size(); j++){
                    //If is the needed item
                    if(staged_items.get(i).name == ship_inventory.get(j).name){
                        //If there is enough of this item
                        if(ship_inventory.get(j).quantity +staged_items.get(i).quantity >= 0){
                            enoughOfGiven = true;
                            break;
                        }
                    }
                }
                if(!enoughOfGiven){
                    hasAllItems = false;
                    break;
                }
            }
        }
        if(canAfford && hasAllItems){
            //SUCCESSFULLY committed
            //3
            //Money
            moneyOwned -= totalCost;
            //Items
            for(int i=0; i<staged_items.size(); i++){
                for(int j=0; j<ship_inventory.size(); j++){
                    if(ship_inventory.get(j).name == staged_items.get(i).name){
                        ship_inventory.get(j).quantity += staged_items.get(i).quantity;
                        break;
                    }
                }
            }
            //Staged
            println("Commit success");
            staged_items.clear();
        }
        else{
            //FAILED to commit
            println("Commit failed");
        }
    }
    float calcPositiveCost(ArrayList<item> itemList){
        float summedCost = 0.0;
        for(int i=0; i<itemList.size(); i++){
            if(itemList.get(i).quantity > 0.0){ //e.g If you are BUYING ITEMS
                summedCost += itemList.get(i).quantity*stockExchange.getValue(itemList.get(i).name).get(0);
            }
        }
        return summedCost;
    }
    float calcNegativeCost(ArrayList<item> itemList){
        float summedCost = 0.0;
        for(int i=0; i<itemList.size(); i++){
            if(itemList.get(i).quantity < 0.0){ //e.g If you are SELLING ITEMS
                summedCost += itemList.get(i).quantity*stockExchange.getValue(itemList.get(i).name).get(0);
            }
        }
        return summedCost;
    }
    float calcTotalCost(ArrayList<item> itemList){
        return calcPositiveCost(itemList) +calcNegativeCost(itemList);
    }


    void loadButtons_screen_selection(){
        buttonSet.clear();
        for(int i=0; i<inv_cellNumber; i++){
            int givenInd = invIndOffset +i;
            if(givenInd < ship_inventory.size()){   //If valid
                button newButton1 = new button( new PVector(cornerPos.x +inv_leftBorder                   , cornerPos.y +i*inv_dim.y +(i+1)*inv_border), new PVector(inv_dim.x/3.0, inv_dim.y), "rect", "stocks_buyItem");
                button newButton2 = new button( new PVector(cornerPos.x +inv_leftBorder +    inv_dim.x/3.0, cornerPos.y +i*inv_dim.y +(i+1)*inv_border), new PVector(inv_dim.x/3.0, inv_dim.y), "rect", "stocks_goToStockGraph");
                button newButton3 = new button( new PVector(cornerPos.x +inv_leftBorder +2.0*inv_dim.x/3.0, cornerPos.y +i*inv_dim.y +(i+1)*inv_border), new PVector(inv_dim.x/3.0, inv_dim.y), "rect", "stocks_sellItem");
                newButton1.relatedItem = generateCopy_item(ship_inventory.get(givenInd));newButton2.relatedItem = generateCopy_item(ship_inventory.get(givenInd));newButton3.relatedItem = generateCopy_item(ship_inventory.get(givenInd));
                buttonSet.add(newButton1);buttonSet.add(newButton2);buttonSet.add(newButton3);
            }
        }
        button newButton0 = new button( scroller_pos, scroller_dim, "circ", "stocks_incrementInvIndOffset");
        button newButton1 = new button( stockDetail_commit_pos, stockDetail_commit_dim, "circ", "stocks_commitStagedItems");
        buttonSet.add(newButton0);buttonSet.add(newButton1);
    }
    void loadButtons_screen_stockGraph(item givenItem){
        buttonSet.clear();
        button newButton0 = new button(backButton_pos, backButton_dim, "rect", "stocks_goToSelection");
        newButton0.relatedItem = generateCopy_item(givenItem);
        buttonSet.add(newButton0);
    }
}


class item{
    /*
    The ship has an inventory, holding items
    Minerals mining and collected must be converted to items

    Items detailed;
    - Type
    - Quantity
    - Info text
    - ...
    */
    String name;
    float quantity;

    item(float quantity){
        this.quantity = quantity;
    }

    //pass
}
class item_crestulin extends item{
    //pass

    item_crestulin(float quantity){
        super(quantity);
        name = "crestulin";
    }

    //pass
}
class item_forbicite extends item{
    //pass

    item_forbicite(float quantity){
        super(quantity);
        name = "forbicite";
    }

    //pass
}
class item_traen04 extends item{
    //pass

    item_traen04(float quantity){
        super(quantity);
        name = "traen04";
    }

    //pass
}
class item_probeCore extends item{
    //pass

    item_probeCore(float quantity){
        super(quantity);
        name = "probeCore";
    }

    //pass
}
class item_tickline extends item{
    //pass

    item_tickline(float quantity){
        super(quantity);
        name = "tickline";
    }

    //pass
}
class item_gaiaite extends item{
    //pass

    item_gaiaite(float quantity){
        super(quantity);
        name = "gaiaite";
    }

    //pass
}
class item_chronosilicate extends item{
    //pass

    item_chronosilicate(float quantity){
        super(quantity);
        name = "chronosilicate";
    }

    //pass
}
class item_astridium extends item{
    //pass

    item_astridium(float quantity){
        super(quantity);
        name = "astridium";
    }

    //pass
}
class item_hyperflex extends item{
    //pass

    item_hyperflex(float quantity){
        super(quantity);
        name = "hyperflex";
    }

    //pass
}


/*
##
**This is an IRL needy module
Make sure is kept up to date
##
*/
item mineralToItem(mineral cMineral){
    if(cMineral.name == "crestulin"){
        item_crestulin newItem = new item_crestulin(cMineral.quantity);
        return newItem;
    }
    else if(cMineral.name == "forbicite"){
        item_forbicite newItem = new item_forbicite(cMineral.quantity);
        return newItem;
    }
    else if(cMineral.name == "traen04"){
        item_traen04 newItem = new item_traen04(cMineral.quantity);
        return newItem;
    }
    else if(cMineral.name == "tickline"){
        item_tickline newItem = new item_tickline(cMineral.quantity);
        return newItem;
    }
    else if(cMineral.name == "gaiaite"){
        item_gaiaite newItem = new item_gaiaite(cMineral.quantity);
        return newItem;
    }
    else if(cMineral.name == "chronosilicate"){
        item_chronosilicate newItem = new item_chronosilicate(cMineral.quantity);
        return newItem;
    }
    else if(cMineral.name == "astridium"){
        item_astridium newItem = new item_astridium(cMineral.quantity);
        return newItem;
    }
    else if(cMineral.name == "hyperflex"){
        item_hyperflex newItem = new item_hyperflex(cMineral.quantity);
        return newItem;
    }
    else{
        return null;
    }
}
item generateCopy_item(item givenItem){
    float quantity = 0.0;
    if(givenItem.name == "crestulin"){
        return new item_crestulin(quantity);
    }
    else if(givenItem.name == "forbicite"){
        return new item_forbicite(quantity);
    }
    else if(givenItem.name == "traen04"){
        return new item_traen04(quantity);
    }
    else if(givenItem.name == "probeCore"){
        return new item_probeCore(quantity);
    }
    else if(givenItem.name == "tickline"){
        return new item_tickline(quantity);
    }
    else if(givenItem.name == "gaiaite"){
        return new item_gaiaite(quantity);
    }
    else if(givenItem.name == "chronosilicate"){
        return new item_chronosilicate(quantity);
    }
    else if(givenItem.name == "astridium"){
        return new item_astridium(quantity);
    }
    else if(givenItem.name == "hyperflex"){
        return new item_hyperflex(quantity);
    }
    else{
        return null;
    }
}
mineral generateCopy_mineral(mineral givenMineral){
    if(givenMineral.name == "crestulin"){
        return new crestulin();
    }
    else if(givenMineral.name == "forbicite"){
        return new forbicite();
    }
    else if(givenMineral.name == "traen04"){
        return new traen04();
    }
    else if(givenMineral.name == "tickline"){
        return new tickline();
    }
    else if(givenMineral.name == "gaiaite"){
        return new gaiaite();
    }
    else if(givenMineral.name == "chronosilicate"){
        return new chronosilicate();
    }
    else if(givenMineral.name == "astridium"){
        return new astridium();
    }
    else if(givenMineral.name == "hyperflex"){
        return new hyperflex();
    }
    else{
        return null;
    }
}