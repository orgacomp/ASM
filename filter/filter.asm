
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
    mov rbp, rsp                        ;inicializamos el stack frame
    push r12                            
    push r13                            
    push r14                            
    push r15                          


    mov r12, rdi                        ; r12 = lista
    mov r13, rsi                        ; r13 = func
    mov r14, [r12 + OFFSET_LIST_FIRST]  ; r14 = actual

.ciclo:
    cmp r14, 0                          ; verifico que el primer elemento NO sea null (o puede ser test r14, r14) (caso 0)
    je  .end                            ; si es null, finalizo

    mov r15, [r14 + OFFSET_ELEM_NEXT]   ; r15 = nextElem = actual->next 
    mov edi, [r14 + OFFSET_ELEM_DATA]   ; edi = actual->data (la necesito en el primer parametro para la función) 
                                        ; edi porque data es un int => es de 4 bytes
    call r13                            ; llamo a func(data)
    cmp eax, 0                          ; verifico si es 0 (eax porque la función devuelve un int)
    jne .next                           ; si no es 0, sigo con el siguiente elemento
                                        
                                        ; si llegó aca es porque la función devolvió 0 => hay que eliminarlo 
                                        ; y sigue uno de los 4 casos dentro del while

    mov r9, [r14 + OFFSET_ELEM_PREV]    ; r9 = prevElem = actual -> prev 
                                        ; utilizo un registro volatil porque NO se lo utiliza después de llamar alguna función

    cmp dword [r12 + OFFSET_LIST_SIZE], 1  ; verifico si la lista tiene un solo elemento (caso 1)
    je  .unElem

    cmp r14, [r12 + OFFSET_LIST_FIRST]  ; verifico si es igual al primero de la lista (caso 2)
    je  .actualFirst

    cmp r14, [r12 + OFFSET_LIST_LAST]   ; verifico si es igual al ultimo de la lista (caso 3)
    je  .actualLast

    jmp .else                           ; caso feliz  

.unElem:
    mov qword [r12 + OFFSET_LIST_FIRST], 0   ; lista -> first = NULL
    mov qword [r12 + OFFSET_LIST_LAST], 0    ; lista -> last =  NULL
    jmp .deleteElem

.actualFirst:
    mov [r12 + OFFSET_LIST_FIRST], r15       ; lista -> first = nextElem
    mov qword [r15 + OFFSET_ELEM_PREV], 0    ; nextElem -> prev = NULL
    jmp .deleteElem

.actualLast:
    mov [r12 + OFFSET_LIST_LAST], r9         ; lista -> last =  prevElem          
    mov qword [r9 + OFFSET_ELEM_NEXT], 0     ; prevElem -> next = NULL    
    jmp .deleteElem

.else:
    mov qword [r9 + OFFSET_ELEM_NEXT], r15   ; prevElem -> next =  nextElem 
    mov qword [R15 + OFFSET_ELEM_PREV], r9   ; nextElem -> prev = prevElem     

.deleteElem:
    mov rdi, r14                             
    call free                                ; free(actual)   
    sub dword [r12 + OFFSET_LIST_SIZE] , 1   ; size -=1   

.next:
    mov r14, r15                             ; actual = nextElem
    jmp .ciclo                               

.end:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret

; chequeamos que la pila esté alineada a 16 bytes!!! Si :D
; si no lo estaba => se hace un sub rsp, 8  y luego un add rsp, 8

