%{
#include <stdio.h>
#include <stdlib.h>
FILE    *yyin;
int     yylval;
char    *yyltext;

int yyerror(void);

%}

%option noyywrap

ENTERO          [0-9]
DECIMAL         ({ENTERO}*\.[0-9]+)
LETRA           [a-zA-Z]
ESPACIO         [\s+]
TEXTO           \"(.)*\"

ID              {LETRA}({LETRA}|{ENTERO})*

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
OP_DIFF         "!""="
OP_AND          "&""&"
OP_OR           "|""|"
OP_ASIG         ":"

LLAVE           "{"
END_LLAVE       "}"
PARENTESIS      "("
END_PARENTESIS  ")"
COMA            ","
END_LINE        ";"
COMILLA_DOBLE   "\""
COMILLA_SIMPLE  "'"

%%
{TEXTO}             {printf("\nTEXTO: %s\n", yytext);}
{ENTERO}            {printf("\nDIGITO: %s\n", yytext);}
{DECIMAL}           {printf("\nDECIMAL: %s\n", yytext);}
{END_LINE}          {printf("\nEND LINE: %s\n", yytext);}
{OP_ASIG}           {printf("\nOPERADOR ASIG: %s\n", yytext);}
{OP_SUM}            {printf("\nOPERADOR SUMA: %s\n", yytext);}
{OP_MUL}            {printf("\nOPERADOR MUL: %s\n", yytext);}
{OP_RES}            {printf("\nOPERADOR RES: %s\n", yytext);}
{OP_DIV}            {printf("\nOPERADOR DIV: %s\n", yytext);}
{OP_LESS}           {printf("\nOPERADOR LESS: %s\n", yytext);}
{OP_MORE}           {printf("\nOPERADOR MORE: %s\n", yytext);}
{OP_EQ}             {printf("\nOPERADOR EQ: %s\n", yytext);}
{OP_LEQ}            {printf("\nOPERADOR LEQ: %s\n", yytext);}
{OP_MOQ}            {printf("\nOPERADOR MOQ: %s\n", yytext);}
{OP_EQQ}            {printf("\nOPERADOR EQQ: %s\n", yytext);}
{OP_DIFF}           {printf("\nOPERADOR DIFF: %s\n", yytext);}
{OP_AND}            {printf("\nOPERADOR AND: %s\n", yytext);}
{OP_OR}             {printf("\nOPERADOR OR: %s\n", yytext);}
{LLAVE}             {printf("\nLLAVE: %s\n", yytext);}
{END_LLAVE}         {printf("\nEND LLAVE: %s\n", yytext);}
{PARENTESIS}        {printf("\nPARENTESIS: %s\n", yytext);}
{END_PARENTESIS}    {printf("\nEND PARENTESIS: %s\n", yytext);}
{COMA}              {printf("\nCOMA: %s\n", yytext);}
{COMILLA_DOBLE}     {printf("\nCOMILLA DOBLE: %s\n", yytext);}
{COMILLA_SIMPLE}    {printf("\nCOMILLA SIMPLE: %s\n", yytext);}
"DECVAR"            {printf("\nDECLARACION: %s\n", yytext);}
"ENDDEC"            {printf("\nEND DECLARACION: %s\n", yytext);}
"Integer"           {printf("\nTIPO INTEGER: %s\n", yytext);}
"Float"             {printf("\nTIPO FLOAT: %s\n", yytext);}
"String"            {printf("\nTIPO STRING: %s\n", yytext);}
"if"                {printf("\nIF: %s\n", yytext);}
"else"              {printf("\nELSE: %s\n", yytext);}
"while"             {printf("\nWHILE: %s\n", yytext);}
"for"               {printf("\nFOR: %s\n", yytext);}
"write"             {printf("\nWRITE: %s\n", yytext);}
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