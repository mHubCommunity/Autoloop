
import oscP5.*;
import netP5.*;

int bassDrum1 = 3;
int bassDrum2 = 49;
boolean bassDrum = true;

int cowBell1 = 38;
int cowBell2 = 41;
boolean cowBell = true;

int SnareDrum1 = 44;
int SnareDrum2 = 46;
boolean snareDrum = true;


OscP5 oscP5;
NetAddress myRemoteLocation;



void setup() {
  size(400, 400);
  frameRate(25);



  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("10.1.10.177", 8888);

}

void draw() {
}

void mousePressed() {
  
  
  playBassDrum();
  //playCowbell();
}


void playBassDrum() {
  int nowPlaying = 0;
  int snareNow = 0;
  if (bassDrum) {
    nowPlaying = bassDrum1;
    bassDrum = false;
    snareNow =44;
  }
  else {
    nowPlaying = bassDrum2;
    bassDrum = true;
    snareNow =46;
  }

  OscMessage myMessage1 = new OscMessage(snareNow + "!");
  oscP5.send(myMessage1, myRemoteLocation);
delay(60);
  OscMessage myMessage2 = new OscMessage(nowPlaying + "!");
  oscP5.send(myMessage2, myRemoteLocation);
}


void playCowbell() {
  int nowPlaying = 0;
  if (cowBell) {
    nowPlaying = cowBell1;
    cowBell = false;
  }
  else {
    nowPlaying = cowBell2;
    cowBell = true;
  }
  OscMessage myMessage = new OscMessage(nowPlaying + "!");
  oscP5.send(myMessage, myRemoteLocation);
}

