#include "debugger_macro.S"

.global main

main:
    /* Register
    r0: i
    r1: j
    r2: j+1
    r3: 32-i-2
    r4: Input_data 주소
    r5: Output_data 주소
    r6: input[j]
    r7: input[j+1]
    r8: save_to_output을 위한 index
    r9: save_to_output에서 하나씩 읽어올 레지스터
    */

    ldr r4, =Input_data   @ input_data의 시작 주소를 r4에 저장
    ldr r5, =Output_data  @ output_data의 시작 주소를 r5에 저장
    mov r0, #0 @ i = 0
    mov r8, #0 @ save_to_output 인덱스 = 0

outer_loop:
    sub sp, sp, #68
    str r0, [sp, #0]
    str r1, [sp, #4]
    str r2, [sp, #8]
    str r3, [sp, #12]
    str r4, [sp, #16]
    str r5, [sp, #20]
    str r6, [sp, #24]
    str r7, [sp, #28]
    str r8, [sp, #32]
    str r9, [sp, #36]
    str r10, [sp, #40]
    str r11, [sp, #44]
    str r12, [sp, #48]
    str r13, [sp, #52]
    str r14, [sp, #56]
    str r15, [sp, #60]
    mrs r0, CPSR
    str r0, [sp, #64]

    DEBUGGER_MACRO

    cmp r0, #31
    bgt save_to_output @ i == 31 까지만 실행
    mov r1, #0 @ j = 0
    rsb r3, r0, #30 @ r3 = 32-i-2

inner_loop:
    adds r2, r1, #1 @ r2 = j+1
    cmp r1, r3
    bgt back_to_outer_loop @ j == 30-i 까지만 실행
    ldr r6, [r4, r1, lsl #2]  @ r1 인덱스에 해당하는 input_data의 원소를 r6에 로드
    ldr r7, [r4, r2, lsl #2]  @ r2 인덱스에 해당하는 input_data의 원소를 r7에 로드
    cmp r6, r7
    bgt swap @ r6 > r7 이면 swap

back_to_inner_loop:
    adds r1, r1, #1
    b inner_loop @ 인덱스 하나 증가시키고 루프 반복

swap:
    str r7, [r4, r1, lsl #2]  @ r1 인덱스에 해당하는 input_data에 r7를 저장
    str r6, [r4, r2, lsl #2]  @ r2 인덱스에 해당하는 input_data에 r6를 저장
    adds r1, r1, #1
    b inner_loop @ 인덱스 하나 증가시키고 루프 반복

back_to_outer_loop:
    adds r0, r0, #1
    b outer_loop @ 인덱스 하나 증가시키고 루프 반복

save_to_output:
    cmp r8, #31
    bgt done @ Input_data의 모든 데이터를 Output_data로 모두 옮기면 과제 끝
    ldr r9, [r4, r8, lsl #2]  @ r8 인덱스에 해당하는 input_data의 원소를 r9에 로드
    str r9, [r5, r8, lsl #2]  @ r8 인덱스에 해당하는 output_data에 r9를 저장
    adds r8, r8, #1
    b save_to_output @ 인덱스 하나 증가시키고 루프 반복

done:
.data
.align 4
Input_data:
    .word 2, 0, -7, -1, 3, 8, -4, 10
    .word -9, -16, 15, 13, 1, 4, -3, 14
    .word -8, -10, -15, 6, -13, -5, 9, 12
    .word -11, -14, -6, 11, 5, 7, -2, -12

Output_data:
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, 0, 0, 0
    .word 0, 0, 0, 0, 0, 0, 0, 0
