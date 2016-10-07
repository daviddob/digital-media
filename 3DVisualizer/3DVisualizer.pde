//This requires the minim library which can be installed from
//Sketch->ImportLibrary->AddLibrary->"Minim"->install
import ddf.minim.*;
import ddf.minim.signals.*; 
import ddf.minim.analysis.*;
import java.util.LinkedList;
import java.util.ListIterator;

Minim minim;
FFT fft;
int timestamp = 0;

AudioPlayer mp3;
float[] spectrum;
LinkedList<float[]> hist = new LinkedList<float[]>();

void setup() {
  size(1000, 500, P3D);
  frameRate(30);

  minim = new Minim(this);
  mp3 = minim.loadFile("dub.mp3", 2048);
  mp3.loop();
  fft = new FFT(mp3.bufferSize(), mp3.sampleRate());
  camera(width/2, height/2-150, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  spectrum = new float[fft.specSize()];
}

void draw() {
  background(0);
  fft.forward(mp3.mix);
  mp3.play();
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
  timestamp = (timestamp < 99)? timestamp+1 : 0;
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