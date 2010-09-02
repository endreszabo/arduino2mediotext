#include "TimerOne.h"

#include "WProgram.h"
#include "Mediotext.h"

Mediotext Display;

void Mediotext::Setup(uint8_t row_pin_0, uint8_t row_pin_1, uint8_t row_pin_2, uint8_t blank_pin, uint8_t shift_data_pin, uint8_t shift_clk_pin, int refresh_interval, void (*user_function)(uint8_t)) {
	this->actual_row=0;
	this->row_pin_0=row_pin_0;
	this->row_pin_1=row_pin_1;
	this->row_pin_2=row_pin_2;
	this->blank_pin=blank_pin;
	this->shift_data_pin=shift_data_pin;
	this->shift_clk_pin=shift_clk_pin;
	update_function=user_function;
	
	pinMode(row_pin_0, OUTPUT);
	pinMode(row_pin_1, OUTPUT);
	pinMode(row_pin_2, OUTPUT);
	pinMode(blank_pin, OUTPUT);
	pinMode(shift_data_pin, OUTPUT);
	pinMode(shift_clk_pin, OUTPUT);
	Timer1.initialize(refresh_interval);
	Timer1.attachInterrupt(step_row);
}

void Mediotext::step_row() {
  screen_row--;
  if (screen_row < 0) {
    screen_row = 6;
  }
  Display.update_function(actual_row); //call user defined function to update framebuffer.
                                     //It should be fast to complete in the interrupt i guess to not to be throttled
  digitalWrite(this->blank_pin,HIGH);
  for (byte rx=0; rx<12; rx++) {
    shiftOut(this->shift_data_pin, this->shift_clk_pin, MSBFIRST, 255-(fb[rx][this->actual_row]));
  }
  set_row(screen_row);
}

void Mediotext::set_row(byte row) {
  digitalWrite(this->row_pin_0,row&1);
  digitalWrite(this->row_pin_1,row&2);
  digitalWrite(this->row_pin_2,row&4);
  digitalWrite(this->blank_pin,LOW);
}

