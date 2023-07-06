class spaceBody{
    /*
    Planets, comets, asteroids, etc that can be encountered
    Probes are NOT considered spaceBodies
    Most spaceBodies will have very small rotations that should be kept track of by the 
    player (through repeated sensor readings) to ensure drilling occurs where expected
    *All bodies are circular (as of the current state of the game)
    */
    PVector pos;
    PVector vel;
    PVector acc;

    float radius;
    float angMomentum;

    spaceBody(PVector pos, PVector vel, PVector acc, float radius, float angMomentum){
        this.pos = pos;
        this.vel = vel;
        this.acc = acc;
        this.radius = radius;
        this.angMomentum = angMomentum;
    }

    boolean isCollidingWithBody(PVector point, float relief){
        /*
        Checks if a point is within the circular zone of this celestial body
        Used for collision
        "relief" is the radius around the point that will also trigger a collision
        ##############################################
        ## MAY HAVE PROBLEMS WITH LOGARITHMIC MATHS ##
        ##############################################
        */
        float dist = vec_mag(vec_dir(point, pos));
        return ( dist <= (radius+relief) );
    }
}