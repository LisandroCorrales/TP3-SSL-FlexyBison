%{
#include <stdio.h>
#include <stdlib.h> 
#include <math.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
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
programa: INICIO sentencias FIN {printf("Programa terminado con exito");return 0;}
;
sentencias: sentencias sentencia 
|sentencia
;
sentencia: ID {printf("LA LONG es: %d",yyleng);if(yyleng>4) yyerror("metiste la pata");}
ASIGNACION expresion PYCOMA
|LEER PARENIZQUIERDO listaVariables PARENDERECHO PYCOMA
|ESCRIBIR PARENIZQUIERDO parametros PARENDERECHO PYCOMA 
;
expresion: primaria 
|expresion operadorAditivo primaria
;
listaVariables: listaVariables COMA ID
|ID
;
parametros: parametros COMA expresion
|expresion
;
primaria: ID
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
printf ("mi error personalizado es %s\n",s);
}
int yywrap()  {
  return 1;  
}
 
 