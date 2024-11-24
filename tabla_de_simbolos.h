#include <stdlib.h>

typedef struct Simbol{
    char nombre[100];
    int valor;
} Simbolo;

typedef struct Nodo{
    Simbolo simbolo;
    struct Nodo* siguiente;
} Nodo;

typedef struct Lista{
    Nodo *cabeza;
} Lista;

Nodo *crearNodo(simbolo *simbolo);
void insertar(Lista *lista, Simbolo * simbolo);
Simbolo *buscar(Lista *lista,char *nombre);
void modificar(Lista *lista, char * simbolo, int valor);