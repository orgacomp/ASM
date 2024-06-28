section .text
global map

extern map_c
extern arrayNew

%define ARRAY_TYPE 0
%define ARRAY_SIZE 4
%define ARRAY_CAPACITY 5
%define ARRAY_DATA 8

;array_t *map(array_t* array, void* (*func)(void*));

map:
    push rbp
    mov rbp, rsp

    push r12
    push r13
    push r14
    push r15 ; alineada a 16 bytes

    mov r14, rsi ; preservo el puntero a la funcion en r14

    ;array_t* newArray = arrayNew(array->type, array->capacity);
    mov r12, rdi ; array original en r12
    mov edi, [r12 + ARRAY_TYPE]
    mov sil, [r12 + ARRAY_CAPACITY]
    call arrayNew
    mov r13, rax ; array mapeado en r13

    xor rbx, rbx
    
    mov dl, [r12 + ARRAY_SIZE]
    mov r12, [r12 + ARRAY_DATA] ; reutilizo r12 para el puntero a data
    mov r15, [r13 + ARRAY_DATA] ; puntero a data del nuevo array
    ;for(int i=0; i<array->size; i++){
    .loop:
        cmp bl, dl ; i < array->size
        jge .end

        ;void* data = func(array->data[i]);
        mov rdi, [r12 + rbx*8]  ; rdi = array->data[i]

        push rdx
        sub rsp, 8              ; alineo la pila a 16 bytes      
        call r14                ; rax = func(array->data[i])
        add rsp, 8              
        pop rdx                 

        mov [r15 + rbx*8], rax  ; newArray->data[i] = data
        inc bl ; i++
        ;newArray->size++;
        mov [r13 + ARRAY_SIZE], bl
        jmp .loop
    
    .end:

    mov rax, r13
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret
