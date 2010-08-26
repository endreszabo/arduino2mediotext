#include <TimerOne.h>
#include "c64font.h"
#include <avr/pgmspace.h>

// write your scroll text here
#include "WProgram.h"
void stepRow();
void setRow(byte row);
void setup();
void updateFb(int row);
void loop();
const char* SCROLLTEXT = 
"hspbp.org hackerspace budapest";

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
const prog_uint8_t C64_CHAR[] PROGMEM = { C64_FONT_DATA };


byte fb[12][7];

byte screenRow;
int dataPin=13;
int clockPin=12;

void stepRow() {
  screenRow++;
  if (screenRow == 7) {
    screenRow = 0;
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
  Timer1.initialize(1500);
  for (i = 8; i <= 13; i++) {
    pinMode(i, OUTPUT);
  }
  Timer1.attachInterrupt(stepRow);
}
int x,y,o;
int loopCount=0;

void updateFb(int row) {
  if ((row==0) && (loopCount>=16)) {
    loopCount=0; o++;
      for (byte b = 0; b<12; b++) {
        for (byte i = 0; i<7; i++) {
          fb[b][i]=(pgm_read_byte_near(C64_CHAR + FONT_OFFSET + i+(SCROLLTEXT[o/8+b]-96)*8)<<o%8)+
          (pgm_read_byte_near(C64_CHAR + FONT_OFFSET + i+(SCROLLTEXT[o/8+b+1]-96)*8)>>(8-o%8));
        }
      }
    if (o>20*8) {o=0;};
  }
  loopCount++;
}

void loop() {
}

int main(void)
{
	init();

	setup();
    
	for (;;)
		loop();
        
	return 0;
}

