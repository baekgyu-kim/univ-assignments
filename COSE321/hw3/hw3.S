#define LED_ADDRESS 0x41200000
#define SWITCH_ADDRESS 0x41210000
.global main
/*     r0: r1 �ּҿ� ����Ǿ� �ִ� �� (����ġ ��ǲ)
       r1: SWITCH_ADDRESS
*/
 main:
 myloop:
       ldr r1, =SWITCH_ADDRESS /*r1 = 0x41210000*/
       ldr r0, [r1] /* �� iteration���� ����ġ ��ǲ ������Ʈ */

       bl turn_on_leds
       b myloop