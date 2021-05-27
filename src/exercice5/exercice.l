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
 
[A-Z]+                          {	yylval=yytext[0];
                                	return(VALUE);
                                }

\n                              {	nlin++;
                                    return(yytext[0]);
                                }

.                               {	return(yytext[0]);	
                                }	/*  Els errors es processaran a nvell sintàctic */


