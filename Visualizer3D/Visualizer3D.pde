//This requires the minim and peasycam librarys which can be installed from
//Sketch->ImportLibrary->AddLibrary->"Minim"->install
//Sketch->ImportLibrary->AddLibrary->"Peasycam"->install

import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.test.*;

import ddf.minim.*;
import ddf.minim.signals.*; 
import ddf.minim.analysis.*;
import java.util.LinkedList;
import java.util.ListIterator;

Minim minim;
FFT fft;
AudioPlayer mp3;
LinkedList<float[]> hist = new LinkedList<float[]>();
PeasyCam camera;
float[] spectrum;
int mode = 1;

void setup() {
  size(1000, 500, P3D);
  frameRate(30);
  minim = new Minim(this);
  mp3 = minim.loadFile("dub.mp3", 2048);
  //mp3 = minim.loadFile("song_of_seven_sorrows.mp3", 2048);
  mp3.loop();
  fft = new FFT(mp3.bufferSize(), mp3.sampleRate());
  spectrum = new float[fft.specSize()];
  mp3.play();
  newCam(1000/2, 500/2, 125, 0, 0, 0);
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      newCam(width/2, height/2+50, -1040, 2.79, 0, -3.14);
    }
    if(keyCode == DOWN){
      newCam(width/2, height/2+50, 0, .5, 0, 0);
    }
    if(keyCode == LEFT){
      newCam(-50, height/2+50, -510, 3.14/2, -1.2, 3.14/2);
    }
    if(keyCode == RIGHT){
      newCam(width, height/2+50, -520, 3.14/2, 1, -3.14/2);
    }
  }else{
    if(key == ' '){
      mode = (mode < 3)? mode +1 : 0;
      if(mode == 3){
        newCam(width/2, height/2+50, 0, .5, 0, 0);
      }else{
        newCam(width/2, height/2, 125, 0, 0, 0);
      }
    }
  }
}

void draw() {
  background(0);
  fft.forward(mp3.mix);
  smooth();
  colorMode(HSB);
  for(int i = 0; i < fft.specSize(); i++){
    float amplitude = fft.getFreq(i)*1.1;
    spectrum[i] = amplitude;
  }
  float[] temp = new float[fft.specSize()];
  arrayCopy(spectrum, temp);
  hist.addFirst(temp);
  if(hist.size() > 100) hist.removeLast();
  if(mode == 3){
    ListIterator<float[]> it = hist.listIterator();
    while (it.hasNext()) {
      float[] tmp = it.next();
      for(int j = 0; j < fft.specSize(); j+=5){
        stroke(0);
        fill(j/4, 255, 225);     
        pushMatrix();
        translate(j, (height-tmp[j]/2)+100, 0);
        box(5, tmp[j], 10);
        popMatrix();
      }
      translate(0,0,-(10));
    }
  }else if(mode == 2){
    for(int i = 0; i < fft.specSize(); i+=5){
      //camera.setYawRotationMode();
      stroke(0);
      fill(i/4, 255,225);
      pushMatrix();
      translate(i, height/2);
      box(5,fft.getFreq(i)*1.3,10);
      popMatrix();
    }
  }else{
    for(int i = 0; i < mp3.left.size() - 1; i+=2){
      colorMode(HSB);
      stroke(i/8, 255,225);
      line(i/2, height/2-50 + mp3.left.get(i/2)*50, i/2+1, height/2-50 + mp3.left.get(i/2+1)*50);
      line(i/2, height/2+50 + mp3.right.get(i/2)*50, i/2+1, height/2+50 + mp3.right.get(i/2+1)*50);
    }
  }
}

void newCam(float camX, float camY, float camZ, float rotX, float rotY, float rotZ){
  camera = new PeasyCam(this, camX, camY, camZ, 330);
  camera.setRotations(rotX, rotY, rotZ);
  camera.setSuppressRollRotationMode();
}

void close() {
  minim.stop();
  super.stop();
}

void arrayCopy(float[]a, float[]b) {
  for (int i = 0; i < a.length; i++) {
    b[i] = a[i];
  }
}