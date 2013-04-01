/*
 Interactivity Project
 Starry Night @
 
 Meng Shi Mar 26, 2013
 lolaee@gmail.com
 Master Student @ Tangible Interaction Design, Code Lab, CMU
 
 Project3 for course Interactive Art and Computational Design
 by Prof Golan Levin @ CMU School of Art
 
 */

import peasy.*;
import processing.opengl.*;

PGraphics pg1;
PGraphics pg2;
PGraphics pg3;

PeasyCam cam;               // our world camera
ArrayList<Point> pc;        // our Point data structure 

// variables for reading data from txt
FloatTable data;

Point[] starPoint =new Point[119617];

//-------------------- Setup -------------------- 

void setup() {

  background(0);
  size(1280, 800, OPENGL);

  // sets up a world camera with controls similar to Rhino
  cam = new PeasyCam(this, 100);
  cam.setCenterDragHandler(cam.getPanDragHandler());		
  cam.setRightDragHandler(cam.getRotateDragHandler());
  cam.setLeftDragHandler(null);

  cam.rotateX(-1.5);
  cam.rotateY(1.5);
  cam.rotateZ(1.5);

  cam.setMinimumDistance(100);
  cam.setMaximumDistance(width*10);


  // initialize our point cloud arraylist
  pc = new ArrayList<Point>();


  // reading the file and get the data and add the the Point Cloud
  data = new FloatTable("hygxyzData.txt");
  int counter=0;
  for (int i=0; i<2800; i++) {

    float temp_starMag = data.getFloat(i, 0);

    temp_starMag= map(temp_starMag, -26.73, 21, 100, 255);
    float temp_starAbsMag= data.getFloat(i, 1);
    if (temp_starAbsMag<=0) {
      temp_starAbsMag= 0.5;
    }
    else {
      temp_starAbsMag=map(temp_starAbsMag, 0, 19.62861803, 0.0, 3.0);
    }

    float temp_x= data.getFloat(i, 2); //+X is in the direction of the vernal equinox 
    float temp_y= data.getFloat(i, 3);// +Y in the direction of R.A. 6 hours, declination 0 degrees.
    float temp_z= data.getFloat(i, 4);//+Z towards the north celestial pole

    //    float starMag = map(temp_starMag, -26.73, 21, -200, 200);
    //    float starAbsMag = map(temp_starAbsMag, -11.06, 19.62861803, -800, 800);
    //    float x = map(temp_x, -9995039.38, 9983610.019, -800, 800);
    //    float y = map(temp_y, -9997924.749, 9996325.392, -800, 800);
    //    float z = map(temp_z, -9986775.471, 9986251.44, -800, 800);
    pc.add(new Point(temp_starMag, temp_starAbsMag, temp_x*2, temp_y*2.5, temp_z*2));
  }
}
//-------------------- draw -------------------- 

void draw() {
  background(0);
  //  drawAxes();
  // visualize points
  drawPointCloud();

  /*another way of trying to acheive three group 
   of point cloud by vector transformation 
   ....but not sucessful
   
   //  cam.beginHUD();
   //  pushMatrix();
   //  translate(width/2, height/8);
   //
   //  rotateY(PI/2);
   //  translate(cam.getPosition()[0], cam.getPosition()[2], cam.getPosition()[1]);
   //
   //  //  rotateY(-PI/2);
   //  drawPointCloud();
   //  drawAxes();
   //  popMatrix();
   //  cam.endHUD(); 
   */

  PImage screenshotUp = get(0, height/3, width, height/3*2);

  //  PImage screenshotDown = get(0, height/3, width, height/3*2);
  //  PImage screenshotDown = get();
  cam.beginHUD();
  //  noStroke();
  //  rect(0, 0, screenshot.width, screenshot.height);
  //  tint(255, 255, 255, 90); 
  //  image(screenshotDown, 0, -height/3-10);
  //  image(screenshotDown, 0, -300);
  //
  //  tint(255, 255, 255); 
  //  image(screenshotUp, 0, height/3+20);
}


/*
  X, Y, Z Axes for PeasyCam
 */

//-------------------- drawAxes --------------------  

void drawAxes() {

  strokeWeight(1.5f);	  
  stroke(0, 189, 255);			// z = blue
  line(0, 0, 0, 0, 0, width/2);	  
  stroke(152, 255, 0);			// y = green
  line(0, 0, 0, 0, width/2, 0);	  
  stroke(255, 196, 0);			// x = orange
  line(0, 0, 0, width/2, 0, 0);
}

//-------------------- key --------------------  

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      println(str(cam.getRotations()));
    }
    else if (keyCode == DOWN) {
      println(str(cam.getPosition()));
    }
  }
}


/*
  Draw a box at each point
 */

//-------------------- drawPointCloud -------------------- 

void drawPointCloud() {

  for (int i=0; i<pc.size(); i++) {
    Point p = pc.get(i);

    pushMatrix();
    translate(p.x, p.y, p.z);

    noStroke();
    fill(255, p.starMag);
    box(p.starAbsMag);
    popMatrix();
  }
}

void drawPointLine() {
}

