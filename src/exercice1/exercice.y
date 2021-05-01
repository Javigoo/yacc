        /************************************************/
        /*              ESPECIFICACIO YACC              */
        /*         Calculadora amb registres            */
        /************************************************/

    
        
%{
    
    #include<stdio.h>
    #include<ctype.h>
    
    int intRegs[26]={0};
    float floatRegs[26]={0};
    
    extern int nlin;
    extern int yylex(void);
    void yyerror (char const *);

    

%}
    

%start calculadora

%union{	int intValue;
        int intReg;
        float floatValue;
        int floatReg;
        }

%token <intValue> INT_VALUE
%token <intReg> INT_REG
%token <floatValue> FLOAT_VALUE
%token <floatReg> FLOAT_REG

%left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMENYS        /* precedencia de l'operador unari menys */

%type <floatValue> floatExpr sentencia calculadora
%type <intValue> intExpr


%%

calculadora:        {;}
                |   calculadora sentencia
                ;

sentencia:      '\n'                                {;}
                |   intExpr ';'                     {fprintf(stdout,"%d \n", $1);}
                |   floatExpr ';'                   {fprintf(stdout,"%f \n", $1);}
                |   INT_REG '=' intExpr ';'         {intRegs[$1] = $3;}
                |   FLOAT_REG '=' floatExpr ';'     {floatRegs[$1] = $3;}
                |   error ';'                       {fprintf(stderr,"ERROR EXPRESSIO INCORRECTA Línea %d \n", nlin);
                                                        yyerrok;
                                                    }
                ;

intExpr:        '(' intExpr ')'             {$$ = $2;}
            |   intExpr '+' intExpr         {$$ = $1 + $3;}
            |   intExpr '-' intExpr         {$$ = $1 - $3;} 
            |   intExpr '*' intExpr         {$$ = $1 * $3;}
            |   intExpr '/' intExpr         {   if ($3)
                                                    $$ = $1 / $3;
                                                else{
                                                    fprintf(stderr,"Divisio per zero \n");
                                                    YYERROR;
                                                }
                                            }
            |   intExpr '%' intExpr         {$$ = $1 % $3;}
            |   intExpr '&' intExpr         {$$ = $1 & $3;}
            |   intExpr '|' intExpr         {$$ = $1 | $3;}
            |   '-' intExpr %prec UMENYS    {$$ = - $2;}
            |   INT_REG                     {$$ = intRegs[$1];}
            |   INT_VALUE                   {$$ = $1;}
            ;

floatExpr:        '(' floatExpr ')'             {$$ = $2;}
            |   floatExpr '+' floatExpr         {$$ = $1 + $3;}
            |   floatExpr '-' floatExpr         {$$ = $1 - $3;} 
            |   floatExpr '*' floatExpr         {$$ = $1 * $3;}
            |   floatExpr '/' floatExpr         {   if ($3)
                                                    $$ = $1 / $3;
                                                else{
                                                    fprintf(stderr,"Divisio per zero \n");
                                                    YYERROR;
                                                }
                                            }
            |   '-' floatExpr %prec UMENYS    {$$ = - $2;}
            |   FLOAT_REG                     {$$ = floatRegs[$1];}
            |   FLOAT_VALUE                   {$$ = $1;}
            ;

%%

/* Called by yyparse on error. */

void yyerror (char const *s){
    fprintf (stderr, "%s\n", s);
}

int main(){
    if (yyparse()==0) {
        for (int i=0; i<26; i++) {
            if (intRegs[i]!=0) {
                printf("%c = %d \n", 'a'+i, intRegs[i]);
            }
            if (floatRegs[i]!=0) {
                printf("%c = %f \n", 'A'+i, floatRegs[i]);
            }   
        }
        return(0);
    } else {
        return(1);
    }
}
