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

/*
For temperature maps, store as functions somehow;
Could store as [blank small + small noise everywhere]
PLUS [Set of nodesthat emit heat] -> Likely formed around stars or small ones around planets
   -> These nodes could then sway and move to give variation to sensor readings
 -> Planets can store their own temperature that is also added to these values
-> MAYBE imprint all together into a final snapshot Array when a reading is taken

Mineral readings held entirely by planet
    Use functions to generate mineral distrobution
    -> Numbers from 0.0 to 1.0, bin to determine material
        ->0.0 => more common, 1.0 => less common
    Maybe store the lines that were mined out, So the minerals can be ignored when scanned (within a given radius)
    -> Will only marginally slow down display of the given planet => good
*/