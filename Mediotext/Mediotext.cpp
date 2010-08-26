#include <TimerOne.h>

#include "WProgram.h"
#include "Mediotext.h"

Mediotext::Setup(int row_pin_0, int row_pin_1, int row_pin_2, int blank_pin, int shift_data_pin, int shift_clk_pin, int refresh_interval, void (*update_function)(void)) {
	this->actual_row=0;
	this->row_pin_0=row_pin_0;
	this->row_pin_1=row_pin_1;
	this->row_pin_2=row_pin_2;
	this->blank_pin=blank_pin;
	this->shift_data_pin=shift_data_pin;
	this->shift_clock_pin=shift_clock_pin;
	
	Timer1.initialize(refresh_interval);
	pinMode(row_pin_0, OUTPUT);
	pinMode(row_pin_1, OUTPUT);
	pinMode(row_pin_2, OUTPUT);
	pinMode(blank_pin, OUTPUT);
	pinMode(shift_data_pin, OUTPUT);
	pinMode(shift_clk_pin, OUTPUT);
	Timer1.attachInterrupt(Mediotext::step_row);
}

void Mediotext::step_row() {
  screenRow--;
  if (screenRow < 0) {
    screenRow = 6;
  }
  digitalWrite(this->blank_pin,HIGH);
  this->update_function(actual_row); //call user defined function to update framebuffer.
                                     //It should be fast to complete in the interrupt i guess to not to be throttled
  for (byte rx=0; rx<12; rx++) {
    shiftOut(this->shift_data_pin, this->shift_clk_pin, MSBFIRST, 255-(fb[rx][this->actual_row]));
  }
  setRow(screenRow);
}

void Mediotext::set_row(byte row) {
  digitalWrite(this->row_pin_0,row&1);
  digitalWrite(this->row_pin_1,row&2);
  digitalWrite(this->row_pin_2,row&4);
  digitalWrite(this->blank_pin,LOW);
}

