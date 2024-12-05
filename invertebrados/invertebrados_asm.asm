%define LIST_FIRST_OFFSET 0
%define LIST_LAST_OFFSET 8
%define LIST_SIZE_OFFSET 16

%define NODE_NEXT_OFFSET 0
%define NODE_DATA_OFFSET 8

%define ANIMAL_INVERTEBRADO_OFFSET 8
%define ANIMAL_REGION_OFFSET 16

global get_invertebrados_por_region_asm
extern memset
extern malloc
extern strcmp

section .data:

NODE_PRINT: db "%d -> ", 0
NULL_PRINT: db "NULL", 10, 0


section .text


;uint8_t *get_invertebrados_por_region_asm(list_t* list, char* region){
get_invertebrados_por_region_asm:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push rbx ; list
    push r12 ; region
    push r13 ; array
    push r14 ; nodo
    push r15 ; i
    
    mov rbx, rdi ; list
    mov r12, rsi ; region
    ;uint8_t *invertebrados = malloc(list->size);
    movzx rdi , byte [rbx + LIST_SIZE_OFFSET]
    call malloc
    mov r13, rax

    ;memset(invertebrados, -1, list->size);
    mov rdi, r13
    mov rsi, -1
    movzx rdx , byte [rbx + LIST_SIZE_OFFSET]
    call memset

    ;node_t *actual = list->first;

    mov r14, [rbx + LIST_FIRST_OFFSET]   
    
    ;int i = 0;
    ;int j = 0;

    xor r15, r15
    mov [rbp -8], r15

    ;while(actual != NULL) {

    .while:
        cmp r14, 0
        je .end_while

        mov rdx, [r14 + NODE_DATA_OFFSET]
        cmp byte [rdx + ANIMAL_INVERTEBRADO_OFFSET], 0
        je .next

        mov rdi , [rdx + ANIMAL_REGION_OFFSET]
        mov rsi, r12
        call strcmp
        cmp rax, 0
        jne .next

        ;invertebrados[j++] = i;
        mov rcx, [rbp -8]
        mov [r13 + rcx], r15b
        inc byte [rbp - 8]

        ;actual = actual->next;
        .next:
        mov r14, [r14 + NODE_NEXT_OFFSET]
        inc r15
        jmp .while
    
    .end_while:
    
    ;return invertebrados;
    mov rax, r13
    
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    add rsp, 8
    pop rbp
    ret