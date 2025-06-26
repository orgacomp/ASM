section .text
global listAddFirst_asm
extern getCloneFunction
extern malloc

%define LIST_TYPE 0
%define LIST_SIZE 4
%define LIST_FIRST 8
%define LIST_LAST 16

%define LIST_ELEM_DATA 0
%define LIST_ELEM_NEXT 8
%define LIST_ELEM_PREV 16
%define LIST_ELEM_SIZE 24

;void *listAddFirst_asm(list_t* list, void* data)

listAddFirst_asm:
    
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    sub rsp, 8

    mov r12, rdi ; r12 = list_t* list
    mov r13, rsi ; r13 = void* data

    mov rdi, LIST_ELEM_SIZE
    call malloc
    mov r14, rax ; r14 = nuevo nodo

    mov rdi, [r12 + LIST_TYPE]
    call getCloneFunction
    mov rdi, r13
    call rax
    
    mov [r14 + LIST_ELEM_DATA], rax
    mov rcx, [r12 + LIST_FIRST] 
    mov [r14 + LIST_ELEM_NEXT], rcx
    mov qword [r14 + LIST_ELEM_PREV], 0
    mov [r12 + LIST_FIRST], r14
    ; Si la lista estaba vacía, actualizo el último nodo
    cmp rcx, 0
    je .last
    ; Si la lista no está vacía, actualizo el nodo previo
    mov [rcx + LIST_ELEM_PREV], r14
    jmp .done
.last:
    mov [r12 + LIST_LAST], r14
.done:
    ; Actualiza el tamaño de la lista
    inc byte [r12 + LIST_SIZE]

    add rsp, 8    
    pop r14
    pop r13
    pop r12
    pop rbp
    ret