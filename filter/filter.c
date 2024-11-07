
#include <stdlib.h>
#include "lib.h"

void filter(list_t *l, int (*func)(int))
{
    listElem_t *actual = l->first;
    while (actual != NULL) // caso 0
    {
        listElem_t *nextElem = actual->next;
        if (!func(actual->data))
        {
            listElem_t *prevElem = actual->prev;
            if (l->size == 1) // caso 1
            {
                l->first = NULL;
                l->last = NULL;
            }
            else if (actual == l->first) // caso 2
            {
                l->first = nextElem;
                nextElem->prev = NULL;
            }
            else if (actual == l->last) // caso 3
            {
                l->last = prevElem;
                prevElem->next = NULL;
            }
            else // caso feliz
            {
                nextElem->prev = prevElem;
                prevElem->next = nextElem;
            }
            free(actual);
            l->size--;
        }

        actual = nextElem;
    }
}
