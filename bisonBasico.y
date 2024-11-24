%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
TablaDeSimbolos* tablaSimbolos;  // Declarar la tabla de símbolos

// Prototipos
void verificarId(char* nombre);
void insertarSimbolo(TablaDeSimbolos* tabla, char* nombre, TipoDeDato tipo);
Simbolo* buscarSimbolo(TablaDeSimbolos* tabla, const char* nombre);
void verificarDuplicado(char* nombre, char** listaIds, int* size);
void liberarTabla(TablaDeSimbolos* tabla);
%}

%union{
    char* cadena;
    int num;
}

%token INICIO FIN LEER ESCRIBIR
%token ASIGNACION PYCOMA COMA SUMA RESTA PARENIZQUIERDO PARENDERECHO
%token <cadena> ID
%token <num> CONSTANTE

%%

programa:
    INICIO sentencias FIN { 
        printf("Programa ejecutado correctamente.\n"); 
        liberarTabla(tablaSimbolos);  // Liberar memoria al final
    }
;

sentencias:
    sentencias sentencia
    | sentencia
;

sentencia:
    ID ASIGNACION expresion PYCOMA { 
        verificarId($1); 
        insertarSimbolo(tablaSimbolos, $1, T_INT);  // Declarar la variable como entero
    }
    | LEER PARENIZQUIERDO listaVariables PARENDERECHO PYCOMA
    | ESCRIBIR PARENIZQUIERDO parametros PARENDERECHO PYCOMA
;

expresion:
    PRIMARY
    | expresion SUMA PRIMARY
    | expresion RESTA PRIMARY
;

listaVariables:
    listaVariables COMA ID { 
        verificarId($3); 
        verificarDuplicado($3, listaIds, &listaSize);  // Verificar duplicados
        insertarSimbolo(tablaSimbolos, $3, T_INT);
    }
    | ID { 
        verificarId($1); 
        verificarDuplicado($1, listaIds, &listaSize);  // Verificar duplicados
        insertarSimbolo(tablaSimbolos, $1, T_INT);
    }
;

parametros:
    parametros COMA expresion
    | expresion
;

PRIMARY:
    ID { verificarId($1); }
    | CONSTANTE { printf("Constante: %d\n", $1); }
    | PARENIZQUIERDO expresion PARENDERECHO
;

%%

// Función para verificar si una variable ha sido declarada
void verificarId(char* nombre) {
    Simbolo* simbolo = buscarSimbolo(tablaSimbolos, nombre);
    if (!simbolo) {
        yyerror("Error: la variable no está declarada");
    }
}

// Función para verificar si un identificador está duplicado
void verificarDuplicado(char* nombre, char** listaIds, int* size) {
    // Buscar si el identificador ya está en la lista
    for (int i = 0; i < *size; i++) {
        if (strcmp(listaIds[i], nombre) == 0) {
            yyerror("Error: identificador duplicado en la lista de leer");
            return;
        }
    }

    // Si no es un duplicado, agregar a la lista
    listaIds[*size] = strdup(nombre);  // Copiar el nombre a la lista
    (*size)++;
}

// Función principal de ejecución
int main() {
    tablaSimbolos = crearTabla(2);  // Crear la tabla de símbolos
    char* listaIds[100];  // Lista de IDs para leer
    int listaSize = 0;  // Tamaño de la lista

    yyparse();

    // Liberar los identificadores almacenados
    for (int i = 0; i < listaSize; i++) {
        free(listaIds[i]);
    }

    return 0;
}

void yyerror(char* mensaje) {
    printf("Error: %s\n", mensaje);
}
