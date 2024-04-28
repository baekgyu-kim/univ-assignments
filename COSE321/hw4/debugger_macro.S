#include "uart_init.s"

.macro DEBUGGER_MACRO

    UART_init


    ldr    r0, =uart_Channel_sts_reg0
    ldr r4, =uart_TX_RX_FIFO0

//----------------------------------------------------------
    ldr    r1, =r0
TX_first_loop0:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_first_loop0

    ldrb r3, [r1], #1

    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_first_loop0

    ldr r6, [sp, #0]
    and r7, r6, #0xff000000
    lsr r7, #24

TX_second_loop0:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_second_loop0

    strb r7, [r4]

    ldr r6, [sp, #0]
    and r7, r6, #0x00ff0000
    lsr r7, #16

TX_third_loop0:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_third_loop0

    strb r7, [r4]

    ldr r6, [sp, #0]
    and r7, r6, #0x0000ff00
    lsr r7, #8

TX_fourth_loop0:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_fourth_loop0

    strb r7, [r4]

    ldr r6, [sp, #0]
    and r7, r6, #0x00000ff

TX_fifth_loop0:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_fifth_loop0

    strb r7, [r4]

//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r1
    ldr    r0, =uart_Channel_sts_reg0
TX_loop1:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop1

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop1
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r2
    ldr    r0, =uart_Channel_sts_reg0
TX_loop2:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop2

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop2
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r3
    ldr    r0, =uart_Channel_sts_reg0
TX_loop3:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop3

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop3
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r4
    ldr    r0, =uart_Channel_sts_reg0
TX_loop4:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop4

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop4
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r5
    ldr    r0, =uart_Channel_sts_reg0
TX_loop5:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop5

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop5
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r6
    ldr    r0, =uart_Channel_sts_reg0
TX_loop6:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop6

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop6
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r7
    ldr    r0, =uart_Channel_sts_reg0
TX_loop7:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop7

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop7
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r8
    ldr    r0, =uart_Channel_sts_reg0
TX_loop8:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop8

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop8
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r9
    ldr    r0, =uart_Channel_sts_reg0
TX_loop9:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop9

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop9
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r10
    ldr    r0, =uart_Channel_sts_reg0
TX_loop10:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop10

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop10
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r11
    ldr    r0, =uart_Channel_sts_reg0
TX_loop11:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop11

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop11
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r12
    ldr    r0, =uart_Channel_sts_reg0
TX_loop12:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop12

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop12
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r13
    ldr    r0, =uart_Channel_sts_reg0
TX_loop13:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop13

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop13
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r14
    ldr    r0, =uart_Channel_sts_reg0
TX_loop14:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop14

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop14
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =r15
    ldr    r0, =uart_Channel_sts_reg0
TX_loop15:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop15

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop15
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =cpsr
    ldr    r0, =uart_Channel_sts_reg0
TX_loop16:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop16

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop16
//----------------------------------------------------------
//----------------------------------------------------------
    ldr    r1, =ARM_mode
    ldr    r0, =uart_Channel_sts_reg0
TX_loop17:
    ldr r2, [r0]
    and    r2, r2, #0x8
    cmp    r2, #0x8
    bne    TX_loop17

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]
    cmp  r3, #0x00
    bne  TX_loop17
//----------------------------------------------------------

.data
r0:
    .ascii "r0"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r1:
    .byte 0x2C
    .byte 0x20
    .ascii "r1"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r2:
    .byte 0x2C
    .byte 0x20
    .ascii "r2"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r3:
    .byte 0x2C
    .byte 0x20
    .ascii "r3"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r4:
    .byte 0x2C
    .byte 0x20
    .ascii "r4"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r5:
    .byte 0x2C
    .byte 0x20
    .ascii "r5"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r6:
    .byte 0x2C
    .byte 0x20
    .ascii "r6"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r7:
    .byte 0x2C
    .byte 0x20
    .ascii "r7"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r8:
    .byte 0x2C
    .byte 0x20
    .ascii "r8"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r9:
    .byte 0x2C
    .byte 0x20
    .ascii "r9"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r10:
    .byte 0x2C
    .byte 0x20
    .ascii "r10"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r11:
    .byte 0x2C
    .byte 0x20
    .ascii "r11"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r12:
    .byte 0x2C
    .byte 0x20
    .ascii "r12"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r13:
    .byte 0x2C
    .byte 0x20
    .ascii "r13"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r14:
    .byte 0x2C
    .byte 0x20
    .ascii "r14"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

r15:
    .byte 0x2C
    .byte 0x20
    .ascii "r15"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

cpsr:
    .byte 0x2C
    .byte 0x20
    .ascii "cpsr"
    .byte 0x20
    .byte 0x3D
    .byte 0x00

ARM_mode:
    .byte 0x2C
    .byte 0x20
    .ascii "IF, ARM mode, current mode"
    .byte 0x20
    .byte 0x3D
    .byte 0x00




.text
.align 4
.endm

