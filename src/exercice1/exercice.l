        /*************************************************/
        /*               ESPECIFICACIO LEX               */
        /*          Calculadora amb registres            */
        /*************************************************/

%{
	#include "exercice.tab.h"

	int nlin=1;
%}

%option nounput
%option noinput
%option noyywrap


%%
[ \t]+                          ;
 
[a-z]                           {	yylval.intReg=yytext[0]-'a';
                                	return(INT_REG);
                                }

[A-Z]                           {	yylval.floatReg=yytext[0]-'A';
                                	return(FLOAT_REG);
                                }

[0-9]+                          {	yylval.intValue=atoi(yytext);
                               	 	return(INT_VALUE);
                                }

[0-9]+\.[0-9]+                  {	yylval.floatValue=atof(yytext);
                               	 	return(FLOAT_VALUE);
                                }

\n                              {	nlin++;
                                        return(yytext[0]);
                                }

.                               {	return(yytext[0]);	
                                }	/*  Els errors es processaran a nvell sintàctic */


