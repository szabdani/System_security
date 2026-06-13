; define some macros
%define O_RDONLY    00000000o
%define O_WRONLY    00000001o
%define O_RDWR      00000002o
%define O_CREAT     00000100o
%define O_TRUNC     00001000o
%define S_IRUSR     00000400o
%define S_IWUSR     00000200o

section .data
path: db "/home/user/message", 0
greeting: db "himum!", 0

section .text
global _start

_start:
    ;----------------------------------

    ; Open the file
    mov eax, 5                  ; sys_open: 0x05
    mov ebx, path               ; filename: pointer to the filepath string
    mov ecx, O_WRONLY | O_CREAT ; flags: combine write-only and create macros
    mov edx, S_IRUSR | S_IWUSR  ; mode: read and write permission for user
    int 0x80                    ; call kernel
    
    ; The file descriptor is returned into EAX.
    ; Move it to EBX for writing.
    mov ebx, eax            

    ; Write the message to the file
    mov eax, 4              ; sys_write: 0x04
                            ; fd: already in ebx
    mov ecx, greeting       ; buf: pointer to the message string
    mov edx, 6              ; count: length of the string
    int 0x80                ; call kernel

    ; Close the file
    mov eax, 6              ; sys_close: 0x06
                            ; fd: still in ebx
    int 0x80                ; call kernel

    ; Exit the program
    mov eax, 1              ; sys_exit: 0x01
    xor ebx, ebx            ; error_code: 0
    int 0x80                ; call kernel

    ; ------------ End of file ------------