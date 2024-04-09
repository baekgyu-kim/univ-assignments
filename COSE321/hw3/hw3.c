#include <unistd.h>
void turn_on_leds(unsigned switch_input){
       char switch7 = (switch_input>>7) & 1;
       char switch6 = (switch_input>>6) & 1;
       char switch5 = (switch_input>>5) & 1;
       char switch4 = (switch_input>>4) & 1;
       char switch3 = (switch_input>>3) & 1;
       char switch2 = (switch_input>>2) & 1;
       char switch1 = (switch_input>>1) & 1;
       char switch0 = (switch_input>>0) & 1;

       int duration_mode = 9;
       if(switch7 == 1){
             duration_mode = 7;
       }else if(switch6 == 1){
             duration_mode = 6;
       }else if(switch5 == 1){
             duration_mode = 5;
       }else if(switch4 == 1){
             duration_mode = 4;
       }else if(switch3 == 1){
             duration_mode = 3;
       }else if(switch2 == 1){
             duration_mode = 2;
       }else if(switch1 == 1){
             duration_mode = 1;
       }else if(switch0 == 1){
             duration_mode = 0;
       }

       unsigned char arr[8] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};

       float duration_time = 0;
       if(duration_mode == 9){
             duration_time = 1000000.0;
       }else{
             duration_time = 1000000.0*(0.8-(duration_mode * 0.1));
       }

       unsigned char *led_address = (unsigned char *) 0x41200000;
       for(int i = 0; i < 8; i++){
             *led_address = arr[i];
             usleep(duration_time);
       }

       *led_address = 0x00;
}

