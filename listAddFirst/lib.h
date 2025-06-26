#ifndef LIB_H
#define LIB_H

#include <stdint.h>
#include <stdio.h>

typedef void(funcDelete_t)(void *);
typedef void(funcPrint_t)(void *, FILE *pFile);
typedef void* (funcClone_t)(void*);

void intDelete(int32_t* a);
void intPrint(int32_t* a, FILE* pFile);
int32_t* intClone(int32_t* a);

uint32_t strLen(char* a);
void strDelete(char* a);
void strPrint(char* a, FILE* pFile);
char* strClone(char* a);
int32_t strCmp(char* a, char* b);

typedef enum e_type
{
    TypeNone = 0,
    TypeInt = 1,
    TypeString = 2
} type_t;

typedef struct s_list {
	type_t   type;
	uint8_t  size;
	struct s_listElem* first;
	struct s_listElem* last;
} list_t;

typedef struct s_listElem {
	void* data;
	struct s_listElem* next;
	struct s_listElem* prev;
} listElem_t;


list_t* listNew(type_t t);
void  listDelete(list_t* l);
void  listPrint(list_t* l, FILE* pFile);
void* listGet(list_t* l, uint8_t i);
void listAddFirst(list_t* l, void* data);
void listAddFirst_asm(list_t* l, void* data);
void listAddLast(list_t* l, void* data);

#endif /* LIB_H */