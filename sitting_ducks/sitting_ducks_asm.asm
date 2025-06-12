extern malloc
global sitting_ducks_asm

section .text

sitting_ducks_asm:
    push rbp
    mov rbp, rsp
    push r12 ;str
    push r13 ;marker
    push r14 ; len
    sub rsp, 8 ; align stack


    mov r12, rdi ; str
    mov r13b, sil

    xor r14, r14
; calcular len de str
.loop:
    mov cl, [rdi + r14] 
    cmp cl, 0
    je .alloc
    inc r14
    jmp .loop

; alocar memoria
.alloc:
    mov rdi, r14
    inc rdi
    call malloc 

; reemplazar caractes que no sean marker por guion
    xor rcx, rcx
.for:
    cmp rcx, r14
    je .done
    mov dl, [r12 + rcx]
    cmp r13b, dl
    je .copy
    mov byte [rax + rcx], '_'
    inc rcx
    jmp .for
.copy:
    mov [rax + rcx], dl
    inc rcx
    jmp .for

.done:
    mov byte [rax + rcx], 0 

    add rsp, 8
    pop r14 
    pop r13
    pop r12 
    pop rbp
    ret
