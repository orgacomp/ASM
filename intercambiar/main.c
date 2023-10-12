#include <stdio.h>
#include <string.h>
#include "intercambiar.h"

int main() {
    char cadena[] = "Orga";

    intercambiar(cadena);

    printf("%s\n", cadena);

    return 0;
}


int calcularLongitud_str(char cadena[]) {
    int longitud = 0;

    while (cadena[longitud] != '\0') {
        longitud++;
    }

    return longitud;
}

void intercambiar_c(char str[]) {
    int longitud = strlen(str);
    int ini = 0;
    int fin = longitud - 1;
    char aux;

    while (ini < fin) {
        aux = str[ini];
        str[ini] = str[fin];
        str[fin] = aux;
        
        ini++;
        fin--;
    }
}