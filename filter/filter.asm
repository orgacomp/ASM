global filterAsm

extern free

%define OFFSET_ELEM_DATA 0
%define OFFSET_ELEM_NEXT 8
%define OFFSET_ELEM_PREV 16

%define OFFSET_LIST_FIRST 0
%define OFFSET_LIST_LAST 8
%define OFFSET_LIST_SIZE 16


section .text

filterAsm:
        push rbp
        mov rbp, rsp                            ;inicializamos el stack frame
        push    r12
        push    r13
        push    r15                             
        push    rbx                             ; stack alineado a 16 bytes

        mov     r12, rdi                        ; r12 = lista
        mov     r13, rsi                        ; r13 = func
        mov     rbx, [r12+ OFFSET_LIST_FIRST]   ; rbx = actual = l->first

.ciclo:  
        test rbx, rbx                           ; verifico que el primer elemento NO sea null (o puede ser cpm rbx, 0)
        je      .finish                         ; es null, finalizo

        mov     r15, [rbx+OFFSET_ELEM_NEXT]     ; r15 = nextElem = actual->next 
        mov     edi, [rbx + OFFSET_ELEM_DATA]   ; edi = actual-> data
        call    r13                             ; llamo a func(data)
        cmp eax, 0                              ; verifico si es 0
        jne      .actualize                     ; si no es 0, sigo con el siguiente elemento

        mov r9, [rbx+OFFSET_ELEM_PREV]          ; r9 = prevElem

        cmp     dword [r12+OFFSET_LIST_SIZE], 1 ; verifico si la lista tiene un solo elemento
        je      .one_element

        cmp     rbx, [r12+OFFSET_LIST_FIRST]    ; verifico si es el primero de la lista
        je      .is_first
        cmp     rbx, [r12+OFFSET_LIST_LAST]     ; verifico si es el ultimo de la lista
        je      .is_last

        mov     [r15+OFFSET_ELEM_PREV], r9      ; nextElem -> prev = prevElem
        mov     [r9+OFFSET_ELEM_NEXT], r15      ; prevElem -> next =  nextElem   

.delete_element:
        mov     rdi, rbx                    
        call    free                            ; free(actual)
        sub     dword [r12+OFFSET_LIST_SIZE], 1 ; size -=1

.actualize:
    mov rbx, r15                                ; actual = nextElem
    jmp .ciclo

.is_first:
        mov     [r12+OFFSET_LIST_FIRST], r15     ; lista -> first = nextElem
        mov     qword [r15+OFFSET_ELEM_PREV], 0  ; nextElem -> prev = NULL
        jmp     .delete_element             

.is_last:
        mov     [r12+OFFSET_LIST_LAST], r9        ; lista -> last =  prevElem          
        mov     qword [r9+OFFSET_ELEM_NEXT], 0    ; prevElem -> next = NULL
        jmp     .delete_element

.one_element:
        mov     qword[r12+OFFSET_LIST_FIRST], 0   ; lista -> first = NULL
        mov     qword[r12+OFFSET_LIST_LAST], 0    ; lista -> last =  NULL
        jmp     .delete_element

.finish:
        pop     rbx
        pop     r15
        pop     r13
        pop     r12
        pop     rbp
        ret