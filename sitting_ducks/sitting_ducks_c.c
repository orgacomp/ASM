#include <stdlib.h>
#include <string.h>
#include "sitting_ducks.h"

char* sitting_ducks_c(char* str, char marker){

    size_t len = 0;
    while(str[len] != '\0') {
        len++;
    }
    char* result = (char*)malloc(len + 1);

    for (size_t i = 0; i < len; i++) {
        if (str[i] != marker) {
            result[i] = '_';
        }else{
            result[i] = str[i];
        }
    }
    result[len] = '\0'; // Null-terminate

    return result;    
}
