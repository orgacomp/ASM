extern printf
global _start

section .data
vec: dd 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
mensaje: db "La suma es: %d", 10, 0

section .text

; toma un vector de 16 enteros de 32 bits y los suma
_start:
    mov eax, 0
    mov rbx, vec
    mov ecx, 16
    .suma:
        add eax, [rbx]
        add rbx, 4
        dec ecx
        cmp ecx, 0
        jne .suma

    mov rdi, mensaje
    mov esi, eax
    mov eax, 0 ; cantidad de argumentos float
    
    call printf
    
    ; exit
    mov rax, 60
    mov rdi, 0
    syscall


