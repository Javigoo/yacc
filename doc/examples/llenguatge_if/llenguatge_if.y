        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /*              declaracions i instucció if     */
        /************************************************/


%{  #include<stdio.h>
    
    extern int nlin;
    extern int yylex();
    extern int yyerror (char *);
    
    
%}


	
%start programa

%token  INT ID CONSTE IF ELSE MEIG MAIG IG AND OR

%%

programa: llistadecla llistainst

llistadecla: 
			| llistadecla decla
			;

decla:	INT llistaid ';'        {   fprintf(stdout,"Declaració correcta línea %d \n", nlin);}
        | error ';'             {   fprintf(stderr,"ERROR EXPRESSIO INCORRECTA Línea %d \n", nlin);
                                    yyerrok;	}
        ;


llistaid: 	identificador
		| llistaid ',' identificador
		;

identificador: 	ID
                | ID '=' CONSTE
                ;

llistainst: 
		|  llistainst inst
		;

inst:		assig ';'           {   fprintf(stdout,"Assignació correcta línea %d \n", nlin);}
		| condicional           {   fprintf(stdout,"If correcte línea %d \n", nlin);}
        | error ';'             {   fprintf(stderr,"ERROR EXPRESSIO INCORRECTA Línea %d \n", nlin);
                                    yyerrok;	}
        ;


		;

assig:		ID '=' expre
		;

expre:	expre '+' expre
		| expre '-' expre
		| expre '*' expre
		| expre '/' expre
		| '+' expre
		| '-' expre
		| '(' expre ')'
		| CONSTE
		| ID
		;

condicional: 	IF '(' exprelogica ')'  inst else
			;

else:
		| ELSE inst
		;

exprelogica:	exprelogica AND exprelogica
			|   exprelogica OR exprelogica
			| '!' exprelogica
			| '(' exprelogica ')'
			| exprerelacio
			;

exprerelacio: expre oprel expre
			;

oprel: 	'<'
		| '>'
		| IG
		| MEIG
		| MAIG
		;

%%

int main(){
    
    return (yyparse());
    
}

