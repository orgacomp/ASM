#include <stdio.h>
#include <stdlib.h>
#include "list.h"
#include "invertebrados.h"

# define N 4

void print_animals(list_t* l, uint8_t* indexes){
    for(int i = 0; i < l->size; i++){
        if (indexes[i] == 255) {
            break;
        }
        printf("%s ", list_get(l,indexes[i])->nombre);
    }
    printf("\n");
}

int main() {
    list_t *l = create_list();

    animal_t animales [10] = {
        { .nombre = "Araña",
          .invertebrado = 1,
          .region = "India"
        },
        { .nombre = "Elefante",
          .invertebrado = 0,
          .region = "Africa"
        },
        { .nombre = "Abeja",
          .invertebrado = 1,
          .region = "Argentina"
        },
        { .nombre = "Mosquito",
          .invertebrado = 1,
          .region = "Argentina"
        },
        { .nombre = "Caballo",
          .invertebrado = 0,
          .region = "Argentina"
        },
        { .nombre = "Cucaracha",
          .invertebrado = 1,
          .region = "Singapur"
        },
        { .nombre = "Antilope",
          .invertebrado = 0,
          .region = "Canada"
        },
        { .nombre = "Oso",
          .invertebrado = 0,
          .region = "Rusia"
        },
        { .nombre = "Perro",
          .invertebrado = 0,
          .region = "Brasil"
        },
        { .nombre = "Mosca",
          .invertebrado = 1,
          .region = "Africa"
        }
    };

    for (int i = 0; i < 10; i++) {
        add_node(l, &animales[i]);
    }

    uint8_t* inv[N];
    char *regiones[N] = {"Argentina", "Africa", "India", "Rusia"};

    for (int i = 0; i < N; i++) {
        inv[i] = get_invertebrados_por_region_asm(l, regiones[i]);
        //inv[i] = get_invertebrados_por_region_c(l, regiones[i]);
    }

    for (int i = 0; i < N; i++) {
        printf("%-12s: ", regiones[i]);
        print_animals(l, inv[i]);
    }

    destroy_list(l);
    for (int i = 0; i < 4; i++) {
        free(inv[i]);
    }

    return 0;
}