%{
#include <stdio.h>
#include <stdlib.h>

#include "y.tab.h"
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
%option yylineno

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
CAR_PUNTO           "\."
CORCHETE            "["
END_CORCHETE        "]"
LLAVE           "{"
END_LLAVE       "}"
PARENTESIS      "("
END_PARENTESIS  ")"
COMA            ","
PUNTO           ","
PUNTO_Y_COMA    ";"
COMILLA_SIMPLE  "'"
CAR_COMILLAS        "\""

%%
{COMENTARIO_SIMPLE} { print("\n %s", yytext); RETURN COMENTARIO_SIMPLE; }
{CONST_STR}         { print("\n %s", yytext); RETURN CONST_STR;         }
{CONST_INT}         { print("\n %s", yytext); RETURN CONST_INT;         }
{CONST_REAL}        { print("\n %s", yytext); RETURN CONST_REAL;        }
{PUNTO}             { print("\n %s", yytext); RETURN PUNTO;             }
{PUNTO_Y_COMA}      { print("\n %s", yytext); RETURN PUNTO_Y_COMA;      }
{OP_ASIG}           { print("\n %s", yytext); RETURN OP_ASIG;           }
{OP_ASIG_CONS}      { print("\n %s", yytext); RETURN OP_ASIG_CONS;      }
{OP_SUM}            { print("\n %s", yytext); RETURN OP_SUM;            }
{OP_MUL}            { print("\n %s", yytext); RETURN OP_MUL;            }
{OP_RES}            { print("\n %s", yytext); RETURN OP_RES;            }
{OP_DIV}            { print("\n %s", yytext); RETURN OP_DIV;            }
{OP_LEQ}            { print("\n %s", yytext); RETURN OP_LEQ;            }
{OP_MOQ}            { print("\n %s", yytext); RETURN OP_MOQ;            }
{OP_EQQ}            { print("\n %s", yytext); RETURN OP_EQQ;            }
{OP_DIFF}           { print("\n %s", yytext); RETURN OP_DIFF;           }
{OP_LESS}           { print("\n %s", yytext); RETURN OP_LESS;           }
{OP_MORE}           { print("\n %s", yytext); RETURN OP_MORE;           }
{OP_AND}            { print("\n %s", yytext); RETURN OP_AND;            }
{OP_OR}             { print("\n %s", yytext); RETURN OP_OR;             }
{LLAVE}             { print("\n %s", yytext); RETURN LLAVE;             }
{END_LLAVE}         { print("\n %s", yytext); RETURN END_LLAVE;         }
{PARENTESIS}        { print("\n %s", yytext); RETURN PARENTESIS;        }
{END_PARENTESIS}    { print("\n %s", yytext); RETURN END_PARENTESIS;    }
{CORCHETE}          { print("\n %s", yytext); RETURN CORCHETE;          }
{END_CORCHETE}      { print("\n %s", yytext); RETURN END_CORCHETE;      }
{COMA}              { print("\n %s", yytext); RETURN COMA;              }
{COMILLA_SIMPLE}    { print("\n %s", yytext); RETURN COMILLA_SIMPLE;    }
"CONST"             { print("\n %s", yytext); RETURN CONST;             }
"const"             { print("\n %s", yytext); RETURN CONST;"            }
"DIM"               { print("\n %s", yytext); RETURN DIM;"              }
"dim"               { print("\n %s", yytext); RETURN DIM;"              }
"AS"                { print("\n %s", yytext); RETURN AS;"               }
"as"                { print("\n %s", yytext); RETURN AS;"               }
"float"             { print("\n %s", yytext); RETURN FLOAT;"            }
"Float"             { print("\n %s", yytext); RETURN FLOAT;"            }
"integer"           { print("\n %s", yytext); RETURN INTEGER;"          }
"Integer"           { print("\n %s", yytext); RETURN INTEGER;"          }
"string"            { print("\n %s", yytext); RETURN STRING;"           }
"String"            { print("\n %s", yytext); RETURN STRING;"           }
"if"                { print("\n %s", yytext); RETURN IF;"               }
"IF"                { print("\n %s", yytext); RETURN IF;"               }
"else"              { print("\n %s", yytext); RETURN ELSE;"             }
"Else"              { print("\n %s", yytext); RETURN ELSE;"             }
"for"               { print("\n %s", yytext); RETURN FOR;"              }
"FOR"               { print("\n %s", yytext); RETURN FOR;"              }
"to"                { print("\n %s", yytext); RETURN TO;"               }
"TO"                { print("\n %s", yytext); RETURN TO;"               }
"do"                { print("\n %s", yytext); RETURN DO;"               }
"DO"                { print("\n %s", yytext); RETURN DO;"               }
"while"             { print("\n %s", yytext); RETURN WHILE;"            }
"WHILE"             { print("\n %s", yytext); RETURN WHILE;"            }
"in"                { print("\n %s", yytext); RETURN IN;"               }
"IN"                { print("\n %s", yytext); RETURN IN;"               }
"repeat"            { print("\n %s", yytext); RETURN REPEAT;"           }
"REPEAT"            { print("\n %s", yytext); RETURN REPEAT;"           }
"until"             { print("\n %s", yytext); RETURN UNTIL;"            }
"UNTIL"             { print("\n %s", yytext); RETURN UNTIL;"            }
"PUT"               { print("\n %s", yytext); RETURN PUT;"              }
"put"               { print("\n %s", yytext); RETURN PUT;"              }
"GET"               { print("\n %s", yytext); RETURN GET;"              }
"get"               { print("\n %s", yytext); RETURN GET;"              }
{ID}                { print("\n %s", yytext); RETURN ID;                }
" "
"\n"
"\t"
"\n\t"
"\r\n"

%%
