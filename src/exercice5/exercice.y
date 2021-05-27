        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /*         Calculadora amb registres            */
        /************************************************/

	
		
%{
	
	#include<stdio.h>
	#include<ctype.h>
    #include <string.h>
    
    char reserva[26][100];
    int i=0;
	
	extern int nlin;
    extern int yylex(void);
    void yyerror (char const *);

	

%}
	

%start calculadora

%union{	char char_value;
        int int_value;
		}

%token <char_value> VALUE

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMENYS        /* precedencia de l'operador unari menys */

%type <int_value> expr  sentencia calculadora

%%

calculadora	:           {;}
       			 |       calculadora sentencia
       			 ;
sentencia  :    '\n' 			{;}
                |	expr '\n'             {fprintf(stdout,"%d \n", $1);}
                |    error '\n'           {fprintf(stderr,"ERROR EXPRESSIO INCORRECTA Línea %d \n", nlin);
                                            yyerrok;	}

         		  ;
expr  :        '(' expr ')'             {
                                         int index = reservar();
                                         strcat(reserva[index], '(');
                                         strcat(reserva[index], reserva[$2]);
                                         strcat(reserva[index], ')');
                                         $$ = index;
                                        }
      |        expr '^' expr            {
                                         int index = reservar();
                                         strcat(reserva[index], reserva[$1]);
                                         strcat(reserva[index], '^');
                                         strcat(reserva[index], reserva[$3]);
                                         $$ = index;
                                        }
      |        expr 'v' expr            {
                                         int index = reservar();
                                         strcat(reserva[index], reserva[$1]);
                                         strcat(reserva[index], '^');
                                         strcat(reserva[index], reserva[$3]);
                                         $$ = index;
                                        }
      |        expr '-' '>' expr           {
                                         int index = reservar();
                                         strcat(reserva[index], '!');
                                         strcat(reserva[index], reserva[$1]);
                                         strcat(reserva[index], 'v');
                                         strcat(reserva[index], reserva[$4]);
                                         $$ = index;
                                        }
      |        expr '<' '-' '>' expr          {
                                         int index = reservar();
                                         strcat(reserva[index], "!");
                                         strcat(reserva[index], reserva[$1]);
                                         strcat(reserva[index], 'v');
                                         strcat(reserva[index], reserva[$5]);
                                         strcat(reserva[index], '^');
                                         strcat(reserva[index], '!');
                                         strcat(reserva[index], reserva[$5]);
                                         strcat(reserva[index], 'v');
                                         strcat(reserva[index], reserva[$1]);
                                         $$ = index;
                                        }
      |       VALUE                  {
                                         int index = reservar();
                                         strcpy(reserva[index], yylval);
                                         $$ = index;
                                        }
      ;

%%

/* Called by yyparse on error. */

void yyerror (char const *s){
    fprintf (stderr, "%s\n", s);
}

int main(void) {
  yyparse();
  return 0;
} 

int reservar(){
    return i++;
}
