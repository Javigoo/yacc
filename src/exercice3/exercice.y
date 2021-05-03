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

%type <operando> E

%%

final:  {;}
        |   final lines
        ;

lines:  '\n'    {;}
        | E ';' { printf("\n");}
	;

E:      E'-'E   { fprintf(stdout,"resta: %i - %i \n", $1, $3);}
        | E'+'E { fprintf(stdout,"sum: %i + %i \n", $1, $3);}
        | E'*'E { fprintf(stdout,"mult: %i * %i \n", $1, $3);}
        | E'%'E { fprintf(stdout,"mod: %i %% %i \n", $1, $3);}
        | E'/'E { fprintf(stdout,"division: %i / %i \n", $1, $3);}
        | '('E')'       { fprintf(stdout,"parentesis: (%i) \n", $2);}
        | OPERANDO { printf("operando:%i \n ",yylval);}
        ;

%%

void yyerror (char const *s){
  fprintf (stderr, "%s\n", s);
}

int main(void) {
  yyparse();
  return 0;
} 
