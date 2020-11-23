/*---- 1. Declaraciones ----*/

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "y.tab.h"
#define YYERROR_VERBOSE 1
#define ES_CONST_NOMBRE 1
#define NO_ES_CONST_NOMBRE 0
FILE  *yyin;

//char vecAux[35];

/* --- Tabla de simbolos --- */
typedef struct
{
        char *nombre;
        char *tipo;
        char *nombreASM;
        bool esConst;
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

char* reemplazarString(char*, const char*);

char idvec[50][50];
int cantid = 0, i=0, contadorString = 0, cant_aux=0;
char vecAux[300], vecAsignacion[30][50];
char* punt;

/* POLACA */
char vectorPolaca[500][50], auxBet[50];
int pilaPolaca[50];
int posActual = 0, topePila = -1;

//Funciones Polaca
char* insertarPolaca(char *);
void insertarPolacaInt(int);
void insertarPolacaDouble(double);
void avanzarPolaca();
void grabarPolaca();
void guardarPos();
int pedirPos();
void imprimirPolaca();
void escribirPosicionEnTodaLaPila(int, int);
char * insertarPolacaEnPosicion(const int, const int);
void insertarExpresionEnContar();
int numeroAnidadas = -1, cantidadCondiciones = 0, hayOr = 0;
int vecif[50];
void notCondicion(int);

/* --- Assembler --- */
int vectorEtiquetas[50], topeVectorEtiquetas = -1;
void generarAssembler();

void guardarPosicionDeEtiqueta(const char *);
bool esPosicionDeEtiqueta(int);
bool esEtiquetaWhile(const char *);


void crearHeader(FILE *);
void crearSeccionData(FILE *);
void crearSeccionCode(FILE *);
void crearFooter(FILE *);

bool esValor(const char *);
bool esComparacion(const char *);
bool esSalto(const char *);
char * getSalto(const char *);
bool esGet( char * str );
bool esDisplay(const char * str);
bool esAsignacion( char * str );
bool esOperacion(const char *);
bool esContar(const char *);
bool esEndContar(const char *);
bool esValorAEvaluar(const char *);
bool esCalculoAux(const char *);
bool esCont(const char *);
char * getOperacion(const char *);


char* my_itoa(int num, char *str);
char* reemplazarChar(char* dest, const char* cad, const char viejo, const char nuevo);
char* limpiarString(char* dest, const char* cad);
char* obtenerID(char* cadena);


//bool verificarAsignacion(const char* id);

char* punt;
char pos[2];
char* separador1;
char nombre[50];
char tipo_dato[50];

int j=0;

/* --- Validaciones --- */
int existeID(const char*);
int esNumero(const char*, char*);
void guardarAsignacion(const char*);
void guardarAsignacionInt(const int);
void guardarAsignacionDouble(const double);
bool verificarAsignacion(const char*);
bool verificarComparacion();
bool esCompatible(const char*, const char*);
int esAsig = 0, esComp = 0, topeAsignacion = -1;
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
%token OP_NOT

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
    algoritmo {
        guardarTS();
        grabarPolaca();
        printf("\nGrabar Polaca\n");
        generarAssembler();
        printf("\nCompilacion OK.\n");
    };

algoritmo:
    bloque
    ;

bloque:
    bloque sentencia
    | sentencia
    ;

sentencia:
    { numeroAnidadas++; } ciclo
    | est_declaracion
    | est_asignacion PUNTO_Y_COMA
    | { numeroAnidadas++; } seleccion
    | entrada_salida PUNTO_Y_COMA
    ;

est_asignacion:
	CONST ID OP_ASIG_CONS CONST_REAL { 
        strcpy($<tipo_str>$, $2);
        insertarTS(obtenerID($<tipo_str>$), "CONST_REAL", "", 0, $4, ES_CONST_NOMBRE);
        strcpy(idvec[cantid], obtenerID($2));
        cantid = 0;
        insertarPolacaDouble($4);
        insertarPolaca("=");
        insertarPolaca(obtenerID($2));
    }
    | CONST ID OP_ASIG_CONS CONST_INT 
    {   
        strcpy($<tipo_str>$, $2);
        insertarTS(obtenerID($<tipo_str>$), "CONST_INT", "", $4, 0, ES_CONST_NOMBRE);
        strcpy(idvec[cantid], obtenerID($2));
        cantid = 0;
        insertarPolacaInt($4);
        insertarPolaca("=");
        insertarPolaca(obtenerID($2));
    }                               
    | CONST ID OP_ASIG_CONS CONST_STR {        
        insertarTS(obtenerID($2), "CONST_STR", yylval.tipo_str, 0, 0, ES_CONST_NOMBRE);
        strcpy(idvec[cantid], obtenerID($2));
        cantid = 0;
        insertarPolaca(obtenerID(yylval.tipo_str));
        insertarPolaca("=");
        insertarPolaca(obtenerID($2));
    }
    |  asignacion
    ;

asignacion:
    ID OP_ASIG 
    { 
        esAsig = 1; 
    }
    expresion 
    {
        insertarPolaca(":");
        strcpy(vecAux, $1); /*en $1 esta el valor de ID*/
        punt = strtok(vecAux," +-*/[](){}:=,\n"); /*porque puede venir de cualquier lado, pero ver si funciona solo con el =*/
        // if(!existeID(punt)) /*No existe: entonces no esta declarada*/
        // {
        //     sprintf(mensajes, "%s%s%s", "Error: Variable no declarada '", punt, "'");
        //     yyerror(mensajes, @1.first_line, @1.first_column, @1.last_column);
        // }
        // //Verifica que los tipos de datos sean compatibles
        // if(!verificarAsignacion(punt))
        // {
        //     sprintf(mensajes, "%s", "Error: se hacen asignaciones de distinto tipo de datos");
        //     yyerror(mensajes, @1.first_line, @1.first_column, @2.last_column);
        // }
        insertarPolaca(vecAux);
        esAsig = 0;
        topeAsignacion = -1;
    }
    ;

ciclo:
    WHILE 
    {
        insertarPolaca("ET");
        posActual--;
        guardarPos();
    }
    PARENTESIS condicion END_PARENTESIS LLAVE bloque END_LLAVE
    {
        insertarPolaca("BI");
        escribirPosicionEnTodaLaPila(vecif[numeroAnidadas], posActual +1);
        numeroAnidadas--; //decrementa porque ese bloque while ya terminó
        insertarPolacaInt(pedirPos());
    }
    ;

condicion:
    comparacion 
    {
          vecif[numeroAnidadas] = cantidadCondiciones;
          cantidadCondiciones = 0; //Se pasa a otra seleccio n o iteracion y se reseta la cantidad de condiciones.  
    }
    | comparacion OP_AND comparacion
    {
          vecif[numeroAnidadas] = cantidadCondiciones;
          cantidadCondiciones = 0; //Se pasa a otra seleccion o iteracion y se reseta la cantidad de condiciones.  
    }
    | comparacion
    {     //cuando ya lee la primera comparacion, avisamos que se trata de un OR
        hayOr=1;
        cantidadCondiciones--; //decrementamos porque ya vamos a trabajar con esa celda ahora, no hace falta que lo haga arriba
        vecif[numeroAnidadas] = cantidadCondiciones;
        notCondicion(cantidadCondiciones); //invierto el condicional: el salto va a ser adentro del bloque en lugar de al final
    } 
    OP_OR comparacion
    {
        vecif[numeroAnidadas] = cantidadCondiciones;
        cantidadCondiciones = 0; //Se pasa a otra seleccion o iteracion y se reseta la cantidad de condiciones.  
    }
    | OP_NOT comparacion
    {   vecif[numeroAnidadas] = cantidadCondiciones; 
        notCondicion(cantidadCondiciones);
        cantidadCondiciones = 0;
    }
    | PARENTESIS comparacion END_PARENTESIS OP_AND PARENTESIS comparacion END_PARENTESIS 
    {   
        vecif[numeroAnidadas] = cantidadCondiciones;
        cantidadCondiciones = 0;
    }
    | PARENTESIS comparacion END_PARENTESIS 
    {
        hayOr=1;
        cantidadCondiciones--;
        vecif[numeroAnidadas] = cantidadCondiciones;
        notCondicion(cantidadCondiciones);
    }           
    OP_OR PARENTESIS comparacion END_PARENTESIS 
    { 
        vecif[numeroAnidadas] = cantidadCondiciones;
        cantidadCondiciones = 0;
    }
    | OP_NOT PARENTESIS comparacion END_PARENTESIS 
    {
         vecif[numeroAnidadas] = cantidadCondiciones;
         notCondicion(cantidadCondiciones);
         cantidadCondiciones=0;
    }
    ;

comparacion:
    expresion OP_LEQ
    {
        insertarPolaca("CMP");
    } 
    expresion
    {
        if(!verificarComparacion())
        {
            sprintf(mensajes, "%s", "Error: se hacen comparaciones con distintos tipos de datos");
            yyerror(mensajes, @1.first_line, @1.first_column, @4.last_column);
        }
        esComp = 0;
        topeAsignacion = -1;
        insertarPolaca("BGE");
        if(hayOr)
        {
            insertarPolacaEnPosicion(pedirPos(), posActual +1);
            hayOr=0;
        } 
        guardarPos(); 
        cantidadCondiciones++;
    }
    | expresion OP_MOQ
    {
        insertarPolaca("CMP");
    }
    expresion 
    {
        if(!verificarComparacion())
        {
            sprintf(mensajes, "%s", "Error: se hacen comparaciones con distintos tipos de datos");
            yyerror(mensajes, @1.first_line, @1.first_column, @4.last_column);
        }
        esComp = 0;
        topeAsignacion = -1;
        insertarPolaca("BLT");
        if(hayOr)
        {
            insertarPolacaEnPosicion(pedirPos(), posActual +1);
            hayOr=0;
        } 
        guardarPos(); 
        cantidadCondiciones++;
    }
    | expresion OP_EQQ 
    {
        insertarPolaca("CMP");
    }
    expresion
    {
        if(!verificarComparacion())
        {
            sprintf(mensajes, "%s", "Error: se hacen comparaciones con distintos tipos de datos");
            yyerror(mensajes, @1.first_line, @1.first_column, @4.last_column);
        }
        esComp = 0;
        topeAsignacion = -1;
        insertarPolaca("BNE");
        if(hayOr)
        {
            insertarPolacaEnPosicion(pedirPos(), posActual +1);
            hayOr=0;
        } 
        guardarPos(); 
        cantidadCondiciones++;
    } 
    |expresion OP_DIFF
    {
        insertarPolaca("CMP");
    } expresion
    {
        if(!verificarComparacion())
        {
            sprintf(mensajes, "%s", "Error: se hacen comparaciones con distintos tipos de datos");
            yyerror(mensajes, @1.first_line, @1.first_column, @4.last_column);
        }
        esComp = 0;
        topeAsignacion = -1;
        insertarPolaca("BEQ");
        if(hayOr)
        {
            insertarPolacaEnPosicion(pedirPos(), posActual +1);
            hayOr=0;
        }
        guardarPos(); 
        cantidadCondiciones++;
    }
    |
    expresion OP_LESS
    {
        insertarPolaca("CMP");
    } 
    expresion
    {
        if(!verificarComparacion())
        {
            sprintf(mensajes, "%s", "Error: se hacen comparaciones con distintos tipos de datos");
            yyerror(mensajes, @1.first_line, @1.first_column, @4.last_column);
        }
        esComp = 0;
        topeAsignacion = -1;
        insertarPolaca("BGE");
        if(hayOr)
        {
            insertarPolacaEnPosicion(pedirPos(), posActual +1);
            hayOr=0;
        } 
        guardarPos(); 
        cantidadCondiciones++;
    }
    |
    expresion OP_MORE
    {
        insertarPolaca("CMP");
    } 
    expresion
    {
        if(!verificarComparacion())
        {
            sprintf(mensajes, "%s", "Error: se hacen comparaciones con distintos tipos de datos");
            yyerror(mensajes, @1.first_line, @1.first_column, @4.last_column);
        }
        esComp = 0;
        topeAsignacion = -1;
        insertarPolaca("BLE");
        if(hayOr)
        {
            insertarPolacaEnPosicion(pedirPos(), posActual +1);
            hayOr=0;
        } 
        guardarPos(); 
        cantidadCondiciones++;
    }
    ;

lista: 
expresion {
    insertarExpresionEnContar();
}
| expresion COMA
{ 
    insertarExpresionEnContar();
} lista;


expresion:
    expresion OP_SUM termino
    {
        insertarPolaca("+");
    }
    | expresion OP_RES termino
    {
        insertarPolaca("-");
    }
    | termino 
 	;

termino: 
    termino OP_MUL factor
    {
        insertarPolaca("*");
    }
    | termino OP_DIV factor
    {
        insertarPolaca("/");
    }
    | factor

    ;

factor:
    ID {
        strcpy(vecAux, $1);
        punt = strtok(vecAux," +-*/[](){}:=,\n");
        // if(!existeID(punt))
        // {
        //     sprintf(mensajes, "%s%s%s", "Error: no se declaro la variable '", punt, "'");
        //     yyerror(mensajes, @1.first_line, @1.first_column, @1.last_column);
        // }
        if(esAsig == 1)
            guardarAsignacion(punt);
        insertarPolaca(punt);
    }
    | CONST_INT  {
        $<tipo_int>$ = $1;
        if(esAsig == 1)
            guardarAsignacionInt($<tipo_int>$);
        insertarPolacaInt($<tipo_int>$);
    }
    | CONST_REAL {
        $<tipo_double>$ = $1;
        if(esAsig == 1)
            guardarAsignacionInt($<tipo_int>$);
        insertarPolacaDouble($<tipo_double>$);
    }	 
    | CONST_STR {
        $<tipo_str>$ = $1;
        strcpy(vecAux, $1);
        if(esAsig == 1)
            guardarAsignacion($<tipo_str>$);
        insertarPolaca(vecAux);
    }
    | PARENTESIS expresion END_PARENTESIS
    | CONTAR {
        insertarPolaca("CONTAR");
    }
    PARENTESIS
    {
        /* insertarPolaca("0");
        insertarPolaca("=");
        insertarPolaca("@cont"); */
    } expresion
    {
        insertarPolaca("=");
        insertarPolaca("@valorAEvaluar");
    } PUNTO_Y_COMA CORCHETE lista END_CORCHETE END_PARENTESIS { insertarPolaca("ENDCONTAR"); }
    ;

est_declaracion:
	DIM est_variables AS est_tipos {  
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
        //cantid=0;
    }
    ;

est_variables:
    OP_LESS lista_variables OP_MORE;

lista_variables:
    ID {
        strcpy(vecAux, $1); /*tomamos el nombre de la variable*/
        punt = strtok(vecAux, ">"); /*eliminamos extras*/
        strcpy(idvec[cantid], punt); /*copiamos al array de ids*/  
        cantid++;
    }
    | ID COMA lista_variables {
        strcpy(vecAux, $1); /*tomamos el nombre de la variable*/
        punt = strtok(vecAux, ","); /*eliminamos extras*/
        strcpy(idvec[cantid], punt); /*copiamos al array de ids*/
        cantid++;
        cant_aux = cantid;
    }
    ;

lista_tipos:
    tipo
    | tipo COMA lista_tipos;

tipo:
    INTEGER {
        strcat(idvec[cantid-1],";");
        strcat(idvec[cantid-1],"INTEGER");
        cantid--;
    }
    | FLOAT {
        strcat(idvec[cantid-1],";");
        strcat(idvec[cantid-1],"FLOAT");
        cantid--;
    }
    | CONST_STR
    ;

est_tipos:
    OP_LESS lista_tipos OP_MORE;

seleccion:
    IF PARENTESIS condicion END_PARENTESIS LLAVE bloque END_LLAVE
    {
       escribirPosicionEnTodaLaPila(vecif[numeroAnidadas], posActual);
       numeroAnidadas--;
    } 
    | IF PARENTESIS condicion END_PARENTESIS LLAVE bloque END_LLAVE ELSE
    {
        insertarPolaca("BI");
        escribirPosicionEnTodaLaPila(vecif[numeroAnidadas], posActual + 1);
        numeroAnidadas--;
        guardarPos();
        //insertarPolacaInt(pedirPos());
    } LLAVE bloque
    {
        insertarPolacaEnPosicion(pedirPos(), posActual);
    } END_LLAVE
    | IF PARENTESIS condicion END_PARENTESIS sentencia
    {
        escribirPosicionEnTodaLaPila(vecif[numeroAnidadas], posActual);
        numeroAnidadas--;
        //insertarPolacaEnPosicion(pedirPos(), posActual);

    }
    ;

entrada_salida:
	GET ID {
        strcpy(vecAux, $2);
        // if(!existeID(vecAux)) 
        // {
        //     sprintf(mensajes, "%s%s%s", "Error: Variable no declarada '", vecAux, "'");
        //     yyerror(mensajes, @1.first_line, @1.first_column, @1.last_column);
        // }
        insertarPolaca("GET");
        insertarPolaca(vecAux);        
        }
	| PUT ID {
        strcpy(vecAux, $2);
        // if(!existeID(vecAux)) 
        // {
        //     sprintf(mensajes, "%s%s%s", "Error: Variable no declarada '", vecAux, "'");
        //     yyerror(mensajes, @1.first_line, @1.first_column, @1.last_column);
        // }
        insertarPolaca("PUT");
        insertarPolaca(vecAux);
    }
	| PUT CONST_STR {
        strcpy(vecAux, $2);
        insertarPolaca("PUT");
        insertarPolaca(vecAux);
        
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
    stdout->_ptr = stdout->_base;

    char full[100] = "_";
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
        data->esConst = false;
        data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
        strcpy(data->nombre, nombre);
        data->nombreASM = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
        strcpy(data->nombreASM, nombre);
        return data;
    }
    else
    {   

        
        if(esConstNombre == ES_CONST_NOMBRE)
        {
            printf("NOMBRE: %s\n", nombre);
            data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
            strcpy(data->nombre, nombre);
            printf("CONST: %s\n", data->nombre);
            data->esConst = true;
            strcpy(data->nombre, nombre);
        }

         //Son constantes: tenemos que agregarlos a la tabla con "_" al comienzo del nombre, hay que agregarle el valor
        if(strcmp(tipo, "CONST_STR") == 0)
        {
            contadorString++;
            
            data->valor.valor_str = (char*)malloc(sizeof(char) * (strlen(valString) + 1));
            strcpy(data->valor.valor_str, valString);
            
            char auxString[32];
            strcpy(full, ""); 
            strcpy(full, "S");  // "S_"
            reemplazarString(auxString, nombre);
            
            strcat(full, auxString); // "S_<nombre>"  
            char numero[10];
            sprintf(numero, "_%d", contadorString);
            strcat(full, numero);
            
            
            if(esConstNombre == ES_CONST_NOMBRE)
            {
                strcpy(data->nombreASM, data->nombre); 
            }
            else
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(valString) + 1));
                //strcat(full, valString); Comenté esto porque rompia.
                strcpy(data->nombre, full);
                data->nombreASM = (char*)malloc(sizeof(char) * (strlen(full) + 1));
                strcpy(data->nombreASM, data->nombre);     
            }
            
        }
        if(strcmp(tipo, "CONST_REAL") == 0)
        {

            data->valor.valor_double = valDouble;

            if(esConstNombre == ES_CONST_NOMBRE)
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
                data->nombreASM = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
                strcpy(data->nombre, nombre);
                strcpy(data->nombreASM, nombre);
                sprintf(aux, "%g", valDouble);
                data->valor.valor_double = valDouble;
            }
            else
            {
                char dest[32];
                sprintf(aux, "%g", valDouble);
                strcat(full, aux);
                data->nombre = (char*)malloc(sizeof(char) * strlen(full));
                strcpy(data->nombre, full);
                data->valor.valor_double = valDouble;
                reemplazarChar(dest, full, '.', '_');
                data->nombreASM = (char*)malloc(sizeof(char) * (strlen(dest) + 1));
                strcpy(data->nombreASM, dest);
            }

        }
        if(strcmp(tipo, "CONST_INT") == 0)
        {
            data->valor.valor_int = valInt;

            if(esConstNombre == ES_CONST_NOMBRE)
            {
                data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
                strcpy(data->nombre, nombre);
                data->valor.valor_int = valInt;
                data->nombreASM = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
                strcpy(data->nombreASM, nombre);
            }
            else
            {
                sprintf(aux, "%d", valInt);
                strcat(full, aux);
                data->nombre = (char*)malloc(sizeof(char) * strlen(full));
                strcpy(data->nombre, full);
                data->valor.valor_int = valInt;
                data->nombreASM = (char*)malloc(sizeof(char) * (strlen(full) + 1));
                strcpy(data->nombreASM, full);
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
        //free(aux);
    }
    fclose(arch); 
}

void crearTablaTS()
{
    tablaTS.primero = NULL;
}

t_simbolo * getLexema(const char *valor){

    t_simbolo *lexema;
    t_simbolo *tablaSimbolos = tablaTS.primero;

    char nombreLimpio[32];
    limpiarString(nombreLimpio, valor);
    char nombreCTE[32] = "_";
    strcat(nombreCTE, nombreLimpio);
    int esID, esCTE, esASM, esValor =-1;
    char valorFloat[32];

    while(tablaSimbolos){  
        esID = strcmp(tablaSimbolos->data.nombre, nombreLimpio);
        esCTE = strcmp(tablaSimbolos->data.nombre, nombreCTE);
        esASM = strcmp(tablaSimbolos->data.nombreASM, valor);

        if(strcmp(tablaSimbolos->data.tipo, "CONST_STR") == 0)
        {
            esValor = strcmp(valor, tablaSimbolos->data.valor.valor_str);
        }

        if(esID == 0 || esCTE == 0 || esASM == 0 || esValor == 0)
        { 
            lexema = tablaSimbolos;
            return lexema;
        }
        tablaSimbolos = tablaSimbolos->next;
    }
    return NULL;
    
}

int existeID(const char* id)
{
    t_simbolo *tabla = tablaTS.primero;
    char valor[32];
    char nombreCTE[32] = "_";
    strcat(nombreCTE, id);
    int b1, b2, b3, b4 = -1;
 
    while(tabla)
    {   
        b1 = strcmp(tabla->data.nombre, id);
        b2 = strcmp(tabla->data.nombre, nombreCTE);
        b3 = strcmp(tabla->data.nombreASM, id);
 
        if(strcmp(tabla->data.tipo, "CONST_STR") == 0)
        {
            b4 = strcmp(tabla->data.valor.valor_str, id);
        }
 
        if(b1 == 0 || b2 == 0 || b3 == 0 || b4 == 0)
        {
            return 1;
        }
        tabla = tabla->next;
    }
    return 0;
}

int existeCTE(const char* id)
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
        //b1 = strcmp(idvec[j], id);
        b2 = strcmp(tabla->data.nombreASM, nombreCTE);
        if(b2 == 0)
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


/* ---------Funciones para Notación Polaca ------- */


//Inserta un string en la notación polaca. 
char* insertarPolaca(char * cad)
{
	strcpy(vectorPolaca[posActual],cad);
	posActual++; //Aumentamos la posicion, ya que la celda está ocupada por la cadena recibida.
	return cad;
}

//Inserta un int en la notación polaca. Lo pasamos a string para que pueda ser almacenado en el array de Polaca.
void insertarPolacaInt(int entero)
{
	char cad[20];
    //itoa(entero, cad, 10); 
	my_itoa(entero, cad); 
	insertarPolaca(cad);
}

//Inserta un double en la notación polaca. Lo pasamos a string para que pueda ser almacenado en el array de Polaca.
void insertarPolacaDouble(double real)
{
	char cad[20];
	sprintf(cad,"%.10f", real);
	insertarPolaca(cad);
}

void avanzarPolaca()
{
	posActual++;
}

void imprimirPolaca()
{
	int i;
	for (i=0;i<posActual;i++)
	    printf("posActual: %d, valor: %s \r\n",i,vectorPolaca[i]);
}

void guardarPos()
{
	topePila++; //Tope = -1 significa pila vacía, el primer elemento de la pila esta en tope = 0
	pilaPolaca[topePila] = posActual;
	posActual++;
}

int pedirPos()
{
    //Si hay alguna posicion guardada...
	if(topePila > -1)
    {
        //Retorno es es el numero de celda, y topepila reduce ya que el tope ahora es una posicion menos.
	    int retorno = pilaPolaca[topePila];
	    topePila--;
	    return retorno;
	}
    else
    {
	    return -1;
	}
}

//Rellena aquellas posiciones de la Polaca que indican hacia donde hacer el branch.
void escribirPosicionEnTodaLaPila(int cant, int celda)
{
	while(cant > 0)
    {
        char cad[20];
        //itoa(celda, cad, 10);
        my_itoa(celda, cad); 
        strcpy(vectorPolaca[pedirPos()],cad);
        cant --;
	}
}

//Escribe el archivo de polaca, intermedia.txt
void grabarPolaca()
{
    FILE* pf = fopen("intermedia.txt","wt");
    int i;
    for (i=0;i<posActual;i++)
	    fprintf(pf,"Posicion: %d, Valor: %s \r",i,vectorPolaca[i]);
    fclose(pf);
}

/* Esta función está pensada para cuando desapilamos el valor
de una celda y lo debemos insertar en la polaca. */

char * insertarPolacaEnPosicion(const int posicion, const int valorCelda)
{
    //Ponele que tenemos hasta 1M celdas.
    char aux[6];
    return strcpy(vectorPolaca[posicion], my_itoa(valorCelda, aux));//itoa(valorCelda, aux, 10));
}

void notCondicion(int cant) //aca le pasamos por parametro el cantidadCondiciones correspondiente a cada if
{
    int j;
    for(j=0; j<=cant; j++)
    {
        char cad[50];
        int k = topePila-j;
        int i = pilaPolaca[k] - 1;
        strcpy(cad,vectorPolaca[i]);
        
        if(strcmp(cad, "BGE") == 0)
            strcpy(vectorPolaca[i], "BLT");
        else if(strcmp(cad, "BLT") == 0)
            strcpy(vectorPolaca[i], "BGE");
        else if(strcmp(cad, "BLE") == 0)
            strcpy(vectorPolaca[i], "BGT");
        else if(strcmp(cad, "BGT") == 0)
            strcpy(vectorPolaca[i], "BLE");
        else if(strcmp(cad, "BEQ") == 0)
            strcpy(vectorPolaca[i], "BNE");
        else if(strcmp(cad, "BNE") == 0)
            strcpy(vectorPolaca[i], "BEQ");
    }
}

void insertarExpresionEnContar()
{
    insertarPolaca("=");
    insertarPolaca("@calculoAux");
    insertarPolaca("@calculoAux");
    insertarPolaca("CMP");
    insertarPolaca("@valorAEvaluar");
    insertarPolaca("BNE");
    insertarPolacaInt(posActual + 6);
    insertarPolaca("@cont");
    insertarPolaca("1");
    insertarPolaca("+");
    insertarPolaca("=");
    insertarPolaca("@cont");
}



/** funciones assembler **/

void generarAssembler(){
    FILE* archAssembler = fopen("final.asm","w+t");

    printf("\n01 - Generar header\n");
    crearHeader(archAssembler);

    printf("\n02 - Generar Seccion de Data\n");
    crearSeccionData(archAssembler);

    printf("\n03 - Generar Seccion de Code\n");
    crearSeccionCode(archAssembler);

    printf("\n04 - Generar assembler antes del for\n");

    int i;
    for(i=0; i<=posActual; i++){
    
        if(esPosicionDeEtiqueta(i) || esEtiquetaWhile(vectorPolaca[i])){
            fprintf(archAssembler, "branch%d:\n\n", i);
        }        

        if(esValor(vectorPolaca[i])){
            t_simbolo *lexema = getLexema(vectorPolaca[i]);
            fprintf(archAssembler, "fld %s\n", lexema->data.nombreASM);
        }
        else if(esComparacion(vectorPolaca[i])){
            fprintf(archAssembler, "fstp @ifI\n\n");
        }
        else if(esSalto(vectorPolaca[i])){
            char *tipoSalto = getSalto(vectorPolaca[i]);
            if(strcmp(tipoSalto, "jmp") != 0){
                fprintf(archAssembler, "fstp @ifD\n\n");
                fprintf(archAssembler, "fld @ifI\nfld @ifD\n");
                fprintf(archAssembler, "fxch\nfcom\nfstsw AX\nsahf\n");
            }
            i++;
            fprintf(archAssembler, "%s branch%s\n\n", tipoSalto, vectorPolaca[i]);
            guardarPosicionDeEtiqueta(vectorPolaca[i]);
        }
        else if(esGet(vectorPolaca[i])){
            i++;
            t_simbolo *lexema = getLexema(vectorPolaca[i]);

            if(strcmp(lexema->data.tipo, "CONST_REAL") == 0 || strcmp(lexema->data.tipo, "INT") == 0)
            {
                fprintf(archAssembler, "GetFloat %s\nNEWLINE\n", lexema->data.nombreASM);
            }
            else
            {
                fprintf(archAssembler, "getString %s\nNEWLINE\n", lexema->data.nombreASM);
            }
        }
        else if(esDisplay(vectorPolaca[i])){
            i++;
            t_simbolo *lexema = getLexema(vectorPolaca[i]);
            //printf("[generarAsembler] hola");


            if(strcmp(lexema->data.tipo, "CONST_STR") == 0){
                fprintf(archAssembler, "displayString %s\nNEWLINE\n", lexema->data.nombreASM);
            }
            else{
                fprintf(archAssembler, "displayFloat %s\nNEWLINE\n", lexema->data.nombreASM);
            }
        }
        else if(esAsignacion(vectorPolaca[i])){
            i++;
            fprintf(archAssembler, "fstp %s\n\n", vectorPolaca[i]);
        }
        else if(esOperacion(vectorPolaca[i])){
            fprintf(archAssembler, "%s\n", getOperacion(vectorPolaca[i]));
        }
        else if(esContar(vectorPolaca[i])){ // para encontrar el bloque perteneciente al metodo CONTAR, se agregaron las etiquetas CONTAR y ENDCONTAR en la polaca 
            i++;
            while(!esEndContar(vectorPolaca[i])) 
            {
                //aca se tiene que evaluar cada expresion de la lista. En la lista todavia tenemos la vieja estructura de la polaca de operando operando operador
                printf("contenido del vector: %s\n",vectorPolaca[i]);
                if(esValorAEvaluar(vectorPolaca[i])) {
                    fprintf(archAssembler, "fstp @ValorAEvaluar\n");
                }
                else if(esCalculoAux(vectorPolaca[i])) {
                    fprintf(archAssembler, "fstp @CalculoAux\n");
                }
                else if(esValor(vectorPolaca[i])) {
                    t_simbolo *lexema = getLexema(vectorPolaca[i]);
                    fprintf(archAssembler, "fld %s\n", lexema->data.nombreASM);
                }
                else if(esCont(vectorPolaca[i])) {
                    fprintf(archAssembler, "fld @cont\n");
                }
                else if(esOperacion(vectorPolaca[i])) {
                    fprintf(archAssembler, "%s\n", getOperacion(vectorPolaca[i]));
                }
                else if(esSalto(vectorPolaca[i])) {
                    char *tipoSalto = getSalto(vectorPolaca[i]);
                    if(strcmp(tipoSalto, "jmp") != 0) {
                        fprintf(archAssembler, "fstp @ifD\n\n");
                        fprintf(archAssembler, "fld @ifI\nfld @ifD\n");
                        fprintf(archAssembler, "fxch\nfcom\nfstsw AX\nsahf\n");
                    }
                    i++;
                    fprintf(archAssembler, "%s branch%s\n\n", tipoSalto, vectorPolaca[i]);
                    guardarPosicionDeEtiqueta(vectorPolaca[i]);
                }
                i++; 
            }
        }
    }      

    printf("\n05 - Antes del footer\n");

    crearFooter(archAssembler);
    fclose(archAssembler);
}

void crearHeader(FILE *archAssembler){
    fprintf(archAssembler, "%s\n%s\n\n", "include number.asm", "include macros2.asm");
    
    fprintf(archAssembler, "%-30s%-30s\n", ".MODEL LARGE", "; Modelo de mem4oria");
    fprintf(archAssembler, "%-30s%-30s\n", ".386", "; Tipo de procesador");
    fprintf(archAssembler, "%-30s%-30s\n\n", ".STACK 200h", "; Bytes en el stack");
}

void crearSeccionData(FILE *archAssembler){
    
    t_simbolo *aux;
    t_simbolo *tablaSimbolos = tablaTS.primero;

    //tablaSimbolos = tablaSimbolos->next;
    stdout->_ptr = stdout->_base;
    fprintf(archAssembler, "%s\n\n", ".DATA");
    while(tablaSimbolos){
        
        aux = tablaSimbolos;
        
    
        if(strcmp(aux->data.tipo, "INTEGER") == 0)
        {
            fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", aux->data.nombreASM, "dd", "?", "; Variable int");
        }
        else if(strcmp(aux->data.tipo, "FLOAT") == 0)
        {
            fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", aux->data.nombreASM, "dd", "?", "; Variable float");
        }
        else if(strcmp(aux->data.tipo, "STRING") == 0)
        { 
            fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", aux->data.nombreASM, "db", "?", "; Variable string");
        }
        else if(strcmp(aux->data.tipo, "CONST_INT") == 0)
        { 
            char valor[50];
            sprintf(valor, "%d.0", aux->data.valor.valor_int);
            if(aux->data.esConst == false)
                fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", aux->data.nombreASM, "dd", valor, "; Constante int");
            else
                fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", aux->data.nombreASM, "dd", valor, "; Constante con nombre int");
        }
        else if(strcmp(aux->data.tipo, "CONST_REAL") == 0)
        { 
            char valor[50];
            sprintf(valor, "%g", aux->data.valor.valor_double);
            fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", aux->data.nombreASM, "dd", valor, "; Constante float");
        }
        else if(strcmp(aux->data.tipo, "CONST_STR") == 0)
        {
            char valor[50];
            sprintf(valor, "%s, '$', %d dup (?)",aux->data.valor.valor_str, strlen(aux->data.valor.valor_str) - 2);
            fprintf(archAssembler, "%-35s%-15s%-15s%-15s\n", aux->data.nombreASM, "db", valor, "; Constante string");
        }
        tablaSimbolos = tablaSimbolos->next;
    }
    fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", "@cont", "dd", "?", "; Variable para almacenar el resultado de contar");
    fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", "@valorAEvaluar", "dd", "?", "; Variable para almacenar el primer parametro de contar");
    fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", "@calculoAux", "dd", "?", "; Variable para almacenar cada valor de la lista de expresiones de contar");
    fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", "@ifI", "dd", "?", "; Variable para condición izquierda");
    fprintf(archAssembler, "%-15s%-15s%-15s%-15s\n", "@ifD", "dd", "?", "; Variable para condición derecha");

}

void crearSeccionCode(FILE *archAssembler){
    fprintf(archAssembler, "\n%s\n\n%s\n\n", ".CODE", "inicio:");
    fprintf(archAssembler, "%-30s%-30s\n", "mov AX,@DATA", "; Inicializa el segmento de datos");
    fprintf(archAssembler, "%-30s\n%-30s\n\n", "mov DS,AX", "mov ES,AX");
}

void crearFooter(FILE *archAssembler){
    fprintf(archAssembler, "\n%-30s%-30s\n", "mov AX,4C00h", "; Indica que debe finalizar la ejecución");
    fprintf(archAssembler, "%s\n\n%s", "int 21h", "END inicio");
}





char *my_itoa(int num, char *str)
{
        if(str == NULL)
        {
                return NULL;
        }
        sprintf(str, "%d", num);
        return str;
}


char* reemplazarChar(char* dest, const char* cad, const char viejo, const char nuevo)
{
    int i, longitud;
    longitud = strlen(cad);

    for(i=0; i<longitud; i++)
    {
        if(cad[i] == viejo)
        {
            dest[i] = nuevo;
        }
        else
        {
            dest[i] = cad[i];
        }
    }
    dest[i] = '\0';
    return dest;
}


char* limpiarString(char* dest, const char* cad)
{
    int i, longitud, j=0;
    longitud = strlen(cad);
    for(i=0; i<longitud; i++)
    {
        if(cad[i] != '"')
        {
            dest[j] = cad[i];
            j++;
        }
    }
    dest[j] = '\0';
    return dest;
} 

bool verificarAsignacion(const char* id)
{
    t_simbolo* lexemaI = getLexema(id);
    t_simbolo* lexemaD;
    int i;

    //printf("lexemaI: %s\n",lexemaI->data.tipo);
    //printf("lexemaD: %s\n",lexemaD->data.tipo);

    for(i=0; i<=topeAsignacion; i++)
    {
        printf("vecAsignacion[i]: %s\n", vecAsignacion[i]);
        lexemaD = getLexema(vecAsignacion[i]);
        printf("%s: %s\n", lexemaI->data.tipo, lexemaI->data.nombre);
        printf("%s: %s\n", lexemaD->data.tipo, lexemaD->data.nombre);
        if(!esCompatible(lexemaI->data.tipo, lexemaD->data.tipo))
        {
            return false;
        }
    }
    return true;
}

bool esCompatible(const char* tipo1, const char* tipo2)
{
    if(strcmp("INTEGER", tipo1) == 0)
    {
        return (strcmp("INTEGER", tipo2) == 0 || strcmp("CONST_INT", tipo2) == 0);
    }
    else if(strcmp("FLOAT", tipo1) == 0)
    {
        return (strcmp("FLOAT", tipo2) == 0 || strcmp("CONST_REAL", tipo2) == 0 || strcmp("CONST_INT", tipo2) == 0 || strcmp("INTEGER", tipo2) == 0);
    }
    else if(strcmp("STRING", tipo1) == 0)
    {
        return (strcmp("STRING", tipo2) == 0 || strcmp("CONST_STR", tipo2) == 0);
    }
}

bool esPosicionDeEtiqueta(int posicion){
    int i;
    for(i = 0; i <= topeVectorEtiquetas; i++){
        if(posicion == vectorEtiquetas[i]){
            return true;
        }
    }
    return false;
}

bool esValor(const char * str){
    //Si es valor, tiene que estar en la tabla de símbolos guiño guiño
    if(existeCTE(str) == 1 || existeID(str) == 1 )
        return true;
    return false;
} 

bool esComparacion(const char * str){
    int aux = strcmp(str, "CMP");
    return aux == 0;
}

//La última comparación no es obligatoria, pero es para no perder de vista todos los saltos.
bool esSalto(const char * str){
    if(strcmp(str, "BNE") == 0){
       return true; 
    }
    else if(strcmp(str, "BGT") == 0){
        return true;
    }
    else if(strcmp(str, "BLT") == 0){
        return true;
    }
    else if(strcmp(str, "BLE") == 0){
       return true; 
    }
    else if(strcmp(str, "BGE") == 0){
        return true;
    }
    else if(strcmp(str, "BEQ") == 0){
        return true;
    }
    else if(strcmp(str, "BI") == 0){
        return true;
    }
    return false;
}


bool esEtiquetaWhile(const char *str){
    return strcmp(str, "ET") == 0;
}

//La última comparación no es obligatoria, pero es más fácil de ver a qué salto corresponde.
char * getSalto(const char * salto){
    if(strcmp(salto, "BNE") == 0){
       return "jne"; 
    }
    else if(strcmp(salto, "BGT") == 0){
        return "ja";
    }
    else if(strcmp(salto, "BLT") == 0){
        return "jb";
    }
    else if(strcmp(salto, "BLE") == 0){
       return "jbe"; 
    }
    else if(strcmp(salto, "BGE") == 0){
        return "jae";
    }
    else if(strcmp(salto, "BEQ") == 0){
        return "je";
    }
    else if(strcmp(salto, "BI") == 0){
        return "jmp";
    }
}

bool esGet(char * str)
{
    int aux = strcmp(str, "GET");
    return aux == 0;
}

bool esDisplay(const char * str){
    int aux = strcmp(str, "PUT");
    return aux == 0;
}

bool esAsignacion(char * str)
{
    int aux = strcmp(str, "=");
    return aux == 0;
}

bool esContar(const char * str){
    int aux = strcmp(str, "CONTAR");
    return aux == 0;
}

bool esEndContar(const char * str){
    int aux = strcmp(str, "ENDCONTAR");
    return aux == 0;
}

bool esValorAEvaluar(const char * str){
    int aux = strcmp(str, "@valorAEvaluar");
    return aux == 0;
}

bool esCalculoAux(const char * str){
    int aux = strcmp(str, "@calculoAux");
    return aux == 0;
}

bool esCont(const char * str){
    int aux = strcmp(str, "@cont");
    return aux == 0;
}

bool esOperacion(const char * str){
    if(strcmp(str, "+") == 0){
       return true; 
    }
    else if(strcmp(str, "-") == 0){
        return true;
    }
    else if(strcmp(str, "*") == 0){
        return true;
    }
    else if(strcmp(str, "/") == 0){
        return true;
    }        
    return false;
}

char * getOperacion(const char * operacion){
    if(strcmp(operacion, "+") == 0){
       return "fadd"; 
    }
    else if(strcmp(operacion, "-") == 0){
        return "fsub";
    }
    else if(strcmp(operacion, "*") == 0){
        return "fmul";
    }
    else {
        return "fdiv";
    }
}

//Podríamos verificar de no introducir duplicados, pero creo que al cohete.
void guardarPosicionDeEtiqueta(const char *posicion){
	topeVectorEtiquetas++;
	vectorEtiquetas[topeVectorEtiquetas] = atoi(posicion);
}

char* reemplazarString(char* dest, const char* cad)
{
    int i, longitud;
    longitud = strlen(cad);

    for(i=0; i<longitud; i++)
    {
        if((cad[i] >= 'a' && cad[i] <= 'z') || (cad[i] >='A' && cad[i] <= 'Z') || (cad[i] >= '0' && cad[i] <= '9'))
        {
            dest[i] = cad[i];
        }
        else
        {
            dest[i] = '_';
        }
    }
    dest[i] = '\0';
    return dest;
}

bool verificarComparacion()
{
    int i;
    t_simbolo* lex;
    if(topeAsignacion >= 0)
        lex = getLexema(vecAsignacion[0]);
    printf("%s\n", lex);
    for(i=1; i<=topeAsignacion; i++)
    {

        t_simbolo* lex2 = getLexema(vecAsignacion[i]);
        if(!esCompatible(lex->data.tipo, lex2->data.tipo))
        {
            return false;
        }
    }
    return true;
}

void guardarAsignacion(const char* id)
{
    topeAsignacion++;
    strcpy(vecAsignacion[topeAsignacion], id);
}

void guardarAsignacionInt(const int id)
{
    char aux[32];
    sprintf(aux, "%d", id);
    guardarAsignacion(aux);
}

void guardarAsignacionDouble(const double id)
{
    char aux[32];
    sprintf(aux, "%g", id);
    guardarAsignacion(aux);
}
