%{
    
  #include<stdio.h>
  #include<ctype.h>

  int estat=0;
  int automat[20][5];
  extern int nlin;
  extern int yylex(void);
  void yyerror (char const *);
%}

%start final

%union{	int letter;
        struct {int *initial_val, final_val} ExpressionType;
      }

%type <ExpressionType> E
%token <letter> LETTER

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
          set_transition( $1.final_val, 'e', $3.initial_val);
          $$.initial_val = $1.final_val;
          $$.final_val = $3.initial_val;
        }

        | E'|'E {
          int estat_inicial = set_estat();
          int estat_final = set_estat();
          set_transition( $1.final_val, 'e', estat_final);
          set_transition( $3.final_val, 'e', estat_final);
          set_transition( estat_inicial, 'e', $1.initial_val);
          set_transition( estat_inicial, 'e', $3.initial_val);
          $$.initial_val = estat_inicial;
          $$.final_val = estat_final;
        }

        | E '*' {
          int estat_inicial = set_estat();
          int estat_final = set_estat();
          set_transition( estat_inicial, 'e', $1.initial_val );
          set_transition( $1.final_val, 'e', estat_final );
          set_transition( $1.final_val, 'e', $1.initial_val );
          set_transition( estat_inicial, 'e', estat_final );
          $$.initial_val = estat_inicial;
          $$.final_val = estat_final;
        }

        | E '+' {
          int estat_inicial = set_estat();
          int estat_final = set_estat();
          set_transition( estat_inicial, 'e', $1.initial_val );
          set_transition( $1.final_val, 'e', estat_final );
          set_transition( $1.final_val, 'e', $1.initial_val );
          $$.initial_val = estat_inicial;
          $$.final_val = estat_final;
        }
        
        | E '?' {
          int estat_inicial = set_estat();
          int estat_final = set_estat();
          set_transition( estat_inicial, 'e', $1.initial_val );
          set_transition( $1.final_val, 'e', estat_final );
          set_transition( estat_inicial, 'e', estat_final );
          $$.initial_val = estat_inicial;
          $$.final_val = estat_final;
        }

        | LETTER { 
            int estat_inicial = set_estat();
            int estat_final = set_estat();
            set_transition(estat_inicial, yylval, estat_final); 
            $$.initial_val = estat_inicial;
            $$.final_val = estat_final;
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
  j >> automat[i][t];
}
