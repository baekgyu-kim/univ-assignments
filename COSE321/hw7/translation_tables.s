.globl figure2
.globl figure3

//�������� �׸� 8-9�� ������
figure2:
.set SECT, 0
.word    SECT + 0x15de6
.set    SECT, SECT+0x100000
.word    SECT + 0x15de6
.word    figure2_level2 + 0x1e1

figure3:
.set SECT, 0
.word    SECT + 0x15de6
.set    SECT, SECT+0x100000
.word    SECT + 0x15de6
.word    figure3_level2 + 0x1e1


//�������� �׸� 8-13�� ������
figure2_level2:
.word 0x40000002
.word 0x41000002
.word 0x42000002

figure3_level2:
.word 0x40000002
.word 0x42000002
.word 0x40000002
