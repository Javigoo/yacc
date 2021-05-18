        /*************************************************/
        /*               ESPECIFICACIO LEX               */
        /*              Declaracions 	                 */
        /*************************************************/

%{
    #include "decla.tab.h"
    
    int nlin = 1;       // token sinceronització és el ;
    
%}

%option nounput
%option noinput


%%

[ \t]+                          	;	/* Ignora blancs, tabuladors i new line*/

"int"                           return INT;         /* paraula reservada */

"float"|"double"               	return REAL;		/* paraulers reservades */

"char"                          return CHAR;		/* paraula reservada */

[a-zA-Z_][a-zA-Z0-9_]*          return ID;			/* identificadors */

\n                              nlin++;       /* ignorem newline */

.                               return(yytext[0]); 	/*  Els errors es processaran a nivell sintàctic */

