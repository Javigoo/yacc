%{
	#include "exercice.tab.h"
    #define YYSTYPE char *



    extern YYSTYPE yylval;
	int nlin=1;
%}

%option nounput
%option noinput
%option noyywrap


%%
[ \t]+                          ;
 
abcd                            {	yylval=yytext[0];
                                	return(NUMBER);
                                }

\n                              {	nlin++;
                                    return(yytext[0]);
                                }
								
.                               {	return(yytext[0]);	
                                }
