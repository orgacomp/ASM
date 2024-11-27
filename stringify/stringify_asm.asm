%define LIST_FIRST_OFFSET 0
%define LIST_LAST_OFFSET 8
%define NODE_NEXT_OFFSET 0
%define NODE_DATA_OFFSET 8

global stringify_asm
extern fprintf

section .data:

NODE_PRINT: db "%d -> ", 0
NULL_PRINT: db "NULL", 10, 0


section .text

;void stringify_asm(FILE *fp, list_t* list);
stringify_asm:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    mov rbx, rdi
    mov r12, [rsi + LIST_FIRST_OFFSET]

    .loop:
        cmp r12, 0
        je .end

        mov rdi, rbx
        mov rsi, NODE_PRINT
        mov edx, [r12 + NODE_DATA_OFFSET]
        xor rax, rax
        call fprintf

        mov r12, [r12 + NODE_NEXT_OFFSET]
        jmp .loop
    
    .end:
        mov rdi, rbx
        mov rsi, NULL_PRINT
        xor rax, rax
        call fprintf
    
    pop r12
    pop rbx
    pop rbp
    ret