/*
When adding a new mineral;
1. Add it into the dictionary below with an Id Value
2. Create its class below like the others
3. Add a space for it in the ship inventory                 ############### SHOULD MAKE THIS AUTOMATOC ##### THEN + THE OTHER NON-MINERAL TYPES AS AN ADDON IN INIT
*/

void initMineralDict(){
    ArrayList<mineral> keySet  = new ArrayList<mineral>();
    ArrayList<Float> valueSet = new ArrayList<Float>();

    keySet.add( new crestulin() );keySet.add( new forbicite() );keySet.add( new traen04() );keySet.add( new tickline() );keySet.add( new gaiaite() );keySet.add( new chronosilicate() );keySet.add( new astridium() );keySet.add( new hyperflex() );
    valueSet.add(1.0);            valueSet.add(2.0);            valueSet.add(3.0);          valueSet.add(4.0);           valueSet.add(5.0);          valueSet.add(6.0);                 valueSet.add(7.0);            valueSet.add(8.0);
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
        float alpha = min(250.0, 250.0*(quantity/quantityCutoff));
        return alpha;
    }
}
class crestulin extends mineral{
    //pass

    crestulin(){
        name          = "crestulin";
        colour        = new PVector(255,0,0);
        digDifficulty = 2.2;
    }

    //pass
}
class forbicite extends mineral{
    //pass

    forbicite(){
        name          = "forbicite";
        colour        = new PVector(0,0,255);
        digDifficulty = 2.9;
    }

    //pass
}
class traen04 extends mineral{
    //pass

    traen04(){
        name          = "traen04";
        colour        = new PVector(0,255,0);
        digDifficulty = 3.8;
    }

    //pass
}
class tickline extends mineral{
    //pass

    tickline(){
        name          = "tickline";
        colour        = new PVector(117, 223, 240);
        digDifficulty = 2.1;
    }

    //pass
}
class gaiaite extends mineral{
    //pass

    gaiaite(){
        name          = "gaiaite";
        colour        = new PVector(125, 50, 168);
        digDifficulty = 3.0;
    }

    //pass
}
class chronosilicate extends mineral{
    //pass

    chronosilicate(){
        name          = "chronosilicate";
        colour        = new PVector(38, 189, 116);
        digDifficulty = 6.6;
    }

    //pass
}
class astridium extends mineral{
    //pass

    astridium(){
        name          = "astridium";
        colour        = new PVector(212, 49, 130);
        digDifficulty = 5.8;
    }

    //pass
}
class hyperflex extends mineral{
    //pass

    hyperflex(){
        name          = "hyperflex";
        colour        = new PVector(180, 235, 91);
        digDifficulty = 4.7;
    }

    //pass
}