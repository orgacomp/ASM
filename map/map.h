#ifndef MAP_H
#define MAP_H

#include "lib.h"

array_t *map_c(array_t* array, void* (*func)(void*));
array_t *map(array_t* array, void* (*func)(void*));

#endif /* MAP_H */
