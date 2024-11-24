%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"
	#include "tabla_de_simbolos.h"
	extern void yyerror(char *s);

	Lista lista = {NULL};
%}
DIGITO [0-9]

LETRA [a-zA-Z]

IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*

constEntera {DIGITO}({DIGITO})*
%%
"inicio" {return INICIO;}
"fin" {return FIN;}
"escribir" {return ESCRIBIR;}
"leer" {return LEER;}


":=" {return ASIGNACION;}
{constEntera} {yylval.num=atoi(yytext);return CONSTANTE;}
{IDENTIFICADOR} {return ID;}
";" {return PYCOMA;}
"," {return COMA;}
"(" {return PARENIZQUIERDO;}
")" {return PARENDERECHO;}
"+" {return SUMA;}
"-" {return RESTA;}

%%
