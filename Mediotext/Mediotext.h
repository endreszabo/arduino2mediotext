#ifndef Mediotext_h
#define Mediotext_h

// library interface description
class Mediotext {
		public:
				void Setup(uint8_t row_pin_0, uint8_t row_pin_1, uint8_t row_pin_2, uint8_t blank_pin, uint8_t shift_data_pin, uint8_t shift_clk_pin, int refresh_interval, void (*user_function)(uint8_t));
				void set_refresh_interval(int refresh_interval);
				byte fb[12][7];
		private:
				void step_row();
				void set_row(uint8_t row);
				void (*update_function)(uint8_t row);
				uint8_t row_pin_0;
				uint8_t row_pin_1;
				uint8_t row_pin_2;
				uint8_t blank_pin;
				uint8_t shift_data_pin;
				uint8_t shift_clk_pin;
				uint8_t screen_row;

				int actual_row;
};

extern Mediotext Display;

#endif
