#define LED_ADDRESS 0x41200000
#define SWITCH_ADDRESS 0x41210000
#include "csd_zynq_peripherals.h"

.extern toggle_led

.global main
main:

myloop:
    ldr r1, =SWITCH_ADDRESS
    ldr r0, [r1]

    and r0, r0, #0b1
    cmp r0, #0
    bleq disable
    blne enable


disable:
    @------------------------
    @ Disable Caches (L2)
    @------------------------
    ldr r0, =L2_reg1_ctrl
    mov r1, #0x0
    str r1, [r0]
    @------------------------
    @ Disable Caches (IL1, DL1)
    @------------------------
    mrc        p15, 0, r0, c1, c0, 0    @ read control register (CP15 register1)
    bic        r0, r0, #4096            @ disable I bit (Instruction Cache)
    bic        r0, r0, #4               @ disable C bit (Data and Unified Caches)
    mcr        p15, 0, r0, c1, c0, 0    @ write control register (CP15 register2)
    bl toggle_led
    b myloop

enable:
    @------------------------
    @ Enable Caches (L2)
    @------------------------
    ldr r0, =L2_reg1_ctrl
    mov r1, #0x1
    str r1, [r0]

    @------------------------
    @ Enable Caches (IL1, DL1)
    @------------------------
    mrc        p15, 0, r0, c1, c0, 0    @ read control register (CP15 register1)
    orr        r0, r0, #(1<<12)        @ Enable I bit (Instruction Cache)
    orr        r0, r0, #(1<<2)         @ Enable C bit (Data and Unified Caches)
    mcr        p15, 0, r0, c1, c0, 0    @ write control register (CP15 register2)
    bl toggle_led
    b myloop
