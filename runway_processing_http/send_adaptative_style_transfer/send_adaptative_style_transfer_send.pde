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
// along with Runway AI Examples.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAY
// www.runwayapp.ai

// Adaptative style transfer Demo:
// Receive HTTP Data from Runway


import java.io.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.util.Base64;
 
import javax.xml.bind.DatatypeConverter;

final String httpDataRoute = "http://localhost:8005/query"; // set to the Runway HTTP route

PGraphics pg;
PImage img;

void setup() {
  size (600, 400);
  noFill();
  stroke(0);

  frameRate(1);
  pg = createGraphics(width, height);
  img = loadImage("1200-bahamas-shutterstock_54949447_0.jpg");
}

void draw () {   
  background(0);

  pg.beginDraw();
  pg.background(100);
  pg.fill(255, 0, 0);
  pg.ellipse(pg.width *0.5, pg.height*0.5, 25, 25);
  pg.endDraw();

  image(pg, 0, 0);
  img.loadPixels();

  String b64 = DatatypeConverter.printBase64Binary(pixelsTobytes(img.pixels).getBytes());
  println(b64);
  //String s = encodeToBase64(img);
 // println(s);
}


public byte[] toByteArray(int value) {
    return new byte[] {
            (byte)(value >> 24),
            (byte)(value >> 16),
            (byte)(value >> 8),
            (byte)value};
}

public String pixelsTobytes (int[] px){
  String b = "";
  
  for (int i = 0 ; i < px.length; i++){
     b += toByteArray(px[i]).toString();
  }
  
  return b;
  
}
