#include <stdlib.h>
#include "lib.h"

funcDelete_t* getDeleteFunction(type_t t) {
    switch (t) {
        case TypeInt:      return (funcDelete_t*)&intDelete; break;
        case TypeString:   return (funcDelete_t*)&strDelete; break;
        default: break;
    }
    return 0;
}
funcPrint_t* getPrintFunction(type_t t) {
    switch (t) {
        case TypeInt:      return (funcPrint_t*)&intPrint; break;
        case TypeString:   return (funcPrint_t*)&strPrint; break;
        default: break;
    }
    return 0;
}

funcClone_t* getCloneFunction(type_t t) {
    switch (t) {
        case TypeInt:      return (funcClone_t*)&intClone; break;
        case TypeString:   return (funcClone_t*)&strClone; break;
        default: break;
    }
    return 0;
}

/** Int **/

int32_t* intClone(int32_t* a){
    int32_t* n = (int32_t*)malloc(sizeof(int32_t));
    *n = *a;
    return n;
}

void intDelete(int32_t* a){
    free(a);
}


void intPrint(int32_t* a, FILE* pFile){
    fprintf(pFile, "%i", *a);
}

/** String **/
uint32_t strLen(char* a) {
    uint32_t i=0;
    while(a[i]!=0) i++;
    return i;
}

char* strClone(char* a) {
    uint32_t len = strLen(a) + 1;
    char* s = malloc(len);
    while(len-- != 0)
        { s[len]=a[len];}
    return s;
}

void strDelete(char* a) {
    free(a);
}

void strPrint(char* a, FILE* pFile) {
    if(strLen(a)!=0)
        fprintf(pFile, "%s", a);
    else
        fprintf(pFile, "NULL");
}

int32_t strCmp(char* a, char* b) {
    int i=0;
    while(a[i]==b[i] && a[i]!=0 && b[i]!=0) i++;
    if(a[i]==0 && b[i]==0) return 0;
    if(a[i]==0) return 1;
    if(b[i]==0) return -1;
    return (a[i]<b[i])? 1 : -1;
}

array_t *arrayNew(type_t t, uint8_t capacity)
{
    array_t *array = (array_t *)malloc(sizeof(array_t));
    array->type = t;
    array->capacity = capacity;
    array->size = 0;
    array->data = (void **)malloc(sizeof(void *) * capacity);
    return array;
}

void  arrayAddLast(array_t* a, void* data) {
    if(a->size != a->capacity) {
        funcClone_t* fc = getCloneFunction(a->type);
        a->data[a->size] = fc(data);
        a->size = a->size + 1;
    }
}

void  arrayDelete(array_t* a) {
    funcDelete_t* fd = getDeleteFunction(a->type);
    for(int i=0; i<a->size; i++)
        fd(a->data[i]);
    free(a->data);
    free(a);
}

void  arrayPrint(array_t* a, FILE* pFile) {
    funcPrint_t* fp = getPrintFunction(a->type);
    fprintf(pFile, "[");
    for(int i=0; i<a->size-1; i++) {
        fp(a->data[i], pFile);
        fprintf(pFile, ",");
    }
    if(a->size >= 1) {
        fp(a->data[a->size-1], pFile);
    }
    fprintf(pFile, "]");
}

void* arrayGet(array_t* a, uint8_t i) {
    void* ret = 0;
    if(a->size > i)
        ret = a->data[i];
    return ret;
}

list_t* listNew(type_t t){
    list_t* l = malloc(sizeof(list_t));
    l->type = t;
    l->first = 0;
    l->last = 0;
    l->size = 0;
    return l;
}

void* listGet(list_t* l, uint8_t i) {
    listElem_t* current = l->first;
    uint8_t count = 0;
    void* ret = 0;
    if( l->size > i ) {
        while(count != i) {
            current =  current->next;
            count = count + 1;
        }
        ret = current->data;
    }
    return ret;
}

void listAddFirst(list_t* l, void* data){
    listElem_t* n = malloc(sizeof(listElem_t));
    funcClone_t* fc = getCloneFunction(l->type);
    l->size = l->size + 1;
    n->data = fc(data);
    n->prev = 0;
    n->next = l->first;
    if(l->first == 0)
        l->last = n;
    else
        l->first->prev = n;
    l->first = n;
}


void listAddLast(list_t* l, void* data){

    listElem_t* n = malloc(sizeof(listElem_t));
    funcClone_t* fc = getCloneFunction(l->type);
    l->size = l->size + 1;
    n->data = fc(data);
    n->next = 0;
    n->prev = l->last;
    if(l->last == 0)
        l->first = n;
    else
        l->last->next = n;
    l->last = n;

}

void listDelete(list_t* l){
    funcDelete_t* fd = getDeleteFunction(l->type);
    listElem_t* current = l->first;
    while(current!=0) {
        listElem_t* tmp = current;
        current =  current->next;
        if(fd!=0) fd(tmp->data);
        free(tmp);
    }
    free(l);
}

void listPrint(list_t* l, FILE* pFile) {
    funcPrint_t* fp = getPrintFunction(l->type);
    fprintf(pFile, "[");
    listElem_t* current = l->first;
    if(current==0) {
        fprintf(pFile, "]");
        return;
    }
    while(current!=0) {
        if(fp!=0)
            fp(current->data, pFile);
        else
            fprintf(pFile, "%p",current->data);
        current = current->next;
        if(current==0)
            fprintf(pFile, "]");
        else
            fprintf(pFile, ",");
    }
}
