#include "createListFrom.h"
#include <stdlib.h>

void listInsertOrdered(list_t* l, void* data);

/* createListFrom implementa una función que dado un array de strings, crea una lista
   doblemente enlazada insertando todos los elementos del array de manera **alfabética**
   La función debe devolver la lista enlazada.
*/
list_t *createListFrom_c(array_t* array)
{
    list_t *l = listNew(TypeString);

    for (int i = 0; i < array->size; i++)
    {
        listInsertOrdered(l, arrayGet(array, i));
    }
    return l;
}

void listInsertOrdered(list_t* l, void* data){
    if (l->size == 0){
        listAddFirst(l, data);
        return;
    }
    
    listElem_t* current = l->first;

    while(current != NULL && strCmp(data, current->data) < 0) {
        current = current->next;
    }

    if (current == l->first){
        listAddFirst(l, data);
        return;
    }

    if (current == NULL){
        listAddLast(l, data);
        return;
    }
    
    listElem_t* newElem = malloc(sizeof(listElem_t));
    newElem->next = current;
    newElem->prev = current->prev;
    current->prev->next = newElem;
    current->prev = newElem;
    newElem->data = strClone(data);
    l->size = l->size + 1;   
}