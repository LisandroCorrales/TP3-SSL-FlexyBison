#include "tabla_de_simbolos.h"

// Crear la tabla de símbolos
TablaDeSimbolos* crearTabla() {
    TablaDeSimbolos* tabla = (TablaDeSimbolos*)malloc(sizeof(TablaDeSimbolos));
    tabla->primero = NULL;  // Inicializar la tabla vacía
    return tabla;
}

// Insertar un símbolo en la tabla de símbolos
void insertarSimbolo(TablaDeSimbolos* tabla, char* nombre, TipoDeDato tipo) {
    Simbolo* nuevo = (Simbolo*)malloc(sizeof(Simbolo));
    nuevo->nombre = strdup(nombre);  // Copiar el nombre del identificador
    nuevo->tipo = tipo;
    nuevo->siguiente = tabla->primero;  // Insertar al inicio de la lista
    tabla->primero = nuevo;
}

// Buscar un símbolo en la tabla de símbolos por nombre
Simbolo* buscarSimbolo(TablaDeSimbolos* tabla, const char* nombre) {
    Simbolo* actual = tabla->primero;
    while (actual != NULL) {
        if (strcmp(actual->nombre, nombre) == 0) {
            return actual;  // Simbolo encontrado
        }
        actual = actual->siguiente;
    }
    return NULL;  // No encontrado
}

// Liberar la memoria de la tabla de símbolos
void liberarTabla(TablaDeSimbolos* tabla) {
    Simbolo* actual = tabla->primero;
    Simbolo* siguiente;
    while (actual != NULL) {
        siguiente = actual->siguiente;
        free(actual->nombre);  // Liberar el nombre del identificador
        free(actual);  // Liberar el nodo
        actual = siguiente;
    }
    free(tabla);  // Liberar la tabla
}
