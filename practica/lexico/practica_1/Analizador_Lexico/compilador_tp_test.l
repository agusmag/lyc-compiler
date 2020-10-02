%{
#include <stdio.h>
#include <stdlib.h>
FILE    *yyin;
int     yylval;
char    *yyltext;
#define COTA_INT 65536
#define COTA_FLOAT 4294967296
#define ERROR_ID 3
#define ERROR_STR 5
#define ERROR_INT 7
#define ERROR_REAL 9

int yyerror(void);

%}

%option noyywrap

DIGITO			    [0-9]
CONST_INT		    ({DIGITO})+
CONST_REAL		    ({DIGITO})+"."({DIGITO})*|({DIGITO})*"."({DIGITO})+
LETRA			    [a-zA-Z]
CONST_STR           {CAR_COMILLAS}([^\"])*{CAR_COMILLAS}
COMENTARIO_SIMPLE	"*-"([^-*]|\n)*?"-*"
ID					{LETRA}({LETRA}|{DIGITO}|_)*

OP_COMPARACION      ["<"|"="|">"|"<="|">="|"><"]
OP_LEQ              "<""="
OP_MOQ              ">""="
OP_EQQ              "=""="
OP_DIFF             "<"">"
OP_LESS             "<"
OP_MORE             ">"
OP_SUM              "\+"
OP_RES				"\-"
OP_MUL              "\*"
OP_DIV				"/"
OP_ASIG   			":"
OP_ASIG_CONS   		"="
OP_AND				("AND"|"and"|"&&")
OP_OR				("OR"|"or"|"\|\|")
OP_NOT				("NOT"|"not")
BETWEEN				("BETWEEN"|"between")
CAR_COMA            ","
CAR_PYC             ";"
CAR_PUNTO           "\."
CAR_CA              "["
CAR_CC              "]"
CAR_PA              "("
CAR_PC              ")"
CAR_COMILLAS        "\""

ENTERO          [0-9]
DECIMAL         ({ENTERO}*\.[0-9]+)
ESPACIO         [\s+]
TEXTO           \"(.)*\"


LLAVE           "{"
END_LLAVE       "}"
PARENTESIS      "("
END_PARENTESIS  ")"
COMA            ","
END_LINE        ";"
COMILLA_SIMPLE  "'"

%%
{COMENTARIO_SIMPLE} {printf("\nCOMENTARIO: %s\n", yytext);}
{CONST_STR}         {printf("\nTEXTO: %s\n", yytext);}
{CONST_INT}         {printf("\nDIGITO: %s\n", yytext);}
{CONST_REAL}        {printf("\nDECIMAL: %s\n", yytext);}
{END_LINE}          {printf("\nEND LINE: %s\n", yytext);}
{OP_ASIG}           {printf("\nOPERADOR ASIG: %s\n", yytext);}
{OP_ASIG_CONS}      {printf("\nOPERADOR ASIG_CONS: %s\n", yytext);}
{OP_SUM}            {printf("\nOPERADOR SUMA: %s\n", yytext);}
{OP_MUL}            {printf("\nOPERADOR MUL: %s\n", yytext);}
{OP_RES}            {printf("\nOPERADOR RES: %s\n", yytext);}
{OP_DIV}            {printf("\nOPERADOR DIV: %s\n", yytext);}
{OP_LEQ}            {printf("\nOPERADOR LEQ: %s\n", yytext);}
{OP_MOQ}            {printf("\nOPERADOR MOQ: %s\n", yytext);}
{OP_EQQ}            {printf("\nOPERADOR EQQ: %s\n", yytext);}
{OP_DIFF}           {printf("\nOPERADOR DIFF: %s\n", yytext);}
{OP_LESS}           {printf("\nOPERADOR LESS: %s\n", yytext);}
{OP_MORE}           {printf("\nOPERADOR MORE: %s\n", yytext);}
{OP_AND}            {printf("\nOPERADOR AND: %s\n", yytext);}
{OP_OR}             {printf("\nOPERADOR OR: %s\n", yytext);}
{LLAVE}             {printf("\nLLAVE: %s\n", yytext);}
{END_LLAVE}         {printf("\nEND LLAVE: %s\n", yytext);}
{PARENTESIS}        {printf("\nPARENTESIS: %s\n", yytext);}
{END_PARENTESIS}    {printf("\nEND PARENTESIS: %s\n", yytext);}
{CAR_CA}            {printf("\nCORCHETE: %s\n", yytext);}
{CAR_CC}            {printf("\nEND CORCHETE: %s\n", yytext);}
{COMA}              {printf("\nCOMA: %s\n", yytext);}
{COMILLA_SIMPLE}    {printf("\nCOMILLA SIMPLE: %s\n", yytext);}
"CONST"             { printf("\nCONST"); }
"const"             { printf("\nCONST"); }
"DIM"               { printf("\nDIM"); }
"dim"               { printf("\nDIM"); }
"AS"                { printf("\nAS"); }
"as"                { printf("\nAS"); }
"float"				{ printf("\nFLOAT"); }
"Float"				{ printf("\nFLOAT"); }
"integer"			{ printf("\nINTEGER"); }
"Integer"			{ printf("\nINTEGER"); }
"string"			{ printf("\nSTRING"); }
"String"			{ printf("\nSTRING"); }
"if"				{ printf("\nIF"); }
"IF"				{ printf("\nIF"); }
"else"   			{ printf("\nELSE"); }
"Else"   			{ printf("\nELSE"); }
"for"				{ printf("\nFOR"); }
"FOR"				{ printf("\nFOR"); }
"to"		      	{ printf("\nTO"); }
"TO"		      	{ printf("\nTO"); }
"do"	         	{ printf("\nDO"); }
"DO"	         	{ printf("\nDO"); }
"while"	      		{printf("WHILE"); }
"WHILE"	      		{printf("\nWHILE"); }
"in"	        	{printf("\nIN"); }
"IN"	        	{printf("\nIN"); }
"repeat"			{ printf("\nREPEAT"); }
"REPEAT"			{ printf("\nREPEAT"); }
"until"				{ printf("\nUNTIL"); }
"UNTIL"				{ printf("\nUNTIL"); }
"PUT"				{ printf("\nPUT");  }
"put"				{ printf("\nPUT");  }
"GET"				{ printf("\nGET");  }
"get"				{ printf("\nGET");  }
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