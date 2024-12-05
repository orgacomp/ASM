#ifndef INVERTEBRADOS_H
#define INVERTEBRADOS_H

#include "list.h"

uint8_t *get_invertebrados_por_region_c(list_t* list, char* region);
uint8_t * get_invertebrados_por_region_asm(list_t* list, char* region);


#endif /* INVERTEBRADOS_H */