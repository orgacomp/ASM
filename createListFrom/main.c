#include <stdio.h>
#include "lib.h"
#include "createListFrom.h"

int main(){
    char *str[10] = {"Hello", "World", "This", "Is", "A", "Test", "String", "Array", "For", "You"};
    array_t* array = arrayNew(TypeString, 10);

    for(int i=0; i<10; i++){
        arrayAddLast(array, str[i]);
    }
    
    printf("Original array:\n");
    arrayPrint(array, stdout);
    printf("\n");

    list_t* list = createListFrom_c(array);
    
    printf("Created list:\n");
    listPrint(list, stdout);
    printf("\n");

    listDelete(list);
    arrayDelete(array);
    
}