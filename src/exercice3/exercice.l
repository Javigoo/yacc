%{
	#include "exercice.tab.h"

	int nlin=1;
%}

%option nounput
%option noinput
%option noyywrap


%%
[ \t]+                          ;
 
[0-9]+                          {	yylval=atoi(yytext);
                                	return(NUMBER);
                                }

\n                              {	nlin++;
                                    return(yytext[0]);
                                }
								
.                               {	return(yytext[0]);	
                                }
								