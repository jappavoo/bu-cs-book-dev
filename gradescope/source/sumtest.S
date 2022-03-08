	.intel_syntax noprefix
	
	.section .text
	.global _start
_start:
test1:
	xor rax, rax
	mov QWORD PTR [SUM_POSITIVE], rax
	mov QWORD PTR [SUM_NEGATIVE], rax
	
	mov rbx, OFFSET data_start

	jmp SUM_FRAG
test2:	
	jmp SUM_FRAG
test3:	
	jmp SUM_FRAG
test4:
	jmp SUM_FRAG
	
	.section .data
data_start:
	.quad -1         
	.quad 1          
	.quad 54644566
	.quad -2233
data_end:
	.quad 0x0
