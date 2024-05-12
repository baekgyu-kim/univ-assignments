#include "csd_zynq_peripherals.h"
#include "uart_init.s"

#define    TIMER_INITIAL    0x1000000

.align 5

csd_vector_table:
    b .
    b .
    b .
    b .
    b .
    b .
    b csd_IRQ_ISR
    b .


.global main
main:

    // init uart
    UART_init

    //00:00:00 출력
    bl print

    // Disable interrupt: CPSR'I = 1
    cpsID i


    cps #0x12                  // IRQ mode
    ldr    r13,=irq_stack_top // Stack pointer setup for IRQ mode

    cps #0x13                  // supervisor mode
    ldr    r13,=svc_stack_top // Stack pointer setup for SVC mode

    cps #0x11                  // FIQ mode
    ldr    r13,=fiq_stack_top // Stack pointer setup for FIQ mode

    cps #0x1F                 // SYS mode

    // Set VBAR (Vector Base Address Register) to my vector table
    ldr     r0, =csd_vector_table
    mcr     p15, 0, r0, c12, c0, 0
    dsb
    isb

    // Enable interrupt: CPSR'I = 0
    cpsIE i

// ---------------------------
// Generic Interrupt Controller (GIC) setup - Begin
// ---------------------------

    // CPU Interface ID Register
    ldr r0, =GICC_IIDR
    ldr r3, [r0]

    // CPU Controller Type Register
    ldr r0, =GICD_TYPER
    ldr r3, [r0]

    // CPU Binary Pointer Register
    ldr r0, =GICC_BPR
    ldr r3, [r0]

    // Distributor Control Register
    ldr r0, =GICD_CTLR
    ldr r1, [r0]
    mov r2, #1       // Enable
    orr r1, r1, r2
    str r1, [r0]
    ldr r3, [r0]

     // Interrupt Set-Enable Register 0
    ldr r0, =GICD_ISENABLER0
    ldr r1, [r0]
    mov r2, #1 << 29   // Enable #29 (Private Timer)
    orr r1, r1, r2
    str r1, [r0]
    ldr r3, [r0]

    // According to specifications,
    // Cortex-A9 supports 5-bit version of priority format [7:3] in secure world
    // ( 0 -> 8 -> 16 -> 24...)

    // Interrupt Priority Register #7
    ldr r0, =GICD_PRIOR7
    ldr r1, [r0]
    mov r2, #0x10 << 8    // Priority 16 for ID# 29 (Private Timer)
    orr r1, r1, r2
    str r1, [r0]
    ldr r3, [r0]

    // CPU Interface Control Register
    ldr r0, =GICC_CTLR
    ldr r1, [r0]
    mov r2, #1        // Enable
    orr r1, r1, r2
    str r1, [r0]
    ldr r3, [r0]

     // CPU Interface Interrupt Priority Mask Register
    ldr r0, =GICC_PMR
    ldr r1, [r0]
    mov r2, #0xFF     // Lowest
    orr r1, r1, r2
    str r1, [r0]
    ldr r3, [r0]

// ---------------------------
// Generic Interrupt Controller (GIC) setup - End
// ---------------------------


// ---------------------------
// Private Timer setup - Begin
// ---------------------------

     // Private Timer Load Register
    ldr r0, =PRIVATE_LOAD
     ldr r1, =TIMER_INITIAL
     str r1, [r0]

     // Private Timer Control Register
      ldr r0, =PRIVATE_CONTROL
     mov r1, #10 << 8   // Prescalar
     orr r1, r1, #7     // IRQ Enable, Auto-Reload, Timer Enable
     str r1, [r0]

// ----------------------------
// Private Timer setup - End
// ----------------------------

     // Check out the counter value to make sure the counter is decrementing
    ldr r0, =PRIVATE_COUNTER
    ldr r1, [r0]
    ldr r2, [r0]
    ldr r3, [r0]
    ldr r4, [r0]
    ldr r5, [r0]
    ldr r6, [r0]
    ldr r7, [r0]
    ldr r8, [r0]

    ldr r0, =PRIVATE_COUNTER
    ldr r1, =PRIVATE_STATUS
    ldr r2, =GICD_ISPENDR0

forever:
    ldr r5, [r0]
    ldr r6, [r1]
    ldr r7, [r2]
    b forever


// ----------------------------
// Interrupt Service Routines (ISRs) - Begin
// ----------------------------

csd_IRQ_ISR:

    stmfd sp!, {r0-r12, lr}

     // Interrupt Ack
      ldr r0, =GICC_IAR
    ldr r3, [r0]

    stmfd sp!, {r3}

    ldr r0, =time
    bl add_one_second

    bl print

    ldmfd sp!, {r3}

     // Clear Interrupt Status bit
      ldr r0, =PRIVATE_STATUS
      mov r1, #1
    str r1, [r0]

     // End-of-Interrupt
      ldr r0, =GICC_EOIR
    str r3, [r0]

    ldmfd sp!, {r0-r12, lr}
    subs pc, lr, #4


//UART 출력을 위한 코드 (교수님의 uart_hello_macro.7z 파일에서 수정함)
print:

    ldr r1, =time
    ldr    r0, =uart_Channel_sts_reg0

TX_loop:
    // ---------  Check to see if the Tx FIFO is empty ------------------------------
    ldr r2, [r0]        // read Channel Status Register
    and    r2, r2, #0x8    // read Transmit Buffer Empty bit(bit[3])
    cmp    r2, #0x8        // check if TxFIFO is empty and ready to receive new data
    bne    TX_loop            // if TxFIFO is NOT empty, keep checking until it is empty
    //------------------------------------------------------------------------------

    ldrb r3, [r1], #1
    ldr  r4, =uart_TX_RX_FIFO0
    strb r3, [r4]    // fill the TxFIFO with 0x48
    cmp  r3, #0x00
    bne  TX_loop
    moveq  pc, lr        // return to the caller

    b print


// ----------------------------
// Interrupt Service Routines (ISRs) - End
// ----------------------------

.data
.align 4

irq_stack:     .space 1024
irq_stack_top:
fiq_stack:     .space 1024
fiq_stack_top:
svc_stack:     .space 1024
svc_stack_top:

time:
    .space 10
    .byte 0x0D
    .ascii "00:00:00"
    .byte 0x00
