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

        //Sum forces
        PVector force = cSolarMap.calcGravity(pos);

        //**If other forces are later included, make sure to /mass and *mass in gravity force
        acc.x = force.x;    //** Note this is for good reason;
        acc.y = force.y;    //Force = calcGravity*mass   =>   acc = calcGravity*mass / mass = calcGravity (= force)
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