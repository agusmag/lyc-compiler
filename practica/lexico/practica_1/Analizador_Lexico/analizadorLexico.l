%{
#include <stdio.h>
#include <stdlib.h>
FILE    *yyin;
int     yylval;
char    *yyltext;

int yyerror(void);

%}

%option noyywrap


INTEGER         "Integer"
DIGITO          [0-9]
LETRA           [a-zA-Z]
ESPACIO         [\s+]

ID              {LETRA}({LETRA}|{DIGITO})*

OP_SUM          "+"
OP_RES          "-"
OP_MUL          "*"
OP_DIV          "/"
OP_LESS         "<"
OP_MORE         ">"
OP_EQ           "="
OP_LEQ          "<""="
OP_MOQ          ">""="
OP_EQQ          "=""="
OP_AND          "&""&"
OP_OR           "|""|"
OP_ASIG         ":"
OP_ENDLN         ";"
/*** OP_LOGICO        (&&||||<|>|>=|<=|==|!=) ***/
/*** OP_ARITMETICO   (+|-|*|/) ***/

LLAVE           "{"
END_LLAVE       "}"
PARENTESIS      "("
END_PARENTESIS  ")"

%%
{OP_ENDLN}          {printf("\nOP ENDLN: %s\n", yytext);}
{OP_ASIG}           {printf("\nOP ASIG: %s\n", yytext);}
{OP_SUM}            {printf("\nOP SUMA: %s\n", yytext);}
{OP_MUL}            {printf("\nOP MUL: %s\n", yytext);}
{OP_RES}            {printf("\nOP RES: %s\n", yytext);}
{OP_DIV}            {printf("\nOP DIV: %s\n", yytext);}
{OP_LESS}           {printf("\nOP LESS: %s\n", yytext);}
{OP_MORE}           {printf("\nOP MORE: %s\n", yytext);}
{OP_EQ}             {printf("\nOP EQ: %s\n", yytext);}
{OP_LEQ}            {printf("\nOP LEQ: %s\n", yytext);}
{OP_MOQ}            {printf("\nOP MOQ: %s\n", yytext);}
{OP_EQQ}            {printf("\nOP EQQ: %s\n", yytext);}
{OP_AND}            {printf("\nOP AND: %s\n", yytext);}
{OP_OR}             {printf("\nOP OR: %s\n", yytext);}
{LLAVE}             {printf("\nLLAVE: %s\n", yytext);}
{END_LLAVE}         {printf("\nEND LLAVE: %s\n", yytext);}
{PARENTESIS}        {printf("\nPARENTESIS: %s\n", yytext);}
{END_PARENTESIS}    {printf("\nEND PARENTESIS: %s\n", yytext);}
"DECVAR"            {printf("\nRESERVADA: %s\n", yytext);}
{ID}                {printf("\nID: %s\n", yytext);}
" "
"\n"
"\t"
"\n\t"
"\r\n"
.                   {yyerror();}

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