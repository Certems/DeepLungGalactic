class musicManager{
    /*
    Manages background music being played in sequence

    Each song starts and ends with fading
    Time is left between each song
    */
    boolean togglePlayMusic = true;

    int music_1_length = floor(146.0*60.0); //In frames
    int music_2_length = floor(104.0*60.0); //
    int music_3_length = floor(169.0*60.0); //
    int songsMax = 3;   //**Make sure to update this value

    int fadeInterval = floor(8.0*60.0); //Time left between intervals to allow fading

    String currentSong = "0";
    int currentFrame = 0;

    IntDict music_database = new IntDict();

    musicManager(){
        initMusicDict();
    }

    void initMusicDict(){
        music_database.set("1", music_1_length);
        music_database.set("2", music_2_length);
        music_database.set("3", music_3_length);
    }

    void calc(){
        /*
        1. If playing a song, keep playing it
        2. If you are fading , keep fading
        3. If you reach the end of a song, set timer to 0 and wait for fade
        4. Once fade is over, play a new song at random 
        */
        if(togglePlayMusic){
            currentFrame++;
            if(int(currentSong) > 0){    //Playing a song
                if(currentFrame > music_database.get(currentSong)){ //If you reach the end of the current song...
                    //Start fade timer
                    currentSong = "0";
                    currentFrame = 0;
                }
            }
            else{                   //Fading
                if(currentFrame > fadeInterval){    //If at end of fade
                    //Reset and start new song
                    currentFrame = 0;
                    int newSong = ceil(random(0.0, songsMax));  //Dont play same song twice in a row
                    while(newSong == int(currentSong)){              //
                        newSong = ceil(random(0.0, songsMax));} //
                    currentSong = str(newSong);
                    playCurrentSong();
                }
            }
        }
    }
    void playCurrentSong(){
        if(int(currentSong) == 1){
            sound_music_1.play();}
        if(int(currentSong) == 2){
            sound_music_2.play();}
        if(int(currentSong) == 3){
            sound_music_3.play();}
        //...
    }

    void toggleMusic(){
        sound_music_1.stop();
        sound_music_2.stop();
        sound_music_3.stop();
        togglePlayMusic = !togglePlayMusic;
    }
}