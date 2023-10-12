#include <stdio.h>
#include <string.h>
#include "empleado.h"
#include <stdio.h>
#include <stdlib.h>

// struct Empleado* empleado(const char *nombre, int edad) {
//     struct Empleado *nuevoEmpleado = (struct Empleado *)malloc(sizeof(struct Empleado));

//     nuevoEmpleado->nombre = (char *)malloc(strlen(nombre) + 1); // +1 para el carácter nulo

//     strcpy(nuevoEmpleado->nombre, nombre);

//     nuevoEmpleado->edad = edad;

//     return nuevoEmpleado;
// }


void liberarEmpleado(struct Empleado *empleado) {
    free(empleado->nombre);
    free(empleado);
}

int main() {
    struct Empleado *nuevoEmpleado = new_empleado("Meli", 30);
    printf("Nombre: %s\n", nuevoEmpleado->nombre);
    printf("Edad: %d\n", nuevoEmpleado->edad);

    liberarEmpleado(nuevoEmpleado);

    return 0;
}


    

