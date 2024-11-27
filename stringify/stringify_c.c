#include "stringify.h"

void stringify_c(FILE *fp, list_t* list) {
    node_t *actual = list->first;
    
    while (actual != NULL) {
        fprintf(fp, "%d -> ", actual->data);
        actual = actual->next;
    }
    fprintf(fp, "NULL\n");
}