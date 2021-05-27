<<<<<<< HEAD
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

  struct intermediateExpression
  {
    char expression[MAX_STACK_SIZE];
    char operation;
  };

  struct intermediateExpression result[MAX_STACK_SIZE];
  int top=0;

  void append(char);
  void postfix_to_infix(void);
  void push(char[], char);
  void pushExpr(char[]);
  struct intermediateExpression pop();

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
    //printf("\nPostfix: %s\n\n", list);
    for(int i = 0; strcmp(&list[i],""); i++){
        char token = list[i];
        if(token == '+' || token == '-'){
            struct intermediateExpression rightIntermediate = pop();
            struct intermediateExpression leftIntermediate = pop();
            
            char intermediateExpression[MAX_STACK_SIZE] = "";
            strcat(intermediateExpression, leftIntermediate.expression);
            strncat(intermediateExpression, &token, 1);
            strcat(intermediateExpression, rightIntermediate.expression);

            push(intermediateExpression, token);

        }else if(token == '*' || token == '/' || token == '%'){
            char leftExpression[MAX_STACK_SIZE] = "";
            char rightExpression[MAX_STACK_SIZE] = "";

            struct intermediateExpression rightIntermediate = pop();
            if((rightIntermediate.operation == '+') || (rightIntermediate.operation == '-')){
                strncat(rightExpression, "(", 1);
                strcat(rightExpression, rightIntermediate.expression);
                strncat(rightExpression, ")", 1);

            }else{
                strcat(rightExpression, rightIntermediate.expression);
            }

            struct intermediateExpression leftIntermediate = pop();
            if((leftIntermediate.operation == '+') || (leftIntermediate.operation == '-')){
                strncat(leftExpression, "(", 1);
                strcat(leftExpression, leftIntermediate.expression);
                strncat(leftExpression, ")", 1);
            }else{
                strcat(leftExpression, leftIntermediate.expression);
            }

            char newExpression[MAX_STACK_SIZE] = "";
            strcat(newExpression, leftExpression);
            strncat(newExpression, &token, 1);
            strcat(newExpression, rightExpression);
   
            push(newExpression, token);

        }else{
            char intermediateToken[MAX_STACK_SIZE] = "";
            strncat(intermediateToken, &token, 1);

            pushExpr(intermediateToken);

        }
        /**
        printf("\t[Token: %c \tStack:", token);
        int loop;
        for (loop = 0; strcmp(&result[loop],""); loop++){
            printf(" %s ,", result[loop].expression);
        }
        printf("]\n");
        **/
    }
    printf("%s\n", result[0].expression);
}

void push(char *expression, char token){
    strcpy(result[top].expression, expression);
    result[top].operation = token;
    //printf("PUSH: %s -> %c\n", result[top].expression, result[top].operation);
    top = top + 1;
}

void pushExpr(char *expression){
    strcpy(result[top].expression, expression);
    //printf("PUSH: %s\n", result[top].expression);
    top = top + 1;
}

struct intermediateExpression pop(){
    top = top - 1;
    struct intermediateExpression popExpression;
    strcpy(popExpression.expression, result[top].expression);
    popExpression.operation = result[top].operation;

    strcpy(result[top].expression, "");

    /**
    if(strcmp(&popExpression.operation, "")){
        printf("POP: %s -> %c\n", popExpression.expression, popExpression.operation);
    }else{
        printf("POP: %s\n", popExpression.expression);
    }
    **/
    return popExpression;
}
