%define OFFSET_FIRST 0

%define OFFSET_DATA 0
%define OFFSET_NEXT 8

%define OFFSET_APROBADO 1
%define OFFSET_PAGADOR 8
%define OFFSET_COBRADOR 16
%define SIZE_OF_PAGO 24

%define OFFSET_CANT_APROBADOS 0 
%define OFFSET_CANT_RECHAZADOS 1
%define OFFSET_APROBADOS 8
%define OFFSET_RECHAZADOS 16
%define SIZE_OF_PAGOSPLITTED 24

section .data

section .text

global contar_pagos_aprobados_asm
global contar_pagos_rechazados_asm

global split_pagos_usuario_asm

extern malloc
extern free
extern strcmp


;########### SECCION DE TEXTO (PROGRAMA)

; uint8_t contar_pagos_aprobados_asm(list_t* pList, char* usuario);
contar_pagos_aprobados_asm:
;rdi = pList
;rsi = usuario

;prologo
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15

mov r12, [rdi+OFFSET_FIRST]
mov r13, rsi

xor r14, r14

.ciclo:
    mov r15, [r12+OFFSET_DATA]
    mov rdi, [r15+OFFSET_COBRADOR]

    mov rsi, r13
    call strcmp
    cmp rax, 0
    jne .next
    mov r15b, BYTE [r15+OFFSET_APROBADO]
    cmp r15b, 1
    jne .next

    inc r14

    .next:
    mov r12, [r12+OFFSET_NEXT]
    cmp r12, 0
    jne .ciclo

;epilogo
mov rax, r14
pop r15
pop r14
pop r13
pop r12
pop rbp
ret

; uint8_t contar_pagos_rechazados_asm(list_t* pList, char* usuario);
contar_pagos_rechazados_asm:
;rdi = pList
;rsi = usuario

;prologo
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15

mov r12, [rdi+OFFSET_FIRST]
mov r13, rsi

xor r14, r14

.ciclo:
    mov r15, [r12+OFFSET_DATA]
    mov rdi, [r15+OFFSET_COBRADOR]

    mov rsi, r13
    call strcmp
    cmp rax, 0
    jne .next
    mov r15b, BYTE [r15+OFFSET_APROBADO]
    cmp r15b, 0
    jne .next

    inc r14

    .next:
    mov r12, [r12+OFFSET_NEXT]
    cmp r12, 0
    jne .ciclo

;epilogo
mov rax, r14
pop r15
pop r14
pop r13
pop r12
pop rbp
ret


; pagoSplitted_t* split_pagos_usuario_asm(list_t* pList, char* usuario);
split_pagos_usuario_asm:
;rdi = pList
;rsi = usuario

;prologo
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15
push rbx
sub rsp, 8

xor r14, r14 
xor r15, r15

mov r12, rdi
mov r13, rsi
call contar_pagos_aprobados_asm
mov r14b, al ;cant_aprobados

mov rdi, r12
mov rsi, r13
call contar_pagos_rechazados_asm
mov r15b, al ;cant_rechazados

mov rdi, SIZE_OF_PAGOSPLITTED
call malloc
mov rbx, rax ;response

mov BYTE [rbx+OFFSET_CANT_APROBADOS], r14b
mov BYTE [rbx+OFFSET_CANT_RECHAZADOS], r15b

mov rdi, r14
shl rdi, 3
call malloc
mov r14, rax ;puntero a array de aprobados

mov rdi, r15
shl rdi, 3
call malloc
mov r15, rax ;puntero a array de rechazados

mov [rbx+OFFSET_APROBADOS], r14
mov [rbx+OFFSET_RECHAZADOS], r15

mov r12, [r12+OFFSET_FIRST]

xor r9, r9

.ciclo:
    mov r8, [r12+OFFSET_DATA]
    mov rdi, [r8+OFFSET_COBRADOR]

    mov rsi, r13
    push r8 
    sub rsp, 8
    call strcmp
    add rsp, 8
    pop r8

    cmp rax, 0
    jne .next
    mov r9b, BYTE [r8+OFFSET_APROBADO]
    cmp r9b, 1
    jne .rechazado

    mov [r14], r8
    add r14, 8
    jmp .next

    .rechazado:

    mov [r15], r8
    add r15, 8 

    .next:
    mov r12, [r12+OFFSET_NEXT]
    cmp r12, 0
    jne .ciclo

;epilogo
mov rax, rbx 
add rsp, 8
pop rbx
pop r15
pop r14
pop r13
pop r12
pop rbp
ret

