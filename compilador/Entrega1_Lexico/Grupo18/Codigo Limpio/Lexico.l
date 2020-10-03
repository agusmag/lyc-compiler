%{
#include <stdio.h>
#include <stdlib.h>

#include "y.tab.h"
FILE    *yyin;
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
%option yylineno

DIGITO			    [0-9]
CONST_INT		    ({DIGITO})+
CONST_REAL		    ({DIGITO})+"."({DIGITO})*|({DIGITO})*"."({DIGITO})+
LETRA			    [a-zA-Z]
CONST_STR           {CAR_COMILLAS}([^\"])*{CAR_COMILLAS}
COMENTARIO_SIMPLE	"*-"([^-*]|\n)*?"-*"
ID					{LETRA}({LETRA}|{DIGITO}|_)*

OP_LEQ              "<="
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
OP_NOT				("NOT"|"not"|"\!")
CORCHETE            "\["
END_CORCHETE        "\]"
LLAVE           "\{"
END_LLAVE       "\}"
PARENTESIS      "\("
END_PARENTESIS  "\)"
COMA            "\,"
PUNTO           "\."
PUNTO_Y_COMA    "\;"
COMILLA_SIMPLE  "\'"
CAR_COMILLAS        "\""

%%
{COMENTARIO_SIMPLE} {  return COMENTARIO_SIMPLE; }
{CONST_STR}         {  return CONST_STR;         }
{CONST_INT}         {  return CONST_INT;         }
{CONST_REAL}        {  return CONST_REAL;        }
{PUNTO_Y_COMA}      {  return PUNTO_Y_COMA;      }
{OP_ASIG}           {  return OP_ASIG;           }
{OP_ASIG_CONS}      {  return OP_ASIG_CONS;      }
{OP_SUM}            {  return OP_SUM;            }
{OP_MUL}            {  return OP_MUL;            }
{OP_RES}            {  return OP_RES;            }
{OP_DIV}            {  return OP_DIV;            }
{OP_LEQ}            {  return OP_LEQ;            }
{OP_MOQ}            {  return OP_MOQ;            }
{OP_EQQ}            {  return OP_EQQ;            }
{OP_DIFF}           {  return OP_DIFF;           }
{OP_LESS}           {  return OP_LESS;           }
{OP_MORE}           {  return OP_MORE;           }
{OP_AND}            {  return OP_AND;            }
{LLAVE}             {  return LLAVE;             }
{END_LLAVE}         {  return END_LLAVE;         }
{PARENTESIS}        {  return PARENTESIS;        }
{END_PARENTESIS}    {  return END_PARENTESIS;    }
{CORCHETE}          {  return CORCHETE;          }
{END_CORCHETE}      {  return END_CORCHETE;      }
{COMA}              {  return COMA;              }
"CONST"             {  return CONST;             }
"const"             {  return CONST;             }
"DIM"               {  return DIM;               }
"dim"               {  return DIM;               }
"AS"                {  return AS;                }
"as"                {  return AS;                }
"float"             {  return FLOAT;             }
"Float"             {  return FLOAT;             }
"integer"           {  return INTEGER;           }
"Integer"           {  return INTEGER;           }
"if"                {  return IF;                }
"IF"                {  return IF;                }
"else"              {  return ELSE;              }
"Else"              {  return ELSE;              }
"while"             {  return WHILE;             }
"WHILE"             {  return WHILE;             }
"PUT"               {  return PUT;               }
"put"               {  return PUT;               }
"GET"               {  return GET;               }
"get"               {  return GET;               }
{ID}                {  return ID;                }
" "
"\n"
"\t"
"\n\t"
"\r\n"

%%

int yyerror(void)
{
    return 0;
}