#include <Mediotext.h>
//#include <TimerOne.h>
#include "linux8x8.h"
#include <avr/pgmspace.h>

void stepRow();
void setRow(byte row);
void setup();
void updateFb(int row);
void loop();
const char* SCROLLTEXT = 
"            http://hspbp.org/ - Hackerspace Budapest            ";

// Depending from the offset you can display upper/lower/inverse
// characters 
// upper case characters 
const int FONT_OFFSET = 0x0000;                         
// upper case inverse characters 
// const int FONT_OFFSET = 0x0400;                         
// lower case characters 
// const int FONT_OFFSET = 0x0800;                         
// lower case inverse characters 
// const int FONT_OFFSET = 0x0c00;  
//unsigned int onTime=100;
const prog_uint8_t C64_CHAR[] PROGMEM = { FONTDATA };

byte fb[12][7];

int screenRow;
int dataPin=13;
int clockPin=12;

void stepRow() {
  screenRow--;
  if (screenRow < 0) {
    screenRow = 6;
  }
  digitalWrite(11,HIGH);
  updateFb(screenRow);
  for (byte rx=0; rx<12; rx++) {
    shiftOut(dataPin, clockPin, MSBFIRST, 255-(fb[rx][screenRow]));
  }
  setRow(screenRow);
}

void setRow(byte row) {
  digitalWrite(8,row&1);
  digitalWrite(9,row&2);
  digitalWrite(10,row&4);
  digitalWrite(11,LOW);
}

void setup() {
  byte b;
  byte i;

//  Serial.begin(9600);
//  Timer1.initialize(2200);
  for (i = 8; i <= 13; i++) {
    pinMode(i, OUTPUT);
  }
//  Timer1.attachInterrupt(stepRow);
}
int x,y,o;
int loopCount=0;

void updateFb(int row) {
//  if ((row==0) && (loopCount>=16)) {
  if (row==6) {
    loopCount=0; o++;
      for (byte b = 0; b<12; b++) {
        for (byte i = 0; i<7; i++) {
          fb[b][i]=(pgm_read_byte_near(C64_CHAR + FONT_OFFSET + i+(SCROLLTEXT[o/8+b]-32)*8)<<o%8)+
          (pgm_read_byte_near(C64_CHAR + FONT_OFFSET + i+(SCROLLTEXT[o/8+b+1]-32)*8)>>(8-o%8));
        }
      }
    if (o>((64-12)*8)) {o=0;};
  }
//  loopCount++;
}

void loop() {
}

