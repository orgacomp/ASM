#include <stdlib.h>
#include "list.h"

list_t* create_list(){
    list_t *l = malloc(sizeof(list_t));
    l->first = 0;
    l->last = 0;
    l->size = 0;
    return l;
}

void destroy_list(list_t* l) {
    node_t *actual = l->first;
    while(actual != NULL) {
        node_t *next = actual->next;
        free(actual);
        actual = next;
    }
    free(l);
}


void add_node(list_t* l, animal_t* animal){
    node_t* n = malloc(sizeof(node_t));
    n->animal = animal;
    n->next = NULL;

    if(l->last == NULL){
        l->first = n;
        l->last = n;
    } else {
        l->last->next = n;
        l->last = n;
    }
    
    l->size++;
}

animal_t* list_get(list_t* l, uint8_t index){
    node_t *actual = l->first;
    for (int i = 0; i < index; i++) {
        actual = actual->next;
    }
    return actual->animal;
}
