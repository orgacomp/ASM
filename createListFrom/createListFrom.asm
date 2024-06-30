section .text
global createListFrom

extern arrayNew
extern listAddFirst
extern listAddLast
extern listNew
extern strCmp
extern strClone
extern malloc

%define ARRAY_TYPE 0
%define ARRAY_SIZE 4
%define ARRAY_CAPACITY 5
%define ARRAY_DATA 8

%define LIST_TYPE 0
%define LIST_SIZE 4
%define LIST_FIRST 8
%define LIST_LAST 16

%define LIST_ELEM_DATA 0
%define LIST_ELEM_NEXT 8
%define LIST_ELEM_PREV 16
%define LIST_ELEM_SIZE 24

%define TYPESTRING 2
;list_t *createListFrom(array_t* array)

createListFrom:
; list_t *createListFrom_c(array_t* array)
; {
;     list_t *l = listNew(TypeString);

    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15
    push rbx
    sub rsp, 8

    mov r12, rdi
    mov edi, TYPESTRING
    call listNew
    mov rbx, rax
    ; for (int i = 0; i < array->size; i++)
    ; {
    ;     listInsertOrdered(l, arrayGet(array, i));
    ; }

    mov r15b, [r12 + ARRAY_SIZE]
    mov r14, [r12 + ARRAY_DATA]
    xor r13, r13
    .loop:
    cmp r13b, r15b
    jge .end
    mov rdi, rbx
    mov rsi, [r14 + r13 * 8]
    call listInsertOrdered
    inc r13
    jmp .loop

    .end:
    mov rax, rbx

    add rsp, 8
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

;     for (int i = 0; i < array->size; i++)
;     {
;         listInsertOrdered(l, arrayGet(array, i));
;     }
;     return l;
; }

; void listInsertOrdered(list_t* l, void* data)
listInsertOrdered:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15

    ;if (l->size == 0){
    ;    listAddFirst(l, data);
    ;    return;
    ;}

    cmp byte [rdi + LIST_SIZE], 0
    jne .listNotEmpty
    call listAddFirst
    jmp .end

    .listNotEmpty:

    ;listElem_t* current = l->first;
    ;while(current != NULL && strCmp(data, current->data) < 0) {
    ;    current = current->next;
    ;}
    mov r15, rdi                ; r15 l
    mov r12, [r15 + LIST_FIRST] ; r12 current
    mov r14, rsi                ; r14 data
    .loop:
    cmp r12, 0
    je .checkCurrentFirst
    mov rdi, r14
    mov rsi, [r12 + LIST_ELEM_DATA]
    call strCmp
    test eax, eax
    jge .checkCurrentFirst
    mov r12, [r12 + LIST_ELEM_NEXT]
    jmp .loop

    

    .checkCurrentFirst:
    ; if (current == l->first){
    ;     listAddFirst(l, data);
    ;     return;
    ; }

    cmp r12, [r15 + LIST_FIRST]
    jne .checkNull
    mov rdi, r15
    mov rsi, r14
    call listAddFirst
    jmp .end

    ; if (current == NULL){
    ;     listAddLast(l, data);
    ;     return;
    ; }
    .checkNull:
    test r12, r12
    jne .notNull
    mov rdi, r15
    mov rsi, r14
    call listAddLast
    jmp .end
    
    .notNull:
    ; listElem_t* newElem = malloc(sizeof(listElem_t));
    ; newElem->next = current;
    ; newElem->prev = current->prev;
    ; current->prev->next = newElem;
    ; current->prev = newElem;
    ; newElem->data = strClone(data);
    ; l->size = l->size + 1;   

    mov rdi, LIST_ELEM_SIZE
    call malloc
    mov [rax + LIST_ELEM_NEXT], r12 ; newElem->next = current;
    mov r13, [r12 + LIST_ELEM_PREV] ; newElem->prev = current->prev;
    mov [rax + LIST_ELEM_PREV], r13 
    mov [r13 + LIST_ELEM_NEXT], rax ; current->prev->next = newElem;
    mov [r12 + LIST_ELEM_PREV], rax ; current->prev = newElem;
    mov r13, rax
    mov rdi, r14
    call strClone
    mov [r13 + LIST_ELEM_DATA], rax ; newElem->data = strClone(data);
    add byte [r15 + LIST_SIZE], 1 ; l->size = l->size + 1;

    .end:

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
