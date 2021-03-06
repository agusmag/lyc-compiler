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

//char vecAux[35];

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

char idvec[50][50];
int cantid = 0, i=0, cant_aux=0;
char vecAux[300];
char* punt;
char pos[2];
char* separador1;
char nombre[50];
char tipo_dato[50];

int j=0;

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
        insertarPolaca(obtenerID($2));
        insertarTS(obtenerID($2), "CONST_REAL", "", 0, $4, ES_CONST_NOMBRE);
        insertarPolacaDouble($4);
        insertarPolaca("=");
    }
    | CONST ID OP_ASIG_CONS CONST_INT {
        insertarPolaca(obtenerID($2));
        strcpy($<tipo_str>$, $2);
        insertarTS(obtenerID($2), "CONST_INT", "", $4, 0, ES_CONST_NOMBRE);
        insertarPolacaInt($4);
        
        insertarPolaca("=");
    }                               
    | CONST ID OP_ASIG_CONS CONST_STR {
        insertarPolaca(obtenerID($2));
        insertarTS(obtenerID($2), "CONST_STR", yylval.tipo_str, 0, 0, ES_CONST_NOMBRE);
        insertarPolaca(obtenerID(yylval.tipo_str));
        
        insertarPolaca("=");
    }
    |  asignacion
    ;

asignacion:
    ID OP_ASIG {
        strcpy(vecAux, $1); /*en $1 esta el valor de ID*/
        punt = strtok(vecAux," +-*/[](){}:=,\n"); /*porque puede venir de cualquier lado, pero ver si funciona solo con el =*/
        if(!existeID(punt)) /*No existe: entonces no esta declarada*/
        {
            sprintf(mensajes, "%s%s%s", "Error: Variable no declarada '", punt, "'");
            yyerror(mensajes, @1.first_line, @1.first_column, @1.last_column);
        }
        insertarPolaca(vecAux);
    } expresion {
        insertarPolaca(":");
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
    expresion OP_LEQ expresion
    {
        insertarPolaca("CMP");
        insertarPolaca("BGE");
        if(hayOr)
        {
            insertarPolacaEnPosicion(pedirPos(), posActual +1);
            hayOr=0;
        } 
        guardarPos(); 
        cantidadCondiciones++;
    }
    | expresion  OP_MOQ expresion {
        insertarPolaca("CMP");
        insertarPolaca("BLT");
        if(hayOr)
        {
            insertarPolacaEnPosicion(pedirPos(), posActual +1);
            hayOr=0;
        } 
        guardarPos(); 
        cantidadCondiciones++;
    }
    | expresion OP_EQQ expresion
    {
        insertarPolaca("CMP");
        insertarPolaca("BNE");
        if(hayOr)
        {
            insertarPolacaEnPosicion(pedirPos(), posActual +1);
            hayOr=0;
        } 
        guardarPos(); 
        cantidadCondiciones++;
    } 
    |expresion OP_DIFF expresion
    {
        insertarPolaca("CMP");
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
    expresion OP_LESS expresion
    {
        insertarPolaca("CMP");
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
    expresion OP_MORE expresion
    {
        insertarPolaca("CMP");
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
        $<tipo_str>$ = $1;
        strcpy(vecAux, $1);
        insertarPolaca(vecAux);
    }
    | CONST_INT  {
        $<tipo_int>$ = $1;
        insertarPolacaInt($<tipo_int>$);
    }
    | CONST_REAL {
        $<tipo_double>$ = $1;
        insertarPolacaDouble($<tipo_double>$);
    }	 
    | CONST_STR {
        strcpy(vecAux, $1);
        insertarPolaca(vecAux);
    }
    | PARENTESIS expresion END_PARENTESIS
    | CONTAR PARENTESIS
    {
        insertarPolaca("0");
        insertarPolaca("@cont");
        insertarPolaca("=");
    } expresion
    {
        insertarPolaca("@valorAEvaluar");
        insertarPolaca("=");
    } PUNTO_Y_COMA CORCHETE lista END_CORCHETE END_PARENTESIS
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
        cantid=0;
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
        if(!existeID(vecAux)) 
        {
            sprintf(mensajes, "%s%s%s", "Error: Variable no declarada '", vecAux, "'");
            yyerror(mensajes, @1.first_line, @1.first_column, @1.last_column);
        }
        insertarPolaca(vecAux);
        insertarPolaca("GET");}
	| PUT ID {
        strcpy(vecAux, $2);
        if(!existeID(vecAux)) 
        {
            sprintf(mensajes, "%s%s%s", "Error: Variable no declarada '", vecAux, "'");
            yyerror(mensajes, @1.first_line, @1.first_column, @1.last_column);
        }
        insertarPolaca(vecAux);
        insertarPolaca("PUT");}
	| PUT CONST_STR {
        strcpy(vecAux, $2);
        insertarPolaca(vecAux);
        insertarPolaca("PUT");
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
	itoa(entero, cad, 10); 
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
        itoa(celda, cad, 10);
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
}

/* Esta función está pensada para cuando desapilamos el valor
de una celda y lo debemos insertar en la polaca. */

char * insertarPolacaEnPosicion(const int posicion, const int valorCelda)
{
    //Ponele que tenemos hasta 1M celdas.
    char aux[6];
    return strcpy(vectorPolaca[posicion], itoa(valorCelda, aux, 10));
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
    insertarPolaca("@calculoAux");
    insertarPolaca("=");
    insertarPolaca("@calculoAux");
    insertarPolaca("@valorAEvaluar");
    insertarPolaca("CMP");
    insertarPolaca("BNE");
    insertarPolacaInt(posActual + 6);
    insertarPolaca("@cont");
    insertarPolaca("1");
    insertarPolaca("+");
    insertarPolaca("@cont");
    insertarPolaca("=");
}