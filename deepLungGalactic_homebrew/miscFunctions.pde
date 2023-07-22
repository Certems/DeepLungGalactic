PVector activeCol   = new PVector(40,250,40);
PVector inactiveCol = new PVector(250,40,40);

float vec_mag(PVector v){
    return sqrt( pow(v.x,2) + pow(v.y,2) );
}
PVector vec_dir(PVector v1, PVector v2){
    return new PVector(v2.x -v1.x, v2.y -v1.y);
}
PVector vec_unitDir(PVector v1, PVector v2){
    PVector dir = vec_dir(v1, v2);
    float mag = vec_mag(dir);
    return new PVector(dir.x/mag, dir.y/mag);
}
PVector vec_unitVec(PVector v){
    float mag = vec_mag(v);
    return new PVector(v.x/mag, v.y/mag);
}

float findMouseAngle(PVector origin){
    /*
    Finds the angle of the mouse from the [X-axis], going 
    clockwise about an origin (=> from 0.0 to 2.0*PI)

    Imagine a unit vec dotProd. with (1,0)
    */
    PVector uDir = vec_unitDir(origin, new PVector(mouseX, mouseY));
    float theta = acos(uDir.x);
    if(uDir.y < 0){
        theta = PI +acos(-uDir.x);}
    return theta;
}

//## MAYBE UNNECESSARY ##
float getLargestElem(ArrayList<ArrayList<Float>> matrix){
    float largestVal = matrix.get(0).get(0);
    for(int j=0; j<matrix.size(); j++){
        for(int i=0; i<matrix.size(); i++){
            if(matrix.get(j).get(i) > largestVal){
                largestVal = matrix.get(j).get(i);
            }
        }
    }
    return largestVal;
}
float getSmallestElem(ArrayList<ArrayList<Float>> matrix){
    float smallestVal = matrix.get(0).get(0);
    for(int j=0; j<matrix.size(); j++){
        for(int i=0; i<matrix.size(); i++){
            if(matrix.get(j).get(i) < smallestVal){
                smallestVal = matrix.get(j).get(i);
            }
        }
    }
    return smallestVal;
}


float calcFalloff(String falloffType, PVector centralPos, PVector targetPos){
    float valuePercent = 0.0;
    if(falloffType == "r^-2"){
        float r = vec_mag(vec_dir(centralPos, targetPos));
        if(r != 0.0){
            valuePercent = pow(r, -2);
        }
    }
    if(falloffType == "r^-1"){
        float r = vec_mag(vec_dir(centralPos, targetPos));
        if(r != 0.0){
            valuePercent = pow(r, -1);
        }
    }
    return valuePercent;
}


boolean checkRectRectCollision(PVector pos_1, PVector dim_1, PVector pos_2, PVector dim_2){
    /*
    pos specifies the top-left corner
    dim is full width and height
    */
    boolean withinX = abs(pos_1.x +dim_1.x/2.0 -pos_2.x -dim_2.x/2.0) < (dim_1.x/2.0 +dim_2.x/2.0);
    boolean withinY = abs(pos_1.y +dim_1.y/2.0 -pos_2.y -dim_2.y/2.0) < (dim_1.y/2.0 +dim_2.y/2.0);
    if(withinX && withinY){
        return true;
    }
    else{
        return false;
    }
}
boolean checkLineLineCollision(PVector p1, PVector q1, PVector p2, PVector q2){
    PVector dir_1 = vec_unitDir(p1, q1);
    PVector dir_2 = vec_unitDir(p2, q2);
    PVector a = new PVector(p1.x -p2.x, p1.y -p2.y);
    PVector b = new PVector(p2.x -p1.x, p2.y -p1.y);
    float alpha = ( (a.y*dir_2.x) - (a.x*dir_2.y) ) / ( (dir_1.x*dir_2.y) - (dir_1.y*dir_2.x) );  //Factor on dir when they meet
    float beta  = ( (b.y*dir_1.x) - (b.x*dir_1.y) ) / ( (dir_2.x*dir_1.y) - (dir_2.y*dir_1.x) );      //## HAVENT CHECKED, MAY BE BOLLOCKS ##

    float alphaEnd = 0.0;
    if(dir_1.x != 0.0){
        alphaEnd = (q1.x -p1.x) / (dir_1.x);}
    else{
        alphaEnd = (q1.y -p1.y) / (dir_1.y);}

    float betaEnd = 0.0;
    if(dir_2.x != 0.0){
        betaEnd = (q2.x -p2.x) / (dir_2.x);}
    else{
        betaEnd = (q2.y -p2.y) / (dir_2.y);}

    /*
    //##BUG FIXING## -> Shows intersection point of both lines (same point, but clarification)
    pushStyle();
    noStroke();
    fill(255,10,10);
    ellipse(p1.x +alpha*dir_1.x, p1.y +alpha*dir_1.y, 20, 20);

    fill(10,255,10);
    ellipse(p2.x +beta*dir_2.x, p2.y +beta*dir_2.y, 10, 10);
    popStyle();
    //##BUG FIXING##
    */

    boolean alphaInRange = (0 <= alpha) && (alpha <= alphaEnd);
    boolean betaInRange  = (0 <=  beta) && ( beta <= betaEnd);
    return (alphaInRange && betaInRange);
}