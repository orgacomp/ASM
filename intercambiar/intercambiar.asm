global intercambiar
extern printf
extern strlen

intercambiar:

xor rax, rax
	
.condicion:
	cmp    byte [rax + rdi], 0
	je 	.inter

.ciclo1: 
	inc 	rax
    jmp 	.condicion

.inter:
    sub     rax, 1          
    test    rax, rax         ; compruebo si la longitud es menor o igual a 0
    jle     .cortar              

    mov     rdx, 0

.ciclo:
    movzx   ecx, byte [rdi+rdx]  ; guardo char del principio
    movzx   esi, byte [rdi+rax]  ; guardo char del final

    mov     [rdi+rdx], sil       ; guardo el caracter final en el principio
    mov     [rdi+rax], cl        ; guardo el caracter inicial en el final

    add     rdx, 1               ; avanzo uno hacia adelante en la cadena
    sub     rax, 1               ; retrocedo uno hacia atrás en la cadena

    cmp     rdx, rax             
    jl      .ciclo                  

.cortar:
    ret
