%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define LONGITUD_IDS 32
#define MAX_TABLA 200

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);

void verificarLongId(int);

typedef struct {
    char id[LONGITUD_IDS + 1];  // 32 caracteres para el id
    int valor;
} SIMBOLO;

static SIMBOLO tablaSimbolos[MAX_TABLA];
int cardinalTabla = 0;

void iniciarTabla();
int insertarSimbolo(char*, int);
int modificarSimbolo(char* nombre, int);
int buscarSimbolo(char* nombre);

%}

%union {
    char* cadena;
    int num;
}

%token ASIGNACION PYCOMA COMA SUMA RESTA PARENIZQUIERDO PARENDERECHO INICIO FIN LEER ESCRIBIR
%token <cadena> ID
%token <num> CONSTANTE

%%

programa: 
    { printf("Ingrese codigo en lenguaje micro\n"); }
    INICIO sentencias FIN
    { printf("Programa terminado con exito"); return 0; }
;

sentencias:
    sentencias sentencia
    | sentencia
;

sentencia:
    ID { verificarLongId(yyleng); }
    ASIGNACION expresion PYCOMA
    | LEER PARENIZQUIERDO listaVariables PARENDERECHO PYCOMA
    | ESCRIBIR PARENIZQUIERDO parametros PARENDERECHO PYCOMA
;

expresion:
    primaria
    | expresion operadorAditivo primaria
;

listaVariables:
    listaVariables COMA ID { verificarLongId(yyleng); }
    | ID { verificarLongId(yyleng); }
;

parametros:
    parametros COMA expresion
    | expresion
;

primaria:
    ID { verificarLongId(yyleng); }
    | CONSTANTE { printf("valores %d", atoi(yytext)); }
    | PARENIZQUIERDO expresion PARENDERECHO
;

operadorAditivo:
    SUMA
    | RESTA
;

%%

int main() {
    yyparse();
}

void yyerror(char *s) {
    printf("Error %s\n", s);
}

int yywrap() {
    return 1;  
}

void verificarLongId(int yyleng) {
    if (yyleng > LONGITUD_IDS) 
        yyerror("Lexico: el ID supera la longitud maxima");
}

void iniciarTabla() {
    int i;
    for (i = 0; i < MAX_TABLA; i++) {
        tablaSimbolos[i].id[0] = '\0';  // Inicializa las cadenas a vacío
        tablaSimbolos[i].valor = 0;
    }
}

int buscarSimbolo(char* nombre) {
    for (int i = 0; i < MAX_TABLA; i++) {
        if (strcmp(tablaSimbolos[i].id, nombre) == 0) {
            return i;  // Retorna el índice del símbolo encontrado
        }
    }
    return -1;  // No encontrado
}

int insertarSimbolo(char* nombre, int valor) {
    strcpy(tablaSimbolos[cardinalTabla].id, nombre);
    tablaSimbolos[cardinalTabla].valor = valor;
    cardinalTabla++;
    return 0;
}

int modificarSimbolo(char* nombre, int nuevoValor) {
    int idx = buscarSimbolo(nombre);
    if (idx != -1) {  
        tablaSimbolos[idx].valor = nuevoValor;
        return 0;  // Modificación exitosa
    }
    return -1;  // No encontrado
}
