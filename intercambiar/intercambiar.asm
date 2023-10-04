global intercambiar
extern printf
extern strlen

intercambiar:
    push    rbx
    mov     rbx, rdi         ; guardo cadena en rbx
    call    strlen           
    sub     rax, 1          
    test    rax, rax         ; compruebo si la longitud es menor o igual a 0
    jle     .L1              

    mov     rdx, 0         
.L3:
    movzx   ecx, byte [rbx+rdx]  ; guardo char del principio
    movzx   esi, byte [rbx+rax]  ; guardo char del final

    mov     [rbx+rdx], sil       ; guardo el caracter final en el principio
    mov     [rbx+rax], cl        ; guardo el caracter inicial en el final

    add     rdx, 1               ; avanzo uno hacia adelante en la cadena
    sub     rax, 1               ; retrocedo uno hacia atrás en la cadena

    cmp     rdx, rax             
    jl      .L3                  

.L1:
    pop     rbx
    ret

