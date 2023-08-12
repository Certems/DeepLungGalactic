int imageWidth;
int imageHeight;

float detailPercent = 0.125;
int asciiJump;
int asciiWidth;
int asciiHeight;

ArrayList<asciiPixel> newImg = new ArrayList<asciiPixel>();
PImage img;

ArrayList<PImage> animation = new ArrayList<PImage>();
int cAnimFrame = 0; //Current frame in animation

float scale = 5.0;

void setup(){
    img = loadImage("buttonSettings.png");

    imageWidth  = img.width;
    imageHeight = img.height;
    //println("imageWidth  -> ",imageWidth);
    //println("imageHeight -> ",imageHeight);

    asciiJump   = floor(1.0/detailPercent);
    asciiWidth  = floor(imageWidth*detailPercent);
    asciiHeight = floor(imageHeight*detailPercent);

    //size(imageWidth, imageHeight);
    //size(810,540);  //sandu_reduced.jpg
    //size(360,640);  //me_reduced.jpg
    size(960, 320);

    convertImage();
    //createAnimationSet();
    //convertAnimation();

    background(30,30,30);
    displayAsciiImage();
    save("outputImg.png");
}
void draw(){
    background(30,30,30);
    //displayImage();
    displayAsciiImage();
    
    //displayAnimation();
}


void convertImage(){
    /*
    Returns the singular image, converted
    */
    newImg.clear();
    //loadPixels();
    img.loadPixels();
    for(int j=0; j<imageHeight; j++){
        for(int i=0; i<imageWidth; i++){
            if( (j % asciiJump == 0) && (i % asciiJump == 0) ){
                int pixelNumber = j*imageWidth +i;
                color newCol = convertColour( img.pixels[pixelNumber] );
                String newAsciiType = convertToText( img.pixels[pixelNumber] );
                asciiPixel newPixel = new asciiPixel(newCol ,newAsciiType);
                newImg.add(newPixel);
            }
        }
    }
    //println("asciiWidth - > ",asciiWidth);
    //println("asciiHeight -> ",asciiHeight);
}
void convertAnimation(){
    /*
    Returns all frames of animation, converted
    */
}

color convertColour(color col){
    //pass -> If you want to do any colour adjustment
    return col;
}
String convertToText(color col){
    float brightnessMax = 300.0;
    float brightnessValue = brightness(col);
    String asciiType = "";
    if(brightnessValue < 0.1*brightnessMax){
        asciiType = " ";}
    else if(brightnessValue < 0.2*brightnessMax){
        asciiType = ".";}
    else if(brightnessValue < 0.3*brightnessMax){
        asciiType = ";";}
    else if(brightnessValue < 0.4*brightnessMax){
        asciiType = "*";}
    else if(brightnessValue < 0.5*brightnessMax){
        asciiType = "£";}
    else if(brightnessValue < 0.6*brightnessMax){
        asciiType = "$";}
    else if(brightnessValue < 0.7*brightnessMax){
        asciiType = "&";}
    else if(brightnessValue < 0.8*brightnessMax){
        asciiType = "%";}
    else if(brightnessValue < 0.9*brightnessMax){
        asciiType = "#";}
    else{
        asciiType = "@";}
    //println(brightnessValue);
    return asciiType;
}


void displayImage(){
    image(img, 0, 0);
}
void displayAsciiImage(){
    float asciiSize = imageWidth/asciiWidth;
    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(scale*asciiSize);
    for(int j=0; j<asciiHeight; j++){
        for(int i=0; i<asciiWidth; i++){
            PVector pos = new PVector(scale*i*asciiSize, scale*j*asciiSize);
            fill(newImg.get(j*asciiWidth +i).col);
            text(newImg.get(j*asciiWidth +i).type, pos.x, pos.y);
        }
    }
    popStyle();
}


void createAnimationSet(){
    animation.clear();
    //...
}
void displayAnimation(){
    if(cAnimFrame > animation.size()){
        cAnimFrame = 0;}
    image(animation.get(cAnimFrame), 0, 0);
    cAnimFrame++;
}

class asciiPixel{
    color col;
    String type;

    asciiPixel(color col, String type){
        this.col  = col;
        this.type = type;
    }

    //pass
}
