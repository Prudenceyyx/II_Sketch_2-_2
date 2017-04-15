//Upload Standard Firmata to Arduino before you run the sketch

import processing.video.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
Movie movie;
float[] averBrightness=new float[10];
int count=0;
float aver=0;

void settings() {
  size(480, 480);
}

void setup() {
  frameRate(30);
 
  movie=new Movie(this,"cave.mov");
  movie.loop();
  
  //Finish loading the movie
  while (movie.height==0) delay(10);
  println(movie.width, movie.height);
  
  //change the screen size to video size
  surface.setResizable(true);
  surface.setSize(movie.width, movie.height);
  
  arduino = new Arduino(this, "/dev/cu.usbmodem1421", 57600);
  
  //Initiate the averBrightness to an array of 0
  for(int i=0;i<averBrightness.length;i++) averBrightness[i]=0;
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  //video image
  image(movie, 0, 0);
  
  //Read from a light sensor connected to pin A0 
  //The darker the environment is, the smaller the analgo value
  int b=arduino.analogRead(0);
  float brightness=map(b,5,20,25,225);
  
  //A data structure to smooth the change.
  //It stores 10 mapped analog value in an array,
  //and output the average float as the brightness
  averBrightness[count]=brightness;
  count=(count+1)%averBrightness.length;
  println("count "+count);
  
  aver=0;
  for(float f :averBrightness)aver+=f;
  aver=aver/averBrightness.length;
  println(aver);

  
  
  //Add a brightness layer to the video
  fill(aver,150);
  rect(0,0,width,height);
}