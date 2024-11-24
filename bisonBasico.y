%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "tabla_de_simbolos.h"

extern char *yytext;
extern int yyleng;
extern int yylex();
extern void yyerror(char*);
extern Lista lista;

void verificarId (int);
//int obtenerValor(char *symbol());
void actualizarSimbolo(char *symbol, int valor);

%}
%union{
   char* cadena;
   int num;
} 
%token ASIGNACION PYCOMA COMA SUMA RESTA PARENIZQUIERDO PARENDERECHO INICIO FIN LEER ESCRIBIR
%token <cadena> ID
%token <num> CONSTANTE
%%
programa: {printf("Ingrese codigo de lenguaje micro\n");} INICIO sentencias FIN {printf("Programa terminado con exito");return 0;}
;
sentencias: sentencias sentencia 
|sentencia
;
sentencia: ID {verificarId(yyleng);} //$$ = 0btenerValor($1); (nose q tan legal es esto} 
ASIGNACION expresion PYCOMA
|LEER PARENIZQUIERDO listaVariables PARENDERECHO PYCOMA{}
|ESCRIBIR PARENIZQUIERDO parametros PARENDERECHO PYCOMA 
;
expresion: primaria 
|expresion operadorAditivo primaria
;
listaVariables: listaVariables COMA ID {verificarId(yyleng);}
|ID {verificarId(yyleng);}
;
parametros: parametros COMA expresion //{quiero ver si el id esta declarado}
|expresion //{quiero ver si el id esta declarado}
;
primaria: ID {verificarId(yyleng);}
|CONSTANTE {printf("valores %d %d",atoi(yytext),$1); }
|PARENIZQUIERDO expresion PARENDERECHO
;
operadorAditivo: SUMA 
| RESTA
;
%%

/*
int obtenerValor(char *symbol){
    Simbolo *buscado = buscar(&lista, symbol);
    return buscado -> valor;
}
*/

void actualizarSimbolo(char *symbol, int valor ){
    modificar(&lista, symbol, valor);
}
int main() {
yyparse();
}
void yyerror (char *s){
printf ("mi error personalizado es %s\n",s);
}
int yywrap()  {
  return 1;  
}

void verificarId (int yyleng){
  if(yyleng>10) yyerror("el ID supera la longitud maxima");
}