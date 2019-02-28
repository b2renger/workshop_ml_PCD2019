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

// PoseNet Demo:
// Receive OSC messages from Runway
// Running PoseNet model

// Import OSC
import oscP5.*;
import netP5.*;

// Runway Parameters
String runwayHost = "127.0.0.1";
int runwayPort = 57100;
int camWidth = 600;
int camHeight = 400;

OscP5 oscP5;
NetAddress myBroadcastLocation;

// This array will hold all the humans detected
JSONObject data;
JSONArray humans;

// This are the pair of body connections we want to form. 
// Try creating new ones!
String[][] connections = {
  {"nose", "leftEye"}, 
  {"leftEye", "leftEar"}, 
  {"nose", "rightEye"}, 
  {"rightEye", "rightEar"}, 
  {"rightShoulder", "rightElbow"}, 
  {"rightElbow", "rightWrist"}, 
  {"leftShoulder", "leftElbow"}, 
  {"leftElbow", "leftWrist"}, 
  {"rightHip", "rightKnee"}, 
  {"rightKnee", "rightAnkle"}, 
  {"leftHip", "leftKnee"}, 
  {"leftKnee", "leftAnkle"}
};

void setup() {
  size(800, 600);
  //frameRate(25);

  OscProperties properties = new OscProperties();
  properties.setRemoteAddress("127.0.0.1", 57200);
  properties.setListeningPort(57200);
  properties.setDatagramSize(99999999);
  properties.setSRSP(OscProperties.ON);
  oscP5 = new OscP5(this, properties);

  // Use the localhost and the port 57100 that we define in Runway
  myBroadcastLocation = new NetAddress(runwayHost, runwayPort);

  connect();

  fill(255);
  stroke(255);
  textMode(CENTER);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(0);

  if (data != null) {
    humans = data.getJSONArray("poses");
    for (int h = 0; h < humans.size(); h++) {
      JSONObject human = humans.getJSONObject(h);
      JSONArray keypoints = human.getJSONArray("keypoints");


      // Now that we have one human, let's draw its body parts
      for (int k = 0; k < keypoints.size(); k++) {
        JSONObject body_part = keypoints.getJSONObject(k);
        JSONObject positions = body_part.getJSONObject("position");
        // Body parts are relative to width and weight of the input
        float x = positions.getFloat("x");
        float y = positions.getFloat("y");
        // map coordinates from camera resolution to screen resolution
        float xScreen = map(x, 0, camWidth, width, 0); // inverse x coordinates
        float yScreen = map(y, 0, camHeight, 0, height);
        text(body_part.getString("part"), xScreen, yScreen - 15);
        ellipse(xScreen, yScreen, 10, 10);
      }

      // draw connections
      for (int i = 0; i < connections.length; i ++) {
        float x1=0, x2=0, y1=0, y2=0;
        for (int k = 0; k < keypoints.size(); k++) {
          JSONObject body_part = keypoints.getJSONObject(k);
          String partName = body_part.getString("part");

          if (partName.equalsIgnoreCase(connections[i][0])) {
            JSONObject positions = body_part.getJSONObject("position");
            x1 = map(positions.getFloat("x"), 0, camWidth, width, 0);
            y1 = map(positions.getFloat("y"), 0, camHeight, 0, height);
          }

          if (partName.equalsIgnoreCase(connections[i][1])) {
            JSONObject positions = body_part.getJSONObject("position");
            x2 = map(positions.getFloat("x"), 0, camWidth, width, 0);
            y2 = map(positions.getFloat("y"), 0, camHeight, 0, height);
          }
        }
        line(x1, y1, x2, y2);
        println(connections[i][0], connections[i][1]);
        // JSONObject body_part1 = keypoints.getString(connections[i][0]);
      }
    }
  }
}



void connect() {
  OscMessage m = new OscMessage("/server/connect");
  oscP5.send(m, myBroadcastLocation);
}

void disconnect() {
  OscMessage m = new OscMessage("/server/disconnect");
  oscP5.send(m, myBroadcastLocation);
}

void keyPressed() {
  switch(key) {
    case('c'):
    /* connect to Runway */
    connect();
    break;
    case('d'):
    /* disconnect from Runway */
    disconnect();  
    break;
  }
}

// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {
  // The data is in a JSON string, so first we get the string value
  String dataString = theOscMessage.get(0).stringValue();

  // We then parse it as a JSONObject
  data = parseJSONObject(dataString);
  // println(data);
}
