%{
	#include "exercice.tab.h"

	int nlin=1;
%}

%option nounput
%option noinput
%option noyywrap


%%
[ \t]+                          ;
 
[0-9]+                          {	yylval.operando=atoi(yytext);
                                	return(OPERANDO);
                                }

\n                              {	nlin++;
                                    return(yytext[0]);
                                }

.                               {	return(yytext[0]);	
                                }	/*  Els errors es processaran a nvell sintàctic */


