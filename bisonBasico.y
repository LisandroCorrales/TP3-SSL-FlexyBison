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
%token ASIGNACION PYCOMA SUMA RESTA PARENIZQUIERDO PARENDERECHO INICIO FIN LEER ESCRIBIR
%token <cadena> ID
%token <num> CONSTANTE
%%
programa: INICIO sentencias FIN { "Programa terminado con exito" }      //agregado
;
sentencias: sentencias sentencia 
|sentencia
;
sentencia: ID {printf("LA LONG es: %d",yyleng);if(yyleng>4) yyerror("metiste la pata");} // rutina semantica
ASIGNACION expresion PYCOMA
|LEER PARENIZQUIERDO expresion PARENDERECHO PYCOMA {#leer}              //agregado
|ESCRIBIR PARENIZQUIERDO expresion PARENDERECHO PYCOMA {#escribir}      //agregado
;
expresion: primaria 
|expresion operadorAditivo primaria 
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
 
 