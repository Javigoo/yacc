/**********************************************************************/
/*               ESPECIFICACIO LEX                                  */
/*             	constants amb parèntesis  acabat en ';'             */
/********************************************************************/

%{
    #include "parentesis.tab.h"
    
    int nlin = 0;       // token sinceronització és \n
%}

%option nounput
%option noinput


%%

[ \t]+                          	;	/* Ignora blancs i tabuladors */

[0-9]+              { return CONSINT; }


\n                  {   nlin++; }       // comptar línies

[();]               {return(yytext[0]);}  // simbols correctes

.                   {return(yytext[0]);}    // passem els errors a nivell sintàctic






