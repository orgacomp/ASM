#ifndef STRINGIFY_H
#define STRINGIFY_H

#include <stdio.h>
#include "list.h"

void stringify_c(FILE *fp, list_t* list);
void stringify_asm(FILE *fp, list_t* list);


#endif /* STRINGIFY_H */