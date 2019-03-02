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

// AttnGan
// Send HTTP Data to Runway


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;


final String httpDataRoute = "http://localhost:8007/query"; // set to the Runway HTTP route


void setup() {
  size (600, 400);
  noFill();
  stroke(0);
}

void draw () {   
  background(0);
}

void mousePressed() {
  try {
    post("dog");
  }
  catch (Exception e) {
  }
}

void post(String caption) throws IOException {

  final String POST_PARAMS = "{\n" + 
    "    \"caption\": \"" + caption +"\""+ "\n}";
  System.out.println(POST_PARAMS);
  URL obj = new URL(httpDataRoute);
  HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
  postConnection.setRequestMethod("POST");
  //postConnection.setRequestProperty("userId", "a1bcdefgh");
  postConnection.setRequestProperty("Content-Type", "application/json");
  postConnection.setDoOutput(true);
  OutputStream os = postConnection.getOutputStream();
  os.write(POST_PARAMS.getBytes());
  os.flush();
  os.close();
  int responseCode = postConnection.getResponseCode();
  System.out.println("POST Response Code :  " + responseCode);
  System.out.println("POST Response Message : " + postConnection.getResponseMessage());
  if (responseCode == HttpURLConnection.HTTP_CREATED) { //success
    BufferedReader in = new BufferedReader(new InputStreamReader(
      postConnection.getInputStream()));
    String inputLine;
    StringBuffer response = new StringBuffer();
    while ((inputLine = in .readLine()) != null) {
      response.append(inputLine);
    } 
    in .close();
    // print result
    System.out.println(response.toString());
  } else {
    System.out.println("POST NOT WORKED");
  }
}
