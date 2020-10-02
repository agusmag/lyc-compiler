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
{COMENTARIO_SIMPLE} { printf("\n %s", yytext); return COMENTARIO_SIMPLE; }
{CONST_STR}         { printf("\n %s", yytext); return CONST_STR;         }
{CONST_INT}         { printf("\n %s", yytext); return CONST_INT;         }
{CONST_REAL}        { printf("\n %s", yytext); return CONST_REAL;        }
{PUNTO}             { printf("\n %s", yytext); return PUNTO;             }
{PUNTO_Y_COMA}      { printf("\n %s", yytext); return PUNTO_Y_COMA;      }
{OP_ASIG}           { printf("\n %s", yytext); return OP_ASIG;           }
{OP_ASIG_CONS}      { printf("\n %s", yytext); return OP_ASIG_CONS;      }
{OP_SUM}            { printf("\n %s", yytext); return OP_SUM;            }
{OP_MUL}            { printf("\n %s", yytext); return OP_MUL;            }
{OP_RES}            { printf("\n %s", yytext); return OP_RES;            }
{OP_DIV}            { printf("\n %s", yytext); return OP_DIV;            }
{OP_LEQ}            { printf("\n %s", yytext); return OP_LEQ;            }
{OP_MOQ}            { printf("\n %s", yytext); return OP_MOQ;            }
{OP_EQQ}            { printf("\n %s", yytext); return OP_EQQ;            }
{OP_DIFF}           { printf("\n %s", yytext); return OP_DIFF;           }
{OP_LESS}           { printf("\n %s", yytext); return OP_LESS;           }
{OP_MORE}           { printf("\n %s", yytext); return OP_MORE;           }
{OP_AND}            { printf("\n %s", yytext); return OP_AND;            }
{OP_OR}             { printf("\n %s", yytext); return OP_OR;             }
{LLAVE}             { printf("\n %s", yytext); return LLAVE;             }
{END_LLAVE}         { printf("\n %s", yytext); return END_LLAVE;         }
{PARENTESIS}        { printf("\n %s", yytext); return PARENTESIS;        }
{END_PARENTESIS}    { printf("\n %s", yytext); return END_PARENTESIS;    }
{CORCHETE}          { printf("\n %s", yytext); return CORCHETE;          }
{END_CORCHETE}      { printf("\n %s", yytext); return END_CORCHETE;      }
{COMA}              { printf("\n %s", yytext); return COMA;              }
{COMILLA_SIMPLE}    { printf("\n %s", yytext); return COMILLA_SIMPLE;    }
"CONST"             { printf("\n %s", yytext); return CONST;             }
"const"             { printf("\n %s", yytext); return CONST;             }
"DIM"               { printf("\n %s", yytext); return DIM;               }
"dim"               { printf("\n %s", yytext); return DIM;               }
"AS"                { printf("\n %s", yytext); return AS;                }
"as"                { printf("\n %s", yytext); return AS;                }
"float"             { printf("\n %s", yytext); return FLOAT;             }
"Float"             { printf("\n %s", yytext); return FLOAT;             }
"integer"           { printf("\n %s", yytext); return INTEGER;           }
"Integer"           { printf("\n %s", yytext); return INTEGER;           }
"string"            { printf("\n %s", yytext); return STRING;            }
"String"            { printf("\n %s", yytext); return STRING;            }
"if"                { printf("\n %s", yytext); return IF;                }
"IF"                { printf("\n %s", yytext); return IF;                }
"else"              { printf("\n %s", yytext); return ELSE;              }
"Else"              { printf("\n %s", yytext); return ELSE;              }
"for"               { printf("\n %s", yytext); return FOR;               }
"FOR"               { printf("\n %s", yytext); return FOR;               }
"to"                { printf("\n %s", yytext); return TO;                }
"TO"                { printf("\n %s", yytext); return TO;                }
"do"                { printf("\n %s", yytext); return DO;                }
"DO"                { printf("\n %s", yytext); return DO;                }
"while"             { printf("\n %s", yytext); return WHILE;             }
"WHILE"             { printf("\n %s", yytext); return WHILE;             }
"in"                { printf("\n %s", yytext); return IN;                }
"IN"                { printf("\n %s", yytext); return IN;                }
"PUT"               { printf("\n %s", yytext); return PUT;               }
"put"               { printf("\n %s", yytext); return PUT;               }
"GET"               { printf("\n %s", yytext); return GET;               }
"get"               { printf("\n %s", yytext); return GET;               }
{ID}                { printf("\n %s", yytext); return ID;                }
" "
"\n"
"\t"
"\n\t"
"\r\n"

%%
