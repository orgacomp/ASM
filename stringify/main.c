#include "list.h"
#include "stringify.h"

int main() {
    list_t *l = create_list();
    stringify_c(stdout, l);
    stringify_asm(stdout, l);
    add_node(l, 1);
    add_node(l, 2);
    add_node(l, 3);
    add_node(l, 4);
    add_node(l, 5);
    stringify_c(stdout, l);
    stringify_asm(stdout, l);
    destroy_list(l);
    return 0;
}