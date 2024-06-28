#include "createListFrom.h"
#include <stdlib.h>

void listInsert(list_t* l, void* data, uint8_t index);

/* createListFrom implementaa una función que dado un array de strings, crea una lista
   doblemente enlazada insertando todos los elementos del array de manera **alfabética**
   La función debe devolver la lista enlazada.
*/
list_t *createListFrom_c(array_t* array)
{
    list_t *list = listNew(TypeString);

    char* str;
    for (int i = 0; i < array->size; i++)
    {
        listInsertOrdered(list, arrayGet(array, i));
    }
    return list;
}

void listInsertOrdered(list_t* l, void* data){
    if (l->size == 0){
        listAddFirst(l, data);
        return;
    }
    
    uint8_t count = 0;
    listElem_t* current = l->first;

    while(current != l->last && strCmp(data, current->data) > 0) {
        current = current->next;
    }
    
    listElem_t* newElem = malloc(sizeof(listElem_t));
    newElem->next = current;
    newElem->prev = current->prev;
    current->prev->next = newElem;
    current->prev = newElem;
    newElem->data = data;
    l->size = l->size + 1;   
    
    listAddLast(l, data);


}