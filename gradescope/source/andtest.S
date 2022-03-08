	.intel_syntax noprefix
	.section .text
	.global _start
_start:
test1:
	mov rbx, OFFSET data_start
	mov rax, 0xdeadbeefdeadbeef
	jmp AND_FRAG
test2:	
	jmp AND_FRAG
test3:	
	jmp AND_FRAG

	.section .data
data_start:
	.quad -1                  # mask all bits
	.quad 0xaaaaaaaaaaaaaaaa  # every other bit
	.quad 0xF000F000F000F000
data_end:
	.quad 0x0
	
