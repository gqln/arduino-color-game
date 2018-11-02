import processing.serial.*;
import processing.sound.*;

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
int end = 10;

// Sound :)
SinOsc sin;

// Did we solve the puzzle?
boolean solved = false;
int solvedCycles = 1000;
 
// First puzzle is sea green
float targetRed = random(255);
float targetGreen = random(255);
float targetBlue = random(255);

void setup()
{
  size(800, 800);
  
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  myPort.clear();
  val = myPort.readStringUntil (end);
  val = null;
  
  sin = new SinOsc(this);

  sin.play();
}

void draw()
{
  background(0);
  stroke(255);  
  
  while ( myPort.available() > 0)  {        // If data is available,
    val = myPort.readStringUntil(end);      // read it and store it in val
  } 
  
  
  if (val != null) { 
    String[] SensorInput = split(val, ',');
    int PRInt [];
    PRInt = int(SensorInput);
    
    // Calcualte rgb from Serial
    float red = (255*PRInt[0]/1500);
    float green = (255*PRInt[1]/1500);
    float blue = (255*PRInt[2]/1500);
    
    color bg = color(red, green, blue);
    
    // Adjust rgb to [0, 255]
    red = (bg & 16711680) >> 16;
    green = (bg & 65280) >> 8;
    blue = (bg & 255);
    
    // Calculate score
    float scoreRed = pow(targetRed - red, 2.0);
    float scoreGreen = pow(targetGreen - green, 2.0);
    float scoreBlue = pow(targetBlue - blue, 2.0);
    float score = pow(scoreRed + scoreGreen + scoreBlue, 0.5);
    
     // A new puzzle
     if (solved) {
      solved = false;
      score = 255;
      delay(3000);
      
      sin.freq(375);
      sin.amp(1.0);
      sin.pan(1.0);
      
      targetRed = random(255);
      targetGreen = random(255);
      targetBlue = random(255);
    }
    
    // Margin of error
    if (score < 49) {
      println("SOLVED");
      solved = true;
      
      color targetColor = color(targetRed, targetGreen, targetBlue);
      background(targetColor);
    } else {
      // Set background to user's color
      background(bg);
      solved = false;
    }
    
    rectMode(CENTER);
    fill(targetRed, targetGreen, targetBlue);
    rect(400, 400, 400, 400, 7);
    
    float freq = red + green;
    float amp = green/(green + blue) + 0.0000000001;
    float pos = (red - blue)/(red + blue);
    
    sin.freq(freq);
    sin.amp(amp);
    sin.pan(pos);
  }
}
