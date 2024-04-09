#define LED_ADDRESS 0x41200000
#define SWITCH_ADDRESS 0x41210000
.global main
/*     r0: r1 주소에 저장되어 있는 값 (스위치 인풋)
       r1: SWITCH_ADDRESS
*/
 main:
 myloop:
       ldr r1, =SWITCH_ADDRESS /*r1 = 0x41210000*/
       ldr r0, [r1] /* 매 iteration마다 스위치 인풋 업데이트 */

       bl turn_on_leds
       b myloop
