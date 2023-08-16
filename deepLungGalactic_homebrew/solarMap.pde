float fullMapRadius = 40.0;

class solarMap{
    /*
    Holds all information about the solar system your are surveying, that being celestial 
    body positions and parameters, probes present

    MapRadius will be in terms of AU
    */
    ArrayList<probe> probes           = new ArrayList<probe>();
    ArrayList<probe> destroyed_probes = new ArrayList<probe>();
    ArrayList<outpost> outposts           = new ArrayList<outpost>();
    ArrayList<outpost> destroyed_outposts = new ArrayList<outpost>();
    ArrayList<spaceBody> spaceBodies  = new ArrayList<spaceBody>();

    float mapRadius;    //In AU
    float AuToPixelSF;
    float PixelToAuSF;

    float temp_noiseRange = 400;   //Kelvin temperature range from sensor imperfections
    float temp_maxValue   = 4000;  //Largest value (in kelvin) the sensor can detect (when it maxes to 1.0)

    solarMap(float mapRadius){
        this.mapRadius = mapRadius;
        AuToPixelSF = ( min(width, height)/2.0 ) / (mapRadius); //So the solar system takes up the whole screen, only for displaying; All calculations left in NON-PIXEL units
        PixelToAuSF = 1.0/AuToPixelSF;
        generateSpaceBodies(20);
    }

    void calc(){
        calcOutposts();
        calcProbes();
        calcTimer(cManager.cOutroScreen);
        calcStockRates();
        calcGameEnd();
    }
    void calcStockRates(){
        if(floor(cManager.cOutroScreen.timer) % (10*60) == 0){
            cManager.cStockRecords.stockExchange_evolvePrice();
        }
    }
    void calcOutposts(){
        calcOutpostDrilling();
        if(floor(cManager.cOutroScreen.timer) % (2*60) == 0){
            calcOutpost_aliens();
            calcOutpost_destruction();}
        if(floor(cManager.cOutroScreen.timer) % (3*60) == 0){
            calcNestDrilling();}
    }
    void calcOutpost_aliens(){
        for(int i=0; i<outposts.size(); i++){
            outposts.get(i).calcAlienAttack();
        }
    }
    void calcNestDrilling(){
        for(int i=0; i<outposts.size(); i++){
            outposts.get(i).updateNestsDrilled();
        }
    }
    void calcOutpost_destruction(){
        for(int i=0; i<outposts.size(); i++){
            outposts.get(i).calcDestruction(this);
        }
    }
    void calcOutpostDrilling(){
        for(int i=0; i<outposts.size(); i++){
            outposts.get(i).calcDrilling();
        }
    }
    void calcProbes(){
        calc_probeMotion(probes);
    }
    void calc_probeMotion(ArrayList<probe> probes){
        //## SHOULD PROBABLY DO ALL POSITION CHANGES AT THE END, BUT FOR PROBES IS LARGELY IRRELEVENT AS THEY ARE TINY
        for(int i=0; i<probes.size(); i++){
            probes.get(i).calcDynamics(this);
            probes.get(i).checkForLanding(this);    //## MAKE EVERY X FRAMES TO REDUCE LAG ##
        }
    }
    void calcTimer(outroScreen cOutroScreen){
        cOutroScreen.timer++;
    }
    void calcGameEnd(){
        int checkInterval = 2*60;   //2 Seconds
        if(floor(cManager.cOutroScreen.timer) % checkInterval == 0){
            cManager.cOutroScreen.isActive = cManager.cOutroScreen.isGameEnd();
        }
    }

    void display(PVector displayPos){
        /*
        See the solar map, mostly for bug fixing
        -> Possibly for a reveal once the game is finished to showcase
            what was discovered/ignore/correctly identified
        */
        display_mapZone(displayPos);
        display_ship(displayPos);
        display_spaceBodies(displayPos);
        display_outposts(displayPos);
        display_probes(displayPos);

        //spaceBodies.get(0).displayMineralProfile();   //##BUG FIXING PLANET MINERALS DISPLAY
    }
    void display_mapZone(PVector displayPos){
        pushStyle();
        stroke(255,255,255);
        strokeWeight(3);
        noFill();
        ellipse(displayPos.x, displayPos.y, 2.0*mapRadius*AuToPixelSF, 2.0*mapRadius*AuToPixelSF);
        popStyle();
    }
    void display_ship(PVector displayPos){
        pushStyle();
        rectMode(CENTER);
        fill(255,30,30);
        noStroke();
        rect(displayPos.x, displayPos.y, 1.0*AuToPixelSF, 1.0*AuToPixelSF);
        popStyle();
    }
    void display_spaceBodies(PVector displayPos){
        for(int i=0; i<spaceBodies.size(); i++){
            display_spaceBody(displayPos, spaceBodies.get(i));
        }
    }
    void display_outposts(PVector displayPos){
        for(int i=0; i<outposts.size(); i++){
            display_outpost(displayPos, outposts.get(i));
        }
    }
    void display_probes(PVector displayPos){
        for(int i=0; i<probes.size(); i++){
            display_probe(displayPos, probes.get(i));
            display_probeScanZone(displayPos, probes.get(i));
        }
    }
    void display_probeScanZone(PVector displayPos, probe cBody){
        pushStyle();
        stroke(255,0,0);
        strokeWeight(3);
        noFill();
        rectMode(CORNER);
        rect(displayPos.x +(cBody.pos.x -cBody.scanDim.x/2.0)*AuToPixelSF, displayPos.y +(cBody.pos.y -cBody.scanDim.y/2.0)*AuToPixelSF, cBody.scanDim.x*AuToPixelSF, cBody.scanDim.y*AuToPixelSF);
        popStyle();
    }
    void display_spaceBody(PVector displayPos, spaceBody cBody){
        pushStyle();
        fill(255,255,255);
        noStroke();
        ellipse(displayPos.x +cBody.pos.x*AuToPixelSF, displayPos.y +cBody.pos.y*AuToPixelSF, 2.0*cBody.radius*AuToPixelSF, 2.0*cBody.radius*AuToPixelSF);
        popStyle();
    }
    void display_outpost(PVector displayPos, outpost cBody){
        pushStyle();
        fill(250, 240, 0);
        noStroke();
        ellipse(displayPos.x +cBody.getRealPos().x*AuToPixelSF, displayPos.y +cBody.getRealPos().y*AuToPixelSF, 10, 10);
        popStyle();
    }
    void display_probe(PVector displayPos, probe cBody){
        pushStyle();
        fill(40,20,255);
        noStroke();
        ellipse(displayPos.x +cBody.pos.x*AuToPixelSF, displayPos.y +cBody.pos.y*AuToPixelSF, 1.0*AuToPixelSF, 1.0*AuToPixelSF);    //Probe too small, so just show a marker of size 1
        popStyle();
    }
    void generateSpaceBodies(int bodyNumber){
        float maxRad = mapRadius/18.0;       //** Manual approx. guesses, in AU
        float minRad = mapRadius/120.0;      //
        float shipSafeZone = 2.5*maxRad;     //Ensure no planets spawn over the top of your ship
        for(int i=0; i<bodyNumber; i++){
            float spawnTheta = random(0.0, 2.0*PI);
            float spawnDist  = random(shipSafeZone, mapRadius-1.2*maxRad);
            spaceBody newBody = new spaceBody( new PVector(spawnDist*cos(spawnTheta), spawnDist*sin(spawnTheta)), new PVector(0,0), new PVector(0,0), random(minRad, maxRad), 0.0);
            spaceBodies.add(newBody);
        }
        //Remove overlapping planets
        int removedNumber = removeSpaceBodyOverlaps();
        //Generate new planets
        //println("Bodies removed -> ",removedNumber);
        if(removedNumber > 0){
            generateSpaceBodies(removedNumber);}
    }
    int removeSpaceBodyOverlaps(){
        /*
        1. Go through each body
        2. Check if it collides with any other body (but not itself)
        3.      If it does collide, remove the original
        */
        int totalRemoved = 0;
        //1
        for(int j=spaceBodies.size()-1; j>=0; j--){
            //2
            for(int i=0; i<spaceBodies.size(); i++){
                float bodySafetyFactor = 1.5;   //**SF on BOTH planet radi used to make sure planets are not overlapping +some change
                if(i != j){
                    if( checkCircleCircleCollision( spaceBodies.get(j).pos, spaceBodies.get(j).radius*bodySafetyFactor, spaceBodies.get(i).pos, spaceBodies.get(i).radius*bodySafetyFactor ) ){
                        //3
                        totalRemoved++;
                        spaceBodies.remove(j);
                        break;
                    }
                }
            }
        }
        return totalRemoved;
    }

    void destroyProbe(probe cProbe){
        for(int i=0; i<probes.size(); i++){
            if(probes.get(i).ID == cProbe.ID){
                sound_flight_probe_destroyed.play();
                probes.get(i).statusCol = inactiveCol;
                destroyed_probes.add( probes.get(i) );
                probes.remove(i);
            }
        }
        //## MAYBE GENERATE DISP CELLS HERE IF IS A PROBLEM ##
    }
    void dismissProbe(probe cProbe){
        for(int i=0; i<destroyed_probes.size(); i++){
            if(destroyed_probes.get(i).ID == cProbe.ID){
                destroyed_probes.remove(i);
            }
        }
        //## MAYBE GENERATE DISP CELLS HERE IF IS A PROBLEM ##
    }
    void destroyOutpost(outpost cOutpost){
        for(int i=0; i<outposts.size(); i++){
            if(outposts.get(i).ID == cOutpost.ID){
                sound_flight_probe_destroyed.play();    //## MAY WANT AN OUTPOST ONE TOO ##
                outposts.get(i).statusCol = inactiveCol;
                destroyed_outposts.add( outposts.get(i) );
                outposts.remove(i);
                cManager.cOutroScreen.outpostsDestroyed++;  //**For end game condition
            }
        }
        //## MAYBE GENERATE DISP CELLS HERE IF IS A PROBLEM ##
    }
    void dismissOutpost(outpost cOutpost){
        for(int i=0; i<destroyed_outposts.size(); i++){
            if(destroyed_outposts.get(i).ID == cOutpost.ID){
                destroyed_outposts.remove(i);
            }
        }
        //## MAYBE GENERATE DISP CELLS HERE IF IS A PROBLEM ##
    }

    PVector calcGravity(PVector point){
        /*
        Calculates the gravity from all planets summed
        */
        PVector force = new PVector(0,0);
        for(int i=0; i<spaceBodies.size(); i++){
            PVector indiv_force = spaceBodies.get(i).calcGravity(point);
            force.x += indiv_force.x;
            force.y += indiv_force.y;
        }
        return force;
    }
}