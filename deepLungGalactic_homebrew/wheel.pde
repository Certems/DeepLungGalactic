class wheel{
    /*
    This is a base class, which extends to other more specific classes

    Each new specific wheel you want can just be formed as its own extension of this, where 
    it can then bespokely setup its own linked_wheel list

    The extended versions will then be used as required in the program
    */
    boolean active = false; //Whether to show the wheel or not, controlled by 'popWheel...' buttons

    ArrayList<wheel> linked_wheels = new ArrayList<wheel>();    //Allows a wheel to be recurrsive
    ArrayList<wheel_segment> segments = new ArrayList<wheel_segment>();

    int linked_disp = -1;   //Which wheel index to display; -1 = display this, n = display nth

    PVector pos;
    float radius;

    wheel(PVector pos, float radius){
        this.pos = pos;
        this.radius = radius;
        initialise();
    }

    void initialise(){
        //pass
    }
    void display(){
        boolean linkedInRange = (0 <= linked_disp) && (linked_disp < linked_wheels.size());
        boolean linkedOther   = (linked_disp != -1);
        if(linkedOther){
            if(linkedInRange){
                linked_wheels.get(linked_disp).display_wheel_body();
                linked_wheels.get(linked_disp).display_wheel_segmentDetails();
            }
        }
        else{
            display_wheel_body();
            display_wheel_segmentDetails();
        }
    }
    void display_wheel_body(){
        float thetaInterval = (2.0*PI) / segments.size();   //## COULD MOVE OUT
        pushStyle();
        
        //Background
        fill(80,80,80);
        ellipse(pos.x,pos.y, 100,100);
        noStroke();
        ellipse(pos.x, pos.y, 2.0*radius, 2.0*radius);
        
        noFill();
        stroke(180,180,180);
        strokeWeight(3);
        for(int i=0; i<segments.size(); i++){
            //Arc
            arc(pos.x, pos.y, 2.0*radius, 2.0*radius, i*thetaInterval, (i+1)*thetaInterval);    //Unnecessary but COULD add some extra customisation
            //Line
            line(pos.x, pos.y, pos.x +radius*cos(i*thetaInterval), pos.y +radius*sin(i*thetaInterval));
        }
        popStyle();
    }
    void display_wheel_segmentDetails(){
        float thetaInterval = (2.0*PI) / segments.size();   //## COULD MOVE OUT
        for(int i=0; i<segments.size(); i++){
            PVector segPos = calcSegmentPositon(i, thetaInterval);
            segments.get(i).display(segPos);
        }
    }
    PVector calcSegmentPositon(int segmentIndex, float thetaInterval){
        /*
        Calculates the position inside a segment where text and images should 
        originate from (a somewhat 'central' location)
        */
        float radFactor = 0.45*radius;
        PVector offset = new PVector(radFactor*cos(segmentIndex*thetaInterval +thetaInterval/2.0), radFactor*sin(segmentIndex*thetaInterval +thetaInterval/2.0));
        return new PVector(pos.x +offset.x, pos.y +offset.y);
    }
    ArrayList<button> getButtonSet(){
        /*
        Returns the buttonSet from the latest wheel
        */
        boolean finalLinkFound = false;     //These are both PRECAUTIONS
        int counter = 0;                    //
        int counterMax = 100;               //
        wheel cWheel = this;
        ArrayList<button> requiredButtonSet = null;
        while( (!finalLinkFound) && (counter<counterMax) ){
            if(cWheel.linked_disp == -1){
                //Have found the last link
                finalLinkFound = true;
                requiredButtonSet = cWheel.loadButtons();
                break;}
            if( (0 <= cWheel.linked_disp) && (cWheel.linked_disp < cWheel.linked_wheels.size()) ){
                //Move to the linked wheel
                cWheel = linked_wheels.get(cWheel.linked_disp);}
            counter++;
        }
        return requiredButtonSet;
    }
    void resetOrdering(){
        /*
        Resets linked_disps and active status
        */
        linked_disp = -1;
        active = false;
        for(int i=0; i<linked_wheels.size(); i++){
            linked_disp = -1;
            active = false;
            linked_wheels.get(i).resetOrdering();
        }
    }
    ArrayList<button> loadButtons(){
        //Is Overwritten
        return null;
    }
}
class cartography_main_wheel extends wheel{
    //pass

    cartography_main_wheel(PVector pos, float radius){
        super(pos, radius);
    }

    @Override
    void initialise(){
        //Wheels
        cartography_mode_wheel newLink1 = new cartography_mode_wheel(pos, radius);
        cartography_icon_wheel newLink2 = new cartography_icon_wheel(pos, radius);
        linked_wheels.add(newLink1);linked_wheels.add(newLink2);
        //Segments
        wheel_segment newSeg1 = new wheel_segment("Modes");
        wheel_segment newSeg2 = new wheel_segment("Icons");
        segments.add(newSeg1);segments.add(newSeg2);
        //Buttons
        loadButtons();
    }
    ArrayList<button> loadButtons(){
        ArrayList<button> buttonSet = new ArrayList<button>();
        button newButton0 = new button(pos, new PVector(2.0*radius, 2.0*radius), "arc", "wheel_cartography_goToMode");  //0th
        newButton0.relatedWheel = this;newButton0.thetaStart = 0.0;newButton0.thetaStop = PI;
        button newButton1 = new button(pos, new PVector(2.0*radius, 2.0*radius), "arc", "wheel_cartography_goToIcon");  //1st
        newButton1.relatedWheel = this;newButton1.thetaStart = PI;newButton1.thetaStop = 2.0*PI;
        buttonSet.add(newButton0);buttonSet.add(newButton1);
        return buttonSet;
    }
}
class cartography_mode_wheel extends wheel{
    //pass

    cartography_mode_wheel(PVector pos, float radius){
        super(pos, radius);
    }

    @Override
    void initialise(){
        //Wheels
        //...
        //Segments
        wheel_segment newSeg1 = new wheel_segment("Back");
        wheel_segment newSeg2 = new wheel_segment("Place");
        wheel_segment newSeg3 = new wheel_segment("Remove");
        wheel_segment newSeg4 = new wheel_segment("Zoom");
        segments.add(newSeg1);segments.add(newSeg2);segments.add(newSeg3);segments.add(newSeg4);
        //Buttons
        loadButtons();
    }
    @Override
    ArrayList<button> loadButtons(){
        ArrayList<button> buttonSet = new ArrayList<button>();
        ArrayList<String> buttonTitles = new ArrayList<String>();
        buttonTitles.add("wheel_cartography_mode_goBack");buttonTitles.add("wheel_cartography_mode_selectPlace");buttonTitles.add("wheel_cartography_mode_selectRemove");buttonTitles.add("wheel_cartography_mode_selectZoom");
        float thetaInterval = (2.0*PI)/segments.size();
        for(int i=0; i<segments.size(); i++){
            button newButton0 = new button(pos, new PVector(2.0*radius, 2.0*radius), "arc", buttonTitles.get(i));
            newButton0.relatedWheel = this;newButton0.thetaStart = i*thetaInterval;newButton0.thetaStop = (i+1)*thetaInterval;
            buttonSet.add(newButton0);
        }
        return buttonSet;
    }
}
class cartography_icon_wheel extends wheel{
    //pass

    cartography_icon_wheel(PVector pos, float radius){
        super(pos, radius);
    }

    @Override
    void initialise(){
        //Wheels
        //...
        //Segments
        wheel_segment newSeg1 = new wheel_segment("Back");
        wheel_segment newSeg2 = new wheel_segment("Circle");
        wheel_segment newSeg3 = new wheel_segment("Triangle");
        wheel_segment newSeg4 = new wheel_segment("Square");
        wheel_segment newSeg5 = new wheel_segment("Exclaim");
        segments.add(newSeg1);segments.add(newSeg2);segments.add(newSeg3);segments.add(newSeg4);segments.add(newSeg5);
        //Buttons
        loadButtons();
    }
    @Override
    ArrayList<button> loadButtons(){
        ArrayList<button> buttonSet = new ArrayList<button>();
        ArrayList<String> buttonTitles = new ArrayList<String>();
        buttonTitles.add("wheel_cartography_icon_goBack");buttonTitles.add("wheel_cartography_icon_selectCircle");buttonTitles.add("wheel_cartography_icon_selectTriangle");buttonTitles.add("wheel_cartography_icon_selectSquare");buttonTitles.add("wheel_cartography_icon_selectExclaim");
        float thetaInterval = (2.0*PI)/segments.size();
        for(int i=0; i<segments.size(); i++){
            button newButton0 = new button(pos, new PVector(2.0*radius, 2.0*radius), "arc", buttonTitles.get(i));
            newButton0.relatedWheel = this;newButton0.thetaStart = i*thetaInterval;newButton0.thetaStop = (i+1)*thetaInterval;
            buttonSet.add(newButton0);
        }
        return buttonSet;
    }
}
class placeholder_wheel extends wheel{
    //pass

    placeholder_wheel(PVector pos, float radius){
        super(pos, radius);
    }

    @Override
    void initialise(){
        //Wheels
        //...
        //Segments
        //...
        //Buttons
        loadButtons();
    }
    @Override
    ArrayList<button> loadButtons(){
        ArrayList<button> buttonSet = new ArrayList<button>();
        //buttonSet.add(newButton0);
        return buttonSet;
    }
}



class wheel_segment{
    /*
    Shows icons within each segment of the wheel
    This also holds the information for what to do when selected ????????????????????????????????
    */
    String infoText;

    wheel_segment(String infoText){
        this.infoText = infoText;
    }

    void display(PVector pos){
        pushStyle();
        fill(255,255,255);
        textAlign(CENTER, CENTER);
        textSize(15);                   //## MAKE RELATIVE SIZE TO WHEEL
        text(infoText, pos.x, pos.y);
        //image(...);
        popStyle();
    }
}