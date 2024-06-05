.global main
main:

write_integers_to_memory:
    ldr r0, =0xFFFFFC00
    mov r1, #3072
    mov r2, #0x400000
    mov r3, #0

write_integers_to_memory_loop:
    str r0, [r2], #4

    add r0, r0, #1
    cmp r0, #0
    addeq r0, r0, #1

    add r3, r3, #1
    cmp r1, r3
    bne write_integers_to_memory_loop

configure_mmu:
// 교과서의 그림 8-10을 참고함
    ldr r0, =figure2  //figure3로 바꿔서 한 번 더 디버깅 함
    orr r0, r0, #0x5B
    mcr p15, 0, r2, c2, c0, 2

    mrc p15, 0, r2, c2, c0, 2
    bic r2, r2, #(1<<4)
    mcr p15, 0, r2, c2, c0, 2

    mrc p15, 0, r0, c1, c0, 0
    bic r0, r0, #(1<<12)
    bic r0, r0, #(1<<2)
    orr r0, r0, #(1<<0)
    mcr p15, 0, r0, c1, c0, 0


result:
    mov r0, #0x200000
    mov r1, #3072
    mov r2, #0
    mov r3, #0
result_loop:
    ldr r3, [r0], #4
    add r2, r2, r3
    add r3, r3, #1
    cmp r3, r1
    bne result_loop
    mov pc, lr
