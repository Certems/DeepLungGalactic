class probe{
    /*
    A device launched from your ship that provides insights into the 
    environment through its various sensors onboard.
    All data it collects is instantly reported back to the ship
    */
    int ID = floor(random(1000000,9999999));
    PVector pos;
    PVector vel;
    PVector acc;
    PVector statusCol = activeCol;  //Colour of status icon

    float mass       = 5.0*pow(10,3);           //In Kg, estimate
    PVector scanDim  = new PVector(5.0, 5.0);   //In AU, width and height of box -> for temp and minerals
    float landingVel = 9999;                    //Maximum velocity for which the probe will not crash when landing
    float fuel = 1.0;                           //Percentage of fuel remaining

    float thrustPower = 5.0*pow(10, -2);

    boolean thrustingFwd = false;
    boolean thrustingBck = false;

    int dataType = 4;   //Which data type the sensor will record when engaged (for this probe); Default is distance

    probe(PVector pos, PVector vel, PVector acc){
        this.pos = pos;
        this.vel = vel;
        this.acc = acc;
    }

    //Solar map will handle drawing this in relation to other planets
    void calcDynamics(solarMap cSolarMap){
        calcAcc(cSolarMap);
        calcVel();
        calcPos();
    }
    void calcAcc(solarMap cSolarMap){
        //####
        //## MAY NEED TO USE LOGARITHMIC CALCS
        //####
        PVector force = new PVector(0,0);

        //Gravity
        PVector specificGravity = cSolarMap.calcGravity(pos);
        PVector gravity = new PVector(specificGravity.x*mass, specificGravity.y*mass);
        force.x += gravity.x;
        force.y += gravity.y;

        //Thrust (From Engines)
        if(fuel > 0.0){
            PVector thrustDir = vec_unitVec(vel);
            if(thrustingFwd){
                force.x += thrustPower*thrustDir.x;
                force.y += thrustPower*thrustDir.y;
                fuel -= 0.001;}
            if(thrustingBck){
                force.x += thrustPower*(-thrustDir.x);  //Not actually thrustDir, is opposite direction (but this is more concise having -ve after)
                force.y += thrustPower*(-thrustDir.y);
                fuel -= 0.001;}
        }

        //...

        //**If other forces are later included, make sure to /mass and *mass in gravity force --> [as can be seen now]
        acc.x = force.x/mass;    //** Note this is for good reason;
        acc.y = force.y/mass;    //Force = calcGravity*mass   =>   acc = calcGravity*mass / mass = calcGravity (= force)
    }
    void calcVel(){
        vel.x += acc.x;
        vel.y += acc.y;
    }
    void calcPos(){
        pos.x += vel.x;
        pos.y += vel.y;
    }
    void checkForLanding(solarMap cSolarMap){
        /*
        Looks through all spaceBodies
        If this probe is inside or at the edge of the body, land on its surface at the nearest edge point
        ####################################################################
        ## BEAR IN MIND THIS WILL NEED TO ACCOUNT FOR PLANET ROTATING TOO ## -> do relative pos, where ALL ROTS occur AFTER
        ####################################################################

        1. Check all bodies
        2. If within their bounding box +margin, then check actual distance
        3. If close enough, set its pos to [dir*radius] -> dir is from centre to probe
        4.   Change its type to an 'outpost'
        5. Determine if the landing is crash landing -> whether outpost spawns or not when probe is destroyed
        */
        //1
        for(int i=0; i<cSolarMap.spaceBodies.size(); i++){
            //2
            boolean withinX = (cSolarMap.spaceBodies.get(i).pos.x -cSolarMap.spaceBodies.get(i).radius <= pos.x) && (pos.x < cSolarMap.spaceBodies.get(i).pos.x +cSolarMap.spaceBodies.get(i).radius);
            boolean withinY = (cSolarMap.spaceBodies.get(i).pos.y -cSolarMap.spaceBodies.get(i).radius <= pos.y) && (pos.y < cSolarMap.spaceBodies.get(i).pos.y +cSolarMap.spaceBodies.get(i).radius);
            if(withinX && withinY){
                //3
                PVector dir = vec_dir(cSolarMap.spaceBodies.get(i).pos, pos);
                float dist  = vec_mag(dir);
                if(dist <= cSolarMap.spaceBodies.get(i).radius){
                    //4 & 5
                    cSolarMap.destroyProbe(this);
                    cManager.cFlightControls.generateCellSet(cManager.cSolarMap.probes, cManager.cSolarMap.destroyed_probes, cManager.cSolarMap.outposts, cManager.cSolarMap.destroyed_outposts);
                    float speed = vec_mag(vel);
                    if(speed <= landingVel){
                        PVector landingPos = new PVector( cSolarMap.spaceBodies.get(i).radius*(dir.x/dist), cSolarMap.spaceBodies.get(i).radius*(dir.y/dist) );
                        outpost newOutpost = new outpost(landingPos, cSolarMap.spaceBodies.get(i));
                        cSolarMap.outposts.add(newOutpost);
                    }
                }
            }
        }
    }
}