%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define LONGITUD_IDS 32
#define MAX_TABLA 200
#define MAX_VARIABLES 25

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);

void verificarLongId (int);

typedef struct {
    char id[LONGITUD_IDS+1];
    int valor;
} SIMBOLO;
static SIMBOLO tablaSimbolos[MAX_TABLA];
int punteroTabla = 0;
void iniciarTabla()

%}
%union{
   char* cadena;
   int num;
} 
%token ASIGNACION PYCOMA COMA SUMA RESTA PARENIZQUIERDO PARENDERECHO INICIO FIN LEER ESCRIBIR
%token <cadena> ID
%token <num> CONSTANTE
%%
programa: {printf("Ingrese codigo en lenguaje micro\n");} INICIO sentencias FIN {printf("Programa terminado con exito");return 0;}
;
sentencias: sentencias sentencia 
|sentencia
;
sentencia: ID {verificarLongId(yyleng);} /* {quiero cargar el ID que reciben asignacion} */ 
ASIGNACION expresion PYCOMA
|LEER PARENIZQUIERDO listaVariables PARENDERECHO PYCOMA
|ESCRIBIR PARENIZQUIERDO parametros PARENDERECHO PYCOMA 
;
expresion: primaria 
|expresion operadorAditivo primaria
;
listaVariables: listaVariables COMA ID {verificarLongId(yyleng);} /* {quiero ver si el ID esta en la tabla, sino lo agrego};*/ /*{quiero ver en el vector de la funcion "rutina2" si existe el ID, si existe error, sino lo agrego} */
|ID {verificarLongId(yyleng);} /* {quiero ver si el ID esta en la tabla, sino lo agrego} */ /*{quiero ver en el vector de la funcion "rutina2" si existe el ID, si existe error, sino lo agrego}*/
;
parametros: parametros COMA expresion /* {quiero ver si el id esta declarado} */
|expresion /* {quiero ver si el id esta declarado} */
;
primaria: ID {verificarLongId(yyleng);} /* {quiero ver si el id esta en la tabla de simbolos, sino error} */
|CONSTANTE {printf("valores %d",atoi(yytext));}
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
  if(yyleng > LONGITUD_IDS) yyerror("Lexico: el ID supera la longitud maxima");
}

void iniciarTabla(){
  int i;
  for (i=0;i<=MAX_TABLA;i++){
    tablaSimbolos.id = '1'
  }
}