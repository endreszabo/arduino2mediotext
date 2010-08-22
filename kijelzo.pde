#include <TimerOne.h>
#include <c64font.h>
#include <avr/pgmspace.h>

const char* SCROLLTEXT = "**** commodore 64 basic v2 **** "
                         "64k ram system "
                         " 38911 basic bytes free  ready. ";
const prog_uint8_t C64_CHAR[] PROGMEM = { C64_FONT_DATA };

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

byte row;
int dataPin=13;
int clockPin=12;
int incomingByte=0;

void stepRow() {
  if (row != 7) {
    row++;
    if (row == 7) {
      row = 0;
    }
  }
  setRow(row);
}

void setRow(byte row) {
  digitalWrite(8,row&1);
  digitalWrite(9,row&2);
  digitalWrite(10,row&4);
}

void setup () {
//  Serial.begin(9600);
  Timer1.initialize(100);
  for (int i = 8; i <= 13; i++) {
    pinMode(i, OUTPUT);
  }
  Timer1.attachInterrupt(stepRow);
}

void loop() {
  for (int col=0; col<16*7; col++) {
    row=7;
    stepRow();
    for (int b=0; b<12; b++) {
      if ((col/(b*8)) > 0){
        shiftOut(dataPin, clockPin, LSBFIRST, 255-(1<<(col%8)));
      } else {
        shiftOut(dataPin, clockPin, LSBFIRST, 255);
      }        
    }
    row=0;
//    delay(50);
  }
  
}
