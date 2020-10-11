%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <math.h>
#include <limits.h>

#include "y.tab.h"

FILE    *yyin;
char    *yyltext;

#define COTA_INT 65536
#define COTA_FLOAT 4294967296
#define ERROR_ID 3
#define ERROR_STR 5
#define ERROR_INT 7
#define ERROR_REAL 9

#define ES_CONST_NOMBRE 1
#define NO_ES_CONST_NOMBRE 0

int esConst = 0;

int yyerror(char *, int, int, int);

/* Tabla de simbolos */

    void validarString(char[]);
    void validarFloat(double);
    void validarInt(int);
    char valor[20];
%}

%option noyywrap
%option yylineno

DIGITO			    [0-9]
CONST_INT		    ({DIGITO})+
CONST_REAL		    ({DIGITO})+"."({DIGITO})*|({DIGITO})*"."({DIGITO})+
LETRA			    [a-zA-Z]
CONST_STR           ({CAR_COMILLAS}|{COMILLA_ABRE})([^\"])*({CAR_COMILLAS}|{COMILLA_CIERRA})
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
COMILLA_ABRE    "\“"
COMILLA_CIERRA  "\”"

%%
{COMENTARIO_SIMPLE} {  return COMENTARIO_SIMPLE; }
{CONST_STR}         {  yylval.tipo_str = yytext;
						validarString(yylval.tipo_str);
                        if(esConst == 0)
                    	    insertarTS(yylval.tipo_str, "CONST_STR", yylval.tipo_str, 0, 0, 0);
                        esConst = 0;
                         return CONST_STR;}
{CONST_INT}         {  yylval.tipo_int = atoi(yytext);
						validarInt(yylval.tipo_int);
                        if(esConst == 0)
                    	insertarTS(yytext, "CONST_INT", "", yylval.tipo_int, 0, 0);
                        esConst = 0;
                        return CONST_INT;         }
{CONST_REAL}        {  yylval.tipo_double = atof(yytext);
						validarFloat(yylval.tipo_double);
                        if(esConst == 0)
                    	insertarTS(yytext, "CONST_REAL", "", 0, yylval.tipo_double, 0);
                        esConst = 0;
                        return CONST_REAL;        }
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
{COMILLA_ABRE}      {  return COMILLA_ABRE;      }
{COMILLA_CIERRA}    {  return COMILLA_CIERRA;    }
"CONST"             {  
                        esConst = 1;
                        return CONST;            
                                                 }
"const"             { 
                        esConst = 1;
                        return CONST;           }
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
"contar"			{  return CONTAR;            }
{ID}                { yylval.tipo_str = yytext; return ID;}
" "
"\n"
"\t"
"\n\t"
"\r\n"

%%

void validarString(char cadena[])
{
    int largo = strlen(cadena);

    if(largo > 30)
    {
        yyerror("Error: Rango de string excedido. Se permite un maximo de 30 caracteres", 0, 0, 0);
    }
}

void validarFloat(double numero)
{   
    double max = 3.402823 * pow(10, 38);
    double min = 1.175494 * pow(10, -38);

    if(numero > max || (numero > 0 && numero < min))
    {
        yyerror("Error: Rango de float excedido. Se permite entre [1.175494*10^-38; 3.402823*10^38] o cero.\n", 0, 0, 0);
    }
}

void validarInt(int numero)
{
    if(numero > 65535)
    {
        yyerror("Error: Valor de int excedido, el mayor posible es 65535", 0, 0, 0);
    }
}

int yyerror(char *mensaje, int fila, int ci, int cf)
{
    if(fila == 0 || ci == 0 || cf == 0) /* || fila <= yylineno)*/
        printf("\nLinea %d: %s.\n", yylineno, mensaje);
    else
        printf("\nLinea %d, %d-%d: %s.\n", fila, ci, cf, mensaje);
    
    system("Pause");
    exit(1);
}
