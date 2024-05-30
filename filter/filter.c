
#include <stdlib.h>
#include "lib.h"

void filter(list_t *l, int (*func)(int))
{
    listElem_t *actual = l->first;
    while (actual != NULL)
    {
        listElem_t *nextElem = actual->next;
        if (!func(actual->data))
        {
            listElem_t *prevElem = actual->prev;
            if (l->size == 1)
            {
                l->first = NULL;
                l->last = NULL;
            }
            else if (actual == l->first)
            {
                l->first = nextElem;
                nextElem->prev = NULL;
            }
            else if (actual == l->last)
            {
                l->last = prevElem;
                prevElem->next = NULL;
            }
            else
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
