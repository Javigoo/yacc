        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /*         Calculadora amb registres            */
        /************************************************/

	
		
%{
	
	#include<stdio.h>
	#include<ctype.h>
    
    int regs[26]={0};
	
	extern int nlin;
    extern int yylex(void);
    void yyerror (char const *);

	

%}
	

%start calculadora

%union{	int valor;
		int reg;
		}

%token <reg> REG
%token <valor> INT

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMENYS        /* precedencia de l'operador unari menys */

%type <valor> expr  sentencia calculadora

%%

calculadora	:           {;}
       			 |       calculadora sentencia
       			 ;
sentencia  :    '\n' 			{;}
                |	expr '\n'             {fprintf(stdout,"%d \n", $1);}
                |    REG '=' expr '\n'    {regs[$1] = $3;}
                |    error '\n'           {fprintf(stderr,"ERROR EXPRESSIO INCORRECTA Línea %d \n", nlin);
                                            yyerrok;	}

         		  ;
expr  :        '(' expr ')'             {$$ = $2;}
      |        expr '+' expr            {$$ = $1 + $3;}
      |        expr '-' expr            {$$ = $1 - $3;} 
      |        expr '*' expr            {$$ = $1 * $3;}
      |        expr '/' expr            {if ($3)
                                          $$ = $1 / $3;
                                         else
                                          {fprintf(stderr,"Divisio per zero \n");
                                           YYERROR;}
                                          }
      |       expr '%' expr           {$$ = $1 % $3;}
      |       expr '&' expr           {$$ = $1 & $3;}
      |       expr '|' expr           {$$ = $1 | $3;}
      |       '-' expr %prec UMENYS   {$$ = - $2;}
      |       REG                  {$$ = regs[$1];}
      |       INT                {$$ = $1;}
      ;

%%

/* Called by yyparse on error. */

void yyerror (char const *s){
    fprintf (stderr, "%s\n", s);
}

int main(){
        
    if (yyparse()==0){
        for (int i=0; i<26; i++)
        if (regs[i]!=0)
        printf("%c = %d \n", 'a'+i, regs[i]);
        return(0);
    }
    else
    return(1);
    
}
