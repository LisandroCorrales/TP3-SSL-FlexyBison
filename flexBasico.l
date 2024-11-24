%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"
	#include "tabla_de_simbolos.h"
	extern void yyerror(char *s);

	Lista lista = {NULL, 0};
%}
DIGITO [0-9]

LETRA [a-zA-Z]

IDENTIFICADOR {LETRA}({LETRA}|{DIGITO}){0,31}

constEntera {DIGITO}({DIGITO})*
%%
"inicio" {return INICIO;}
"fin" {return FIN;}
"escribir" {return ESCRIBIR;}
"leer" {return LEER;}


":=" {return ASIGNACION;}
{constEntera} {yylval.num=atoi(yytext);return CONSTANTE;}
{IDENTIFICADOR} {
		Simbolo *buscado = buscaar(&lista, yytext);
			if(buscado == NULL){
			Simbolo simbolo;
			strcpy(simbolo.nombre , yytext);
			simbolo.valor = 0;
			insertar(&lista, &simbolo);
			}
		strcpy(yylval.id, yytext);
		return ID;
}
";" {return PYCOMA;}
"," {return COMA;}
"(" {return PARENIZQUIERDO;}
")" {return PARENDERECHO;}
"+" {return SUMA;}
"-" {return RESTA;}
.  {ECHO; yyerror("Caracter no esperado");} //puede no ir, es para filtrar los caracteres q no se esperan
%%
int yywrap(void){ //se utiliza para decidir que debe hacer yylex() cuando se alcanza el final del fichero de entrada
	return 1;
}