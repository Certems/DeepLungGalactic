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
        addItem(new item_crestulin(120.0), ship_inventory);
        addItem(new item_traen04(23.3), ship_inventory);
        addItem(new item_probeCore(1.0), ship_inventory);
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
                    //All gone => remove space
                    itemList.remove(i);
                }
                break;
            }
        }
        if( (!itemAlreadyExists) && (givenItem.quantity > 0) ){
            itemList.add(givenItem);
        }
    }
    void stageItem(item givenItem){
        /*
        Prepares the item to be brought or sold
        If possible, when committed, all staged items will be brought and sold

        +ve => Wants to BUY FROM COMPANY
        -ve => Wants to SELL OWNED
        */
        addItem(givenItem, staged_items);
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
            staged_items.clear();
        }
        else{
            //FAILED to commit
            println("Commit failed");
        }
    }
    float calcTotalCost(ArrayList<item> itemList){
        //pass

        //## HOW SHOULD THE MONEY SIDE WORK -> WHERE SHOULD IT PULL FROM ??????????????x
    }


    void loadButtons_screen_selection(){
        buttonSet.clear();
        for(int i=0; i<inv_cellNumber; i++){
            int givenInd = invIndOffset +i;
            if(givenInd < ship_inventory.size()){   //If valid
                button newButton1 = new button( new PVector(cornerPos.x +inv_leftBorder                   , cornerPos.y +i*inv_dim.y +(i+1)*inv_border), new PVector(inv_dim.x/3.0, invDim.y), "rect", "stocks_buyItem");
                button newButton2 = new button( new PVector(cornerPos.x +inv_leftBorder +    inv_dim.x/3.0, cornerPos.y +i*inv_dim.y +(i+1)*inv_border), new PVector(inv_dim.x/3.0, invDim.y), "rect", "stocks_goToStockGraph");
                button newButton3 = new button( new PVector(cornerPos.x +inv_leftBorder +2.0*inv_dim.x/3.0, cornerPos.y +i*inv_dim.y +(i+1)*inv_border), new PVector(inv_dim.x/3.0, invDim.y), "rect", "stocks_sellItem");
                newButton1.relatedItem = ship_inventory.get(i);newButton2.relatedItem = ship_inventory.get(i);newButton3.relatedItem = ship_inventory.get(i);
                buttonSet.add(newButton1);buttonSet.add(newButton2);buttonSet.add(newButton3);
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