/*
When adding a new mineral;
1. Add it into the dictionary below with an Id Value
2. Create its class below like the others
3. Add a space for it in the ship inventory                 ############### SHOULD MAKE THIS AUTOMATOC ##### THEN + THE OTHER NON-MINERAL TYPES AS AN ADDON IN INIT
*/

void initMineralDict(){
    ArrayList<mineral> keySet  = new ArrayList<mineral>();
    ArrayList<Float> valueSet = new ArrayList<Float>();

    keySet.add( new crestulin() );keySet.add( new forbicite() );keySet.add( new traen04() );
    valueSet.add(1.0);            valueSet.add(2.0);            valueSet.add(3.0);
    //...

    mineralDict = new mineralDictionary(keySet, valueSet);
}


class mineral{
    String name;
    PVector colour;
    float digDifficulty;    //Multiplier on default dig speed

    float quantity = 0.0;       //## MAYBE HAVE AS AN ARGUEMENT ??? ###

    mineral(){
        //pass
    }

    float calcTransparency(){
        /*
        Returns the transparency WITHOUT the rest of the colour
        This is based on quantity remaining
        */
        float quantityCutoff = 300.0;   //When transparency starts appearing
        float alpha = min(255.0, 255.0*(quantity/quantityCutoff));
        return alpha;
    }
}
class crestulin extends mineral{
    //pass

    crestulin(){
        name          = "crestulin";
        colour        = new PVector(255,0,0);
        digDifficulty = 1.0;
    }

    //pass
}
class forbicite extends mineral{
    //pass

    forbicite(){
        name          = "forbicite";
        colour        = new PVector(0,0,255);
        digDifficulty = 1.0;
    }

    //pass
}
class traen04 extends mineral{
    //pass

    traen04(){
        name          = "traen04";
        colour        = new PVector(0,255,0);
        digDifficulty = 1.0;
    }

    //pass
}