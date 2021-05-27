%{
    
  #include <stdio.h>
  #include <ctype.h>
  #include <string.h>
  #include <stdlib.h>

 
  #define MAX_STACK_SIZE 100

  extern int nlin;
  extern int yylex(void);
  void yyerror (char const *);

  char list[MAX_STACK_SIZE];
  int i=0;

  void append(char);
  char pop(void);
  void postfix_to_infix(void);

  struct intermediateExpression
  {  
    char expression[MAX_STACK_SIZE];
    char operation[MAX_STACK_SIZE];
  };  

%}

%start final

%token <char> OPERANDO

%left '+' '-'
%left '*' '/' '%'

%%

final:  {;}
        |   final lines
        ;

lines:  '\n'    			{;}
        | expression ';' 	{postfix_to_infix();}
        ;

expression: expression'+'expression         {append('+');}
            | expression'-'expression       {append('-');}
            | expression'*'expression       {append('*');}
            | expression'/'expression       {append('/');}
            | expression'%'expression       {append('%');}				
            | '('expression')'
            | OPERANDO            			{append(yylval);}
            ;

%%

void yyerror (char const *s){
    fprintf (stderr, "%s\n", s);
}


int main(void) {
    yyparse();
    return 0;
} 
 
void append(char ch){
    list[i++] = ch;
}
 
void postfix_to_infix(void){
    //char result[MAX_STACK_SIZE][MAX_STACK_SIZE];
    struct intermediateExpression result[MAX_STACK_SIZE];
    int top=0;

    printf("\npostfix: %s\n\n", list);

    int i;
    for(i = 0; strcmp(&list[i],""); i++){
        char token = list[i];
        if(token == '+' || token == '-'){

            char rightIntermediate[MAX_STACK_SIZE];
            strcpy(rightIntermediate,result[--top].expression);
            printf("Pop: %s\n", rightIntermediate);

            char leftIntermediate[MAX_STACK_SIZE];
            strcpy(leftIntermediate,result[--top].expression);
            printf("Pop: %s\n", leftIntermediate);
            //printf("leftIntermediate: %s \t token: %c \t rightIntermediate: %s\n", leftIntermediate, token, rightIntermediate);

            char intermediateExpression[MAX_STACK_SIZE] = "";
            strcat(intermediateExpression, leftIntermediate);
            strncat(intermediateExpression, &token, 1);
            strcat(intermediateExpression, rightIntermediate);
            //printf("intermediateExpression: %s\n", intermediateExpression);

            strcpy(result[top++].expression, intermediateExpression);
            strcpy(result[top].operation, &token);
            printf("Push: %s %s\n", result[top].expression, result[top].operation);

        }else if(token == '*' || token == '/' || token == '%'){
            char leftExpression[MAX_STACK_SIZE] = "";
            char rightExpression[MAX_STACK_SIZE] = "";

            char rightIntermediate[MAX_STACK_SIZE];
            strcpy(rightIntermediate,result[--top].expression);
            printf("Pop: %s\n", rightIntermediate);
            if(strcmp(rightIntermediate, "+")==0 || strcmp(rightIntermediate, "-")==0){
                strncat(rightExpression, "(", 1);
                strcat(rightExpression, rightIntermediate);
                strncat(rightExpression, ")", 1);

            }else{
                strcat(rightExpression, rightIntermediate);
            }

            char leftIntermediate[MAX_STACK_SIZE];
            strcpy(leftIntermediate,result[--top].expression);
            printf("Pop: %s\n", leftIntermediate);
            if(strcmp(leftIntermediate, "+")==0 || strcmp(leftIntermediate, "-")==0){
                strncat(leftExpression, "(", 1);
                strcat(leftExpression, leftIntermediate);
                strncat(leftExpression, ")", 1);
            }else{
                strcat(leftExpression, leftIntermediate);
            }

            char newExpression[MAX_STACK_SIZE] = "";
            strcat(newExpression, leftExpression);
            strncat(newExpression, &token, 1);
            strcat(newExpression, rightExpression);

            strcpy(result[top++].expression,newExpression);
            printf("Push: %s\n", newExpression);

        }else{
            char intermediateToken[MAX_STACK_SIZE] = "";
            strncat(intermediateToken, &token, 1);
            strcpy(result[top++].expression, intermediateToken);
            printf("Push: %c\n", token);
        }
        

    }
    printf("\nResultado (infix): %s\n", result[0].expression);          
}