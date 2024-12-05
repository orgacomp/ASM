#ifndef LIST_H
#define LIST_H

#include <stdint.h>

typedef struct animal{
    char* nombre;
    uint8_t invertebrado;
    char* region;
} animal_t;

typedef struct node{
    struct node *next;
    animal_t *animal;
} node_t;

typedef struct list{
    node_t *first;
    node_t *last;
    uint8_t size;
}list_t;

list_t* create_list();
void add_node(list_t* l, animal_t* animal);
animal_t* list_get(list_t* l, uint8_t index);
void destroy_list(list_t* l);


#endif /* LIST_H */