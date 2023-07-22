/*
########################################
## StringDict essentially useless now ##
########################################
*/
class stringDictionary{
    /*
    Custom dictinary, bit easier to pull values from it
    */
    ArrayList<String> keys = new ArrayList<String>();
    ArrayList<Float> values = new ArrayList<Float>();

    stringDictionary(ArrayList<String> keys, ArrayList<Float> values){
        this.keys   = keys;
        this.values = values;
    }

    float getValue(String key){
        int requiredInd = -1;
        for(int i=0; i<keys.size(); i++){
            if(key == keys.get(i)){
                requiredInd = i;
                break;
            }
        }
        if(requiredInd != -1){
            return values.get(requiredInd);}
        else{
            return -9999.0;}
    }
    int size(){
        return keys.size();
    }
}

class mineralDictionary{
    /*
    Custom dictinary, bit easier to pull values from it
    */
    ArrayList<mineral> keys = new ArrayList<mineral>();
    ArrayList<Float> values = new ArrayList<Float>();

    mineralDictionary(ArrayList<mineral> keys, ArrayList<Float> values){
        this.keys   = keys;
        this.values = values;
    }

    float getValue(mineral key){
        int requiredInd = -1;
        for(int i=0; i<keys.size(); i++){
            if(key.name == keys.get(i).name){
                requiredInd = i;
                break;
            }
        }
        if(requiredInd != -1){
            return values.get(requiredInd);}
        else{
            return -9999.0;}
    }
    mineral getKey(float value){
        int requiredInd = -1;
        for(int i=0; i<values.size(); i++){
            if(value == values.get(i)){
                requiredInd = i;
                break;
            }
        }
        if(requiredInd != -1){
            return keys.get(requiredInd);}
        else{
            return null;}
    }
    int size(){
        return keys.size();
    }
}