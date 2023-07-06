class solarMap{
    /*
    Holds all information about the solar system your are surveying, that being celestial 
    body positions and parameters, probes present

    MapRadius will be in terms of AU
    */
    ArrayList<probe> probes = new ArrayList<probe>();
    ArrayList<spaceBody> spaceBodies = new ArrayList<spaceBody>();

    float mapRadius;    //In AU
    float AuToPixelSF;
    float PixelToAuSF;

    solarMap(float mapRadius){
        this.mapRadius = mapRadius;
        AuToPixelSF = ( min(width, height)/2.0 ) / (mapRadius); //So the solar system takes up the whole screen, only for displaying; All calculations left in NON-PIXEL units
        PixelToAuSF = 1.0/AuToPixelSF;
        generateSpaceBodies(20);
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
        display_probes(displayPos);
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
    void display_probes(PVector displayPos){
        for(int i=0; i<probes.size(); i++){
            display_probe(displayPos, probes.get(i));
        }
    }
    void display_spaceBody(PVector displayPos, spaceBody cBody){
        pushStyle();
        fill(255,255,255);
        noStroke();
        ellipse(displayPos.x +cBody.pos.x*AuToPixelSF, displayPos.y +cBody.pos.y*AuToPixelSF, 2.0*cBody.radius*AuToPixelSF, 2.0*cBody.radius*AuToPixelSF);
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
        float shipSafeZone = 2.5*maxRad;    //Ensure no planets spawn over the top of your ship
        for(int i=0; i<bodyNumber; i++){
            float spawnTheta = random(0.0, 2.0*PI);
            float spawnDist  = random(shipSafeZone, mapRadius-1.2*maxRad);
            spaceBody newBody = new spaceBody( new PVector(spawnDist*cos(spawnTheta), spawnDist*sin(spawnTheta)), new PVector(0,0), new PVector(0,0), random(minRad, maxRad), 0.0);
            spaceBodies.add(newBody);
        }
    }
}