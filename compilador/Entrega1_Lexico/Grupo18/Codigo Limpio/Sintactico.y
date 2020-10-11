/*---- 1. Declaraciones ----*/

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"
#define YYERROR_VERBOSE 1
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
int insertarTS(const char*, const char*, const char*, int, double);
t_data* crearDatos(const char*, const char*, const char*, int, double);
void guardarTS();
t_tabla tablaTS;

char idvec[50][50];
int cantid = 0, i=0, cant_aux=0;
char vecAux[50];
char* punt;
char pos[2];
char* separador1;
char nombre[50];
char tipo_dato[50];

int j=0;

/* --- Validaciones --- */
int existeID(const char*);
int esNumero(const char*,char*);
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
%token LISTA_CONTAR



/*---- 3. Definición de reglas gramaticales ----*/

%%

PROGRAMA:
{
    printf("\tInicia el COMPILADOR\n");
} 
algoritmo
{
	{ guardarTS(); printf("\nCompilacion OK.\n");} 
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
    |  asignacion {printf("\tInicio Declaracion :\n");} 

    ;

asignacion: 
    ID OP_ASIG_CONS FLOAT 
    | ID OP_ASIG_CONS CONST_STR
    |  ID OP_ASIG_CONS CONST_INT {$<tipo_int>$ = $3; printf("\t\tAsignado entero: %d\n", $<tipo_int>$);}
    ;

asignacion: 
		ID OP_ASIG expresion {printf("Fin asignacion.\n");

                                                strcpy(vecAux, $1); /*en $1 esta el valor de ID*/
                                                punt = strtok(vecAux," +-*/[](){}:=,\n"); /*porque puede venir de cualquier lado, pero ver si funciona solo con el =*/
                                                if(!existeID(punt)) /*No existe: entonces no esta declarada*/
                                                {
                                                    sprintf(mensajes, "%s%s%s", "Error: no se declaro la variable '", punt, "'");
                                                    yyerror(mensajes, @1.first_line, @1.first_column, @1.last_column);
                                                }
                                            
                                                
                                            }
        ;

ciclo:
     WHILE {printf("Comienzo de ciclo While.\n");} PARENTESIS condicion END_PARENTESIS LLAVE bloque END_LLAVE {printf("Fin de ciclo While.\n");} 
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
    | termino COMA factor

    ;

factor:
    ID           {$<tipo_str>$ = $1; printf("\t\tAsignado ID: %s\n", $<tipo_str>$);}
    | CONST_INT {$<tipo_int>$ = $1; printf("\t\tAsignado entero: %d\n", $<tipo_int>$);}
    | CONST_REAL	{$<tipo_double>$ = $1; printf("\t\tAsignado Real: %f\n", $<tipo_double>$);}	 
    | CONST_STR
    | PARENTESIS expresion END_PARENTESIS {printf("\t\t(expresion)\n");}
    | CONTAR PARENTESIS expresion PUNTO_Y_COMA CORCHETE expresion END_CORCHETE END_PARENTESIS {printf("\tcontar()\n");}
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
                                                for(i=0;i<cant_aux;i++) /*vamos agregando todos los ids que leyo*/
                                                {
                                                    separador1 = strtok(idvec[i],";");
                                                    strcpy(nombre,separador1);
                                                    separador1 = strtok(NULL, ";");


                                                   if(insertarTS(nombre, separador1, "", 0, 0) != 0) //no lo guarda porque ya existe
                                                    {
                                                        sprintf(mensajes, "%s%s%s", "Error: la variable '", idvec[i], "' ya fue declarada");
                                                        yyerror(mensajes, @3.first_line, @3.first_column, @3.last_column);
                                                    }
                                                }
                                                cantid=0;
                                            
        printf("\tFin de la declaracion multiple\n");
    }
    ;

est_variables:
    OP_LESS lista_variables OP_MORE;

lista_variables:
    ID {                strcpy(vecAux, $1); /*tomamos el nombre de la variable*/
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
    INTEGER {           strcat(idvec[cantid-1],";");
                        strcat(idvec[cantid-1],"INTEGER");
                        cantid--;}
    | FLOAT {
                        strcat(idvec[cantid-1],";");
                        strcat(idvec[cantid-1],"FLOAT");
                        cantid--;}
    | CONST_STR;

est_tipos:
    OP_LESS lista_tipos OP_MORE;


seleccion:
    	IF PARENTESIS condicion END_PARENTESIS LLAVE bloque END_LLAVE
		| IF PARENTESIS condicion END_PARENTESIS LLAVE bloque END_LLAVE ELSE {printf("Comienzo Else.\n");} END_LLAVE bloque END_LLAVE {printf("Fin Else.\n");}
        | IF PARENTESIS condicion END_PARENTESIS sentencia {printf("if sin llave.\n");}
        ;


entrada_salida:
	GET {
        printf("\t\tGET: "); 
    } ID    {printf("%s\n", yylval.tipo_str);}
	| PUT {
        printf("\t\tPUT: ");
    } ID {printf("%s\n", yylval.tipo_str);}
	| PUT {
        printf("\t\tPUT: ");
    } CONST_STR {printf("%s\n", yylval.tipo_str);}
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
        crearTablaTS();//tablaTS.primero = NULL;
        yyparse();
        fclose(yyin);
        system("Pause"); /*Esta pausa la puse para ver lo que hace via mensajes*/
        return 0;
    }
}

int insertarTS(const char *nombre,const char *tipo, const char* valString, int valInt, double valDouble)
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
    data = crearDatos(nombre, tipo, valString, valInt, valDouble);

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


t_data* crearDatos(const char *nombre, const char *tipo, const char* valString, int valInt, double valDouble)
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

    //Es una variable
    if(strcmp(tipo, "STRING")==0 || strcmp(tipo, "INTEGER")==0 || strcmp(tipo, "FLOAT")==0)
    {

        //al nombre lo dejo aca porque no lleva _
        data->nombre = (char*)malloc(sizeof(char) * (strlen(nombre) + 1));
        strcpy(data->nombre, nombre);
        return data;
    }
    else
    { 

         //Son constantes: tenemos que agregarlos a la tabla con "_" al comienzo del nombre, hay que agregarle el valor
        if(strcmp(tipo, "CONST_STR") == 0)
        {
            data->valor.valor_str = (char*)malloc(sizeof(char) * strlen(valString) +1);
            data->nombre = (char*)malloc(sizeof(char) * (strlen(valString) + 1));
            strcat(full, valString);
            strcpy(data->nombre, full);    
            strcpy(data->valor.valor_str, valString);

        }
        if(strcmp(tipo, "CONST_REAL") == 0)
        {
            sprintf(aux, "%g", valDouble);
            strcat(full, aux);
            data->nombre = (char*)malloc(sizeof(char) * strlen(full));

            strcpy(data->nombre, full);
            data->valor.valor_double = valDouble;
        }
        if(strcmp(tipo, "CONST_INT") == 0)
        {
            sprintf(aux, "%d", valInt);
            strcat(full, aux);
            data->nombre = (char*)malloc(sizeof(char) * strlen(full));
            strcpy(data->nombre, full);
            data->valor.valor_int = valInt;
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
            sprintf(linea, "%-50s%-25s%-50s%-d\n", aux->data.nombre, aux->data.tipo, "--", strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "CONST_INT") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50d%-d\n", aux->data.nombre, aux->data.tipo, aux->data.valor.valor_int, strlen(aux->data.nombre) -1);
        }
        else if(strcmp(aux->data.tipo, "FLOAT") ==0)
        {
            sprintf(linea, "%-50s%-25s%-50s%-d\n", aux->data.nombre, aux->data.tipo, "--", strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "CONST_REAL") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50g%-d\n", aux->data.nombre, aux->data.tipo, aux->data.valor.valor_double, strlen(aux->data.nombre) -1);
        }
        else if(strcmp(aux->data.tipo, "STRING") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50s%-d\n", aux->data.nombre, aux->data.tipo, "--", strlen(aux->data.nombre));
        }
        else if(strcmp(aux->data.tipo, "CONST_STR") == 0)
        {
            sprintf(linea, "%-50s%-25s%-50s%-d\n", aux->data.nombre, aux->data.tipo, aux->data.valor.valor_str, strlen(aux->data.nombre) -1);
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