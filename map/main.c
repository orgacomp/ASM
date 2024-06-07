#include <stdio.h>
#include "lib.h"
#include "map.h"

void* intByTwo(void* a){
    int32_t *b = (int32_t*)a;
    int32_t* r = intClone(b);
    *r = (*b)*2;
    return (void*) r;
}

int main(){
    array_t* array = arrayNew(TypeInt, 10);

    for(int i=0; i<10; i++){
        arrayAddLast(array, &i);
    }
    
    printf("Original array:\n");
    arrayPrint(array, stdout);
    printf("\n");

    array_t* mappedArray = map(array, intByTwo);
    
    printf("Mapped array:\n");
    arrayPrint(mappedArray, stdout);
    printf("\n");

    arrayDelete(array);
    arrayDelete(mappedArray);
    
}