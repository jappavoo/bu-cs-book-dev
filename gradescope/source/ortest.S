	.intel_syntax noprefix
	.section .text
	.global _start
_start:
test1:
	mov rbx, OFFSET data_start
	xor rax, rax
	jmp OR_FRAG
test2:	
	jmp OR_FRAG
test3:	
	jmp OR_FRAG

	.section .data
data_start:
	.quad 1                  # lowest bit
	.quad 0x8000000000000000 # higest bit
	.quad 0x00000FFFFFF00000 # middle 12
data_end:
	.quad 0x0
