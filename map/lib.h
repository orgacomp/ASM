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

typedef enum e_type
{
    TypeNone = 0,
    TypeInt = 1,
    TypeString = 2
} type_t;

/** Array **/

typedef struct s_array
{
    type_t type;
    uint8_t size;
    uint8_t capacity;
    void **data;
} array_t;

array_t *arrayNew(type_t t, uint8_t capacity);
void arrayDelete(array_t *a);
void arrayPrint(array_t *a, FILE *pFile);
void  arrayAddLast(array_t* a, void* data);

#endif /* LIB_H */