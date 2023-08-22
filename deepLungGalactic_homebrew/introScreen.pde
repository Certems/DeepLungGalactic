class introScreen{
    /*
    Holds information about how the game should start
    This includes timings of showing opening [explanations] to the game, [credits] for assests used 
    and other details required

    It is shown every time the game is launched
    Assets are loaded during this section whilst showing a 'guide' to the player as to how the 
    game works

    Disp type works as such;
    0                      => display nothing new
    +ve Integer            => display that screen
    -ve Integer [2 digits] => tranistion from 1st to 2nd digit
    ==> Limited to have a max of 9 screens
    */
    boolean isActive = true;

    int dispType = 1;

    float transitionCurrent = 0.0;  //This will be reset once a transition is done, and only every incremented when transitioning
    float sequenceCurrent = 0.0;

    introScreen(){
        sequenceCurrent = 0.0;  //Just not needed, but a good meme
    }

    void display(){
        display_background();
        if(dispType == 1){
            display_screen_1();}
        if(dispType == 2){
            display_screen_2();}
        //...
        
        if(dispType == -12){
            transition_1to2();}
        if(dispType == -21){
            //pass
        }
        //...
    }
    void display_background(){
        pushStyle();
        background(30,30,30);
        popStyle();
    }
    void display_screen_1(){
        display_companyCallout();
        //...
    }
    void display_companyCallout(){
        pushStyle();
        imageMode(CENTER);
        image(texture_general_companySymbol, width/2.0, height/2.0);
        popStyle();
    }

    void display_screen_2(){
        display_instructions();
        //display_loadingStatus();
        //display_continueBox();
        //...
    }
    void display_instructions(){
        pushStyle();
        imageMode(CORNER);
        image(texture_manual_screen, 0, 0);
        popStyle();
    }
    void display_loadingStatus(){
        pushStyle();

        fill(200,200,200);
        rectMode(CORNER);
        rect(width*0.05, width*0.05, width*0.15, height*0.15);

        popStyle();
    }
    void display_continueBox(){
        pushStyle();

        fill(200,200,200);
        rectMode(CORNER);
        rect(width*0.8, height*0.8, width*0.15, height*0.15);

        popStyle();
    }
    void transition_1to2(){
        /*
        Call this function for the full duration of its transition
        */
        //Init
        transitionCurrent++;
        float trans_length = 60.0*5.0;
        //Main
        if(transitionCurrent <= trans_length/2.0){
            display_screen_1();}
        else{
            display_screen_2();}
        //Fade
        pushStyle();
        float ratio = (sin( 2.0*PI*(transitionCurrent / trans_length) -PI/2.0) +1.0)/2.0;
        fill(0,0,0, 255.0*ratio);
        noStroke();
        rectMode(CORNER);
        rect(0,0, width, height);
        popStyle();
        //Reset
        if(transitionCurrent >= trans_length){
            transitionCurrent = 0.0;}
    }

    
    void calc(){
        calc_std_sequence();
    }
    void calc_std_sequence(){
        int company_start     = 0;
        int trans_1to2_start  = company_start +60*2;
        int trans_1to2_length = 60*5;
        int instruct_start    = trans_1to2_start +trans_1to2_length;
        //println("---");
        //println("seqCurr  -> ",sequenceCurrent);
        //println("dispType -> ",dispType);
        if(sequenceCurrent <= instruct_start){
            sequenceCurrent++;
            //Last
            if(sequenceCurrent >= instruct_start){
                dispType = 2;}
            else if(sequenceCurrent >= trans_1to2_start){
                dispType = -12;}
            else{
                dispType = 1;}
            //First
        }
    }


    void introScreen_mousePressed(){
        if(dispType == 2){
            sound_general_gameStart.play();
            isActive = false;}      //## MAYBE ADD SOME FADE ##
    }
    void introScreen_mouseReleased(){
        //pass
    }
}