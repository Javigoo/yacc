        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /*              Declaracions	                */
        /************************************************/

%{  #include<stdio.h>
    
    extern int nlin;
    extern int yylex();
    extern int yyerror (char *);
    
    
%}


	
%start programa


%token  INT REAL CHAR ID 

%%

programa: llistadecla

llistadecla: 
			|  llistadecla decla
			;

decla:	tipus llistaid ';'      {   fprintf(stdout,"Declaració correcta línea %d \n", nlin);}
        | error ';'             {   fprintf(stderr,"ERROR DECLARACIÓ INCORRECTA Línea %d \n", nlin);
                                    yyerrok;	}
		;


tipus: 	INT
		| REAL
		| CHAR
		;


llistaid: 	ID
		|   ID ',' llistaid
		;

%%

int main(){
    if (yyparse()==0)
        return(0);
    else {
        fprintf(stderr,"Acabament fitxer inesperad Línea %d \n", nlin);
        return(1);
    }
}
