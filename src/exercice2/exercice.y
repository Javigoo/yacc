%{
 #define YYSTYPE double
 #include "lex.yy.c"
 #include <stdio.h>
 #include<ctype.h>
 
 void yyerror(char *);
 
%}

%token NUMBER
%left '+'  '-'
%left '*'  '/'  '#'
%right UMINUS
%right '^'

%%
final : lines '\n'
    |
    ;
lines: E ';' { printf("\n");}
	|
	;
E :E'+'E { printf(" + ");}
  |E'-'E { printf(" - ");}
  |E'*'E { printf(" * ");}
  |E'#'E { printf(" # ");}
  |E'/'E { printf(" / ");}
  |'('E')'
  |NUMBER { printf("%g ",yylval);}
  ;



%%

void yyerror(char *s) {
 fprintf(stderr, "%s\n", s);
}



int main(void) {
 yyparse();
 return 0;
} 
