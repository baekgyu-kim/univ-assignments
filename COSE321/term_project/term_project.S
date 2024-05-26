#include "csd_zynq_peripherals.h"

.extern task1_c
.extern task2_c
.extern task3_c

#define TIMER_INITIAL 100000

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

    //lab_interrupt_private_timer의 csd_arm.S 코드 사용
    cpsID i                    // Disable interrupt: CPSR'I = 1

    cps #0x12                  // IRQ mode
    ldr    r13,=irq_stack_top // Stack pointer setup for IRQ mode

    cps #0x13                  // supervisor mode
    ldr    r13,=svc_stack_top // Stack pointer setup for SVC mode

    // Set VBAR (Vector Base Address Register) to my vector table
    cps #0x1F                 // SYS mode
    ldr     r0, =csd_vector_table
    mcr     p15, 0, r0, c12, c0, 0
    dsb
    isb

    cpsIE i                    // Enable interrupt: CPSR'I = 0

    //system initialization in Supervisor mode
    cps #0x13

    //initialize task1
    ldr r13, =task1_tcb_top
    stmfd r13!, {r0-r14} // 현재 sp는 r0의 위치

    ldr r1, =task1_c
    str r1, [r13, #-4]

    mov r1, #0x10
    str r1, [r13, #-8]

    //initialize task2
    ldr r13, =task2_tcb_top
    stmfd r13!, {r0-r14} // 현재 sp는 r0의 위치

    ldr r1, =task2_c
    str r1, [r13, #-4]

    mov r1, #0x10
    str r1, [r13, #-8]

    //initialize task3
    ldr r13, =task3_tcb_top
    stmfd r13!, {r0-r14} // 현재 sp는 r0의 위치

    ldr r1, =task3_c
    str r1, [r13, #-4]

    mov r1, #0x10
    str r1, [r13, #-8]


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


// task1부터 시작
    ldr r0, =task_num
    mov r1, #1
    str r1, [r0]
    cps 0x10
    ldr sp, =task1_tcb_top
    b task1_c

// ----------------------------
// Interrupt Service Routines (ISRs) - Begin
// ----------------------------

csd_IRQ_ISR:
    ldr sp, =irq_stack_top

    stmfd sp!, {r0-r12, lr}
    mrs r0, spsr
    stmfd sp!, {r0, lr}


     // Interrupt Ack
      ldr r0, =GICC_IAR
    ldr r3, [r0]


    // status bit만 돌려놓고 끝
    ldr r0, =PRIVATE_STATUS
    mov r1, #1
    str r1, [r0]

     // End-of-Interrupt
      ldr r0, =GICC_EOIR
    str r3, [r0]

    ldr r0, =task_num
    ldr r1, [r0] // r1 = task number

    cmp r1, #1
    beq task2
    cmp r1, #2
    beq task3
    cmp r1, #3
    beq task1


task1:
    ldr r0, =task_num
    mov r1, #1
    str r1, [r0]

    //지금 하고있던 task3 정보를 task3의 tcb에 저장
    ldr r13, =task3_tcb_top
    stmfd r13!, {r0-r14} // 현재 sp는 r0의 위치

    ldr r1, =task1_c
    str r1, [r13, #-4]

    mov r1, #0x10
    str r1, [r13, #-8]

    //이제 task1 해야하니까 task1의 tcb에서 값 읽어옴
    ldr r13, =task1_tcb_top
    ldmdb r13!, {r0-r14}^

    //이렇게 하면 r14(lr)에는 task1_c 주소가 있을 것임
    ldr r14, [r13, #-4]

    adds pc, lr, #-4

task2:
    ldr r0, =task_num
    mov r1, #1
    str r1, [r0]

    //지금 하고있던 task1 정보를 task1의 tcb에 저장
    ldr r13, =task1_tcb_top
    stmfd r13!, {r0-r14} // 현재 sp는 r0의 위치

    ldr r1, =task1_c
    str r1, [r13, #-4]

    mov r1, #0x10
    str r1, [r13, #-8]

    //이제 task2 해야하니까 task2의 tcb에서 값 읽어옴
    ldr r13, =task2_tcb_top
    ldmdb r13!, {r0-r14}^

    //이렇게 하면 r14(lr)에는 task2_c 주소가 있을 것임
    ldr r14, [r13, #-4]

    adds pc, lr, #-4

task3:
    ldr r0, =task_num
    mov r1, #1
    str r1, [r0]

    //지금 하고있던 task2 정보를 task2의 tcb에 저장
    ldr r13, =task2_tcb_top
    stmfd r13!, {r0-r14} // 현재 sp는 r0의 위치

    ldr r1, =task2_c
    str r1, [r13, #-4]

    mov r1, #0x10
    str r1, [r13, #-8]

    //이제 task3 해야하니까 task3의 tcb에서 값 읽어옴
    ldr r13, =task3_tcb_top
    ldmdb r13!, {r0-r14}^

    //이렇게 하면 r14(lr)에는 task3_c 주소가 있을 것임
    ldr r14, [r13, #-4]

    adds pc, lr, #-4


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

task_num: .space 4

task1_tcb: .space 68 //r0-r14, lr, spsr 총 17개 register
task1_tcb_top:

task2_tcb: .space 68
task2_tcb_top:

task3_tcb: .space 68
task3_tcb_top:
