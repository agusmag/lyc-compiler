%{
#include <stdio.h>
#include <stdlib.h>
FILE    *yyin;
int     yylval;
char    *yyltext;

int yyerror(void);

%}

%option noyywrap

DIGITO          [0-9]
LETRA           [a-zA-Z]
ESPACIO         [\s+]
OP_LOGARITMICO  (&&|\|\||<|>|>=|<=|==|!=)
OP_ARITMETICO   (\+|\-|\*|\/)

END_LINE        ";"
CONS            {LETRA}({LETRA}|{DIGITO})*
CONDICION       {CONS}{ESPACIO}({OP_LOGARITMICO}|{OP_ARITMETICO}){ESPACIO}{CONS}
ASIG            ({CONS}|({CONS}","{CONS})+)":"{CONS}{END_LINE}
BLOQUE          (({ASIG}|{CONDICION}|CONS){END_LINE})*

OP_SUM          "+"
OP_RES          "-"
OP_MUL          "*"
OP_DIV          "/"
OP_LESS         "<"
OP_MORE         ">"
OP_EQ           "="
OP_LEQ          "<="
OP_MOQ          ">="
OP_EQQ          "=="
OP_AND          "&&"
OP_OR           "||"

LLAVE           "{"
END_LLAVE       "}"
PARENTESIS      "("
END_PARENTESIS  ")"

OP_DEC          "DECVAR"({ASIG}*)"ENDDEC"
WRITE           "WRITE"{ESPACIO}({CONS}|{TEXTO})
IF              "IF"{PARENTESIS}{CONDICION}{END_PARENTESIS}{LLAVE}{BLOQUE}{END_LLAVE}("ELSE"{LLAVE}{BLOQUE}{END_LLAVE})*

WHILE           "WHILE"{PARENTESIS}{CONDICION}{END_PARENTESIS}{LLAVE}{BLOQUE}{END_LLAVE}

%%

{END_LINE}          printf("\nEND_LINE: %s\n", yytext);
{CONS}              printf("\nCONS: %s\n", yytext);
{CONDICION}         printf("\nCONDICION: %s\n", yytext);
{BLOQUE}            printf("\nBLOQUE: %s\n", yytext);
{ASIG}              printf("\nOP ASIG: %s\n", yytext);
{OP_SUM}            printf("\nOP SUMA: %s\n", yytext);
{OP_MUL}            printf("\nOP MUL: %s\n", yytext);
{OP_RES}            printf("\nOP RES: %s\n", yytext);
{OP_DIV}            printf("\nOP DIV: %s\n", yytext);
{OP_LESS}           printf("\nOP LESS: %s\n", yytext);
{OP_MORE}           printf("\nOP MORE: %s\n", yytext);
{OP_EQ}             printf("\nOP EQ: %s\n", yytext);
{OP_LEQ}            printf("\nOP LEQ: %s\n", yytext);
{OP_MOQ}            printf("\nOP MOQ: %s\n", yytext);
{OP_EQQ}            printf("\nOP EQQ: %s\n", yytext);
{OP_AND}            printf("\nOP AND: %s\n", yytext);
{OP_OR}             printf("\nOP OR: %s\n", yytext);
{LLAVE}             printf("\nLLAVE: %s\n", yytext);
{END_LLAVE}         printf("\nEND LLAVE: %s\n", yytext);
{PARENTESIS}        printf("\nPARENTESIS: %s\n", yytext);
{END_PARENTESIS}    printf("\nEND PARENTESIS: %s\n", yytext);
{OP_DEC}            printf("\nOP DEC: %s\n", yytext);
{IF}                printf("\nIF: %s\n", yytext);
{WHILE}             printf("\nWHILE: %s\n", yytext);

.                   yyerror();

%%

int main(int argc, char *argv[])
{
    if ((yyin = fopen(argv[1], "rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    }
    else
    {
        yylex();
    }
fclose(yyin);
}

int yyerror(void)
{
    printf("Error lexico, caracter invalido %s\n", yytext);
    exit(1);
}