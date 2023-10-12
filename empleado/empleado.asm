extern strlen
extern malloc
extern strcpy

%define SIZE_OF_EMPLEADO 16
%define OFFSET_NOMBRE 0
%define OFFSET_EDAD 8

global new_empleado

section .text

;struct Empleado* new_empleado(const char *nombre, int edad) 
new_empleado:
        ; armo stack frame
        push rbp
        mov rbp, rsp
        ; pusheo no volátiles que voy a usar
        push r12 
        push r13
        push rbx
        sub  rsp, 8 ;alineo la pila a 16 bytes

        mov  r13d, esi   ; guardo edad
        mov  r12, rdi    ; guardo *nombre en r12
        mov  rdi, SIZE_OF_EMPLEADO    

        call malloc      ; rax tiene puntero a struct

        mov  rdi, r12
        mov  rbx, rax    ; rbx mantiene el puntero a struct
        call strlen      ; size_t strlen (const char * str);
        
        ; rax tiene largo del nombre

        inc  rax
        mov  rdi, rax    ; +1 por el byte nulo
        call malloc      ; rax tiene puntero a nombre del struct

        
        mov  [rbx + OFFSET_NOMBRE], rax  ; copio el puntero al nombre en el struct 

        ; copio el nombre
        mov  rsi, r12    ; puntero src
        mov  rdi, rax    ; puntero dest
        call strcpy      ; char *strcpy(char *dest, const char *src)

        mov  [rbx + OFFSET_EDAD], r13d
        mov  rax, rbx

        add  rsp, 8
        pop  rbx
        pop  r13
        pop  r12
        pop  rbp
        ret





;















