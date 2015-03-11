#include <SoftwareSerial.h>
#include <SPI.h>
#include <SD.h>
SoftwareSerial mySerial(8, 9); //RX,TX

const int ledPin = 13; // the pin that the LED is attached to
//const int analogInPin = A0;
//const int analogOutPin = 9;
const int chipSelect = 4;
//int rx= 10;
//int tx= 11;
int sensor = 0;
int output = 0;
int i;  // for loop counter

byte incomingByte;      // a variable to read incoming serial data into
int count = 0;
int tcount = 0;

int att = 4;
int uscell = 5;
int verison = 6;
int sprint = 7;
int done = 0 ; // boolean 0 = false 1 = true
int newVal;
byte val[3];

void setup() 
{
  // initialize serial communication:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  mySerial.begin(9600);

  Serial.print("Initializing SD card...");
  // make sure that the default chip select pin is set to
  // output, even if you don't use it:
  pinMode(10, OUTPUT);
  // see if the card is present and can be initialized:
  if (!SD.begin(chipSelect)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    return;
  }
  Serial.println("card initialized.");
}

void loop() 
{
  
  tcount++;
  mySerial.listen();
  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  File dataFile = SD.open("datalog3.txt", FILE_WRITE);
    //******************************
    if (mySerial.available() > 0) {
    // read the oldest byte in the serial buffer:
    incomingByte = mySerial.read();
    Serial.print(" . . . . . ");
    Serial.print(incomingByte );
    delay(500);
    count = 0;  //set count to 0 for the first digit
    for (i = 0; i < 3; i++){val[i] = 0;
        Serial.print(i);//debug
    }
    Serial.println();Serial.println();Serial.println();
    Serial.print("*");
    while (done != 1){

      if (incomingByte != 10 || incomingByte != 13) {
        // Serial.print("*");
          val[count] = incomingByte;
          count++;
          if ( count > 0 && (incomingByte == 10 || incomingByte == 13   ))done = 1;
      }
    }
    int power = 1;
    newVal = 0;
    for (i = count ; i >=0; i--){
      newVal = newVal + ((val[i] - 48 ) * power);
      power = power * 10;
    }
   Serial.println(newVal);
  
    /*if (incomingByte != 13 || incomingByte != 10)Serial.print(incomingByte);
    //Serial.print("+");
    if (count % 16)Serial.println();
    analogWrite(ledPin, incomingByte);*/
   // delay (100);
    }
   if (dataFile) 
   {
 // if the file is available, write to it:
   // if (incomingByte != 13 || incomingByte != 10)dataFile.println(incomingByte);
    dataFile.close();
    delay (500);
   }
  // if the file isn't open, pop up an error:
  else {
    Serial.println("error opening datalog.txt");
  }
  }
  
  
    //******************************
  // see if there's incoming serial data:
  
  //******************************* THIS WAY WORKS
  /*
  if (Serial.available() > 0) {
    // read the oldest byte in the serial buffer:
    incomingByte = Serial.read();
       if (incomingByte == 10)Serial.print("-------------------- ");
    if (incomingByte == 13)Serial.print("********************* ");
    Serial.print(incomingByte);
    Serial.print(" - ");
    if (count % 16)Serial.println();
    analogWrite(ledPin, incomingByte);
  }*/
