/*---- 1. Declaraciones ----*/

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"
#define YYERROR_VERBOSE 1
#define ES_CONST_NOMBRE 1
#define NO_ES_CONST_NOMBRE 0
FILE  *yyin;

// Generacion Codigo Intermedio
#define TAM_PILA 100
#define TODO_OK 1
#define ERROR 0
#define EXISTE 1
#define NO_EXISTE 0
#define TODO_OK 1
#define PILA_IF 0
#define PILA_DECLARACION 1
#define PILA_WHILE 2
#define PILA_ASIGNACION 3

#define TRUE 1
#define FALSE 0

/* --- Tabla de simbolos --- */
typedef struct
{
        char *nombre;
        char *tipo;
        union Valor{
                int valor_int;
                double valor_double;
                char *valor_str;
        }valor;
        int longitud;
}t_data;

typedef struct s_simbolo
{
        t_data data;
        struct s_simbolo *next;
}t_simbolo;


typedef struct
{
        t_simbolo *primero;
}t_tabla;

void crearTablaTS();
int insertarTS(const char*, const char*, const char*, int, double, int);
t_data* crearDatos(const char*, const char*, const char*, int, double, int);
void guardarTS();
void limpiarConstanteString();
t_tabla tablaTS;

char idvec[50][50];
int cantid = 0, i=0, cant_aux=0;
char vecAux[300];
char* punt;
char pos[2];
char* separador1;
char nombre[50];
char tipo_dato[50];

int j=0;

// Generacion Codigo Intermedio
int crearArchivoIntermedia();
int insertarEnLista(char*);
void escribirEnLista(int, char*);
char * valorComparacion(char * );
char * aux;
char * auxTipoAsignacion;
char * inicioWhilePos;
int flagWHILE = FALSE;
int flagELSE = FALSE;

char posAuxA[5], posAuxB[5];	//Posicion auxiliar para pivotear con la condicion OR
char posTrue[5], posFalse[5],posCondDos[5];
int puntero_tokens=1; //Arranca en uno para comparar en notepad++
int iniExpre, finExpre;

FILE *fileCodigoIntermedio; //Archivo con el codigo intermedio

// PILAS 
char * pilaIF[TAM_PILA];			// pila 0
char * pilaWhile[TAM_PILA];			// pila 1
char * pilaAsignacion[TAM_PILA];	// pila 3
char * pilaRepeat[TAM_PILA];		// pila 4
char * pilaBetween[TAM_PILA];		// pila 5
int tope_pila_if=0;				// pila 0
int tope_pila_while=0;			// pila 1
int tope_pila_asignacion=0;		// pila 3
int tope_pila_repeat=0;			// pila 4
int tope_pila_between=0;		// pila 5

////////////////////
void apilar(int nroPila, char * val);
int desapilar(int nroPila);
int pilaVacia(int tope);
int pilaLlena(int tope);
void debugPila(int nroPila, int tope);

// LISTAS
char * listaDeclaracion[100];	//Lista para declaraciones
char * listaTokens[10000];		//Lista de tokens para gci polaca inversa
char * listaAux[100];		//Lista de tokens para gci polaca inversa
int puntero_declaracion = 0;
int puntero_asignacion = 0;
int puntero_tokens=1; //Arranca en uno para comparar en notepad++
int puntero_aux=0;

/* --- Validaciones --- */
int existeID(const char*);
int esNumero(const char*,char*);
char* obtenerID(char*);
char mensajes[100];

%}

/*---- 2. Tokens - Start ----*/

%union {
int tipo_int;
double tipo_double;
char* tipo_str;
char* tipo_cmp;
}

%start PROGRAMA
%token DIM
%token <tipo_cmp>OP_LESS
%token <tipo_cmp>OP_MORE
%token <tipo_cmp>OP_DIFF
%token OP_SUM
%token OP_MUL           
%token OP_RES           
%token OP_DIV
%token OP_AND
%token OP_OR
%token OP_EQQ
%token OP_MOQ

%token OP_ASIG //:
%token OP_ASIG_CONS //=
%token <tipo_str> ID
%token CONST
%token <tipo_double>CONST_REAL 
%token COMA
%token <tipo_int>CONST_INT 
%token AS
%token FLOAT            
%token INTEGER
%token PUT
%token CAR_COMILLAS
%token <tipo_str>CONST_STR
%token PUNTO_Y_COMA
%token PUNTO
%token GET
%token WHILE
%token PARENTESIS       
%token END_PARENTESIS
%token <tipo_cmp>OP_LEQ
%token LLAVE            
%token END_LLAVE
%token COMENTARIO_SIMPLE
%token IF
%token ELSE
%token CORCHETE         
%token END_CORCHETE
%token CONTAR
%token COMILLA_ABRE
%token COMILLA_CIERRA
%token LISTA_CONTAR

/*---- 3. Definición de reglas gramaticales ----*/

%%

PROGRAMA:
    {
        printf("\n\nInicia el COMPILADOR\n\n");
    } 
    algoritmo {
        //guardarTS();
        printf("\nCompilacion OK.\n");
        if(crearArchivoIntermedia() == TODO_OK) {
			printf("\nArchivo con codigo intermedio con polaca inversa generado.\n");
		} else {
			printf("Hubo un error al generar el archivo con codigo intermedio.\n");
		}
    };

algoritmo:
    bloque
    ;

bloque:
    bloque sentencia
    | sentencia
    ;

sentencia:
    ciclo
    | est_declaracion
    | est_asignacion PUNTO_Y_COMA {
        printf(";\n");
        printf("\n\t\t\tFin Asignacion.\n");
    }
    | seleccion
    | entrada_salida PUNTO_Y_COMA {
        printf(";\n");
    }
    ;

est_asignacion:
	CONST ID OP_ASIG_CONS CONST_REAL { 
        printf("\n\t\t\tInicio Asignacion.\n");
        printf("\t\t\t\tCONST %s", $2);
        //strcpy($<tipo_str>$, $2);
        //$<tipo_double>$ = $4;
        insertarTS(obtenerID($2), "CONST_REAL", "", 0, $4, ES_CONST_NOMBRE);
    }
    | CONST ID OP_ASIG_CONS CONST_INT {
        printf("\n\t\t\tInicio Asignacion.\n");
        //strcpy($<tipo_str>$, $2);
        printf("\t\t\t\tCONST %s", $2);
        insertarTS(obtenerID($2), "CONST_INT", "", $4, 0, ES_CONST_NOMBRE);
        //insertarTS("nombre", "CONST_INT", "", 80, 0, ES_CONST_NOMBRE);
    }                               
    | CONST ID OP_ASIG_CONS CONST_STR {
        printf("\n\t\t\tInicio Asignacion.\n");
        printf("\t\t\t\tCONST %s", $2);
        //strcpy($<tipo_str>$, $2);
        insertarTS(obtenerID($2), "CONST_STR", yylval.tipo_str, 0, 0, ES_CONST_NOMBRE);
    }
    |  asignacion
    ;

asignacion:
    ID {
        printf("\t\t\t\t%s", $1);
    } OP_ASIG  {
        printf(": ");
    }  expresion {
        strcpy(vecAux, $1); //en $1 esta el valor de ID
        punt = strtok(vecAux," +-*/[](){}:=,\n"); /*porque puede venir de cualquier lado, pero ver si funciona solo con el =*/
        if(!existeID(punt)) /*No existe: entonces no esta declarada*/
        {
            sprintf(mensajes, "%s%s%s", "Error: no se declaro la variable '", punt, "'");
            yyerror(mensajes, @1.first_line, @1.first_column, @1.last_column);
        }

        finExpre = puntero_tokens;
        int i,j,limit;
        char sAux[5];
        sprintf(sAux,yylval.str_val);

        //Agrego el simbolo de asignacion a la polaca
        insertarEnLista("=");
   
        puntero_asignacion = 0;	//Reset
        
        printf("FIN LINEA ASIGNACION\n");
    }
    ;

ciclo:
     WHILE {
         printf("\nInicio While.\n");
         free(inicioWhilePos);
		 inicioWhilePos = (char *) malloc(sizeof(char) * (sizeof(int) + 1));
		 sprintf(inicioWhilePos,"%d",puntero_tokens);
    } PARENTESIS condicion END_PARENTESIS LLAVE bloque END_LLAVE {
        printf("\n\t\t\tFin While.\n");
        int x, i, iPosActual;
        char wPosActual[5], wPosActualTrue[5], wPosCondDos[5];
        insertarEnLista("BI");
        insertarEnLista(inicioWhilePos);			
        
        x=desapilar(PILA_WHILE); //Primero que desapilo -> apunta a la parte verdadera
        sprintf(wPosActualTrue, "%s", posTrue);
        escribirEnLista(x,wPosActualTrue);
        
        x=desapilar(PILA_WHILE); //Segundo que desapilo -> apunta al final
        sprintf(wPosActual, "%d", puntero_tokens);
        escribirEnLista(x,wPosActual);
        
        flagWHILE = FALSE;
    } 
    ;

condicion:
    comparacion {
        if(flagWHILE == TRUE){ //Manejo del While
            insertarEnLista("CMP");
            insertarEnLista(valorComparacion(comparador_usado));
            char sPosActual[5];
            insertarEnLista("###");
            sprintf(sPosActual, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActual); //Usado en el while
            
            char sPosActualB[5];
            insertarEnLista("BI");
            insertarEnLista("###");
            sprintf(sPosActualB, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActualB);	
            sprintf(posTrue, "%d", puntero_tokens); //Guardo la posicion del true						
            
            flagWHILE = FALSE; //Para que no vuelva a entrar
        }
    }
    | comparacion OP_AND {
        if(flagWHILE == TRUE){
            flagWHILEAND = TRUE;
            flagWHILEOR = FALSE;
            insertarEnLista("CMP");
            insertarEnLista(valorComparacion(comparador_usado));
            char sPosActual[5];
            insertarEnLista("###");
            sprintf(sPosActual, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActual);
            
            char sPosActualB[5];
            insertarEnLista("BI");
            insertarEnLista("###");
            sprintf(sPosActualB, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActualB);
        } else {
            flagIFAND = TRUE;
            flagIFOR = FALSE;
            insertarEnLista("CMP");
            insertarEnLista(valorComparacion(comparador_usado));
            char sPosActual[5];
            insertarEnLista("###");
            sprintf(sPosActual, "%d", puntero_tokens-1);
            apilar(PILA_IF,sPosActual);
            
            char sPosActualB[5];
            insertarEnLista("BI");
            insertarEnLista("###");
            sprintf(sPosActualB, "%d", puntero_tokens-1);
            apilar(PILA_IF,sPosActualB);
        }
        sprintf(posCondDos, "%d", puntero_tokens);
        printf("and ");
    } comparacion {
        if(flagWHILE == TRUE){ //Manejo del While
            insertarEnLista("CMP");
            insertarEnLista(valorComparacion(comparador_usado));
            char sPosActual[5];
            insertarEnLista("###");
            sprintf(sPosActual, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActual); //Usado en el while
            
            char sPosActualB[5];
            insertarEnLista("BI");
            insertarEnLista("###");
            sprintf(sPosActualB, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActualB);	
            sprintf(posTrue, "%d", puntero_tokens); //Guardo la posicion del true						
            
            flagWHILE = FALSE; //Para que no vuelva a entrar
        }
    }
    | comparacion OP_OR {
        if(flagWHILE == TRUE)
        {
            flagWHILEOR = TRUE;
            insertarEnLista("CMP");
            insertarEnLista(valorComparacion(comparador_usado));
            char sPosActual[5];
            insertarEnLista("###");
            sprintf(sPosActual, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActual);
            
            char sPosActualB[5];
            insertarEnLista("BI");
            insertarEnLista("###");
            sprintf(sPosActualB, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActualB);	
        } else {
            flagIFAND = FALSE;
            flagIFOR = TRUE;
            insertarEnLista("CMP");
            insertarEnLista(valorComparacion(comparador_usado));
            char sPosActual[5];
            insertarEnLista("###");
            sprintf(sPosActual, "%d", puntero_tokens-1);
            apilar(PILA_IF,sPosActual);
            
            char sPosActualB[5];
            insertarEnLista("BI");
            insertarEnLista("###");
            sprintf(sPosActualB, "%d", puntero_tokens-1);
            apilar(PILA_IF,sPosActualB);	
        }
        sprintf(posCondDos, "%d", puntero_tokens);
        printf("or ");
    } comparacion {
        if(flagWHILE == TRUE){
            // flagWHILEOR = TRUE;
            insertarEnLista("CMP");
            insertarEnLista(valorComparacion(comparador_usado));
            char sPosActual[5];
            insertarEnLista("###");
            sprintf(sPosActual, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActual);
            
            char sPosActualB[5];
            insertarEnLista("BI");
            insertarEnLista("###");
            sprintf(sPosActualB, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActualB);	
            sprintf(posTrue, "%d", puntero_tokens); // guardo la posicion del true				
            //debugPila(PILA_WHILE,tope_pila_while);		
        }
    }
    ;

comparacion:
    expresion lista_comparadores {
        strcpy(comparador_usado,yylval.cmp_val);
    } expresion
    | expresion
    ;

expresion:
    expresion OP_SUM {
        insertarEnLista("+");
        printf("+ ");
    } termino
    | expresion OP_RES {
        insertarEnLista("-");
        printf("- ");
    } termino
    | termino 
 	;

termino: 
    termino OP_MUL {
        printf("* ");
    } factor {
        insertarEnLista("*");
    }
    | termino OP_DIV {
        printf("/ ");
    } factor {
        insertarEnLista("/");
    }
    | factor 
    | termino COMA {
        printf(", ");
    } factor {
        insertarEnLista(",");
    }
    ;

factor:
    ID {
        $<tipo_str>$ = $1;
        printf("%s ", $1);
        insertarEnLista(yylval.str_val);
    }
    | CONST_INT  {
        $<tipo_int>$ = $1;
        printf("%d ", $1);
        insertarEnLista(yylval.int_val);
    }
    | CONST_REAL {
        $<tipo_double>$ = $1;
        printf("%f ", $1);
        insertarEnLista(yylval.real_val); 
    }	 
    | CONST_STR {
        printf("%s ", $1);
        insertarEnLista(yylval.str_val);
    }
    | PARENTESIS {
        printf("( ");
    }expresion END_PARENTESIS {
        printf(") ");
    }
    | CONTAR {
        printf("contar(");
    } PARENTESIS expresion PUNTO_Y_COMA {
        printf("; ");
    } CORCHETE {
        printf("[ ");
    } expresion END_CORCHETE {
        printf("] ");
    } END_PARENTESIS {
        printf(")");
    }
    ;

lista_comparadores:
    OP_LEQ {
        printf("<= ");
    }
    | OP_MOQ {
        printf(">= ");
    }
    | OP_EQQ {
        printf("== ");
    }
    | OP_DIFF {
        printf("<> ");
    }
    | OP_LESS {
        printf("< ");
    }
    | OP_MORE {
        printf("> ");
    }
    ;

est_declaracion:
	DIM {
        printf("\n\t\t\tInicio declaracion multiple\n\t\t\t\t");
    } est_variables AS {
        printf(" AS ");
    } est_tipos {  
        for(i=0;i<cant_aux;i++) /*vamos agregando todos los ids que leyo*/
        {
            separador1 = strtok(idvec[i],";");
            strcpy(nombre,separador1);
            separador1 = strtok(NULL, ";");

            if(insertarTS(nombre, separador1, "", 0, 0, NO_ES_CONST_NOMBRE) != 0) //no lo guarda porque ya existe
            {
                sprintf(mensajes, "%s%s%s", "Error: la variable '", idvec[i], "' ya fue declarada");
                yyerror(mensajes, @3.first_line, @3.first_column, @3.last_column);
            }
        }
        cantid=0;
        printf("\n\t\t\tFin declaracion multiple\n");
    }
    ;

est_variables:
    OP_LESS {
        printf("<");
    } lista_variables OP_MORE;

lista_variables:
    ID {
        printf(" %s", $1);
        strcpy(vecAux, $1); /*tomamos el nombre de la variable*/
        punt = strtok(vecAux, ">"); /*eliminamos extras*/
        strcpy(idvec[cantid], punt); /*copiamos al array de ids*/
        cantid++;
    }
    | ID {
        printf(" %s", $1);
    } COMA lista_variables {
        strcpy(vecAux, $1); /*tomamos el nombre de la variable*/
        punt = strtok(vecAux, ","); /*eliminamos extras*/
        strcpy(idvec[cantid], punt); /*copiamos al array de ids*/
        cantid++;
        cant_aux = cantid;
    }
    ;

lista_tipos:
    tipo
    | tipo COMA {
        printf(", ");
    } lista_tipos;

tipo:
    INTEGER {
        printf("Integer");
        strcat(idvec[cantid-1],";");
        strcat(idvec[cantid-1],"INTEGER");
        cantid--;
    }
    | FLOAT {
        printf("Float");
        strcat(idvec[cantid-1],";");
        strcat(idvec[cantid-1],"FLOAT");
        cantid--;
    }
    | CONST_STR {
        printf("String");
    };

est_tipos:
    OP_LESS {
        printf("<");
    } lista_tipos OP_MORE {
        printf(">");
    };

seleccion:
    IF PARENTESIS condicion END_PARENTESIS LLAVE {
        insertarEnLista("CMP");
        insertarEnLista(valorComparacion(comparador_usado));
        char sPosActual[5];
        insertarEnLista("###");
        sprintf(sPosActual, "%d", puntero_tokens-1);
        apilar(PILA_IF,sPosActual);
        
        sprintf(posTrue, "%d", puntero_tokens); //Guardo la posicion del true
    } bloque {
        char sPosActual[5];
        insertarEnLista("BI"); //Salto incondicional al final del if(todavia no lo se aca)
        insertarEnLista("###"); //Este es el que despues se va a reemplazar por la posicion final
        sprintf(sPosActual, "%d", puntero_tokens-1);
        apilar(PILA_IF,sPosActual);
    } END_LLAVE {
        int x, i, iPosActual;
        char sPosActual[5], sPosActualTrue[5], sPosActualFalse[5], sPosCondDos[5];
        
        x=desapilar(PILA_IF); //Primero que desapilo -> apunta a la posicion actual
        sprintf(sPosActual, "%d", puntero_tokens);
        escribirEnLista(x,sPosActual);
        
        x=desapilar(PILA_IF); //Segundo que desapilo -> apunta a la parte verdadera
        sprintf(sPosActualTrue, "%s", posTrue);
        escribirEnLista(x,sPosActualTrue);
        
        x=desapilar(PILA_IF); //Tercero que desapilo -> apunta al final
        sprintf(sPosActual, "%d", puntero_tokens);
        escribirEnLista(x,sPosActual);
        
        sprintf(sPosActual, "-1");
        sprintf(posCondDos, "-1");
        sprintf(posFalse, "-1");
        sprintf(posTrue, "-1");
        
        printf("FIN DEL IF\n"); 
    }
    | IF PARENTESIS condicion END_PARENTESIS LLAVE {
        insertarEnLista("CMP");
        insertarEnLista(valorComparacion(comparador_usado));
        char sPosActual[5];
        insertarEnLista("###");
        sprintf(sPosActual, "%d", puntero_tokens-1);
        apilar(PILA_IF,sPosActual);
    
        sprintf(posTrue, "%d", puntero_tokens); //Guardo la posicion del true
    } bloque {
        char sPosActual[5];
        insertarEnLista("BI"); //Salto incondicional al final del if(todavia no lo se aca)
        insertarEnLista("###"); //Este es el que despues se va a reemplazar por la posicion final
        sprintf(sPosActual, "%d", puntero_tokens-1);
        apilar(PILA_IF,sPosActual);
    } END_LLAVE ELSE {
        sprintf(posFalse, "%d", puntero_tokens); /*guardo la posicion*/
        printf("ELSE\n");
    } LLAVE bloque END_LLAVE {
        int x, i, iPosActual;
        char sPosActual[5], sPosActualTrue[5], sPosActualFalse[5], sPosCondDos[5];
        
        x=desapilar(PILA_IF); //Primero que desapilo -> apunta a la posicion actual
        sprintf(sPosActual, "%d", puntero_tokens);
        escribirEnLista(x,sPosActual);
        
        x=desapilar(PILA_IF); //Segundo que desapilo -> apunta a la parte verdadera
        sprintf(sPosActualTrue, "%s", posTrue);
        escribirEnLista(x,sPosActualTrue);
        
        x=desapilar(PILA_IF); //Tercero que desapilo -> apunta al final
        sprintf(sPosActual, "%d", puntero_tokens);
        escribirEnLista(x,sPosActual);
        
        sprintf(sPosActual, "-1");
        sprintf(posCondDos, "-1");
        sprintf(posFalse, "-1");
        sprintf(posTrue, "-1");

        printf("FIN ELSE.\n");
    }
    | IF PARENTESIS condicion END_PARENTESIS {
        insertarEnLista("CMP");
        insertarEnLista(valorComparacion(comparador_usado));
        char sPosActual[5];
        insertarEnLista("###");
        sprintf(sPosActual, "%d", puntero_tokens-1);
        apilar(PILA_IF,sPosActual);
    
        sprintf(posTrue, "%d", puntero_tokens); //Guardo la posicion del true
    } sentencia {
        printf("IF Sin llave.\n");
    }
    ;

entrada_salida:
	GET ID {
        printf("\n\t\t\tGET %s", $2);}
	| PUT ID {
        printf("\n\t\t\tPUT %s", $2);}
	| PUT CONST_STR {
        strcpy(vecAux, $2);
        printf("\n\t\t\tPUT %s", vecAux);
    }
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
        crearTablaTS(); //tablaTS.primero = NULL;
        yyparse();
        fclose(yyin);
        return 0;
    }
}

int insertarTS(const char *nombre, const char *tipo, const char* valString, int valInt, double valDouble, int esConstNombre)
{
    t_simbolo *tabla = tablaTS.primero;
    char nombreCTE[50] = "_";
    strcat(nombreCTE, nombre);
    
    while(tabla)
    {
        if(strcmp(tabla->data.nombre, nombre) == 0 || strcmp(tabla->data.nombre, nombreCTE) == 0)
        {
            return 1;
        }
        
        if(tabla->next == NULL)
        {
            break;
        }
        tabla = tabla->next;
    }

    t_data *data = (t_data*)malloc(sizeof(t_data));
    data = crearDatos(nombre, tipo, valString, valInt, valDouble, esConstNombre);

    if(data == NULL)
    {
        return 1;
    }

    t_simbolo* nuevo = (t_simbolo*)malloc(sizeof(t_simbolo));

    if(nuevo == NULL)
    {
        return 2;
    }

    nuevo->data = *data;
    nuevo->next = NULL;

    if(tablaTS.primero == NULL)
    {
        tablaTS.primero = nuevo;
    }
    else
    {
        tabla->next = nuevo;
    }

    return 0;
}

t_data* crearDatos(const char *nombre, const char *tipo, const char* valString, int valInt, double valDouble, int esConstNombre)
{
    char full[50] = "_";
    char aux[20];

    t_data *data = (t_data*)calloc(1, sizeof(t_data));
    if(data == NULL)
    {
        return NULL;
    }

    data->tipo = (char*)malloc(sizeof(char) * (strlen(tipo) + 1));
    strcpy(data->tipo, tipo);

    //Si es una variable
    if((strcmp(tipo, "STRING") == 0 || strcmp(tipo, "INTEGER") == 0 || strcmp(tipo, "FLOAT") == 0) && esConstNombre == 0)
    {
        //Al nombre lo dejo aca porque no lleva _
        data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
        strcpy(data->nombre, nombre);
        return data;
    }
    else
    { 
        if(esConstNombre == ES_CONST_NOMBRE)
        {
            data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
            strcpy(data->nombre, nombre);
        }

         //Son constantes: tenemos que agregarlos a la tabla con "_" al comienzo del nombre, hay que agregarle el valor
        if(strcmp(tipo, "CONST_STR") == 0)
        {
            data->valor.valor_str = (char*)malloc(sizeof(char) * strlen(valString) +1);
            strcpy(data->valor.valor_str, valString);
            
            if(esConstNombre == ES_CONST_NOMBRE)
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
                strcpy(data->nombre, nombre);
            }
            else
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(valString) + 1));
                strcat(full, valString);
                strcpy(data->nombre, full);    
            }

        }
        if(strcmp(tipo, "CONST_REAL") == 0)
        {
            data->valor.valor_double = valDouble;

            if(esConstNombre == ES_CONST_NOMBRE)
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
                strcpy(data->nombre, nombre);
            }
            else
            {
                sprintf(aux, "%g", valDouble);
                strcat(full, aux);
                data->nombre = (char*)malloc(sizeof(char) * strlen(full));
                strcpy(data->nombre, full);
            }

        }
        if(strcmp(tipo, "CONST_INT") == 0)
        {
            data->valor.valor_int = valInt;

            if(esConstNombre == ES_CONST_NOMBRE)
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
                strcpy(data->nombre, nombre);
            }
            else
            {
                sprintf(aux, "%d", valInt);
                strcat(full, aux);
                data->nombre = (char*)malloc(sizeof(char) * strlen(full));
                strcpy(data->nombre, full);
            }
        }
        return data;

    }
    return NULL;
}

void guardarTS()
{
    FILE* arch;
    if((arch = fopen("ts.txt", "wt")) == NULL)
    {
            printf("\nNo se pudo crear la tabla de simbolos.\n\n");
            return;
    }
    else if(tablaTS.primero == NULL)
            return;
    
    fprintf(arch, "%-50s%-25s%-50s%-30s\n", "NOMBRE", "TIPODATO", "VALOR", "LONGITUD");

    t_simbolo *aux;
    t_simbolo *tabla = tablaTS.primero;
    char linea[160];

    while(tabla)
    {
        aux = tabla;
        tabla = tabla->next;
        
        if(strcmp(aux->data.tipo, "INTEGER") == 0) //variable int
        {
            sprintf(linea, "%-50s%-25s%-50s%-ld\n", aux->data.nombre, aux->data.tipo, "--", strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "CONST_INT") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50d%-ld\n", aux->data.nombre, aux->data.tipo, aux->data.valor.valor_int, strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "FLOAT") ==0)
        {
            sprintf(linea, "%-50s%-25s%-50s%-ld\n", aux->data.nombre, aux->data.tipo, "--", strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "CONST_REAL") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50f%-ld\n", aux->data.nombre, aux->data.tipo, aux->data.valor.valor_double, strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "STRING") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50s%-ld\n", aux->data.nombre, aux->data.tipo, "--", strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "CONST_STR") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50s%-ld\n", aux->data.nombre, aux->data.tipo, aux->data.valor.valor_str, strlen(aux->data.nombre));
        }
        fprintf(arch, "%s", linea);
        free(aux);
    }
    fclose(arch); 
}

void crearTablaTS()
{
    tablaTS.primero = NULL;
}

int crearArchivoIntermedia()
{
	FILE * archivo; 
	int i;
	archivo = fopen("intermedia.txt", "wt");

	if (!archivo){	return ERROR; }

	for (i = 1; i < puntero_tokens; i++)
	{
		fprintf(archivo,"%s\n", listaTokens[i]);
	}
	fclose(archivo); 

	return TODO_OK;
}

int insertarEnLista(char * val)
{
	//Convierto en CHAR *
	aux = (char *) malloc(sizeof(char) * (strlen(val) + 1));
    strcpy(aux, val);
	
	//Agrego a la lista de tokens
	listaTokens[puntero_tokens] = aux;
	puntero_tokens++;
	
	//Escribo en archivo
	fprintf(fintermedia,"%s\n",aux);
	
	return (puntero_tokens-1); //Devuelvo posicion
}

int insertarEnListaDeclaracion(char * val)
{
	//Convierto en CHAR *
	aux = (char *) malloc(sizeof(char) * (strlen(val) + 1));
    strcpy(aux, val);
	
	//Agrego a la lista de tokens
	listaDeclaracion[puntero_declaracion] = aux;
	puntero_declaracion++;
	
	return (puntero_declaracion-1); //Devuelvo posicion
}

int insertarEnListaAsig(char * val)
{
	//Convierto en CHAR *
	aux = (char *) malloc(sizeof(char) * (strlen(val) + 1));
    strcpy(aux, val);
	
	//Agrego a la lista de tokens
	listaAsignacion[puntero_asignacion] = aux;
	puntero_asignacion++;
	
	return (puntero_asignacion-1); //Devuelvo posicion
}

void escribirEnLista(int pos, char * val)
{
	//Convierto en CHAR *
	aux = (char *) malloc(sizeof(char) * (strlen(val) + 1));
    strcpy(aux, val);
	
	//Escribo en vector
	listaTokens[pos] = aux;
	
	printf("\tEscribio en %i el valor %s\n",pos,aux);
}

char * valorComparacion(char * val){
	if(strcmp("=", val) == 0){
		return "BNE";
	} else if(strcmp(">=", val) == 0){
		return "BLT";
	} else if(strcmp(">", val) == 0){
		return "BLE";
	} else if(strcmp("<=", val) == 0){
		return "BGT";
	} else if(strcmp("<", val) == 0){
		return "BGE";
	} else if(strcmp("><", val) == 0){
		return "BEQ";
	} else {
		// NUNCA DEBERIA CAER ACA
		return val;
	}
}

int existeID(const char* id) //y hasta diria que es igual para existeCTE
{
    //tengo que ver el tema del _ en el nombre de las cte
    t_simbolo *tabla = tablaTS.primero;
    char nombreCTE[50] = "_";
    strcat(nombreCTE, id);
    int b1 = 0;
    int b2 = 0;
    int j =0;
    
    while(j<cant_aux)
    {
        b1 = strcmp(idvec[j], id);
        //b2 = strcmp(tabla->data.nombre, nombreCTE);
        if(b1 == 0)
        {
                return 1;
        }
        j++;
    }
    return 0;
}

int esNumero(const char* id,char* error)
{
    t_simbolo *tabla = tablaTS.primero;
    char nombreCTE[50] = "_";
    strcat(nombreCTE, id);

    while(tabla)
    {
        if(strcmp(tabla->data.nombre, id) == 0 || strcmp(tabla->data.nombre, nombreCTE) == 0)
        {
            if(strcmp(tabla->data.tipo, "INT")==0 || strcmp(tabla->data.tipo, "FLOAT")==0)
            {
                return 1;
            }
            else
            {
                strcpy(error,"Tipo de dato incorrecto");
                sprintf(error,"%s%s%s","Error: tipo de dato de la variable '",id,"' incorrecto. Tipos permitidos: int y float");
                return 0;
            }
        }
        tabla = tabla->next;
    }
    sprintf(error, "%s%s%s", "Error: no se declaro la variable '", id, "'");
    return 0;
}

char* obtenerID(char* cadena)
{
    char* posAsig = strtok(cadena, "=");
    return cadena;
}

// FUNCIONES DE PILA
void apilar(int nroPila, char * val)
{
	switch(nroPila){
		case PILA_IF:
			if(pilaLlena(PILA_IF) == TRUE){
				printf("Error: Se exedio el tamano de la pila de IF.\n");
				system ("Pause");
				exit (1);
			}
			pilaIF[tope_pila_if]=val;
			printf("\tAPILAR #CELDA ACTUAL -> %s\n",val);
			tope_pila_if++;
			break;
		
		case PILA_WHILE:
		
			if(pilaLlena(PILA_WHILE) == TRUE){
				printf("Error: Se exedio el tamano de la pila de WHILE.\n");
				system ("Pause");
				exit (1);
			}
			pilaWhile[tope_pila_while]=val;
			printf("\tAPILAR #CELDA ACTUAL -> %s\n",val);
			tope_pila_while++;
			break;
		case PILA_ASIGNACION:
		
			if(pilaLlena(PILA_ASIGNACION) == TRUE){
				printf("Error: Se exedio el tamano de la pila de ASIGNACION.\n");
				system ("Pause");
				exit (1);
			}
			pilaAsignacion[tope_pila_asignacion]=val;
			printf("\tAPILAR #CELDA ACTUAL -> %s\n",val);
			tope_pila_asignacion++;
			break;	
		case PILA_REPEAT:
			if(pilaLlena(PILA_REPEAT) == TRUE){
				printf("Error: Se exedio el tamano de la pila de REPEAT.\n");
				system ("Pause");
				exit (1);
			}
			pilaRepeat[tope_pila_repeat]=val;
			printf("\tAPILAR #CELDA ACTUAL -> %s\n",val);
			tope_pila_repeat++;
			break;	
			
		case PILA_BETWEEN:
			if(pilaLlena(PILA_BETWEEN) == TRUE){
				printf("Error: Se exedio el tamano de la pila de BETWEEN.\n");
				system ("Pause");
				exit (1);
			}
			pilaBetween[tope_pila_between]=val;
			printf("\tAPILAR #CELDA ACTUAL -> %s\n",val);
			tope_pila_between++;
			break;	
		
		default:
			printf("\tError: La pila recibida no se reconoce\n",val);
			system ("Pause");
			exit (1);
			break;
	}

}

int desapilar(int nroPila)
{
	switch(nroPila){
		case PILA_IF:
			if(pilaVacia(tope_pila_if) == 0)
			{
				char * dato = pilaIF[tope_pila_if-1];
				tope_pila_if--;	
				printf("\tDESAPILAR #CELDA -> %s\n",dato);
				return atoi(dato);		
			} else {
				printf("Error: La pila esta vacia.\n");
				system ("Pause");
				exit (1);
			}
			
			break;
		
		case PILA_WHILE:
		
			if(pilaVacia(tope_pila_while) == 0)
			{
				char * dato = pilaWhile[tope_pila_while-1];
				tope_pila_while--;	
				printf("\tDESAPILAR #CELDA -> %s\n",dato);
				return atoi(dato);		
			} else {
				finAnormal("Stack Error","La pila esta vacia");
			}
		
			break;
		case PILA_ASIGNACION:
		
			if(pilaVacia(tope_pila_asignacion) == 0)
			{
				char * dato = pilaAsignacion[tope_pila_asignacion-1];
				tope_pila_asignacion--;	
				printf("\tDESAPILAR #CELDA -> %s\n",dato);
				return (tope_pila_asignacion);			// ESTA PILA EN VEZ DE DEVOLVER EL DATO DEVUELVE LA POSICION, SINO TENGO QUE HACER UNA FUNCION NUEVA
			} else {
				finAnormal("Stack Error","La pila esta vacia");
			}
		
			break;	
		case PILA_REPEAT:
		
			if(pilaVacia(tope_pila_repeat) == 0)
			{
				char * dato = pilaRepeat[tope_pila_repeat-1];
				tope_pila_repeat--;	
				printf("\tDESAPILAR #CELDA -> %s\n",dato);
				return atoi(dato);		
			} else {
				finAnormal("Stack Error","La pila esta vacia");
			}
		
			break;	
		
		case PILA_BETWEEN:
		
			if(pilaVacia(tope_pila_between) == 0)
			{
				char * dato = pilaBetween[tope_pila_between-1];
				tope_pila_between--;	
				printf("\tDESAPILAR #CELDA -> %s\n",dato);
				return atoi(dato);		
			} else {
				finAnormal("Stack Error","La pila esta vacia");
			}
		
			break;	

		default:
			finAnormal("Stack Error","La pila recibida no se reconoce");
			break;
		
	}
	
}

int pilaVacia(int tope)
{
	if (tope-1 == -1){
		return TRUE;
	} 
	return FALSE;
}

int pilaLlena(int tope)
{
	if (tope-1 == TAM_PILA-1){
		return TRUE;
	} 
	return FALSE;
}