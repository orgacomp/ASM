#include <stdio.h>
#include <string.h>
#include "intercambiar.h"

int main() {
    char cadena[] = "Orga del computador";

    intercambiar(cadena);

    printf("%s\n", cadena);

    return 0;
}
