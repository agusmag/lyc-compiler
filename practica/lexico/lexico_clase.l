%{
#include <stdio.h>
#include <stdlib.h>
FILE *yyin;
int yylval;
char *yyltext;

int yyerror(void);
%}

%option noyywrap
%option yylineno

DIGITO [0-9]
LETRA [a-zA-Z]

CTE     {DIGITO}+
ID      {LETRA}({LETRA}|{DIGITO})*
OP_AS   ":""="
OP_SUM  ["+"]
OP_MUL  ["*"]

%%

{CTE}       { printf( "\nConstante: %s\n", yytext ); }
{ID}        { printf( "\nIdentificador: %s\n", yytext ); }
{OP_AS}  { printf( "\nSuma: %s\n", yytext ); }
{OP_SUM}  { printf( "\nAsignacion: %s\n", yytext ); }
{OP_MUL}  { printf( "\nMultiplicacion: %s\n", yytext ); }
"\n"
"\t"
"\n\t"
"\r\n"
" "
.           { yyerror(); }

%%

int main(int argc,char *argv[]) {
    if ((yyin = fopen(argv[1], "rt")) == NULL) {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    } else {
        yylex();
    }
    
    fclose(yyin);
    return 0;
}

int yyerror(void) {
    printf("\nError lexico: Caracter invalido: %s\n", yytext);
    exit (1);
}
