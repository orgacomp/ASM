#include <stdlib.h>
#include <string.h>
#include "invertebrados.h"

uint8_t *get_invertebrados_por_region_c(list_t* list, char* region){
    uint8_t *invertebrados = malloc(list->size);
    memset(invertebrados, -1, list->size);
    node_t *actual = list->first;
    int i = 0;
    int j = 0;
    while(actual != NULL) {
        if(actual->animal->invertebrado && strcmp(actual->animal->region, region) == 0){
            invertebrados[j++] = i;
        }
        actual = actual->next;
        i++;
    }
    return invertebrados;
}
