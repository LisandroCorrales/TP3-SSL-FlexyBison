%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define LONGITUD_IDS 32
#define MAX_TABLA 200 
#define LONGITUD_VECTOR 25

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);

void verificarLongId(int);

typedef struct {
    char id[LONGITUD_IDS + 1];  // 32 caracteres para el id
    int valor;
} SIMBOLO;
static SIMBOLO vectorDeVariables[LONGITUD_VECTOR];
static SIMBOLO tablaSimbolos[MAX_TABLA];

int cardinalTabla = 0;
int cardinalVector = 0;

void iniciarTabla();
void iniciarVectorSimbolos();
int insertarSimbolo(char*);
int modificarSimbolo(char* , int);
int buscarSimbolo(char* );
int insertarSimboloVector(char * );
int buscarSimboloVector(char* ) ;
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
    ID { verificarLongId(yyleng); insertarSimbolo(yytext);}
    ASIGNACION expresion PYCOMA
    |  LEER {iniciarVectorSimbolos();} PARENIZQUIERDO listaVariables PARENDERECHO PYCOMA 
    | ESCRIBIR PARENIZQUIERDO parametros PARENDERECHO PYCOMA
;

expresion:
    primaria
    | expresion operadorAditivo primaria
;

listaVariables:
    listaVariables COMA ID { verificarLongId(yyleng); insertarSimbolo(yytext); insertarSimboloVector(yytext); }
    | ID { verificarLongId(yyleng);insertarSimbolo(yytext); insertarSimboloVector(yytext); }
;

parametros:
    parametros COMA expresion
    | expresion
;

primaria:
    ID { verificarLongId(yyleng); if(buscarSimbolo(yytext)==-1){
      yyerror("la variable no fue declarada previamente");
    } }
    | CONSTANTE { printf("valores %d", atoi(yytext)); }
    | PARENIZQUIERDO expresion PARENDERECHO
;

operadorAditivo:
    SUMA
    | RESTA
;

%%

int main() {
    iniciarTabla();
    iniciarVectorSimbolos();
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
void iniciarVectorSimbolos(){
  int i;
  for(i = 0; i < LONGITUD_VECTOR; i++) {
    vectorDeVariables[i].id[0] = '\0'; 
    vectorDeVariables[i].valor = 0;
  
}}

int buscarSimbolo(char* nombre) {
    for (int i = 0; i <cardinalTabla; i++) {
        if (strcmp(tablaSimbolos[i].id, nombre) == 0) {
            return i;  // Retorna el índice del símbolo encontrado
        }
    }
    return -1;  // No encontrado
}

int insertarSimbolo(char * nombre) {
    int resultado = buscarSimbolo(nombre);
    if(resultado == -1){strcpy(tablaSimbolos[cardinalTabla].id,nombre);
    cardinalTabla++;
    return 0;}
    return resultado;
    
}
int insertarSimboloVector(char * nombre) {
    int resultado = buscarSimboloVector(nombre);
    if(resultado == -1){strcpy(vectorDeVariables[cardinalVector].id,nombre);
    cardinalVector++;
    return 0;}
    yyerror("no se puede declarar mas de una vez en un mismo argumento");
    return resultado;
    
}
int buscarSimboloVector(char* nombre) {
    for (int i = 0; i <cardinalVector; i++) {
        if (strcmp(vectorDeVariables[i].id, nombre) == 0) {
            return i;  // Retorna el índice del símbolo encontrado
        }
    }
    return -1;  // No encontrado
}

int modificarSimbolo(char* nombre, int nuevoValor) {
    int idx = buscarSimbolo(nombre);
    if (idx != -1) {  
        tablaSimbolos[idx].valor = nuevoValor;
        return 0;  // Modificación exitosa
    }
    return -1;  // No encontrado
}

