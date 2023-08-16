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

    outroScreen(){
        score_dim     = new PVector(width/5.0, height/15.0);
        score_pos     = new PVector(height/25.0, height/25.0);
        analytics_dim = new PVector(score_dim.x, height/2.0);
        analytics_pos = new PVector(score_pos.x, score_pos.y +score_dim.y +height/25.0);
        story_dim     = new PVector(width/2.0, height/4.0);
        story_pos     = new PVector(width/2.0 -height/25.0, height/25.0);
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
            println("Game is over");
            return true;}
        else{
            println("Game NOT over");
            return false;}
    }
    void display(){
        display_background();
        display_graphic();
        display_score();
        display_analytics();
        display_story();
    }
    void display_background(){
        background(30,30,30);
    }
    void display_graphic(){
        pushStyle();

        fill(200,220,200,80);
        rectMode(CORNER);
        rect(0,0,width,height);

        popStyle();
    }
    void display_score(){
        pushStyle();

        fill(255,255,255);
        textAlign(CENTER, CENTER);
        textSize(score_dim.y/2.0);
        text(cManager.cStockRecords.moneyOwned, score_pos.x +score_dim.x/2.0, score_pos.y +score_dim.y/2.0);

        rectMode(CORNER);
        fill(100,100,150,50);
        rect(score_pos.x, score_pos.y, score_dim.x, score_dim.y);

        popStyle();
    }
    void display_analytics(){
        display_analytics_wealth();
        display_analytics_map();
    }
    void display_analytics_wealth(){
        pushStyle();

        rectMode(CORNER);
        fill(100,100,150);
        rect(analytics_pos.x, analytics_pos.y, analytics_dim.x, analytics_dim.y);

        popStyle();
    }
    void display_analytics_map(){
        //pass
    }
    void display_story(){
        pushStyle();

        rectMode(CORNER);
        fill(100,150,100,50);
        rect(story_pos.x, story_pos.y, story_dim.x, story_dim.y);

        float sizeOfText = story_dim.y/10.0;
        displayTextLog(generateStoryLog(), sizeOfText, new PVector(story_pos.x, story_pos.y +sizeOfText));

        popStyle();
    }

    void calc(){
        //pass
    }

    void outroScreen_mousePressed(){
        //pass
    }
    void outroScreen_mouseReleased(){
        //pass
    }

    ArrayList<String> generateStoryLog(){
        ArrayList<String> newStoryLog = new ArrayList<String>();
        if(isTimeEnding()){
            String line1 = "Your ship is scheduled to move. Records of the total profit ";
            String line2 = "are made and forwarded to the company. An efficiency report ";
            String line3 = "is later returned to your to assess your quality of work;";
            newStoryLog.add(line1);newStoryLog.add(line2);newStoryLog.add(line3);
        }
        else if(isAlienEnding()){
            String line1 = "After losing multiple outposts to the alien ";
            String line2 = "forces you are deemed incapable of continuing ";
            String line3 = "your role.";
            newStoryLog.add(line1);newStoryLog.add(line2);newStoryLog.add(line3);
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
}