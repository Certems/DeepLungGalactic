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
        if(cManager.cStockRecords.invIndOffset >= cManager.cStockRecords.ship_inventory.size()){
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
    if(key == 'q'){
        println("Adding staged item q 5.0 ...");
        cManager.cStockRecords.staged_items.get(0).quantity += 5.0;
    }
    if(key == 'w'){
        println("Evolving stock prices...");
        cManager.cStockRecords.stockExchange_evolvePrice();
    }
    if(key == 'e'){
        println("Creating outpost...");
        spaceBody linkedSpaceBody = cManager.cSolarMap.spaceBodies.get(0);
        float theta = 0.0;
        outpost newOutpost = new outpost(new PVector(linkedSpaceBody.radius*cos(theta), linkedSpaceBody.radius*sin(theta)), linkedSpaceBody);
        cManager.cSolarMap.outposts.add(newOutpost);
    }
    if(key == 'r'){
        println("Calculating drill targets...");
        cManager.cSolarMap.outposts.get(0).calcDrillTargets();
    }
    if(key == 't'){
        println("Outpost is [Drilling]...");
        cManager.cSolarMap.outposts.get(0).drillStep();
    }
    if(key == 'a'){
        println("Scaling DOWN cartoMap...");
        cManager.cToolArray.cartoMap.visibleScale -= 0.1;
    }
    if(key == 's'){
        println("Scaling UP cartoMap...");
        cManager.cToolArray.cartoMap.visibleScale += 0.1;
    }
    if(key == 'h'){
        println("Moving cartoMap LEFT...");
        cManager.cToolArray.cartoMap.visiblePos.x -= 0.5;
    }
    if(key == 'j'){
        println("Moving cartoMap UP...");
        cManager.cToolArray.cartoMap.visiblePos.y += 0.5;
    }
    if(key == 'k'){
        println("Moving cartoMap RIGHT...");
        cManager.cToolArray.cartoMap.visiblePos.x += 0.5;
    }
    if(key == 'm'){
        println("Moving cartoMap DOWN...");
        cManager.cToolArray.cartoMap.visiblePos.y -= 0.5;
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
. Change to     Gray Blue   or smthing like that
                Blue Gray
. Normalise all naming conventions
. Do music for radio + background humming -> hotline miami style
.##### MAYBE CONVERT THE DISTANCE LINE SENSOR TO AN ASCII VERSION ###########
. Special caches floating in space that create beeping sounds -> offer cool rewards, hard to find --> [Skins maybe]
. ...

1. Generate bodies of random size
2. From this, assign a title (planet, asteroid, etc)
3. Assign special qualities (temperature, aliens, etc)






FINISH OFF CARTOGRAPHY SECTION
-> AXIS
-> ZOOM MODE

*/