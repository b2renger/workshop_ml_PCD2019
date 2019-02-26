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

import java.util.Base64;
import java.io.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

// Runway Host && port
String runwayHost = "127.0.0.1";
int runwayPort = 57107;

OscP5 oscP5;
NetAddress myBroadcastLocation;

// This array will hold all the humans detected
JSONObject data;
PImage img;


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

  if (img != null) image(img, 0, 0);
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
    OscMessage myMessage = new OscMessage("/query");
    JSONObject  json = new JSONObject();
    json.setString("caption","hello");
    myMessage.add(json.toString());
    oscP5.send(myMessage, myBroadcastLocation); 
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
  //img = DecodeBase64(data.getString("result"));
}


public PImage DecodeBase64(String image64) {
  PImage result = null;
  try {

    byte[] decodedBytes = Base64.getDecoder().decode(image64);

    ByteArrayInputStream in = new ByteArrayInputStream(decodedBytes);
    BufferedImage bImageFromConvert = ImageIO.read(in);
    BufferedImage convertedImg = new BufferedImage(bImageFromConvert.getWidth(), bImageFromConvert.getHeight(), BufferedImage.TYPE_INT_ARGB);
    convertedImg.getGraphics().drawImage(bImageFromConvert, 0, 0, null);
    result = new PImage(convertedImg);
  }
  catch (Exception e) {
  }
  return result;
}
