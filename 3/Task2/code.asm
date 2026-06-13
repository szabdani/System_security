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
    ; creat syscall
    ; this syscall requires pathname on arg0 (%ebx) and mode on arg1 (%ecx)
    mov ebx,path ; mov path to registry
    ; permissions are a little tricky on pure assembly. we need to specify owner, group and public permissions
    ; in this case i used a online calculator to calculate the octal number of the desired permissions.
    ; 744 = owner has full rights (read, write and execute) while group and public only has read permissions
    ; according to the docs, if we dont specify permissions, the function will just use random bytes from the registry, which can cause
    ; unexpected behaviours.
    mov ecx, 0o744 ; move permissions number to registry
    mov eax, 8 ; creat syscall
    int 0x80 ; interruptor to call kernel
    mov ebx, eax ; creat syscalls return a unique file descriptor, which work as a guide to the created file.
    ; we pass directly this file descriptor to ebx so we can use it with the write syscall.

    ; write syscall
    ; this syscall requires unsigned file descriptor on arg0, buffer of char* on arg1, and size_t count on arg2 (%edx)
    mov ecx, greeting ; msg to be written
    mov edx, 6 ; bytes to write. every char is one byte, so we write 6 bytes.
    mov eax, 4 ; write syscall
    int 0x80

    ; finish the program
    mov eax, 1
    int 0x80
    ; ------------ End of file ------------
