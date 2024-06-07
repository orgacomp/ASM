#include "map.h"

array_t *map_c(array_t* array, void* (*func)(void*)){
    array_t* newArray = arrayNew(array->type, array->capacity);
    for(int i=0; i<array->size; i++){
        void* data = func(array->data[i]);
        newArray->size++;
        newArray->data[i] = data;
    }
    return newArray;
}