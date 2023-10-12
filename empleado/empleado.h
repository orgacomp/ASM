#ifndef EMPLEADO
#define EMPLEADO

struct Empleado {
    char *nombre;
    int edad;
};

struct Empleado* new_empleado(const char *nombre, int edad);

#endif /* EMPLEADO */
