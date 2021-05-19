%{
	#include "exercice.tab.h"

	int nlin=1;
%}

%option nounput
%option noinput
%option noyywrap


%%
[ \t]+                          ;
 
[0-9]+                          {	yylval=yytext[0];   // Error: Solo coje un numero
                                	return(OPERANDO);
                                }

\n                              {	nlin++;
                                    return(yytext[0]);
                                }
								
.                               {	return(yytext[0]);	
                                }
