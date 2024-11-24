#ifndef TABLA_DE_SIMBOLOS_H
#define TABLA_DE_SIMBOLOS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Definición de los tipos
typedef enum { T_INT } TipoDeDato;  // Puedes agregar más tipos si es necesario

// Estructura para almacenar información sobre un símbolo
typedef struct Simbolo {
    char* nombre;
    TipoDeDato tipo;
    struct Simbolo* siguiente;
} Simbolo;

// Estructura para la tabla de símbolos
typedef struct TablaDeSimbolos {
    Simbolo* primero;
} TablaDeSimbolos;

// Declaración de funciones
TablaDeSimbolos* crearTabla(); 
void insertarSimbolo(TablaDeSimbolos* tabla, char* nombre, TipoDeDato tipo);
Simbolo* buscarSimbolo(TablaDeSimbolos* tabla, const char* nombre);
void liberarTabla(TablaDeSimbolos* tabla);

#endif  // TABLA_DE_SIMBOLOS_H
