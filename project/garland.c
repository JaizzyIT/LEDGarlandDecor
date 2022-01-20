/*
 * garland.c
 *
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
 *
 * Created: 12-Dec-21 17:41:43
 * Author: JaizzY
 */

#include <io.h>
#include <delay.h>
#include <bits_macros.h>
#include <stdint.h> 
#include <eeprom.h>

#define BASIC_BRIGHT 100
#define MAX_BRIGHT 240										//~ 94% of power source (255 - max)
#define MIN_BRIGHT 1
#define HALF_BRIGHT MAX_BRIGHT/2
#define BRIGHT_RANGE (MAX_BRIGHT - MIN_BRIGHT)

#define BASIC_FREQ 20
#define MAX_FREQ 255
#define MIN_FREQ 2
#define FREQ_RANGE (MAX_FREQ - MIN_FREQ)

#define MAX_PAUSE 7000
#define MIN_PAUSE 100 
#define PAUSE_RANGE (MAX_PAUSE - MIN_PAUSE)

#define RANGE_RATE_FQ_PS (PAUSE_RANGE/FREQ_RANGE)
#define RANGE_RATE_BR_PS (PAUSE_RANGE/BRIGHT_RANGE)

#define BUTTON 3

#define CHANGE_RATE 75					
#define BUTT_TMIER_TOP 2500
#define EEPROM_TIMER_TOP 30000
#define TRUE 1
#define FALSE 0

#define PWM_STOP 0b00000011
#define PWM_START 0b00100011 //OC0B					//0b00100011 - OC0B, 0b10000011 - OC0A

uint8_t brightness, brightness_prev, blink_max_bright;
uint8_t frequency, frequency_prev;
uint8_t EEMEM eeprom_bright;
uint8_t EEMEM eeprom_freq;
uint16_t butt_timer;
uint16_t pause_timer;
uint16_t blink_timer;
uint16_t eeprom_timer;
uint16_t change_timer;
uint16_t pause_top;
uint16_t br_to_ps_range;

_Bool bright_increase = FALSE;
_Bool freq_increase = FALSE;
_Bool butt_pressed = FALSE;
_Bool blink = FALSE;
_Bool LED_change = FALSE;
_Bool save_to_eeprom = FALSE;
_Bool pause = FALSE;

interrupt [TIM0_OVF] void timer2_ovf_int (void){
	if (butt_pressed){
		if (butt_timer < BUTT_TMIER_TOP) butt_timer++;
	}
	
	if (blink){
		if (blink_timer < frequency) blink_timer++;	
	}

	if (LED_change){
		if (change_timer < CHANGE_RATE) change_timer++;	
	}
	
	if (save_to_eeprom){
		if (eeprom_timer < EEPROM_TIMER_TOP) eeprom_timer++;
	}
	
	if (pause){
		if (pause_timer < pause_top) pause_timer++;	
	}
}

void pause_calc (void){														//pause in blinking mode (when output == 0) for more even blinking
	if (brightness_prev < HALF_BRIGHT) {
		pause_top = ((((frequency - MIN_FREQ) * RANGE_RATE_FQ_PS) + MIN_PAUSE) + br_to_ps_range) >> 1;
	}
	else pause_top = (((frequency - MIN_FREQ) * RANGE_RATE_FQ_PS) + MIN_PAUSE);
}

void main(void)
{
	DDRB = 0b00000011;														//B0 - out, PWM channel A; button pin B3
	PORTB = 0b00001000;														//butt pin pull-up
	
	brightness = eeprom_read_byte(&eeprom_bright);							//rewriting from EEPROM to brightness	
	frequency = eeprom_read_byte(&eeprom_freq);	 
	
	if (brightness > MAX_BRIGHT) {											//if eeprom is reset rewriting default brightness from EEPROM to 'brightness'	 
		brightness = BASIC_BRIGHT;
		eeprom_write_byte(&eeprom_bright, brightness);
	}
	
	brightness_prev = brightness;
	frequency_prev = frequency;
	
	if (brightness >= MAX_BRIGHT - 50) bright_increase = TRUE;				//decide in wich way brightness/frewuency will change
	if (brightness <= MIN_BRIGHT + 50) bright_increase = FALSE;
	
	if (frequency >= MAX_FREQ - 50) freq_increase = TRUE;
	if (frequency <= MIN_FREQ + 50) freq_increase = FALSE;
	
	br_to_ps_range = (((brightness_prev - MIN_BRIGHT) * RANGE_RATE_BR_PS) + MIN_PAUSE);
	pause_calc();
	
	while (BitIsClear(PINB, BUTTON)) blink = TRUE;							//change mode to 'smooth blink'
	
	TCCR0A = PWM_START;														//timer 0 - fast PWM, 8 bit, prescaler = 1 (~4687.5 Hz)
	TCCR0B = 0b00000001;	
	TIMSK0 = 0b00000010;													//timer 0 overflow interrupt enable	

	OCR0B = brightness;

	#asm("sei");
 
	while (1)
	{
		if (BitIsClear(PINB, BUTTON)) butt_pressed = TRUE;					
		else if (butt_pressed){
			butt_pressed = FALSE;
			butt_timer = 0;
			LED_change = FALSE;
			if ((brightness_prev != brightness) || (frequency_prev != frequency)) save_to_eeprom = TRUE;			
		}
	
		if (eeprom_timer == EEPROM_TIMER_TOP) {
			if (blink) {
				eeprom_write_byte(&eeprom_freq, frequency);
				frequency_prev = frequency;
			}
			else {
				eeprom_write_byte(&eeprom_bright, brightness);
				brightness_prev = brightness;	
			}
			
			eeprom_timer = 0;
			save_to_eeprom = FALSE;
			TCCR0A = PWM_STOP;
			delay_ms(20);
			TCCR0A = PWM_START;			
		}
	
		if (butt_pressed){											//brightness/frequency change processing
			if (butt_timer == BUTT_TMIER_TOP){
				if (!blink) bright_increase = !bright_increase;	
				else freq_increase = !freq_increase;	
				
				LED_change = TRUE;
				butt_timer++;
				eeprom_timer = 0;
				save_to_eeprom = FALSE;
				TCCR0A = PWM_STOP;
				delay_ms(10);
				TCCR0A = PWM_START;
			}
		}
	
		if (!blink){												//'simple glow' mode
			if (change_timer >= CHANGE_RATE){
				if (bright_increase == TRUE){
					if (brightness < MAX_BRIGHT) brightness++;
					else {
						TCCR0A = PWM_STOP;
						delay_ms(10);
						TCCR0A = PWM_START;						
					}
				}
				else{
					if (brightness > MIN_BRIGHT) brightness--;
					else {
						TCCR0A = PWM_STOP;
						delay_ms(30);
						TCCR0A = PWM_START;						
					}					
				}		
				OCR0B = brightness;		
				change_timer = 0;
			}
		}		
		else{														//'smooth blinking' mode
			if (blink_timer >= frequency){
				if (bright_increase == TRUE){
					if (brightness < brightness_prev) brightness++;
					else {
						pause = TRUE;
						if (pause_timer >= pause_top>>1){
							{
								bright_increase = FALSE;
								pause_timer = 0;
								pause = FALSE;
							}
						}
					}
				}
				else{
					if (brightness > 0) brightness--;
					else {
						TCCR0A = PWM_STOP;
						pause = TRUE;
						if (pause_timer >= pause_top){
							{
								TCCR0A = PWM_START;
								bright_increase = TRUE;
								pause_timer = 0;
								pause = FALSE;
							}
						}
					}
				}
				blink_timer = 0;
				OCR0B = brightness;		
			}
			
			if (change_timer >= CHANGE_RATE){
				if (freq_increase == TRUE){
					if (frequency < MAX_FREQ) frequency++;
					else{
						TCCR0A = PWM_STOP;
						delay_ms(30);
						TCCR0A = PWM_START;	
						}
					pause_calc();
				}
				else{
					if (frequency > MIN_FREQ) frequency--;
					pause_calc();
				}	
			 change_timer = 0;	
			}
		}
	}
}
