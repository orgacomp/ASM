#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sitting_ducks.h"

#define ASSEMBLY_IMPLEMENTATION


int main() {
    char* (*sitting_ducks)(char*, char);

    #ifdef ASSEMBLY_IMPLEMENTATION
    sitting_ducks = sitting_ducks_asm;
    #else
    sitting_ducks = sitting_ducks_c;
    #endif

    char *str1 ="axbxcdx";
    char marker = 'x';
    int error = 0;
    //char *result_1 = sitting_ducks_c(str1, marker);
    char *result_1 = sitting_ducks(str1, marker);
    
    if (strcmp(result_1, "_x_x__x") != 0) {
        printf("Error!\n");
        error = 1;
        printf("result: %s\n",result_1);
    }

    char *str2 = "";
    char *result_2 = sitting_ducks(str2, marker);
    if (strcmp(result_2, "") != 0) {
        printf("Error!\n");
        error = 1;
        printf("result: %s\n", result_2);
    }
   
    char *str3 = "hello";
    char *result_3 = sitting_ducks(str3, marker);
    if (strcmp(result_3, "_____") != 0) {
        printf("Error!\n");
        error = 1;
        printf("result: %s\n", result_3);
    }
    
    if(error) {
        printf("Results do not match!\n");
    }else{
        printf("All tests passed!\n");
    }
    
    free(result_1);
    free(result_2);
    free(result_3);
    return 0;
}