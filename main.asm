; assemble with "nasm -f bin -o hi.com test.asm"

section .data
hello_wrld db 'Hello, world!', 0xa        ;our dear string
hello_wrld_len equ $ - hello_wrld         ;length of our dear string
start db 'Starting program...', 0xa
start_len equ $ - start
credit db 'What is your credit card number: ', 0xa
credit_len equ $ - credit
hello db 'Hello, ', 0xa
hello_len equ $ - hello

input: times 100 db 0
lf: db 10

section .bss
  e1_len resd 1
  dummy resd 1

section .text
global _start 

_start: 

; Print the start messages

    mov edx, 3                  ;system call number (sys_read)
    mov ecx, 0                  ;file descriptor (stdin)
    mov ebx, input              ;pointer to input buffer
    mov eax, 100                ;length of input buffer
    int 80h                     ;call kernel

    mov edx, start_len          ;message length
    mov ecx, start              ;message to write
    mov ebx, 1                  ;file descriptor (stdout)
    mov eax, 4                  ;system call number (sys_write)
    int 0x80                    ;call kernel

    mov edx, hello_wrld_len     ;message length
    mov ecx, hello_wrld         ;message to write
    mov ebx, 1                  ;file descriptor (stdout)
    mov eax, 4                  ;system call number (sys_write)
    int 0x80                    ;call kernel

; Ask user for input

    mov edx, credit_len         ;message length
    mov ecx, credit             ;message to write
    mov ebx, 1                  ;file descriptor (stdout)
    mov eax, 4                  ;system call number (sys_write)
    int 0x80                    ;call kernel

    mov edx, 3                  ;system call number (sys_read)
    mov ecx, 0                  ;file descriptor (stdin)
    mov ebx, input              ;pointer to input buffer
    mov eax, 100                ;length of input buffer
    int 80h                     ;call kernel

    mov [e1_len], edx           ;save length of input
    cmp edx, eax                ;check if input is too long
    jl too_long                 ;if so, jump to too_long
    mov edx, 4                  ;system call number (sys_write)
    mov ecx, 1                  ;file descriptor (stdout)
    mov ebx, input              ;pointer to input buffer
    mov eax, [e1_len]           ;length of input buffer
    int 0x80                    ;call kernel
    

  too_long: 
    mov bl, [ebx+edx-1]         ;get last character of input
    cmp bl, 0x0a                ;check if last character is newline
    je too_long                 ;if so, jump to is_newline

; Print the user input and message

    mov edx, 100                ;message length
    mov ecx, input              ;message to write
    mov ebx, 1                  ;file descriptor (stdout)
    mov eax, 4                  ;system call number (sys_write)
    int 0x80                    ;call kernel

    mov ebx, 0                  ;process' exit code
    mov eax, 1                  ;system call number (sys_exit)
    int 0x80                    ;call kernel - this interrupt won't return