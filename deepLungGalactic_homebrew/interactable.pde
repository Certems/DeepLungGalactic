class interactable{
    /*
    More diverse button type
    Remembers inputs (e.g button press, release coords)
    */
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
        ellipse(pos.x +point_1.x, pos.y +point_1.y, point_1_diam, point_1_diam);
        popStyle();
    }
}