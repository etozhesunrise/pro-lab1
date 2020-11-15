section .data
   higher db 'First element > 60, values changed to 240',10
   higher_size equ $ - higher

   lower db 'First element <= 60, values changed to 16',10
   lower_size equ $ - lower

   arr times 8 db 61
       times 8 db 2
       times 8 db 3
       times 8 db 4
       times 8 db 5
       times 8 db 6
       times 8 db 7
       times 8 db 8

   counter equ $ - arr

section .bss
   time resb 8

section .text
   global _start

%macro changeArrayValues 1
%%loop:
	mov eax, %1
	mov rbx, arr
	movd mm1, dword [rbx+r12*8]
	movd mm1, eax
	movd dword [rbx+r12*8], mm1
	inc r12
	cmp r12, counter
	jne %%loop
	emms
%endmacro

%macro printMSG 2
   mov rax, 1
   mov rdi, 1
   mov rsi, %1
   mov rdx, %2
   syscall
%endmacro

_start:
   rdtsc
   mov r8, rax
   mov r9, rdx

   call _compareValues

   rdtsc
   mov r10, rax
   mov r11, rdx

   call _calculateTime

   mov rax,60
   mov rdi,0
   syscall
   ret

_compareValues:
   mov al, [arr]
   cmp al, 60
   jg _greater

   call _lower
   ret

_calculateTime:
   shl r9, 32
   shl r11, 32
   or r9, r8
   or r11, r10
   sub r11, r9
   mov [time], r11

   mov rax, 1
   mov rdi, 1
   mov rsi, time
   mov rdx, 8
   syscall

   ret

_lower:
   printMSG lower, lower_size

   mov r12, 0
   changeArrayValues 16
   ret

_greater:
   printMSG higher, higher_size

   mov r12, 0
   changeArrayValues 240
   ret