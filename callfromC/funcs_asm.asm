section .text
global sumar_asm

;void sumar_asm(int *a, int*b, int *c, int length);
sumar_asm:

    .ciclo:
        mov eax, [rdi]
        add eax, [rsi]
        mov [rdx], eax
        add rdi, 4
        add rsi, 4
        add rdx, 4
        sub ecx, 1
        jnz .ciclo

