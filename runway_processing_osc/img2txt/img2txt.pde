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

// Img2txt Demo:
// Receive OSC messages from Runway
// Running img2txt model

// Import OSC
import oscP5.*;
import netP5.*;

// Runway parameters
String runwayHost = "127.0.0.1";
int runwayPort = 57102;

OscP5 oscP5;
NetAddress myBroadcastLocation;

// This array will hold all the humans detected
JSONObject data;


void setup() {
  size(800, 600);
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
  
  colorMode(HSB,360, 100,100);
  
  textSize(25);
  textMode(CENTER);
  textAlign(CENTER,CENTER);
}

void draw() {
  background(0);
  fill(255);
  
   
  if (data != null) {
    JSONArray results = data.getJSONArray("results");
    
    for(int i = 0; i < results.size(); i++) {
      JSONObject result = results.getJSONObject(i);
      String caption = result.getString("caption");
      float p = result.getFloat("probability");
     
      
      fill(map(p, 0, 0.1, 60, 0), 100,100);
      text(caption + " (p : " + nf(p, 0,4) +")", width/2, height/2  + 40*i);
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
  println(data);
}
