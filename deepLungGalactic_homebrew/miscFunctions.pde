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
boolean checkLineLineCollision(PVector p1_1, PVector p1_2, PVector p2_1, PVector p2_2){
    /*
    p1_1 = line 1, 1st point
    p1_2 = line 1, 2nd point
    */
    //pass
    return ;
}