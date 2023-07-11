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

    float mass = 5.0*pow(10,3);                 //In Kg, estimate
    PVector scanDim = new PVector(5.0, 5.0);    //In AU, width and height of box -> for temp and minerals

    int dataType = 4;   //Which data type the sensor will record when engaged (for this probe); Default is distance

    probe(PVector pos, PVector vel, PVector acc){
        this.pos = pos;
        this.vel = vel;
        this.acc = acc;
    }

    //Solar map will handle drawing this in relation to other planets
    void calcDynamics(){
        calcAcc();
        calcVel();
        calcPos();
    }
    void calcAcc(){
        //####
        //## MAY NEED TO USE LOGARITHMIC CALCS
        //####
        PVector force = new PVector(0,0);
        
        //Sum forces
        //...

        acc.x = force.x/mass;
        acc.y = force.y/mass;
    }
    void calcVel(){
        vel.x += acc.x;
        vel.y += acc.y;
    }
    void calcPos(){
        pos.x += vel.x;
        pos.y += vel.y;
    }
}