%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define LONGITUD_IDS 32
#define MAX_TS 200
#define MAX_VARIABLES 25

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
void verificarLongId (int);
int variable=0;
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
sentencia: ID {verificarLongId(yyleng);} /* {quiero listar los IDs que reciben asignacion} */ 
ASIGNACION expresion PYCOMA
|LEER PARENIZQUIERDO listaVariables PARENDERECHO PYCOMA
|ESCRIBIR PARENIZQUIERDO parametros PARENDERECHO PYCOMA 
;
expresion: primaria 
|expresion operadorAditivo primaria
;
listaVariables: listaVariables COMA ID //{verificarLongId(yyleng);}
|ID {verificarLongId(yyleng);}
;
parametros: parametros COMA expresion /* {quiero ver si el id esta declarado} */
|expresion /* {quiero ver si el id esta declarado} */
;
primaria: ID {verificarLongId(yyleng);}
|CONSTANTE {printf("valores %d %d",atoi(yytext),$1); }
|PARENIZQUIERDO expresion PARENDERECHO
;
operadorAditivo: SUMA 
| RESTA
;
%%
int main() {
yyparse();
}

void yyerror (char *s){
printf ("Error %s\n",s);
}
int yywrap()  {
  return 1;  
}
void verificarLongId (int yyleng){
  if(yyleng > LONGITUD_IDS) yyerror("Lexico: el ID supera la longitud maxima ()");
}
