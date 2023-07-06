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