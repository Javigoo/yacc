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

final:  {fprintf(stdout,"final:\n");}
        |   final lines {fprintf(stdout,"final: final lines\n");}
        ;

lines:  '\n'    {fprintf(stdout,"lines: \\n\n");}
        | E ';' {fprintf(stdout,"lines: E ';'\n");}
	;

E:      E'-'E           {fprintf(stdout,"E: E'-'E\n");}
        | E'+'E         {fprintf(stdout,"E: E'+'E\n");}
        | E'*'E         {fprintf(stdout,"E: E'*'E\n");}
        | E'%'E         {fprintf(stdout,"E: E'%%'E\n");}
        | E'/'E         {fprintf(stdout,"E: E'/'E\n");}
        | '('E')'       {fprintf(stdout,"E: '('E')'\n");}
        | OPERANDO      {fprintf(stdout,"E: OPERANDO (%i)\n", yyval);}
        ;

%%

void yyerror (char const *s){
  fprintf (stderr, "%s\n", s);
}

int main(void) {
  yyparse();
  return 0;
} 
