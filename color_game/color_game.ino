#include <CapacitiveSensor.h>

long redValue = 0.0;
long greenValue = 0.0;
long blueValue  = 0.0;

// Batch readings for smoother data
#define CYCLES 10

int cycles = 0;

// Sensors correspond to rgb
CapacitiveSensor   cs_red = CapacitiveSensor(2,3); // 1M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil
CapacitiveSensor   cs_green = CapacitiveSensor(4,5);
CapacitiveSensor   cs_blue = CapacitiveSensor(6,7);

void setup()                    
{
   // Capacitive sensor setup
   cs_red.set_CS_AutocaL_Millis(0xFFFFFFFF);// turn off autocalibrate on channel 1 - just as an example
   cs_green.set_CS_AutocaL_Millis(0xFFFFFFFF);
   cs_blue.set_CS_AutocaL_Millis(0xFFFFFFFF);
   Serial.begin(9600);

   // Output to LEDs
   pinMode(11,OUTPUT);
   pinMode(12,OUTPUT);
   pinMode(13,OUTPUT);
}

void loop()                    
{
  long red =  cs_red.capacitiveSensor(50);
  long green =  cs_green.capacitiveSensor(50);
  long blue =  cs_blue.capacitiveSensor(50);

  // LEDs
  digitalWrite(11, (red >= 1000) ? HIGH : LOW);
  digitalWrite(12, (green >= 1000) ? HIGH : LOW);
  digitalWrite(13, (blue >= 1000) ? HIGH : LOW);

  // Update rgb values
  redValue += red/CYCLES;
  greenValue += green/CYCLES;
  blueValue += blue/CYCLES;

  cycles++;

  // Batch data before sending to serial
  if (cycles == CYCLES) {
    Serial.print(redValue);
    Serial.print(",");
    Serial.print(greenValue);
    Serial.print(",");
    Serial.print(blueValue);
    Serial.print(",");
    Serial.println();
    cycles = 0;
    redValue = 0.0;
    greenValue = 0.0;
    blueValue = 0.0;
  }

}
