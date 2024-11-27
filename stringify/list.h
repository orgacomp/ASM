#ifndef LIST_H
#define LIST_H


typedef struct node{
    struct node *next;
    int data;
} node_t;

typedef struct list{
    node_t *first;
    node_t *last;
    int size;
}list_t;

list_t* create_list();
void add_node(list_t* l, int data);
void destroy_list(list_t* l);


#endif /* LIST_H */