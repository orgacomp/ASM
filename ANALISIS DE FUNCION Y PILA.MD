# Análisis de funciones

A continuación analizaremos un fragmento de un programa que contiene funciones de una lista doblemente enlazada la cuales pueden ser llamadas desde un main de C.

```asm
%define TAM_LIST 24
%define OFFSET_TYPE 0
%define OFFSET_SIZE 4
%define OFFSET_FIRST 8
%define OFFSET_LAST 16

%define TAM_ELEMENT 24
%define OFFSET_DATA 0
%define OFFSET_NEXT 8
%define OFFSET_PREV 16

extern getCloneFunction
extern malloc

global listAddLast
global listGet

section .data

section .text
; Si no entendés todo el código realizado hasta ahora te recomiendo leer el COMO ARMAR UN PROGRAMA EN ASSEMBLY.md.

;void listAddLast(list_t *l, void *data)

listAddLast:

push rbp
mov rbp,rsp

sub rsp,8
push r12
push r13
push r14
push r15
sub rsp,8

mov r12,rdi
mov r13,rsi

movzx rdi,dword[r12+OFFSET_TYPE]
call getCloneFunction
mov [rbp-8],rax

mov rdi,r13
call [rbp-8]

mov r14,rax

mov rdi,TAM_ELEMENT
call malloc

mov qword[rax+OFFSET_DATA],r14
mov qword[rax+OFFSET_NEXT],0
mov qword[rax+OFFSET_PREV],0
mov r15,rax
cmp byte[r12+OFFSET_SIZE],0
je .no_tiene
jne .tiene

.no_tiene:
mov [r12+OFFSET_FIRST],r15
mov [r12+OFFSET_LAST],r15
jmp .fin

.tiene:
mov rdx,[r12+OFFSET_LAST]
mov [rdx+OFFSET_NEXT],r15
mov [r15+OFFSET_PREV],rdx
mov [r12+OFFSET_LAST],r15
jmp .fin

.fin:
inc byte[r12+OFFSET_SIZE]
add rsp,8
pop r15
pop r14
pop r13
pop r12
add rsp,8
pop rbp
ret

;uint8_t listGetSize(list_t *l)

listGetSize:

push rbp
mov rbp,rsp

movzx rax,byte [rdi+OFFSET_SIZE]

pop rbp
ret

```

Analicemos listAddLast para afianzar conceptos.

```asm
;void listAddLast(list_t *l, void *data)

listAddLast:
```

Tenemos un comentario con la firma de la función en C y la etiqueta de la función que antes declaramos como global.

Ahora proseguimos con el armado del stack frame. El siguiente diagrama de pila nos ayudará a entender que ocurre.

Estado de la pila cuando se realiza la instrucción.

```asm
call listAddLast
```

![DIAGRAMA DE PILA](Imagenes/PILA1.png)

La instrucción **CALL** guarda en la pila la dirección de la siguiente instrucción a ejecutar después de realizar la ejecución de la función listAddLast.

Con la ayuda de este diagrama, vamos a poder entender que ocurre con dos instrucciones que utilizaremos siempre, para armar el stack frame de una función.

```asm
push rbp
```

![DIAGRAMA DE PILA](Imagenes/PILA2.png)

Como podemos ver el **PUSH RBP**, nos guarda el base pointer anterior que estábamos usando antes de entrar a la función, con la idea de recuperarlo al final de la función cuando hagamos **POP RBP**.

```asm
mov rbp,rsp
```

Después de haber guardado el **RBP** anterior, ahora nos interesará actualizar como nueva dirección del **RBP** al tope de la pila o **RSP**, para así poder operar con la pila pero a partir del nuevo **RBP**.

![DIGRAMA DE PILA](Imagenes/PILA3.png)

Podemos ver que ahora el **RBP** apunta a la dirección 0x10F0. Por el resto de la función al **RBP** no se lo modifica más. Estas dos instrucciones nos servirán para armar el stack frame. Podemos ver que la pila esta alineada a 16, tranquilamente podemos hacer una llamada a una función de C y no tendremos segmentations faults.

```asm
sub rsp,8
```

![DIGRAMA DE PILA](Imagenes/PILA4.png)

La instrucción restará 8 a la dirección de memoria 0x10F0, lo cual deja al **RSP** apuntando a la dirección 0x10EF. Lo que hacemos en esta instrucción es reservar 8 bytes de la pila, para utilizar en un futuro accediendo de la manera **[RBP-8]**. Podemos ver que la pila queda desalineada para llamar funciones de C.

```asm
push r12
```

Habilitamos el uso del registro no volátil **R12**.¿Qué significa que sea no volátil?

Un registro no volátil preserva los datos que guardemos en él. A diferencia de los volátiles que cuando hacemos un **CALL** de una función auxiliar, dentro de nuestra función, se pueden pisar los datos que estos contienen lo que implica la perdida de datos que guardamos, por eso es conveniente usar no volátiles.

Estos guardan los datos cuando necesitamos llamar a funciones auxiliares. Los registros no volátiles son **RBX,R12,R13,R14,R15**.

Para usar un registro no volátil es necesario pushearlo en la pila. ¡¡Usar un registro no volátil sin antes pushearlo generará comportamientos indefinidos!!

![DIGRAMA DE PILA](Imagenes/PILA5.png)

```asm
push r13
```

Un método fácil para saber si podemos llamar a una función de C y para saber si tenemos la pila alineada a 16.

Es tener una cuenta, de cuanto se suma cuando hacemos el **SUB RSP,(MÚLTIPLO DE 8)** e ir sumando 8 por cada **PUSH** hecho, al final del todo dividir por 16 si nos queda resto es que la pila esta desalineada.

![DIAGRAMA DE PILA](Imagenes/PILA6.png)

Veamos hasta ahora como venimos.

sub rsp 8 + push r12 + push r13

8+8+8=24

24%16=8 por ende la pila esta desalineada.

```asm
push r14
```

![DIAGRAMA DE PILA](Imagenes/PILA7.png)

```asm
push r15
```

![DIAGRAMA DE PILA](Imagenes/PILA8.png)

Miremos ahora este caso, ya pusheamos todos los registros y nos consultamos.

¿Voy a llamar a alguna función de C?
En el caso de esta función SI.

Entonces me voy a preguntar.
¿Está la pila alineada a 16?

La respuesta es NO(con el método antes explicado calcular).

Entonces vamos a alinearla nosotros. ¿Cómo?, restándole 8 al **RSP** y reservando un espacio de 8 bytes para utilizar en la función.

Para acceder a este espacio será necesario hacer **[RBP-48]** o haciendo **[RSP]**.

En nuestro caso en la función no lo utilizaremos, esta operación la hacemos con el mero propósito de alinear la pila a 16, para así poder llamar a las funciones de C respetando la convención de llamadas de la ABI.

```asm
sub rsp,8
```

![DIAGRAMA DE PILA](Imagenes/PILA9.png)

Ya librados de la pila continuemos con las siguientes instrucciones.

```asm
mov r12,rdi
mov r13,rsi
```

Guardamos en los registros no-volátiles los parámetros de la función, en este caso en **R12** el puntero a la lista(lista_t\*l) y en **R13** el puntero al dato(void\*data). Son datos que no queremos perder cuando llamemos a getCloneFunction.

```asm
movzx rdi,dword[r12+OFFSET_TYPE]
call getCloneFunction
mov [rbp-8],rax
```

Analicemos ahora esta seguidilla de instrucciones.
**MOVZX** ¿Qué hace?. La instrucción **MOVZX** nos permite rellenar con ceros un registro en el cual queremos guardar un dato más chico.

En este caso **MOVZX** rellenara los primeros 32 bits de la parte alta de **RDI** con ceros y en los 32 bits bajos o 4 bytes dejara el type_t(al ser un enum es un unsigned int de 4 bytes) de la lista.

Sería lo mismo hacer:

```asm
mov edi,[r12+OFFSET_TYPE]
```

¿Que hace esta instrucción en la función?, deja preparado como parámetro en **RDI** el type_t de la lista para así llamar a getCloneFunction de C(Por eso alineamos la pila) que tiene una firma:

```c
funcClone_t *getCloneFunction(type_t t)
```

Hacemos el:

```asm
call getClone Function
```

La cual está declarada como extern en el programa.

Lo cual en **RAX** nos dejara un puntero a una función de clonación del estilo funcClone_t.

Y para poder llamar a la función de clonación siempre que queramos, la podemos guardar en un registro no volátil, o en nuestro caso en el espacio que reservamos para usar en la pila.

```asm
mov [rbp-8],rax
```

![DIAGRAMA DE PILA](/Imagenes/PILA10.png)

```asm
mov rdi,r13
call [rbp-8]
```

En esta parte de la función preparamos como parámetro en **RDI**, el registro **R13** que contiene el puntero al dato, lo cual recibe la función de clonación. Y llamamos a la función de clonación guardada en **[RBP-8]** o **[RSP+40]**.

```asm
mov r14,rax
```

En **R14** nos guardamos el dato clonado para no perderlo en la llamada de malloc.

```asm
mov rdi,TAM_ELEMENT
call malloc
```

Preparamos devuelta como primer parámetro, el tamaño del elemento y llamamos a malloc. Que en **RAX** nos dejara un puntero a memoria de TAM_ELEMENT bytes.

```asm
mov qword[rax+OFFSET_DATA],r14
mov qword[rax+OFFSET_NEXT],0
mov qword[rax+OFFSET_PREV],0
```

Asignamos el campo data del nodo, con elemento clonado guardado en **R14** e inicializamos en 0 los punteros a los nodos siguiente y previo(evitamos el error "Conditional jump or move depends on uninitialized value(s)" de Valgrind).

Es importante destacar el uso de **QWORD** ya que esto le indicara el tamaño de memoria al cual se debe acceder.
| TIPO EN C | BITS | REGISTRO | ACCESO A MEMORIA | ASIGNACIÓN DE MEMORIA |
|-----------|------|----------|------------------|-----------------------|
| char | 8 | al | byte[ptr] | db |
| short | 16 | ax | word[ptr] | dw |
| int | 32 | eax | dword[ptr] | dd |
| long | 64 | rax | qword[ptr] | dq |

**ptr** es el puntero del cual queremos acceder a sus datos.

```asm
mov r15,rax
```

En **R15**, un no volátil , me guardo el puntero al nodo que estaba en **RAX**.

```asm
cmp byte[r12+OFFSET_SIZE],0
je .no_tiene
jne .tiene

.no_tiene:
mov [r12+OFFSET_FIRST],r15
mov [r12+OFFSET_LAST],r15
jmp .fin

.tiene:
mov rdx,[r12+OFFSET_LAST]
mov [rdx+OFFSET_NEXT],r15
mov [r15+OFFSET_PREV],rdx
mov [r12+OFFSET_LAST],r15
jmp .fin
```

En esta parte de la función está la lógica principal, expliquemos cada parte y cada sub etiqueta de la función.

```asm
cmp byte[r12+OFFSET_SIZE],0
je .no_tiene
jne .tiene
```

En estas tres líneas compararemos el tamaño de la lista con 0, para saber si la lista tiene elementos. Cabe destacar que hay que acceder a un byte, ya que list-size es un uint8_t. Comparamos con la instrucción **CMP** y aplicamos dos saltos condicionales, **JE** a la etiqueta **.no_tiene**, y **JNE** a la etiqueta **.tiene.**

¡Importante los saltos condiciones deben de estar si o si después de la instrucción **CMP**!

| SALTOS CONDICIONALES | CONDICIÓN EN C | ESPAÑOL        |
| -------------------- | -------------- | -------------- |
| je                   | ==             | igual          |
| jne                  | !=             | distinto       |
| jle                  | <=             | menor o igual  |
| jge                  | >=             | mayor o igual  |
| jg                   | >              | mayor estricto |
| jl                   | <              | menor estricto |

La instrucción **JMP** saltará a la etiqueta sin importar la condición.

Para llamar a una etiqueta solo basta con hacer **.etiqueta** aunque después hay que definir el código que esta contiene con un **.etiqueta:**

En el caso de nuestra función cada etiqueta tiene un **JMP** **.fin** lo cual mantiene el flujo de ejecución de la función.

Como extra interpretar que hace cada etiqueta.

Veamos ahora la etiqueta de .fin

```asm
.fin:
inc byte[r12+OFFSET_SIZE]
add rsp,8
pop r15
pop r14
pop r13
pop r12
add rsp,8

pop rbp
ret
```

Incrementamos el list->size en 1 con:

```asm
inc byte[r12+OFFSET_SIZE]
```

Veamos el estado de la pila:

![DIAGRAMA DE PILA](Imagenes/PILA10.png)

Para finalizar hay que dejar la pila como la recibimos.

![DIAGRAMA DE PILA](Imagenes/PILA1.png)

Entonces de manera inversa a como hicimos en el inicio haremos **POP** de cada registro reservado y **ADD RSP,(multiplo de 8)** según corresponda.

```asm
add rsp,8
```

![DIAGRAMA DE PILA](Imagenes/PILA11.png)

```asm
pop r15
```

![DIAGRAMA DE PILA](Imagenes/PILA12.png)

```asm
pop r14
```

![DIAGRAMA DE PILA](Imagenes/PILA13.png)

```asm
pop r13
```

![DIAGRAMA DE PILA](Imagenes/PILA14.png)

```asm
pop r12
```

![DIAGRAMA DE PILA](Imagenes/PILA15.png)

```asm
add rsp,8
```

![DIAGRAMA DE PILA](Imagenes/PILA16.png)

Después de haber desapilado todos los registros para volver a la función en la que estábamos antes de llamar a listAddLast vamos a hacer la operación:

```asm
pop rbp
```

Que termina con el stack frame de la función y devuelve a la función que uso a listAddLast como auxiliar el valor del **RBP** anterior a llamar a la función.

![DIAGRAMA DE PILA](Imagenes/PILA17.png)

Por último la instrucción **RET**:

```asm
ret
```

Carga en el **RIP** la dirección guardada por el **CALL** para así seguir con la siguiente instrucción de la función que uso a listAddLast como auxiliar.

![DIAGRAMA DE PILA](Imagenes/PILA18.png)

Después de esto dejamos a la pila en el mismo estado en el que estaba antes de entrar a la función y no tuvimos ninguna clase de errores.

Ahora vos por tu propia cuenta hace un análisis de listGetSize.

Espero que te haya servido el apunte para entender mejor como usar assembly.
