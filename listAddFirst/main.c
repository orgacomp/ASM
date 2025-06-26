#include <stdio.h>
#include "lib.h"

int main(){
    char *str[10] = {"Hello", "World", "This", "Is", "A", "Test", "String", "Array", "For", "You"};
    list_t* list = listNew(TypeString);

    for(int i=0; i<10; i++){
        listAddFirst(list, str[i]);
    }
    
    printf("listAddFirst C:\n");
    listPrint(list, stdout);
    printf("\n");

    list_t* list_asm = listNew(TypeString);

    for(int i=0; i<10; i++){
        listAddFirst_asm(list_asm, str[i]);
    }

    printf("listAddFirst ASM:\n");
    listPrint(list_asm, stdout);
    printf("\n");

    listDelete(list);
    listDelete(list_asm);
    
}