# Simple LED brightness and blink control system
*Media data link: [GoogleDrive]()*  
   
Hardware:   
    - ATTiny13A, ULN2003A;  
  
Software:  
    - CodeVisionAVR;  

You can find *.hex file in '..\project\Debug\Exe' folder  
  
 * simple PWM system with one button to control brightness in simple glow mode and frequency in smooth blinking mode
 * 
 * default mode after powering up - 'simple glow'
 * to switch mode to 'smooth blinking' - hold buttom and turn on power, then release button
 *
 * in 'simple glow' mode hold button and wait for a second: after short blinking brightness change will occure. To invert brightness change - repeat this prosedure.
 * in 'smooth blinking' mode hold button and wait for a second: after short blinking frequency change will occure. To invert blinking frquency change - repeat this prosedure.
 * max brightness in 'smooth blinking' will apply from settings in 'simple glow' mode. Min brightness in 'smooth blinking' mode is 0.
 *
 * after ~5 sec after last change (frquency or brightness) short blink will occure: that's indication of saved settings to EEPROM memory of MCU:
 * next time PWM and blink frequency (after next power up) will apply from EEPROM memory.

