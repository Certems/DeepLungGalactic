class outroScreen{
    /*
    Shown when the player reaches the end of the game
    It allows them to play again or quit
    It shows them various analytics as to how well they performed, such as 
    showing them how much of the total map was explored, how much of the total 
    wealth available was accumulated, etc

    It will also contain a small section of 'story' to help give some finality (or not) 
    to the playthrough
    */
    boolean isActive = false;

    int dispType = 1;

    float timer = 0.0;              //Keeps track of how far through their playthrough the player is (in frames)
    float timerEndMax = 36000.0;    //10 mins at 60 fps => may be better to use some sort of clock module to just record a start and end time

    int outpostsDestroyed  = 0;
    int outpostDestructMax = 4;

    PVector score_dim;
    PVector score_pos;
    PVector analytics_dim;
    PVector analytics_pos;
    PVector story_dim;
    PVector story_pos;
    PVector mapComp_dim;    //Both maps same dim
    PVector mapComp_pos;    //Centre pos for REAL map, GUESSED map will be place to its RHS
    PVector playAgain_dim;
    PVector playAgain_pos;

    outroScreen(){
        score_dim     = new PVector(width/5.0, height/15.0);
        score_pos     = new PVector(height/25.0, height/25.0);
        analytics_dim = new PVector(score_dim.x, height/2.0);
        analytics_pos = new PVector(score_pos.x, score_pos.y +score_dim.y +height/25.0);
        story_dim     = new PVector(width/2.0, height/4.0);
        story_pos     = new PVector(width/2.0 -height/25.0, height/25.0);
        mapComp_dim   = new PVector(height/5.0, height/5.0);
        mapComp_pos   = new PVector(0.1*height +mapComp_dim.x/2.0, height-0.1*height -mapComp_dim.y/2.0);
        playAgain_dim = new PVector(width/10.0, height/10.0);
        playAgain_pos = new PVector(width -1.1*playAgain_dim.x, height -1.1*playAgain_dim.y);
    }

    boolean isTimeEnding(){
        return (timer >= timerEndMax);   //Run out of time;
    }
    boolean isAlienEnding(){
        return (outpostsDestroyed >= outpostDestructMax); //Aliens destroy too many outposts
    }
    boolean isMoneyEnding(){
        return false;    //If you run out of money and resources --> may want to implement
    }
    boolean isGameEnd(){
        /*
        Check every second or so maybe
        Dont do very often, not worth it
        */
        boolean timeEnding  = isTimeEnding();
        boolean alienEnding = isAlienEnding();
        boolean moneyEnding = isMoneyEnding();
        //...
        if( ((timeEnding) || (alienEnding)) || (moneyEnding) ){
            //println("Game is over");
            sound_general_gameEnd.play();
            dispType = 1;
            return true;}
        else{
            //println("Game NOT over");
            return false;}
    }
    void display(){
        display_background();
        if(dispType == 1){
            display_endScreen();
        }
        if(dispType == 2){
            display_creditsScreen();
        }
    }
    void display_endScreen(){
        display_graphic();
        display_score();
        display_analytics();
        display_story();
        display_playAgain();
    }
    void display_background(){
        background(30,30,30);
    }
    void display_graphic(){
        pushStyle();

        imageMode(CORNER);
        image(texture_outro_screen, 0, 0);

        popStyle();
    }
    void display_score(){
        pushStyle();

        fill(255,255,255);
        textAlign(CENTER, CENTER);
        textSize(score_dim.y/2.0);
        //text(cManager.cStockRecords.moneyOwned, score_pos.x +score_dim.x/2.0, score_pos.y +score_dim.y/2.0);

        rectMode(CORNER);
        fill(100,100,150,50);
        //rect(score_pos.x, score_pos.y, score_dim.x, score_dim.y);

        popStyle();
    }
    void display_analytics(){
        display_analytics_wealth();
        display_analytics_map(cManager.cSolarMap);
    }
    void display_analytics_wealth(){
        pushStyle();

        float sizeOfText = analytics_dim.y/12.0;

        rectMode(CORNER);
        noStroke();
        fill(150,110,110, 80);
        rect(analytics_pos.x, analytics_pos.y +3.6*sizeOfText, analytics_dim.x/2.0, 1.2*sizeOfText);
        
        fill(255,255,255);
        textAlign(LEFT);
        float wealthOwned = calcTotalWealth_acquired(cManager.cStockRecords);
        float wealthLeft  = calcTotalWealth_remaining(cManager.cSolarMap, cManager.cStockRecords);
        textSize(sizeOfText);text("$"+ str(floor(cManager.cStockRecords.moneyOwned))   , analytics_pos.x, analytics_pos.y +1.0*sizeOfText);   textSize(sizeOfText*0.5);text("=> Raw Cash" , analytics_pos.x +analytics_dim.x*0.7, analytics_pos.y +1.0*sizeOfText);
        textSize(sizeOfText);text("$"+ str(roundToXdp(wealthOwned, 1)), analytics_pos.x, analytics_pos.y +2.2*sizeOfText);   textSize(sizeOfText*0.5);text("=> Net Cash Total" , analytics_pos.x +analytics_dim.x*0.7, analytics_pos.y +2.2*sizeOfText);
        textSize(sizeOfText);text("$"+ str(roundToXdp(wealthLeft, 1)) , analytics_pos.x, analytics_pos.y +3.4*sizeOfText);   textSize(sizeOfText*0.5);text("=> Net Cash Unclaimed" , analytics_pos.x +analytics_dim.x*0.7, analytics_pos.y +3.4*sizeOfText);
        fill(170,170,250);
        textSize(sizeOfText);text(str(roundToXdp(wealthOwned/(wealthLeft +wealthOwned), 4)) +"%", analytics_pos.x, analytics_pos.y +4.6*sizeOfText); textSize(sizeOfText*0.5);text("=> Solar Cash Percentage" , analytics_pos.x +analytics_dim.x*0.7, analytics_pos.y +4.6*sizeOfText);

        popStyle();
    }
    void display_analytics_map(solarMap cSolarMap){
        cSolarMap.display(mapComp_pos, (mapComp_dim.y/height));    //### For Bug-Fixing ###
        cManager.cToolArray.cartoMap.displayMini(new PVector(mapComp_pos.x +mapComp_dim.x, mapComp_pos.y), 2.0);
    }
    void display_story(){
        pushStyle();

        rectMode(CORNER);
        fill(100,150,100,50);
        //rect(story_pos.x, story_pos.y, story_dim.x, story_dim.y);

        float sizeOfText = story_dim.y/9.0;
        displayTextLog(generateStoryLog(), sizeOfText, new PVector(story_pos.x, story_pos.y +sizeOfText));

        popStyle();
    }
    void display_playAgain(){
        pushStyle();

        rectMode(CORNER);
        fill(200,200,200,70);
        rect(playAgain_pos.x, playAgain_pos.y, playAgain_dim.x, playAgain_dim.y);

        textAlign(CENTER, CENTER);
        textSize(playAgain_dim.x/8.0);
        fill(255,255,255);
        text("Play Again", playAgain_pos.x +playAgain_dim.x/2.0, playAgain_pos.y +playAgain_dim.y/2.0);

        popStyle();
    }
    void display_creditsScreen(){
        pushStyle();
        imageMode(CORNER);
        image(texture_credits_screen, 0, 0);
        popStyle();
    }

    void calc(){
        //pass
    }

    void outroScreen_mousePressed(){
        if(dispType == 1){
            //restart game
            boolean withinX = (playAgain_pos.x < mouseX) && (mouseX < playAgain_pos.x +playAgain_dim.x);
            boolean withinY = (playAgain_pos.y < mouseY) && (mouseY < playAgain_pos.y +playAgain_dim.y);
            if(withinX && withinY){
                cManager = new manager();
                cManager.cIntroScreen.sequenceCurrent = 99999.0;        //Skip intro
                cManager.cIntroScreen.dispType = 2;                     //
            }
        }
        if(dispType == 2){
            isActive = false;   //Can click out of credits
        }
    }
    void outroScreen_mouseReleased(){
        //pass
    }

    ArrayList<String> generateStoryLog(){
        ArrayList<String> newStoryLog = new ArrayList<String>();
        if(isTimeEnding()){
            String line1 = "Your ship is scheduled to move. Records of your total profit ";
            String line2 = "are made and forwarded to the company. An efficiency report ";
            String line3 = "is constructed to evaluate your worth at the company. If you ";
            String line4 = "are lucky a new salvage operation will be made available. ";
            newStoryLog.add(line1);newStoryLog.add(line2);newStoryLog.add(line3);newStoryLog.add(line4);
        }
        else if(isAlienEnding()){
            String line1 = "After losing multiple outposts to the alien forces you are ";
            String line2 = "deemed incapable of effective salvaging and removed from your ";
            String line3 = "position immediately. A report is made to evaluate the work ";
            String line4 = "conducted so far. All profits will be claimed by the company ";
            String line5 = "to cover damages. ";
            newStoryLog.add(line1);newStoryLog.add(line2);newStoryLog.add(line3);newStoryLog.add(line4);newStoryLog.add(line5);
        }
        else if(isMoneyEnding()){
            String line1 = "With all your money gone, the company ";
            String line2 = "repossesses your ship to cover costs. ";
            String line3 = "You are removed from your role, effective immediately.";
            newStoryLog.add(line1);newStoryLog.add(line2);newStoryLog.add(line3);
        }
        else{
            String line1 = "I'm not sure how you got here";
            newStoryLog.add(line1);
        }
        return newStoryLog;
    }
    float calcTotalWealth_acquired(stockRecords cStockRecords){
        /*
        Values all money and stock you own (at stock rates EVOLVED MULTIPLE TIMES) -> less predicatable => more risky
        */
        float totalValue = 0.0;
        //Money
        totalValue += cStockRecords.moneyOwned;
        //Stocks
        totalValue += cStockRecords.calcPositiveCost(cStockRecords.ship_inventory);
        return totalValue;
    }
    float calcTotalWealth_remaining(solarMap cSolarMap, stockRecords cStockRecords){
        /*
        Values all ore remaining (at current stock rate)
        */
        float totalValue = 0.0;
        for(int i=0; i<cSolarMap.spaceBodies.size(); i++){
            totalValue += cSolarMap.spaceBodies.get(i).calcRemainingWealth(cStockRecords);}
        return totalValue;
    }
}