#include "funcs.h"

void sumar_c(int *a, int *b, int *c, int length){
    for (int i=0; i<length; ++i){
        c[i] = a[i] + b[i];
    }
}