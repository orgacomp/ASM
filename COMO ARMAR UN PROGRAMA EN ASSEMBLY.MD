# COMO HACER UN PROGRAMA EN ASSEMBLY NASM

En nuestro caso queremos hacer funciones de una lista doblemente enlazada donde la estructura a manejar es:

```c
typedef struct s_list {
type_t type;
uint8_t size;
struct s_listElem* first;
struct s_listElem* last;
} list_t;

typedef struct s_listElem {
void* data;
struct s_listElem* next;
struct s_listElem* prev;
} listElem_t;
```

Inicialmente nos interesa hacer los defines de los tamaños de las estructuras (para poder llamar a malloc o calloc según corresponda) y definir los Offsets de cada variable, para poder acceder correctamente a cada campo de los structs y mantener la legibilidad del código.

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
```

Después haremos llamadas extern que nos permitirán utilizar funciones de C. Ya sea de funciones estándar como malloc o calloc, o las funciones proporcionadas por la cátedra para clonar, eliminar e imprimir los datos que tendremos en el taller de asmlab.

```asm
extern malloc
extern calloc
extern free
extern getCloneFunction
extern getDeleteFunction
extern getPrintFunction
extern fprintf
```

Definimos los nombres de la funciones como globales asi los puede visibilizar el linker.

```asm
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
```

Definimos en section .data datos constantes que usaremos para imprimir, aunque podría ser cualquier otro tipo de constante.

```asm
section .data

FORMATEO_STRING: db "%s",0
NULL_STR: db "NULL",0
CORCHETE_INICIO: db "[", 0
CORCHETE_FINAL: db "]", 0
COMA: db ",", 0
LLAVE_INICIO: db "{",0
LLAVE_FINAL: db "}",0
GUION_BAJO: db "-",0
```

Definimos en section .text las etiquetas de las funciones antes declaradas como global y su determinada implementación. Aca se escribira el programa.

```asm
section .text

listNew:			preparamos la etiqueta antes declarada en global
;list_t*listNew(type_t t)
implementación de la función
ret


listGetSize:
;uint8_t listGetSize(list_t *l)
implementación de la función


listAddFirst:
;void listAddFirst(list_t *l, void *data)


listAddLast:
;void listAddLast(list_t *l, void *data)


listGet:
;void *listGet(list_t *l, uint8_t i)


listClone:
;list_t *listClone(list_t *l)


listRemove:
;void *listRemove(list_t *l, uint8_t i)


listSwap:
;void listSwap(list_t *l, uint8_t i, uint8_t j)


listDelete:
;void listDelete(list_t *l)


listPrint:
;void listPrint(list_t *l, FILE *pFile)
```

Haciendo un comentario con la definición de cada función en C con sus respectivos parámetros, nos ayudará a recordar en que registros tenemos los datos de cada parámetro.

Para realizar comentarios en assembly es necesario poner un ; como se muestra en el siguiente ejemplo.

```asm
push rbp            ;armo stack frame
mov rbp,rsp

sub rsp,8
push r12
push r13
push r14

mov r12,rdi                         ;en r12 guardo el puntero a la lista
mov r13,rsi                         ;en r13 guardo el puntero al FILE
```
