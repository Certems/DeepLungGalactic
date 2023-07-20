manager cManager;
mineralDictionary mineralDict;

void setup(){
    size(800,500);

    cManager = new manager();
    initMineralDict();
}
void draw(){
    cManager.display();
    cManager.calc();
}
void keyPressed(){
    if(key == '1'){
        println("Fired probe (AND generate new cells)...");
        cManager.cFlightControls.launchProbe(cManager.cSolarMap.probes, new PVector(0,0), random(0.0, 2.0*PI), random(0.001, 0.02));
    }
    if(key == '2'){
        println("Increment offsetInd AND generate new cells...");
        cManager.cFlightControls.probeSetIndOffset++;
        if(cManager.cFlightControls.probeSetIndOffset >= cManager.cSolarMap.probes.size()){
            cManager.cFlightControls.probeSetIndOffset = 0;}
        cManager.cFlightControls.generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
        cManager.cFlightControls.loadButtons_screen_selection();
    }
    if(key == '3'){
        println("generate new cells...");
        cManager.cFlightControls.generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
    }
    if(key == '4'){
        println("loading flight AND tool AND stocks sel buttons...");
        cManager.cFlightControls.generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
        cManager.cFlightControls.loadButtons_screen_selection();
        cManager.cToolArray.loadButtons_screen_selection();
        cManager.cStockRecords.loadButtons_screen_selection();
    }
    if(key == '5'){
        cManager.cSensorArray.recordReadings_distance(cManager.cSolarMap, cManager.cSolarMap.probes.get(0));
    }
    if(key == '6'){
        cManager.cSensorArray.sensorZoom -= 0.1;
    }
    if(key == '7'){
        cManager.cSensorArray.sensorZoom += 0.1;
    }
    if(key == '8'){
        println("Increment offsetInd AND generate new cells...");
        cManager.cStockRecords.invIndOffset++;
        if(cManager.cStockRecords.invIndOffset >= cManager.cStockRecords.shipInventory.size()){
            cManager.cStockRecords.invIndOffset = 0;}
        cManager.cStockRecords.loadButtons_screen_selection();
    }
    if(key == '9'){
        println("Destroy 0th probe...");
        cManager.cSolarMap.destroyProbe( cManager.cSolarMap.probes.get(0) );
        cManager.cFlightControls.generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
        cManager.cFlightControls.loadButtons_screen_selection();
    }
    if(key == '0'){
        println("Dismiss 0th destr. probe...");
        cManager.cSolarMap.dismissProbe( cManager.cSolarMap.destroyed_probes.get(0) );
        cManager.cFlightControls.generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
        cManager.cFlightControls.loadButtons_screen_selection();
    }
}
void mousePressed(){
    cManager.manager_mousePressed();
}
void mouseReleased(){
    cManager.manager_mouseReleased();
}

/*
Notes & TODO;
. Scroller as a rect under the sections with an arrow pointing down --> HOWEVER MAY MEAN FINGERS GET IN THE WAY
. Analogue displays, tick every X seconds for refresh rate
. Compose-esc displays -> only redraw if needed
. 2.0 * RADIUS FOR ELLIPSES
. Remove overlapping planets when spawned
. Change to     Gray Blue   or smthing like that
                Blue Gray
. Normalise all naming conventions
. Have buttons all correctly placed
. Do music for radio + background humming -> hotline miami style
. Do minerals for planets
. Landing + mining mechanics
.##### MAYBE CONVERT THE DISTANCE LINE SENSOR TO AN ASCII VERSION ###########
.    Have stock items be split in 3 sections {| BUY |  SEE GRAPH  | SELL |}
.    Have running total of what is ADDED to total and what is TAKEN from total before confirming a purchase
. Special caches floating in space that create beeping sounds -> offer cool rewards, hard to find --> [Skins maybe]
. ...

1. Generate bodies of random size
2. From this, assign a title (planet, asteroid, etc)
3. Assign special qualities (temperature, aliens, etc)

*/