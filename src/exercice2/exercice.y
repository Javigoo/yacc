%{
    
  #include<stdio.h>
  #include<ctype.h>
    
  extern int nlin;
  extern int yylex(void);
  void yyerror (char const *);

%}

%start final

%union{	int operando;
        }

%token <operando> OPERANDO

%left '+' '-'
%left '*' '/' '%'

%%

final:  {;}
        |   final lines
        ;

lines:  '\n'    {;}
        | E ';' { printf("\n");}
	;

E:      E'+'E { printf("+ ");}
        | E'-'E { printf("- ");}
        | E'*'E { printf("* ");}
        | E'/'E { printf("/ ");}
        | E'%'E { printf("%% ");}
        | '('E')'
        | OPERANDO { printf("%i ",yylval);}
        ;

%%

void yyerror (char const *s){
  fprintf (stderr, "%s\n", s);
}

int main(void) {
  yyparse();
  return 0;
} 
