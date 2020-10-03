/*---- 1. Declaraciones ----*/

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
#define YYERROR_VERBOSE 1
FILE  *yyin;
%}

/* --- Tabla de simbolos --- */
// A definir.



/*---- 2. Tokens - Start ----*/

%union {
	char * int_val;
	char * real_val;
	char * str_val;
	char * cmp_val;
}

%start PROGRAMA
%token DIM
%token <cmp_val>OP_LESS
%token <cmp_val>OP_MORE
%token <cmp_val>OP_DIFF
%token OP_SUM
%token OP_MUL           
%token OP_RES           
%token OP_DIV
%token OP_AND
%token OP_EQQ
%token OP_MOQ

%token OP_ASIG //:
%token OP_ASIG_CONS //=
%token <str_val> ID
%token CONST
%token CONST_REAL 
%token COMA
%token <int_val>CONST_INT 
%token AS
%token FLOAT            
%token INTEGER
%token PUT
%token CAR_COMILLAS
%token <str_val>CONST_STR
%token PUNTO_Y_COMA
%token PUNTO
%token GET
%token WHILE
%token PARENTESIS       
%token END_PARENTESIS
%token <cmp_val>OP_LEQ
%token LLAVE            
%token END_LLAVE
%token COMENTARIO_SIMPLE
%token IF
%token ELSE
%token CORCHETE         
%token END_CORCHETE


/*---- 3. Definición de reglas gramaticales ----*/

%%

PROGRAMA:
{
    printf("\tInicia el COMPILADOR\n");
} 
algoritmo
{
	printf("\tFin COMPILADOR ok\n"); 
};

algoritmo: 
{
    printf("COMIENZO de BLOQUES\n");
} 
bloque;

bloque:
    bloque sentencia
    | sentencia
    ;

sentencia:
    ciclo
    | est_declaracion
    | est_asignacion PUNTO_Y_COMA
    | seleccion
    | entrada_salida PUNTO_Y_COMA
    ;


est_asignacion:
	CONST {
        printf("\t\tInicio Declaracion CONST\n");
    } asignacion {
        printf("\tFin Declaracion CONST\n");
    }
    ;

asignacion: 
    ID OP_ASIG_CONS FLOAT
    | ID OP_ASIG_CONS CONST_STR
    | ID OP_ASIG_CONS CONST_INT {printf("\t\tAsignado entero: %d\n", $3);}
    ;

ciclo:
     WHILE PARENTESIS condicion END_PARENTESIS LLAVE bloque END_LLAVE
     ;


condicion:
    comparacion
    | comparacion OP_AND comparacion;

comparacion:
    expresion lista_comparadores expresion  
    | expresion
    ;

expresion:
    expresion OP_SUM termino
    | expresion OP_RES termino
    | termino
 	;

termino: 
    termino OP_MUL factor
    | termino OP_DIV factor
    | factor
    ;

factor:
    ID
    | CONST_INT
    | CONST_REAL		 
    | CONST_STR
    | PARENTESIS expresion END_PARENTESIS
    ;


lista_comparadores:
    OP_LEQ
    | OP_MOQ 
    | OP_EQQ
    | OP_DIFF
    | OP_LESS
    | OP_MORE
    ;

est_declaracion:
	DIM {
        printf("\t\nInicio declaracion multiple\n");
    } est_variables AS est_tipos {
        printf("\tFin de la declaracion multiple\n");
    }
    ;

est_variables:
    OP_LESS lista_variables OP_MORE;

lista_variables:
    ID
    | ID COMA lista_variables
    ;

lista_tipos:
    tipo
    | tipo COMA lista_tipos;

tipo:
    INTEGER
    | FLOAT
    | CONST_STR;

est_tipos:
    OP_LESS lista_tipos OP_MORE;

//If
seleccion:
    	IF PARENTESIS condicion END_PARENTESIS LLAVE bloque END_LLAVE
		| IF PARENTESIS condicion END_PARENTESIS LLAVE bloque END_LLAVE ELSE LLAVE bloque END_LLAVE;

entrada_salida:
	GET {
        printf("\t\tGET\n"); 
    } ID 
	| PUT {
        printf("\t\tPUT\n");
    } ID 
	| PUT {
        printf("\t\tPUT\n");
    } CONST_STR
;

%%

/*---- 4. Código ----*/

int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\r\n", argv[1]);
        return -1;
    }
    else
    { 
        //crearTablaTS();//tablaTS.primero = NULL;
        yyparse();
        fclose(yyin);
        system("Pause"); /*Esta pausa la puse para ver lo que hace via mensajes*/
        return 0;
    }
}