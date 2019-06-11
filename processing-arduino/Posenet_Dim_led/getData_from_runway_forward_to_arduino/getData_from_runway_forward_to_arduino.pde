// Copyright (C) 2018 Runway AI Examples
// 
// This file is part of Runway AI Examples.
// 
// Runway-Examples is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Runway-Examples is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with RunwayML.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAY
// www.runwayapp.ai

// This example communicates with posenet via HTTP and sends the result to arduino via serial.
// The goal is to be able to dim to leds with the detected position of your left and right wrists


// to communicate with arduino via USB port
import processing.serial.*;
Serial myPort;  

// route to communicate with runway
final String httpGetRoute = "http://localhost:8000/data";
final String httpPostRoute = "http://localhost:8000/query";

// This array will hold all the humans detected
JSONArray humans;

float newLeftWristY = 0;
float currentLeftWristY = 0;

float newRightWristY = 0;
float currentRightWristY = 0;

void setup() {
  size(400, 350);
  frameRate(25);

  fill(255);
  stroke(255);

  println(Serial.list()); // print a list of available usb devices
  String portName = Serial.list()[3];// be carefull to use the right port (check arduino IDE if needed)
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  background(255,180,180);
  fill(0);

  JSONObject json = loadJSONObject(httpGetRoute);
  if (json != null) {
    humans = json.getJSONArray("poses");

    JSONObject resolution = json.getJSONObject("size");
    float w = resolution.getFloat("width");
    float h = resolution.getFloat("height");


    JSONObject human = humans.getJSONObject(0);
    JSONArray keypoints = human.getJSONArray("keypoints");
    for (int k = 0; k < keypoints.size(); k++) {
      JSONObject body_part = keypoints.getJSONObject(k);

      if (body_part.getString("part").equals("leftWrist")) {
        JSONObject positions = body_part.getJSONObject("position");
        // Body parts are relative to width and weight of the input
        //float x = positions.getFloat("x")/w;
        float y = positions.getFloat("y")/h;
        newLeftWristY = y;
      }

      else if (body_part.getString("part").equals("rightWrist")) {
        JSONObject positions = body_part.getJSONObject("position");
        // Body parts are relative to width and weight of the input
        //float x = positions.getFloat("x")/w;
        float y = positions.getFloat("y")/h;
        newRightWristY = y;
      }
    }
  }

  currentLeftWristY += (newLeftWristY-currentLeftWristY)*0.1;
  currentRightWristY += (newRightWristY-currentRightWristY)*0.1;
  
  
  currentLeftWristY = constrain(currentLeftWristY, 0, 1);
  currentRightWristY = constrain(currentRightWristY, 0, 1);
  
  ellipse(width*0.66, currentLeftWristY*height, 50, 50);
  ellipse(width*0.33, currentRightWristY*height, 50, 50);
  
  float dimLeft = (1- currentLeftWristY)*255;
  float dimRight = (1- currentRightWristY)*255;
  
  if (dimLeft < 10){
   dimLeft = 0; 
  }
  if (dimRight < 10){
    dimRight = 0;
  }

  String s = dimLeft+","+dimRight+";"; // compose a string with the values (comma separated)
  //println(s);
  myPort.write(s); // write the string to serial
}




void mousePressed() {
}
