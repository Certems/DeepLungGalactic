class interactable{
    /*
    An object that records position that are clicked within its bounds

    On click, it is checked (if visible) to see where mouse coords are

    Some examples of its uses are;
    Angular selector -> circular plate that remembers 1 position
    Slider selector  -> Rectangle that remembers 1 position
    */
    Boolean isVisible = false;

    PVector point_1 = new PVector(0,0);    //All points relative to the draw position given (centre position given)
    PVector point_2 = new PVector(0,0);    //
    String type;

    interactable(String type){
        this.type = type;
    }

    void display(PVector pos, PVector dim){
        if(type == "angSelector"){
            display_angSelector(pos, dim);
        }
        if(type == "slider"){
            display_slider(pos, dim);
        }
        //...
    }
    void display_angSelector(PVector pos, PVector dim){
        /*
        Point 1 = clicked position
        */
        pushStyle();
        //Outer circle
        noFill();
        stroke(180, 180, 180);
        strokeWeight(4);
        ellipse(pos.x, pos.y, dim.x, dim.y);

        //Centre
        float centreDiam = max(10.0, dim.x/20.0);
        fill(250,250,250);
        noStroke();
        ellipse(pos.x, pos.y, centreDiam, centreDiam);

        //Req. points
        float point_1_diam = max(6.0, dim.x/30.0);
        noFill();
        stroke(242, 245, 66);
        strokeWeight(3);
        ellipse(point_1.x, point_1.y, point_1_diam, point_1_diam);
        popStyle();
    }
    void display_slider(PVector pos, PVector dim){
        /*
        pos = Top-Left corner
        dim = full widht and height
        */
        pushStyle();
        rectMode(CORNER);

        //Background
        fill(80,80,80);
        stroke(40,40,40);
        strokeWeight(3);
        rect(pos.x, pos.y, dim.x, dim.y);

        //Axis
        //... Maybe Include
        
        //Point
        fill(220,220,220);
        noStroke();
        ellipse(point_1.x, point_1.y +dim.y/2.0, 0.7*dim.y, 0.7*dim.y);
        popStyle();
    }
    void findClickPoints(PVector pos, PVector dim){
        if(isVisible){
            if(type == "angSelector"){
                findClickPoints_angSelector(pos, dim);}
            if(type == "slider"){
                findClickPoints_slider(pos, dim);}
        }
    }
    void findClickPoints_angSelector(PVector pos, PVector dim){
        println("Clicking angSelector...");
        float dist = vec_mag(vec_dir(pos, new PVector(mouseX, mouseY)));
        boolean withinRadius = dist < dim.x/2.0;
        if(withinRadius){
            point_1 = new PVector(mouseX, mouseY);
        }
    }
    void findClickPoints_slider(PVector pos, PVector dim){
        println("Clicking slider...");
        boolean withinX = (pos.x <= mouseX) && (mouseX < pos.x +dim.x);
        boolean withinY = (pos.y <= mouseY) && (mouseY < pos.y +dim.y);
        if(withinX && withinY){
            point_1 = new PVector(mouseX, pos.y);
        }
    }

    //AngSelector specific
    float getTheta(PVector pos){
        /*
        Returns the angle the point chosen makes with the centre
        */
        return findAngle(point_1, pos);
    }
    float getSpeed(PVector pos, PVector dim){
        /*
        Returns the speed the probe will be fired at
        Based on the distance of the point from the centre
        */
        float speedMax = 0.01;                          //In AU frame^-1
        float dist     = vec_mag(vec_dir(pos, point_1));
        float ratio    = (dist)/(dim.x/2.0);
        return speedMax*ratio;
    }

    //Slider specific
    float findPercentage(PVector pos, PVector dim){
        /*
        Returns the percentage of the way the point is through the slider, which 
        can be used to assign cts. values
        */
        return (point_1.x -pos.x) / (dim.x);
    }
}