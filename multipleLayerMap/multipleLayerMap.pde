/*
 Interactivity Project Part 2
 Multiple Layer Map (work in Progress) @ CMU
 
 Meng Shi Mar 26, 2013
 lolaee@gmail.com
 Master Student @ Tangible Interaction Design, Code Lab, CMU
 
 Project3 for course Interactive Art and Computational Design
 by Prof Golan Levin @ CMU School of Art
 
 */

import peasy.*;
import processing.opengl.*;
import codeanticode.glgraphics.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;


import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.providers.*;

de.fhpotsdam.unfolding.Map map;

PeasyCam cam;

//Declare Handler
PeasyDragHandler PanDragHandler;
PeasyDragHandler ZoomDragHandler;


float[] airportPositionsX=new float[44895];
float[] airportPositionsY=new float[44895];
FloatTable data;
AirPort airPort;

Location PLocation;

public void setup() {
  // basic setup
  size(1440, 900, GLConstants.GLGRAPHICS);
  // map setup
  noStroke();

  PLocation = new Location(40.44f, -79.98f);
  map = new de.fhpotsdam.unfolding.Map(this, -700, -400, 1400, 800, new OpenStreetMap.CloudmadeProvider(MapDisplayFactory.OSM_API_KEY, 30635));
  map.setTweening(true);
  map.zoomToLevel(2);
  map.panTo(PLocation);
  // cam setup
  cam = new PeasyCam(this, 100);
  PanDragHandler = cam.getPanDragHandler();
  cam.setLeftDragHandler(PanDragHandler);
  ZoomDragHandler = cam.getZoomDragHandler();
  // set first view

  cam.setMinimumDistance(10);
  cam.setMaximumDistance(800);

  data = new FloatTable("airports.txt");
  //  ====================data loading=
  for (int i=0; i<44895; i++) {

    airportPositionsX[i]= data.getFloat(i, 0); 
    airportPositionsY[i]= data.getFloat(i, 1);
  }
  //  =================================
}

public void draw() {

  directionalLight(166, 166, 196, -60, -60, -60);
  background(0);
  map.draw();




  cam.beginHUD();

  fill(0);
  rect(0, 0, width, height/3);

  fill(0);
  rect(0, height/3*2, width, height);

  cam.endHUD();
  for (int i=0; i<44895; i++) {

    float xy[] = map.getScreenPositionFromLocation(new Location(airportPositionsX[i], airportPositionsY[i]));
    drawLayerMarkerMarker(xy[0], xy[1]);
    drawLayerMarkerMarker1(xy[0], xy[1]);
  }
}
//
public void drawLayerMarkerMarker(float x, float y) {
  fill(255, 0, 0, 100);
  noStroke();
  pushMatrix();
  translate(x, y-height/3, 0);
  rect(0, 0, 1, 1);
  popMatrix();
}

public void drawLayerMarkerMarker1(float x, float y) {
  fill(255, 155, 0, 100);
  noStroke();
  pushMatrix();
  translate(x, y+height/3, 0);
  rect(0, 0, 1, 1);
  popMatrix();
}


//-----------------------------keyPressed-----------------------------------
public void keyPressed() {
  if (key == 'p') {
    map.panTo(PLocation);
  }
  if (key == 'c') {

    cam.rotateX(-0.8);
    cam.rotateY(-0.4);
    cam.rotateZ(0.4);
  }

  if (key == '+') {
    map.zoomLevelIn();
  }
  if (key == '-') {
    map.zoomLevelOut();
  }

  if (key == ' ') {
    cam.reset();
  }
  if (key == CODED) {
    if (keyCode == UP) {
      println(str(cam.getRotations()));
    }
    else if (keyCode == DOWN) {
      println(str(cam.getPosition()));
    }
  }
}


//----------------------------LayerMarker------------------------------------

class LayerMarker {
  Location location;
  float richterValue;

  LayerMarker(Location location, float richterValue) {
    this.location = location;
    this.richterValue = richterValue;
  }
}

