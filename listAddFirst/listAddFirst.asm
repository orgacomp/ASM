section .text
global listAddFirst_asm
extern listAddFirst
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
    jmp listAddFirst
    
    ; push rbp
    ; mov rbp, rsp
    ; push r12
    ; push r13
    ; push r14
    ; push r15
    ; push rbx
    ; sub rsp, 8
