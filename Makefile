ARDUINO_DIR  = /usr/share/arduino
ARDUINO_LIBS = LiquidCrystal Hardware TimerOne Mediotext
TARGET       = kijelzo
MCU          = atmega168
F_CPU        = 16000000
ARDUINO_PORT = /dev/ttyUSB*
include /usr/share/arduino/Arduino.mk

