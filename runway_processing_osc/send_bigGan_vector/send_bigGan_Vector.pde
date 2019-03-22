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

// AttnGan demo
// Send a string and Receive OSC base64 images from Runway


// Import OSC
import oscP5.*;
import netP5.*;

// Runway Host && port
String runwayHost = "127.0.0.1";
int runwayPort = 57102;

OscP5 oscP5;
NetAddress myBroadcastLocation;

JSONObject data;


void setup() {
  size(400, 350);
  frameRate(25);

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
}

void draw() {
  background(0);
  fill(255);

 
}

void mouseDragged(){
    OscMessage myMessage = new OscMessage("/query");
    JSONObject  json = new JSONObject();
     json.setString("category","Tench, Tinca Tinca");
    JSONArray coordinates = new JSONArray();
    coordinates.setFloat(0, (float)mouseX/width);
    coordinates.setFloat(1, (float)mouseY/height);
    json.setJSONArray("z", coordinates);
   
    println(json);
    
    myMessage.add(json.toString());
    oscP5.send(myMessage, myBroadcastLocation); 
  
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
    case('s'):
    
    break;
  }
}
