%define TAM_LIST 24
%define OFFSET_TYPE 0
%define OFFSET_SIZE 4
%define OFFSET_FIRST 8
%define OFFSET_LAST 16



%define TAM_ELEMENT 24
%define OFFSET_DATA 0
%define OFFSET_NEXT 8
%define OFFSET_PREV 16

;DEFINIMOS OFFSETS Y TAMAÑO PARA TENER UN CODIGO MAS LIMPIO 

extern malloc
extern calloc
extern getCloneFunction
extern getDeleteFunction
extern getPrintFunction
extern fprintf
extern free

;DEFINIMOS FUNCIONES EXTERNAS DE C QUE NECESITEMOS LLAMAR

global listNew
global listGetSize
global listAddFirst
global listAddLast
global listGet
global listClone
global listRemove 
global listSwap
global listDelete
global listPrint

;DECLARAMOS LOS NOMBRES DE LAS FUNCIONES DE LISTA COMO GLOBALES

section .data
FORMATEO_STRING: db "%s",0
NULL: db "NULL",0
CORCHETE_INICIO: db "[", 0
CORCHETE_FINAL: db "]", 0
COMA: db ",", 0 
LLAVE_INICIO: db "{",0
LLAVE_FINAL: db "}",0
GUION_BAJO: db "-",0

;EL SECTION DATA CON TODAS LAS COSAS NECESARIAS PARA IMPRIMIR

section .text



;/////////////////////////////////////////////////////////////////////////////
;list_t*listNew(type_t t)

listNew:
push rbp                            ;ARMADO DE STACK FRAME
mov rbp,rsp

push r12                            ;OPERACIONES DE PILA
sub rsp,8                           ;hago un rsp 8 para mantener la pila alineada a 16 para despues llamar a malloc

mov r12d,edi                        ;guardo el type_t t en r12d.Puede ser que con la llamada de malloc se pierda por eso utilizo un registro no volatil 
mov rdi,TAM_LIST                    ;en RDI guardo el 24(el tamaño de la lista) dejo preparada la funcion para malloc
call malloc                         ;llamo a malloc

mov dword[rax+OFFSET_TYPE],r12d     ;incializo el type
mov byte [rax+OFFSET_SIZE],0        ;incializo el size en 0
mov qword [rax+OFFSET_FIRST],0      ;el puntero al primer nodo lo incializo en NULL
mov qword [rax+OFFSET_LAST],0       ;el puntero al segundo nodo lo inicializo en NULL

add rsp,8                           ;CIERRE DE OPERACIONES DE PILA. al reves del orden que incialice hago add y pop de registros
pop r12

pop rbp                             ;CIERRE DEL STACK FRAME
ret 

;OTRA APOXIMACION DE LIST NEW PERO CON CALLOC
;listNew:
;push rbp 
;mov rbp,rsp
;push r12
;sub rsp,8
;mov r12d,edi
;mov rdi,1
;mov rsi,TAM_LIST
;call calloc
;mov dword[rax],r12d
;add rsp,8
;pop r12
;pop rbp
;ret


;/////////////////////////////////////////////////////////////////////////////
;uint8_t listGetSize(list_t *l)

listGetSize:

push rbp 
mov rbp,rsp                         ;armo stack frame

movzx rax,byte [rdi+OFFSET_SIZE]    ;en rax dejo el size del puntero  

pop rbp                             ;cierro stack frame
ret 



;////////////////////////////////////////////////////////////////////////////
;void listAddFirst(list_t *l, void *data)

listAddFirst:

push rbp 
mov rbp,rsp
sub rsp, 16                         ;es de 16 para mantener alineada la pila para el llamado de calloc
push r12                                                      
push r13
push r14
push r15

mov r12,rdi                         ;dejo en r12 list_t* l
mov r13,rsi                         ;dejo en r13 void*data

movzx rdi,dword[r12+OFFSET_TYPE]    ;paso como parametro el tipo
call getCloneFunction               ;llamo a getclone
mov [rbp-8],rax                     ;dejo en rbp-8 la funcion de clonacion

mov rdi,r13                         ;paso como parametro data
call [rbp-8]                        ;llamo a la funcion de clonacion

mov r14,rax                         ;dejo en r14 el dato clonado 

mov rdi,1                           ;dejo en rdi la cantidad de list_elem
mov rsi,TAM_ELEMENT                 ;dejo en rsi el tamaño de list_elem
call calloc                         ;inicializa los punteros en 0

mov r15,rax                         ;dejo en r15 el nodo
mov [r15+OFFSET_DATA],r14           ;asigno data de elem con el dato clonado
cmp byte[r12+OFFSET_SIZE],0         ;reviso si la lista pasada por parametro no tiene ningun elemento
je .no_tiene
jne .tiene

.no_tiene:
mov [r12+OFFSET_FIRST],r15         ;asigna el primero de la lista la direccion del nodo
mov [r12+OFFSET_LAST],r15          ;asigna el ultimo de la lista la direccion del nodo
jmp .fin

.tiene:
mov rdx,[r12+OFFSET_FIRST]         ;busco el puntero del primero
mov [rdx+OFFSET_PREV],r15          ;asigno el anterior al primero como el nodo nuevo
mov [r15+OFFSET_NEXT],rdx          ;asigno como siguiente al que va a quedar como segundo
mov [r12+OFFSET_FIRST],r15         ;asigno al primero de la lista al nodo creado
jmp .fin

.fin:
inc byte[r12+OFFSET_SIZE]          ;incremento en uno el tamaño de la lista
pop r15
pop r14
pop r13
pop r12
add rsp,16
pop rbp
ret


;/////////////////////////////////////////////////////////////////////////////
;void listAddLast(list_t *l, void *data) 

listAddLast:

push rbp 
mov rbp,rsp

sub rsp, 16
push r12 
push r13
push r14
push r15

mov r12,rdi                         ;dejo en r12 list_t* l
mov r13,rsi                         ;dejo en r13 void*data

movzx rdi,dword[r12+OFFSET_TYPE]    ;paso como parametro el tipo
call getCloneFunction               ;llamo a getclone
mov [rbp-8],rax                     ;dejo en rbp-8 la funcion de clonacion

mov rdi,r13                         ;paso como parametro data
call [rbp-8]                        ;llamo a la funcion de clonacion

mov r14,rax                         ;dejo en r14 el dato clonado 

mov rdi,TAM_ELEMENT                 ;dejo en rdi la cantidad de list_elem
call malloc

mov qword[rax+OFFSET_DATA],r14      
mov qword[rax+OFFSET_NEXT],0        ;inicializo punteros en 0 para salvar uninitialized values de valgrind;
mov qword[rax+OFFSET_PREV],0        ;
mov r15,rax                         ;dejo en r15 el nodo
cmp byte[r12+OFFSET_SIZE],0         ;reviso si la lista pasada por parametro no tiene ningun elemento
je .no_tiene
jne .tiene

.no_tiene:
mov [r12+OFFSET_FIRST],r15         ;asigna el primero de la lista la direccion del nodo
mov [r12+OFFSET_LAST],r15          ;asigna el ultimo de la lista la direccion del nodo
jmp .fin

.tiene:
mov rdx,[r12+OFFSET_LAST]          ;busco el puntero del ultimo
mov [rdx+OFFSET_NEXT],r15          ;asigno el siguiente al ultimo como el nodo nuevo
mov [r15+OFFSET_PREV],rdx          ;asigno como previo al que va a quedar como anteultimo
mov [r12+OFFSET_LAST],r15          ;asigno al ultimo de la lista al nodo creado
jmp .fin

.fin:
inc byte[r12+OFFSET_SIZE]          ;incremento en uno el tamaño de la lista
pop r15
pop r14
pop r13
pop r12
add rsp,16
pop rbp
ret



;/////////////////////////////////////////////////////////////////////////////
;void *listGet(list_t *l, uint8_t i) 

listGet:

push rbp
mov rbp,rsp

cmp sil,byte[rdi+OFFSET_SIZE]  ;comparo el i con el tamaño de la lista l->size
jge .fin_corte
mov cl,0                      ;incio un contador en 0
mov rax,[rdi+OFFSET_FIRST]    ;dejo en rax el primer nodo de la lista
.while:
cmp cl ,sil                   ;mientras que el contador sea menor a la posicion i 
jge .fin
mov rax,[rax+OFFSET_NEXT]     ;pasar al siguiente nodo
inc cl                        ;incrementar el contador
jmp .while 

.fin:
mov rax,[rax+OFFSET_DATA]     ;en rax dejo el puntero a data del nodo
pop rbp
ret

.fin_corte:
mov rax,0                   ;si la i esta fuera de rango se retorna un puntero NULL
pop rbp
ret



;/////////////////////////////////////////////////////////////////////////////
;list_t *listClone(list_t *l)

listClone:

push rbp
mov rbp,rsp

sub rsp,8
push r12 
push r13
push r14
mov r12,rdi                             ;en r12 guardo lista_t*l

movzx rdi,dword[r12+OFFSET_TYPE]        ;en rdi preparo el tipo
call listNew                            ; llamo a list new

mov r13,rax                             ;en r13 guardo la lista nueva

mov r14,[r12+OFFSET_FIRST]              ;en r14 dejo el primer elemento de la lista me interesa que este un no volatil porque voy a llamar funciones de las cuales pisotean no volatiles
.while:
cmp r14,0                               ;si el puntero es null es que se llego al final de la lista
je .fin
mov rdi,r13                             ;en rdi dejo la lista nueva
mov rsi,[r14+OFFSET_DATA]               ;en rsi el puntero a data de la lista vieja
call listAddLast                        ;llamo a listAddLast que ya de por si clona al puntero y me lo añade al final de la lista 
mov r14,[r14+OFFSET_NEXT]               ;voy al nodo siguiente de la lista vieja
jmp .while

.fin:
mov rax,r13                             ;dejo en rax la lista vieja 
pop r14
pop r13
pop r12 
add rsp,8
pop rbp 
ret



;/////////////////////////////////////////////////////////////////////////////
;void *listRemove(list_t *l, uint8_t i)

listRemove:

push rbp
mov rbp,rsp

sub rsp,8
push r12
push r13 
push r14 

mov r12, rdi                    ;en r12 guardo la lista_t*l
cmp sil, byte[rdi+OFFSET_SIZE]  ;verifico si el i es mayor o no esto ya me tiene en cuenta el caso donde la lista es vacia
jge .corto                      ;en el caso de que no corto y retorno NULL
mov r13,[rdi+OFFSET_FIRST]      ;muevo en r12 el primer nodo para iterar
mov cl,0                        ;inicializo un contador en 0 en cl (byte de rcx)
.while:
cmp cl,sil                      ;mientras cl<sil(posicion deseada)
jge .analizar_casos             ;se termino el while y tengo el nodo que quiero eliminar 
mov r13,[r13+OFFSET_NEXT]       ;avanzo al nodo siguiente
inc cl                          ;incremento el contador de posicion
jmp .while

.corto:
mov rax,0                       ;en caso de que no hay elementos o la i esta fuera de rango retorno null
jmp .fin

.analizar_casos:
mov r14,[r13+OFFSET_DATA]       ;me guardo en r14 el void*data que retornaremos al final de la funcion
cmp byte[r12+OFFSET_SIZE],1     ;comparo para ver si es el unico elemento de la lista
je .un_solo_elemento
cmp r13,[r12+OFFSET_FIRST]      ;compara para ver si es el primer_elemento de la lista y hay mas de 1
je .primer_elemento
cmp r13,[r12+OFFSET_LAST]       ;compara para ver si es el ultimo elemento de la lista y hay mas de 1
je .ultimo_elemento
jne .elemento_intermedio        ;en el caso de que no, es un elemento intermedio

.un_solo_elemento:
mov qword [r12+OFFSET_FIRST],0  ;asigno los punteros de first y last a 0, la lista queda vacia
mov qword [r12+OFFSET_LAST],0   
jmp .se_elimina

.primer_elemento:
mov r8,[r13+OFFSET_NEXT]        ;busco el segundo elemento 
mov qword[r8+OFFSET_PREV],0     ;establezco el previo del segundo elemento en NULL
mov [r12+OFFSET_FIRST],r8       ;establezco como primer elemento de la lista el segundo elemento
jmp .se_elimina

.ultimo_elemento:
mov r8,[r13+OFFSET_PREV]        ;busco el anteultimo elemento
mov qword[r8+OFFSET_NEXT],0     ;establezco el siguiente del anteultimo elemento en NULL
mov [r12+OFFSET_LAST],r8        ;establezco como ultimo elemento el anteultimo
jmp .se_elimina

.elemento_intermedio:
mov r8,[r13+OFFSET_PREV]        ;busco el previo al elemento    
mov r9,[r13+OFFSET_NEXT]        ;busco el siguiente al elemento
mov [r8+OFFSET_NEXT],r9         ;asgino al siguiente del previo el elemento siguiente
mov [r9+OFFSET_PREV],r8         ;asigno al previo del siguiente el elemento previo
jmp .se_elimina

.se_elimina:
mov rdi,r13                     ;en el caso de que se exitoso elimino el nodo
call free                       ;llamo a free por eso mantengo alineada la pila con rsp-8
dec byte[r12+OFFSET_SIZE]       ;decremento la cantidad de elementos 
mov rax,r14                     ;dejo en rax la data del nodo eliminado 
jmp .fin 

.fin:
pop r14
pop r13
pop r12
add rsp, 8
pop rbp 
ret

;ESTA FUNCION DE LIST REMOVE SE PUEDE SIMPLIFICAR :P

;///////////////////////////////////////////////////////////////////
;void listSwap(list_t *l, uint8_t i, uint8_t j)

listSwap:

push rbp                                ;armo stack frame
mov rbp,rsp

cmp sil,dl                              ;si i==j se termina la funcion
je .fin 
cmp sil,byte[rdi+OFFSET_SIZE]           ;me fijo si i>= list->size  
jge .fin
cmp dl, byte[rdi+OFFSET_SIZE]           ;reviso si j>= list->size
jge .fin
mov r8,[rdi+OFFSET_FIRST]               ;en r8 dejo el primer nodo de la lista
xor cl,cl                               ;establezco cl en 0 (registro de 8 bits de rcx(se usa como contador))

cmp sil,dl                              ;reviso si i>j 
jg .intercambiar_i_j                    
jmp .while_i

.intercambiar_i_j:                      ;La idea es recorrer la lista una sola vez y guardarse los nodos de los cuales queremos intercambiar
mov al,sil   ;temp=i                    ;primero siempre voy a querer llegar a i y despues recorrer hasta j y realizar el intercambio
mov sil,dl   ;i=j
mov dl,al    ;j=temp
jmp .while_i

.while_i:
cmp cl,sil                              ;comparo el contador con i si llegue a la posicion indicada freno 
jge .continuar
mov r8,[r8+OFFSET_NEXT]                 ;paso al nodo siguiente
inc cl                                  ;incremento el contador
jmp .while_i

.continuar:
mov r9,r8                                ;preparo r9 para llegar hasta j 
jmp .while_j

.while_j:
cmp cl,dl                                ;comparo las posiciones despues de i hasta que llego a la posicion J
jge .swap
mov r9,[r9+OFFSET_NEXT]                  ;paso al nodo siguiente
inc cl                                   ;incremento el contador
jmp .while_j

.swap:
mov r10,[r8+OFFSET_DATA]                ;intercambio los void*data de de r8(nodo  posicion i) y r9(nodo posicion j) 
mov r11,[r9+OFFSET_DATA]
mov [r8+OFFSET_DATA],r11
mov [r9+OFFSET_DATA],r10
jmp .fin 

.fin:
pop rbp 
ret



;///////////////////////////////////////////////////////////////////
;void listDelete(list_t *l)

listDelete:

push rbp
mov rbp,rsp

sub rsp,8                           ;guardo lugar para la llamada de la delete function
push r12                            ;registro que guarda la lista ya que rdi es pisoteado

mov r12,rdi
movzx  rdi,dword[r12+OFFSET_TYPE]   ;guardo en rdi el l->type que es type_t
call getDeleteFunction              ;llamo a getDeleteFunction CON LA PILA ALINEADA
mov [rbp-8],rax                     ;guardo en rbp-8 la funcion para eliminar la cual voy a usar repetidas veces 

.while:
cmp byte[r12+OFFSET_SIZE],0         ;comparo si el tamñano es mayor a 0 para seguir eliminando
jle .fin                            ;caso de que ya saco los elmentos libera la lista en el fin
mov rdi,r12                         ;en rdi guardo la lista
xor rsi,rsi                         ;establezco 0 en rsi para llamar a list remove con el primer elemento
call listRemove                     ;list remove elimina el nodo y nos devuelve el elemento 
mov rdi,rax                         ;dejo como parametro el elemento a eliminar que me da list remove
call [rbp-8]                        ;llamo a la funcion delete que elimina el elemento
jmp .while

.fin:
mov rdi,r12                         ;dejo la lista como parametro
call free                           ;llamo a free con la lista PILA ALINEADA A 16 
pop r12                                     
add rsp,8
pop rbp 
ret



;///////////////////////////////////////////////////////////////////
;void listPrint(list_t *l, FILE *pFile)

listPrint:

push rbp            ;ARMO STACK FRAME 
mov rbp,rsp

sub rsp,8
push r12
push r13
push r14

mov r12,rdi                         ;en r12 guardo el puntero a la lista
mov r13,rsi                         ;en r13 guardo el puntero al FILE

mov rdi,r13                                
mov rsi,FORMATEO_STRING             
mov rdx,CORCHETE_INICIO
call fprintf                        ;fprintf(pfile,"%s","[")

movzx rdi,dword[r12+OFFSET_TYPE]    ;guardo en rdi el type_t 
call getPrintFunction               
mov [rbp-8],rax                     ;dejo en el rpb-8 la funcion de print 

mov r14,[r12+OFFSET_FIRST]          ;en r14 dejo el puntero al primer nodo de la lista
cmp r14,0                           ;si es NULL es que se llego al final de la lista
je .fin
mov rdi,[r14+OFFSET_DATA]           ;dejo la data en rdi
mov rsi,r13                         ;en rsi dejo el pfile
call [rbp-8]                        ;llamo a la funcion de print las funciones de print son del estilo DATOprint(DATO*DATO,FILE*pfile)
mov r14,[r14+OFFSET_NEXT]           ;paso al siguiente nodo de la lista

.while:                             ;despues de printear el primer elemento printeo ,elemento y cuando llego al fin pongo un ] 
cmp r14,0
je .fin

mov rdi,r13
mov rsi,FORMATEO_STRING
mov rdx,COMA                       ;Printeo una coma
call fprintf

mov rdi,[r14+OFFSET_DATA]
mov rsi,r13
call [rbp-8]
mov r14,[r14+OFFSET_NEXT]          ;Printeo un elemento
jmp .while

.fin 
mov rdi,r13    
mov rsi,FORMATEO_STRING             
mov rdx,CORCHETE_FINAL
call fprintf                       ;fprintf(pfile,"%s","]") printeo el corchete final

pop r14                            ;Restauro pila a como estaba incialmente
pop r13
pop r12
add rsp,8
pop rbp 
ret
