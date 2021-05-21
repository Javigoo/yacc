%{
    
  #include<stdio.h>
  #include<ctype.h>
    
  #define YYSTYPE char *

  int MAX = 20;
  int estat=0;
  int automat[MAX][5];
  extern int nlin;
  extern int yylex(void);
  void yyerror (char const *);

%}

%start final

%union{	int operando;
        int expression[2];
      }

%type <expression> E
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

E:      E'.'E { 
          set_transition( $1[1], 'e', $3[0]); 
          int initial_and_final_estat[2] = { $1[1], $3[0]}
          $$ = initial_and_final_estat;
        }

        | E'|'E {
          int estat_inicial = set_estat();
          int estat_final = set_estat();
          set_transition( $1[1], 'e', estat_final);
          set_transition( $3[1], 'e', estat_final);
          set_transition( estat_inicial, 'e', $1[0]);
          set_transition( estat_inicial, 'e', $3[0]);
          int initial_and_final_estat[2] = {estat_inicial, estat_final}
          $$ = initial_and_final_estat;
        }

        | E '*' {
          int estat_inicial = set_estat();
          int estat_final = set_estat();
          set_transition( estat_inicial, 'e', $1[0] )
          set_transition( $1[1], 'e', estat_final )
          set_transition( $1[1], 'e', $1[0] )
          set_transition( estat_inicial, 'e', estat_final )
          int initial_and_final_estat[2] = {estat_inicial, estat_final}
          $$ = initial_and_final_estat;          
        }

        | E '+' {
          int estat_inicial = set_estat();
          int estat_final = set_estat();
          set_transition( estat_inicial, 'e', $1[0] )
          set_transition( $1[1], 'e', estat_final )
          set_transition( $1[1], 'e', $1[0] )
          int initial_and_final_estat[2] = {estat_inicial, estat_final};
          $$ = initial_and_final_estat;          
        }
        
        | E '?' {
          int estat_inicial = set_estat();
          int estat_final = set_estat();
          set_transition( estat_inicial, 'e', $1[0] );
          set_transition( $1[1], 'e', estat_final );
          set_transition( estat_inicial, 'e', estat_final );
          int initial_and_final_estat[2] = {estat_inicial, estat_final};
          $$ = initial_and_final_estat;
        }

        | '('E')' { $$ = $2; }

        | OPERANDO { 
            int estat_inicial = set_estat();
            int estat_final = set_estat();
            set_transition(estat_inicial, yylval, estat_final); 
            int initial_and_final_estat[2] = {estat_inicial, estat_final};
            $$ = initial_and_final_estat;
          }
        ;

%%

void yyerror (char const *s){
  fprintf (stderr, "%s\n", s);
}

int main(void) {
  yyparse();
  return 0;
}

int get_estat(){
  return estat;
}

int set_estat(){
  estat++;
  return estat;
}

void set_transition(int i, char t, int j){
  j >> automat[i][t]
}
