//This requires the minim library which can be installed from
//Sketch->ImportLibrary->AddLibrary->"Minim"->install
import ddf.minim.*;
import ddf.minim.signals.*; 
import ddf.minim.analysis.*;

Minim minim;
FFT fft;

AudioPlayer mp3;

void setup(){
  size(1000,500,P3D);
  frameRate(120);
  
  minim = new Minim(this);
  mp3 = minim.loadFile("dub.mp3",2048);
  mp3.loop();
  fft = new FFT(mp3.bufferSize(),mp3.sampleRate());
  camera(width/2, height/2-150, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
}

void draw(){
    background(0);
    fft.forward(mp3.mix);
    mp3.play();
    smooth();
    colorMode(HSB);
    rectMode(CORNERS);
    for(int i = 0; i < fft.specSize(); i+=5){
      stroke(0);
      fill(i/4, 255,225);

      pushMatrix();
      translate(i, height/2);
      //rotateX(-PI/6);
      //rotateY(radians(frameCount));
      box(5,fft.getFreq(i)*1.3,10);
      popMatrix();
//      rect(i,height, i, height - fft.getFreq(i)*1.3);
    }
}

void close(){
  minim.stop();
  super.stop();
}