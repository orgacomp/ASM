
typedef struct s_list
{
    struct s_listElem *first;
    struct s_listElem *last;
    int size;
} list_t;

typedef struct s_listElem
{
    int data;
    struct s_listElem *next;
    struct s_listElem *prev;
} listElem_t;

void filter(list_t *l, int (*func)(int));
void filterAsm(list_t *l, int (*func)(int));
