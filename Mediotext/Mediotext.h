#ifndef Mediotext_h
#define Mediotext_h

// library interface description
class Mediotext {
		public:
				setup(uint8_t row_pin_0, uint8_t row_pin_1, uint8_t row_pin_2, uint8_t blank_pin, uint8_t shift_data_pin, uint8_t shift_clk_pin, int refresh_intterval, void (*update_function)(void));
				void set_refresh_interval(int refresh_interval)
				byte fb[12][7];
		private:
				void step_row();
				void set_row(uint8_t row);
				uint8_t row_pin_0;
				uint8_t row_pin_1;
				uint8_t row_pin_2;
				uint8_t blank_pin;
				uint8_t shift_data_pin;
				uint8_t shift_clk_pin;

				int actual_row;
};

#endif
