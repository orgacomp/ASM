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


void add_node(list_t* l, int data){
    node_t* n = malloc(sizeof(node_t));
    n->data = data;
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


