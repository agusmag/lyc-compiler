%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include <math.h>
#include <limits.h>

#include "y.tab.h"

/* CONSTANTES */
#define COTA_INT 65536
#define COTA_FLOAT 4294967296
#define ERROR_ID 3
#define ERROR_STR 5
#define ERROR_INT 7
#define ERROR_REAL 9
#define DEBUG_MODE 0 /*1 para YES, 0 para NO*/
#define DEBUG_MODE_B 0 /*1 para YES, 0 para NO*/
#define ES_CONST_NOMBRE 1
#define NO_ES_CONST_NOMBRE 0

/* VARIABLES */
int esConst = 0;
FILE    *yyin;
char    *yyltext;

/* FUNCIONES*/
int yyerror(char *, int, int, int);
int insertarTS(const char*, const char*, const char*, int, double, int);
void debug_print(char*, char *);

/* TABLA DE SIMBOLOS*/

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
LLAVE               "\{"
END_LLAVE           "\}"
PARENTESIS          "\("
END_PARENTESIS      "\)"
COMA                "\,"
PUNTO               "\."
PUNTO_Y_COMA        "\;"
COMILLA_SIMPLE      "\'"
CAR_COMILLAS        "\""
COMILLA_ABRE        "\“"
COMILLA_CIERRA      "\”"

%%
{COMENTARIO_SIMPLE} {  debug_print("COMENTARIO_SIMPLE", yytext); return COMENTARIO_SIMPLE; }
{CONST_STR}         {  yylval.tipo_str = yytext;
						validarString(yylval.tipo_str);
                        if(esConst == 0)
                    	    insertarTS(yylval.tipo_str, "CONST_STR", yylval.tipo_str, 0, 0, 0);
                        esConst = 0;
                        debug_print("CONST_STR", yytext);
                        return CONST_STR;}
{CONST_INT}         {  yylval.tipo_int = atoi(yytext);
						validarInt(yylval.tipo_int);
                        if(esConst == 0)
                    	insertarTS(yytext, "CONST_INT", "", yylval.tipo_int, 0, 0);
                        esConst = 0;
                        debug_print("CONST_INT", yytext);
                        return CONST_INT;         }
{CONST_REAL}        {  yylval.tipo_double = atof(yytext);
					   validarFloat(yylval.tipo_double);
                       if(esConst == 0)
                    	insertarTS(yytext, "CONST_REAL", "", 0, yylval.tipo_double, 0);
                       esConst = 0;
                       debug_print("CONST_REAL", yytext);
                       return CONST_REAL;        }
{PUNTO_Y_COMA}      {  debug_print("PUNTO_Y_COMA", yytext); return PUNTO_Y_COMA;        }
{OP_ASIG}           {  debug_print("OP_ASIG", yytext); return OP_ASIG;                  }
{OP_ASIG_CONS}      {  debug_print("OP_ASIG_CONS", yytext); return OP_ASIG_CONS;        }
{OP_SUM}            {  debug_print("OP_SUM", yytext); return OP_SUM;                    }
{OP_MUL}            {  debug_print("OP_MULT", yytext); return OP_MUL;                   }
{OP_RES}            {  debug_print("OP_RES", yytext); return OP_RES;                    }
{OP_DIV}            {  debug_print("OP_DIV", yytext); return OP_DIV;                    }
{OP_LEQ}            {  debug_print("OP_LEQ", yytext); return OP_LEQ;                    }
{OP_MOQ}            {  debug_print("OP_MOQ", yytext); return OP_MOQ;                    }
{OP_EQQ}            {  debug_print("OP_EQQ", yytext); return OP_EQQ;                    }
{OP_DIFF}           {  debug_print("OP_DIFF", yytext); return OP_DIFF;                  }
{OP_LESS}           {  debug_print("OP_LESS", yytext); return OP_LESS;                  }
{OP_MORE}           {  debug_print("OP_MORE", yytext); return OP_MORE;                  }
{OP_AND}            {  debug_print("OP_AND", yytext); return OP_AND;                    }
{OP_OR}             {  debug_print("OP_OR", yytext); return OP_OR;                      }
{LLAVE}             {  debug_print("LLAVE", yytext); return LLAVE;                      }
{END_LLAVE}         {  debug_print("END_LLAVE", yytext); return END_LLAVE;              }
{PARENTESIS}        {  debug_print("PARENTESIS", yytext); return PARENTESIS;            }
{END_PARENTESIS}    {  debug_print("END_PARENTESIS", yytext); return END_PARENTESIS;    }
{CORCHETE}          {  debug_print("CORCHETE", yytext); return CORCHETE;                }
{END_CORCHETE}      {  debug_print("END_CORCHETE", yytext); return END_CORCHETE;        }
{COMA}              {  debug_print("COMA", yytext); return COMA;                        }
{COMILLA_ABRE}      {  debug_print("COMILLA_ABRE", yytext); return COMILLA_ABRE;        }
{COMILLA_CIERRA}    {  debug_print("COMILLA_CIERRA", yytext); return COMILLA_CIERRA;    }
"CONST"             {  
                        esConst = 1;
                        debug_print("CONST", yytext);
                        return CONST;            
                    }
"const"             { 
                        esConst = 1;
                        debug_print("CONST", yytext);
                        return CONST;           
                    }
"DIM"               {  debug_print("DIM", yytext); return DIM;                          }
"dim"               {  debug_print("DIM", yytext); return DIM;                          }
"AS"                {  debug_print("AS", yytext); return AS;                            }
"as"                {  debug_print("AS", yytext); return AS;                            }
"float"             {  debug_print("FLOAT", yytext); return FLOAT;                      }
"Float"             {  debug_print("FLOAT", yytext); return FLOAT;                      }
"integer"           {  debug_print("INTEGER", yytext); return INTEGER;                  }
"Integer"           {  debug_print("INTEGER", yytext); return INTEGER;                  }
"if"                {  debug_print("IF", yytext); return IF;                            }
"IF"                {  debug_print("IF", yytext); return IF;                            }
"else"              {  debug_print("ELSE", yytext); return ELSE;                        }
"Else"              {  debug_print("ELSE", yytext); return ELSE;                        }
"while"             {  debug_print("WHILE", yytext); return WHILE;                      }
"WHILE"             {  debug_print("WHILE",yytext); return WHILE;                       }
"PUT"               {  debug_print("PUT", yytext); return PUT;                          }
"put"               {  debug_print("PUT", yytext); return PUT;                          }
"GET"               {  debug_print("GET", yytext); return GET;                          }
"get"               {  debug_print("GET", yytext); return GET;                          }
"contar"			{  debug_print("CONTAR", yytext); return CONTAR;                    }
{ID}                {  debug_print("ID", yytext); yylval.tipo_str = yytext; return ID;  }
" "
"\n"
"\t"
"\n\t"
"\r\n"
.                   {printf("%s", yytext); yyerror("ERROR: TOKEN NO RECONOCIDO", 0, 0, 0);}

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
    
    exit(1);
}

void debug_print(char* tipo, char *mensaje)
{
    if (DEBUG_MODE == 1)
        printf("\nLEX: %s [%s]\n", mensaje, tipo);    

    return;
}

void debug_print_b(char *mensaje)
{
    if (DEBUG_MODE_B == 1)
        printf("\nBISON: %s\n", mensaje);    

    return;
}