      /**********************************************************************/
        /*               ESPECIFICACIO LEX                                  */
        /*             	declaracions i instucci— if                         */
        /********************************************************************/

%{
	#include "llenguatge_if.tab.h"
    
    int nlin = 1;       // token sinceronitzaci— Žs el ;
%}

%option nounput
%option noinput


%%

[ \t]+                          	;	/* Ignora blancs i tabuladors */

[0-9]+                  return CONSTE;	/* contant entera  */

"if"					return IF;		/* paraula reservada */

"else"                  return ELSE;		/* paraula reservada */

"int"					return INT;		/* paraula reservada */

[a-zA-Z][a-zA-Z0-9]*	return ID;		/* identificadors */

"<="					return MEIG;		/* operador */

">="					return MAIG;		/* operador */

"=="					return IG;			/* operador */

"&&"                    return AND;			/* operador */

"||"                    return OR;			/* operador */

\n                      {	nlin++; }       /* ignorem newline */

.                     	{	return(yytext[0]);	}	/*  Els errors es processaran a nivell sintˆctic */


