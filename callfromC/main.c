#include <stdio.h>
#include "funcs.h"

int main(){
    int a[] = {1,2,3,4,5,6,7,8,9,10};
    int b[] = {4,6,7,8,9,-1,7,-1,5,-10};
    int c[10] = {0};
    int d[10] = {0};

    sumar_c(a,b,c,10);
    sumar_asm(a,b,d,10);

    for (int i=0; i < 10; ++i){
        if(c[i] != d[i]){
            printf("Error en la suma\n");
            return 1;
        }
    }
    printf("OK!\n");
}