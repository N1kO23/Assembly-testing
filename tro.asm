global _start

section .data
  input: times 100 db 0
  hello db 'Welcome! Tell me your name.', 0xa
  hello_len equ $ - hello
  templ db 'Your input: '
  templ_len equ $ - templ
  nice_to_meet db 'Nice to meet you, '
  nice_to_meet_len equ $ - nice_to_meet

section .bss
  ea1_len resd 1
  dum resd 1

section .text

_start:
  mov eax, 4            ; set up call for SYS_WRITE
  mov ebx, 1            ; set up for STDOUT
  mov ecx, hello        ; pointer for template
  mov edx, hello_len    ; length of template
  int 0x80              ; call system for write

  mov eax, 4            ; set up call for SYS_WRITE
  mov ebx, 1            ; set up for STDOUT
  mov ecx, templ        ; pointer for template
  mov edx, templ_len    ; length of template
  int 0x80              ; call system for write

  mov eax, 3            ; set up call for SYS_READ
  mov ebx, 0            ; set up for STDIN
  mov ecx, input        ; pointer for input
  mov edx, 100          ; length of input
  int 0x80              ; call system for read

  mov [ea1_len], eax    ; store length of input string
  cmp eax, edx          ; if length of input string is greater than 100
  jb _end               ; jump to end
  mov bl,[ecx+eax-1]    ; else, store last character of input string
  cmp bl, 10            ; if last character of input string is LF
  jne _end              ; jump to end
  inc DWORD [ea1_len]   ; else, increment length of input string

_buf_clear: 
  mov eax, 3            ; set up call for SYS_READ
  mov ebx, 0            ; set up for STDIN
  mov ecx, dum          ; pointer for buffer
  mov edx, 1            ; read 1 byte
  int 0x80              ; call SYS_READ
  cmp al, 0             ; if read byte is 0
  jz _end               ; jump to end
  mov al, [dum]         ; else, store read byte in buffer
  cmp al, 10            ; if read byte is LF
  je _buf_clear         ; if not, jump to the beginning of the loop

_end: 
  mov eax, 4            ; set up call for SYS_WRITE
  mov ebx, 1            ; set up for STDOUT
  mov ecx, nice_to_meet        ; pointer for user input data
  mov edx, nice_to_meet_len    ; set up pointer to length of input string
  int 0x80              ; call system for write

  mov eax, 4            ; set up call for SYS_WRITE
  mov ebx, 1            ; set up for STDOUT
  mov ecx, input        ; pointer for user input data
  mov edx, [ea1_len]    ; set up pointer to length of input string
  int 0x80              ; call system for write

  mov eax, 1            ; set up for call to exit
  mov ebx, 0            ; set exit status to 0
  int 0x80              ; call system for exit