import processing.sound.*;

SoundFile file1;
SoundFile file2;
SoundFile file3;
SoundFile file4;

/*
. Stopping audio is working fine
. Lots of channels can be played at once
. Audio sounds clear
*/

void setup(){
    size(100,100);

    file1 = new SoundFile(this, "button_generalClick_active.wav");
    file2 = new SoundFile(this, "button_generalClick_inactive.wav");
    file3 = new SoundFile(this, "button_scroller.wav");
    file4 = new SoundFile(this, "aliens_1.wav");
}
void draw(){
    background(30,30,30);
}
void keyPressed(){
    if(key == '1'){
        file1.play();}
    if(key == '2'){
        file2.play();}
    if(key == '3'){
        file3.play();}
    if(key == '4'){
        file4.play();}
    if(key == '5'){
        file4.stop();}
}
void mousePressed(){
  file1.play();
}

void play_collection_1(){
    //pass
}
void play_collection_2(){
    //pass
}
void play_collection_3(){
    //pass
}
