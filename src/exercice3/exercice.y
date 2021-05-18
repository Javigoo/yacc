%{
    
  #include<stdio.h>
  #include<ctype.h>
  #include<string.h>
    
  extern int nlin;
  extern int yylex(void);
  void yyerror (char const *);

  void A1(char c);
  void B1(char c);
  void A2(void);
  void B2(void);
  void P(void);

%}


%start final

%token <int> NUMBER

%left '+' '-'
%left '*' '/' '%'

%%

final:  {;}
        lines '\n'
        ;

lines:  E ';' { P(); }
	    ;
        
E:      E '*' {A1(yytext[0]);} E
    |   E '+' {A1(yytext[0]);} E
    |   '(' {B1('(');} E ')'{B1(')');}
    |   NUMBER {A1(yytext[0]);}

%%

void yyerror (char const *s){
  fprintf (stderr, "%s\n", s);
}

char sta[100];
char stb[100];
int topa=0;
int topb=0;

int main(void) {
  yyparse();
  return 0;
} 

void A1(char c)
{
    if (c=='+'){A2();}
    if (c=='*'){B2();}
    sta[topa++]=c;
    B1(c);
}

void B1(char c)
{
    stb[topb++]=c;
}

void A2(void)
{
    strcpy(stb,sta);
    topb=topa;
}

void B2(void)
{
    strcpy(sta,stb);
    topa=topb;
}

void P(void)
{
    printf("%s\n", sta);
}