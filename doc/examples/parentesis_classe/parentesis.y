
/********************************************************************/
/*              ESPECIFICACIO YACC                                  */
/*              constants amb parèntesis   acabades amb ;           */
/********************************************************************/


%{  #include<stdio.h>
    
    extern int nlin;
    extern int yylex();
    extern int yyerror (char *);
    %}

%token CONSINT

%start programa

%%

programa:
        | llista_inst
        ;

llista_inst : inst ';'                     {   fprintf(stdout,"Expressió correcta línea %d \n", nlin);}
            | llista_inst inst   ';'   {   fprintf(stdout,"Expressió correcta línea %d \n", nlin);}
            ;

inst : '(' inst ')'
        | CONSINT
        | error ';'    {   fprintf(stderr,"ERROR EXPRESSIO INCORRECTA Línea %d \n", nlin);
                        yyerrok;	}
        ;



%%

int main(){
    
    return (yyparse());
    
}
