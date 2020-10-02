%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

#define TAM_PILA 100
#define TODO_OK 1
#define ERROR 0
#define EXISTE 1
#define NO_EXISTE 0
#define PILA_IF 0
#define PILA_DECLARACION 1
#define PILA_WHILE 2
#define PILA_ASIGNACION 3
#define PILA_REPEAT 4
#define PILA_BETWEEN 5
#define TRUE 1
#define FALSE 0

//DECLARACION FUNCIONES
int yyerror();
int yylex();
int yyparse();

void finAnormal(char *, char * );
void validarDeclaracionTipoDato(char *);
int insertarEnListaAsig(char *);
void debugListaAsignacion();
int insertarEnListaDeclaracion(char *);
int verificarExistencia(char* );
char * valorComparacionCICLO(char * ); // utilizado en repeat

// TABLA DE SIMBOLOS
struct struct_tablaSimbolos
{
	char nombre[100];
	char tipo[100];
	char valor[50];
	char longitud[100];
};

int puntero_ts = 0;
struct struct_tablaSimbolos tablaSimbolos[10000];
int insertar_TS(char*, char*);
char * recuperarTipoTS(char* );
int crearArchivoTS();
void debugTS();
char * recuperarValorTS(char* );

int crearArchivoIntermedia();
char * aux;
char valorFactor[5],valorTermino[5],valorElemento[5];
double sumTermino = 0;
double sumElemento = 0;

int cont = 0;
int iPosCondDos;
int insertarEnLista(char*);
void escribirEnLista(int, char*);
char * valorComparacion(char * );
char comparador_usado[2];

// PILAS 
char * pilaIF[TAM_PILA];			// pila 0
char * pilaWhile[TAM_PILA];			// pila 1
char * pilaAsignacion[TAM_PILA];	// pila 3
char * pilaRepeat[TAM_PILA];		// pila 4
char * pilaBetween[TAM_PILA];		// pila 5
int tope_pila_if=0;				    // pila 0
int tope_pila_while=0;			    // pila 1
int tope_pila_asignacion=0;		    // pila 3
int tope_pila_repeat=0;			    // pila 4
int tope_pila_between=0;			// pila 5
void apilar(int nroPila, char * val);
int desapilar(int nroPila);
int pilaVacia(int tope);
int pilaLlena(int tope);
void debugPila(int nroPila, int tope);

// LISTAS
char * listaDeclaracion[100];	// lista para declaraciones
char * listaTokens[10000];		// lista de tokens para gci polaca inversa
char * listaAux[100];		// lista de tokens para gci polaca inversa
char * listaAsignacion[30];	// lista para acumular la asignacion multiple
int puntero_declaracion = 0;
int puntero_asignacion = 0;
int puntero_tokens=1; // arranca en uno para comparar en notepad++
int puntero_aux=0;

// DECLARACION DE VARIABLES - FUNCIONES
void debugListaDeclaracion();
int flagWHILE = FALSE;
int flagIFOR = FALSE;
int flagIFAND = FALSE;
int flagWHILEOR = FALSE;
int flagWHILEAND = FALSE;
int flagELSE = FALSE;
int flagPrimero = FALSE; // para identificar los token en asign multiple
int flagREPEAT = FALSE;
int flagAsigMul = FALSE;

//DECLARACION VARIABLES
char posAuxA[5], posAuxB[5]; // posicion auxiliar para pivotear con la condicion OR
char posTrue[5], posFalse[5],posCondDos[5];
char inicioCuerpoRepeat[5];
char * auxTipoAsignacion;
char * inicioWhilePos;
//int posTrue, posFalse, posCondDos;
int pos_actual=0;
int yystopparser=0;
int iniExpre, finExpre;

FILE *yyin;
FILE *fIntermedia; //ARCHIVO CON INTERMEDIA

%}

%token COMENTARIO_SIMPLE
%token CONST_STR        
%token CONST_INT        
%token CONST_REAL       
%token END_LINE         
%token OP_ASIG          
%token OP_ASIG_CONS     
%token OP_SUM           
%token OP_MUL           
%token OP_RES           
%token OP_DIV           
%token OP_LEQ           
%token OP_MOQ           
%token OP_EQQ           
%token OP_DIFF          
%token OP_LESS          
%token OP_MORE          
%token OP_AND           
%token OP_OR            
%token LLAVE            
%token END_LLAVE        
%token PARENTESIS       
%token END_PARENTESIS   
%token CAR_CA           
%token CAR_CC           
%token COMA             
%token COMILLA_SIMPLE   
%token CONST            
%token DIM              
%token AS               
%token FLOAT            
%token INTEGER          
%token STRING           
%token IF               
%token ELSE             
%token FOR	            
%token TO               
%token DO               
%token WHILE            
%token IN               
%token REPEAT           
%token UNTIL            
%token PUT              
%token GET              
%token ID               

%%

// ---------------------------------------------------------------

programa:
	{
        printf("\tInicia el COMPILADOR\n");
    } algoritmo {
		printf("\tFin COMPILADOR ok\n"); 
		if(crearArchivoIntermedia()==TODO_OK) {
			printf("\nArchivo con intermedia generado\n");
			generarASM();
		} else {
			printf("Hubo un error al generar el archivo de intermedia");
		}
	};

est_declaracion:
	DIM {
        printf("\t\Inicio declaracion multiple\n");
    } est_variables AS est_tipos {
        printf("\tFin de la declaracion multiple\n");
    }
    ;

est_variables:
    OP_LESS lista_variables OP_MORE

lista_variables:
    ID
    | ID COMA lista_variables

est_tipos:
    OP_LESS lista_variables OP_MORE

lista_tipos:
    tipo
    | tipo COMA lista_tipos

tipo:
    INTEGER
    | FLOAT
    | STRING

est_asignacion:
	CONST {
        printf("\t\tInicio Declaracion CONST\n");
    } asignacion {
        printf("\tFin Declaracion CONST\n");
    }
    ;

asignacion: 
    ID OP_ASIG_CONS REAL {
        validarDeclaracionTipoDato("REAL");
    }; 
    | ID OP_ASIG_CONS STRING {
        validarDeclaracionTipoDato("STRING");
    }
    | ID OP_ASIG_CONS INTEGER {
        validarDeclaracionTipoDato("INTEGER");
    }
    ;
	 
algoritmo: 
    {
        printf("COMIENZO de BLOQUES\n");
    } bloque
    ;

bloque:
    bloque sentencia
    | sentencia
    ;

sentencia:
    ciclo
    | est_declaracion
    | seleccion  
    | asignacion
    | entrada_salida
    ;

//While
ciclo:
     WHILE
	 { 
		 free(inicioWhilePos);
		 inicioWhilePos = (char *) malloc(sizeof(char) * (sizeof(int) + 1));
		 sprintf(inicioWhilePos,"%d",puntero_tokens);
		
		 flagWHILE = TRUE; 
		 printf("WHILE\n");
	 
	 } PARENTESIS  condicion END_PARENTESIS LLAVE bloque endw_

endw_: END_LLAVE {
			int x, i, iPosActual;
			char wPosActual[5], wPosActualTrue[5], wPosCondDos[5];
			// debugPila(PILA_WHILE,tope_pila_while);
			insertarEnLista("BI");
			insertarEnLista(inicioWhilePos);			
			
			x=desapilar(PILA_WHILE); // Primero que desapilo -> apunta a la parte verdadera
			sprintf(wPosActualTrue, "%s", posTrue);
			escribirEnLista(x,wPosActualTrue);
			
			x=desapilar(PILA_WHILE); // Segundo que desapilo -> apunta al final
			sprintf(wPosActual, "%d", puntero_tokens);
			escribirEnLista(x,wPosActual);
			//debugPila(PILA_WHILE,tope_pila_while);
			
			if(flagWHILEAND == TRUE){
				if(pilaVacia(tope_pila_while) == FALSE){
					
					x=desapilar(PILA_WHILE); // Tercero que desapilo -> apunta a la segunda condicion
					sprintf(wPosCondDos, "%s", posCondDos);
					escribirEnLista(x,wPosCondDos);
					
					x=desapilar(PILA_WHILE); // Cuarto que desapilo -> apunta al final
					sprintf(wPosActual, "%d", puntero_tokens);
					escribirEnLista(x,wPosActual);
				}
			} else if (flagWHILEOR == TRUE) {
				
				if(pilaVacia(tope_pila_while) == FALSE){
					
					x=desapilar(PILA_WHILE);// Tercero que desapilo -> apunta a la parte verdadera
					sprintf(wPosActualTrue, "%s", posTrue);
					escribirEnLista(x,wPosActualTrue);
					
					x=desapilar(PILA_WHILE);// Tercero que desapilo -> apunta a la segunda condicion
					sprintf(wPosCondDos, "%s", posCondDos);
					escribirEnLista(x,wPosCondDos);
				}			
				
			}
			flagWHILEOR = FALSE;
			flagWHILEAND = FALSE;
			flagWHILE = FALSE;

		}

asignacion: 
		ID OP_ASIG expresion {
			finExpre = puntero_tokens;
			int i,j,limit;
			char sAux[5];
			sprintf(sAux,yylval.str_val);
			
			if(flagAsigMul == TRUE) {
				printf("\n\n ASIGNACION MULTIPLE \n\n");
				insertarEnLista(":");
							
				limit = puntero_asignacion;
				
				for (i=0; i < limit;i++) {
					insertarEnLista(listaAsignacion[i]);
					printf("\n\n INICIO EXPRESION: %d - FIN EXPRESION %d \n\n",iniExpre,finExpre);
					for(j=iniExpre ; j<finExpre; j++){
						printf("Entre en el For \n");
						insertarEnLista(listaTokens[j]);
					}
					insertarEnLista(":");
				}
			} else {
				insertarEnLista(":=");	
			}

			puntero_asignacion = 0;	// reset
			
			flagAsigMul = FALSE;
			printf("FIN LINEA ASIGNACION\n");
		}
        ;

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

//If
seleccion:
    	IF PARENTESIS condicion END_PARENTESIS start_if_ bloque { 
				char sPosActual[5];
				insertarEnLista("BI");
				insertarEnLista("###");
				sprintf(sPosActual, "%d", puntero_tokens-1);
				apilar(PILA_IF,sPosActual);	
			}
			END_LLAVE {
				int x, i, iPosActual;
				char sPosActual[5], sPosActualTrue[5], sPosActualFalse[5], sPosCondDos[5];
				
				x=desapilar(PILA_IF); // Primero que desapilo -> apunta a la posicion actual
				sprintf(sPosActual, "%d", puntero_tokens);
				escribirEnLista(x,sPosActual);
				
				x=desapilar(PILA_IF);// Segundo que desapilo -> apunta a la parte verdadera
				sprintf(sPosActualTrue, "%s", posTrue);
				escribirEnLista(x,sPosActualTrue);
				
				x=desapilar(PILA_IF); // Tercero que desapilo -> apunta al final
				sprintf(sPosActual, "%d", puntero_tokens);
				escribirEnLista(x,sPosActual);
				
				if(flagIFOR == TRUE){
					x=desapilar(PILA_IF); // Cuarto que desapilo -> apunta a la parte verdadera
					escribirEnLista(x,sPosActualTrue);
					
					x=desapilar(PILA_IF); // Quinto que desapilo -> apunta a la segunda condicion
					sprintf(sPosCondDos, "%s", posCondDos);
					escribirEnLista(x,sPosCondDos);
					
				} else if (flagIFAND == TRUE){
					x=desapilar(PILA_IF); // Cuarto que desapilo -> apunta a la segunda condicion
					sprintf(sPosCondDos, "%s", posCondDos);
					escribirEnLista(x,sPosCondDos);
					
					x=desapilar(PILA_IF);// Quinto que desapilo -> apunta a la parte falsa
					escribirEnLista(x,sPosActualFalse);
				} else {
					// NO HAGO NADA - IF DE CONDICION SIMPLE	
				}
				
				flagIFAND = FALSE;
				flagIFOR = FALSE;
				
				sprintf(sPosActual, "-1");
				sprintf(posCondDos, "-1");
				sprintf(posFalse, "-1");
				sprintf(posTrue, "-1");
				
				printf("FIN DEL IF\n"); 
		}
		| IF PARENTESIS condicion END_PARENTESIS start_if_ bloque { 
				char sPosActual[5];
				insertarEnLista("BI");
				insertarEnLista("###");
				sprintf(sPosActual, "%d", puntero_tokens-1);
				apilar(PILA_IF,sPosActual);
			} 
			END_LLAVE else_ LLAVE bloque END_LLAVE {
				int x, i, iPosActual;
				char sPosActual[5], sPosActualTrue[5], sPosActualFalse[5], sPosCondDos[5];
				
				x=desapilar(PILA_IF); // Primero que desapilo -> apunta a la posicion actual
				sprintf(sPosActual, "%d", puntero_tokens);
				escribirEnLista(x,sPosActual);
				
				x=desapilar(PILA_IF); // Segundo que desapilo -> apunta a la parte verdadera
				sprintf(sPosActualTrue, "%s", posTrue);
				escribirEnLista(x,sPosActualTrue);
				
				x=desapilar(PILA_IF); // Tercero que desapilo -> apunta a la parte falsa
				sprintf(sPosActualFalse, "%s", posFalse);
				escribirEnLista(x,sPosActualFalse);
				
				if(flagIFOR == TRUE){
					x=desapilar(PILA_IF); // Cuarto que desapilo -> apunta a la parte verdadera
					sprintf(sPosActualTrue, "%s", posTrue);
					escribirEnLista(x,sPosActualTrue);
					
					x=desapilar(PILA_IF); // Quinto que desapilo -> apunta a la segunda condicion
					sprintf(sPosCondDos, "%s", posCondDos);
					escribirEnLista(x,sPosCondDos);
					
				} else if (flagIFAND == TRUE){
					x=desapilar(PILA_IF); // Cuarto que desapilo -> apunta a la segunda condicion
					sprintf(sPosCondDos, "%s", posCondDos);
					escribirEnLista(x,sPosCondDos);
					
					x=desapilar(PILA_IF); // Quinto que desapilo -> apunta a la parte falsa
					sprintf(sPosActualFalse, "%s", posFalse);
					escribirEnLista(x,sPosActualFalse);
				}
				
				flagIFAND = FALSE;
				flagIFOR = FALSE;
				sprintf(sPosActual, "-1");
				sprintf(posCondDos, "-1");
				sprintf(posFalse, "-1");
				sprintf(posTrue, "-1");
				
			    printf("FIN DEL IF CON ELSE\n");
		}	
;

start_if_: LLAVE {
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

    sprintf(posTrue, "%d", puntero_tokens); // guardo la posicion del true	
}
;

else_: ELSE {
    sprintf(posFalse, "%d", puntero_tokens); /*guardo la posicion del false*/ 
}
;

condicion:
    comparacion {
        if( flagWHILE == TRUE ) { //Manejo del While
            insertarEnLista("CMP");
            insertarEnLista(valorComparacion(comparador_usado));
            char sPosActual[5];
            insertarEnLista("###");
            sprintf(sPosActual, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActual); // usado en el while
            
            char sPosActualB[5];
            insertarEnLista("BI");
            insertarEnLista("###");
            sprintf(sPosActualB, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActualB);	
            sprintf(posTrue, "%d", puntero_tokens); // guardo la posicion del true						
            
            flagWHILE = FALSE; //agregado lucas (dsp fijate mauro es para q no vuelva a entrar)
        }
			 
        if( flagREPEAT == TRUE ) {
        
            insertarEnLista("CMP");
            insertarEnLista(valorComparacion(comparador_usado));
            char sPosActual[5];
            insertarEnLista("###");
            sprintf(sPosActual, "%d", puntero_tokens-1);
            apilar(PILA_REPEAT,sPosActual); // usado en el while
            
            char sPosActualB[5];
            insertarEnLista("BI");
            insertarEnLista("###");
            sprintf(sPosActualB, "%d", puntero_tokens-1);
            apilar(PILA_WHILE,sPosActualB);	
            sprintf(posTrue, "%d", puntero_tokens); // guardo la posicion del true						
            
            flagREPEAT = FALSE;
        }
	}
    | OP_NOT comparacion {
        printf("NO ES CONDICION\n");
    }
    | comparacion op_and_ {
            sprintf(posCondDos, "%d", puntero_tokens);
        }  
        comparacion { 
            if( flagWHILE == TRUE ) {
                flagWHILEAND = TRUE;
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
	| comparacion op_or_ {
         sprintf(posCondDos, "%d", puntero_tokens);
      } 
      comparacion { 
          if( flagWHILE == TRUE ) {
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
          printf("CONDICION DOBLE OR\n"); 
    }
    | OP_NOT PARENTESIS comparacion OP_AND comparacion END_PARENTESIS {
        printf("NO ES CONDICION DOBLE AND\n");
    }
    | OP_NOT PARENTESIS comparacion OP_OR comparacion END_PARENTESIS {
        printf("NO ES CONDICION DOBLE OR\n");
    }
	;

op_and_: OP_AND {	
    if( flagWHILE == TRUE ) {
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
} ;

op_or_: OP_OR {		
    if( flagWHILE == TRUE ) {
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
} ;

comparacion:
    expresion OP_COMPARACION expresion { 
            strcpy(comparador_usado,yylval.cmp_val);
    }  
    | expresion
    ;

expresion:
    expresion OP_SUM termino {
            insertarEnLista("+"); 
    }
    | expresion OP_RES termino {
            insertarEnLista("-"); 
    }
    | termino
 	;

termino: 
    termino OP_MUL factor {
            insertarEnLista("*"); 
            sumTermino = sumTermino * atof(valorFactor);
    }
    | termino OP_DIV factor {
            insertarEnLista("/"); 
            sumTermino = sumTermino / atof(valorFactor);
    }
    | factor { 
        sumTermino = 0;
        sumTermino = atof(valorFactor);
        sprintf(valorTermino,"%f",sumTermino); 
    }
    ;

factor:
    ID { 
        if(verificarExistencia(yylval.str_val) == NO_EXISTE) { 
            finAnormal("Syntax Error","Variable no declarada"); 
        } 
        insertarEnLista(yylval.str_val);
    }
    | CONST_INT {
        if(verificarExistencia(yylval.str_val) == NO_EXISTE) { 
            insertar_TS("CONST_INT",yylval.int_val);
        } 
        insertarEnLista(yylval.int_val); 
        sprintf(valorFactor,"%s",yylval.int_val);
    }
    | CONST_REAL {
        if(verificarExistencia(yylval.real_val) == NO_EXISTE)
        { 
            insertar_TS("CONST_REAL",yylval.real_val);
        } 
        insertarEnLista(yylval.real_val); 
        sprintf(valorFactor,"%s",yylval.real_val);
    }		 
    | CONST_STR {
        if(verificarExistencia(yylval.str_val) == NO_EXISTE)
        { 
            insertar_TS("CONST_STR", yylval.str_val);
        } 
        insertarEnLista(yylval.str_val); 
        sprintf(valorFactor,"%s", yylval.str_val);
    }
    | PARENTESIS expresion END_PARENTESIS
    ;

// ---------------------------------------------------------------

%%

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

void debugPila(int nroPila, int tope) {
    char * nombre;
    char * pila[TAM_PILA];
    int i;
    printf("====== DEBUG PILA ======\n\n");

    switch(nroPila) {
        case PILA_IF:
            printf("posCondDos: %s\n",posCondDos);
            printf("posTrue: %s\n",posTrue);
            printf("posFalse: %s\n",posFalse);
            printf("El tope de la pila es %d \n",tope_pila_if);
            printf("Lista de elementos: \n");
            for (i=0; i<tope_pila_if;i++){
                    printf("%d => %s\n",i,pilaIF[i]);
            }

            break;
        case PILA_WHILE:
            printf("posCondDos: %s\n",posCondDos);
            printf("posTrue: %s\n",posTrue);
            printf("posFalse: %s\n",posFalse);
            printf("El tope de la pila es %d \n",tope_pila_while);
            printf("Lista de elementos: \n");
            for (i=0; i<tope_pila_while;i++){
                    printf("%d => %s\n",i,pilaWhile[i]);
            }

            break;
        case PILA_ASIGNACION:
            printf("El tope de la pila es %d \n",tope_pila_asignacion);
            printf("Lista de elementos: \n");
            for (i=0; i<tope_pila_asignacion;i++){
                    printf("%d => %s\n",i,pilaAsignacion[i]);
            }

            break;
        case PILA_BETWEEN:
            printf("El tope de la pila es %d \n",tope_pila_between);
            printf("Lista de elementos: \n");
            for (i=0; i<tope_pila_between;i++){
                    printf("%d => %s\n",i,pilaBetween[i]);
            }

            break;
        case PILA_REPEAT:
            printf("El tope de la pila es %d \n",tope);
            printf("Lista de elementos: \n");
            for (i=0; i<tope_pila_repeat;i++){
                    printf("%d => %s\n",i,pilaRepeat[i]);
            }

            break;

        default:
                printf("Error interno: Pila no reconocida \n");
                system("Pause");
                exit(1);
                break;
    }

    printf("\n====== FIN DEBUG PILA ======\n\n");
}

int insertarEnLista(char * val) {
    // Convierto en CHAR *
    aux = (char *) malloc(sizeof(char) * (strlen(val) + 1));
    strcpy(aux, val);

    // Agrego al array de tokens
    listaTokens[puntero_tokens] = aux;
    puntero_tokens++;

    //escribo en archivo
    //fprintf(fintermedia,"%s\n",aux);

    // DEBUG por consola
    if(strcmp(aux,"###")!=0){
            printf("\tinsertar_en_polaca(%s)\n", aux);
    }
    return (puntero_tokens-1); // devuelvo posicion
}

int insertarEnListaDeclaracion(char * val) {
    // Convierto en CHAR *
    aux = (char *) malloc(sizeof(char) * (strlen(val) + 1));
    strcpy(aux, val);

    // Agrego al array de tokens
    listaDeclaracion[puntero_declaracion] = aux;
    puntero_declaracion++;

    return (puntero_declaracion-1); // devuelvo posicion
}

int insertarEnListaAsig(char * val) {
    // Convierto en CHAR *
    aux = (char *) malloc(sizeof(char) * (strlen(val) + 1));
    strcpy(aux, val);

    // Agrego al array de tokens
    listaAsignacion[puntero_asignacion] = aux;
    puntero_asignacion++;

    return (puntero_asignacion-1); // devuelvo posicion
}

void debugListaDeclaracion() {
    int i;
    printf("====== DEBUG LISTA DECLARACION ======\n\n");
    printf("La cantidad de elementos es %d \n",puntero_declaracion);
    printf("Lista de elementos: \n");
    for (i=0; i < puntero_declaracion;i++){
            printf("%d => %s\n",i,listaDeclaracion[i]);
    }

    printf("\n====== FIN DEBUG LISTA DECLARACION ======\n\n");
}

void debugListaAsignacion() {
    int i;
    printf("====== DEBUG LISTA ASIGNACION ======\n\n");
    printf("La cantidad de elementos es %d \n",puntero_asignacion);
    printf("Lista de elementos: \n");
    for (i=0; i < puntero_asignacion;i++){
            printf("%d => %s\n",i,listaAsignacion[i]);
    }

    printf("\n====== FIN DEBUG LISTA ASIGNACION ======\n\n");
}

void debugTS() {
    int i;
    printf("====== DEBUG TABLA SIMBOLOS ======\n\n");
    printf("La cantidad de elementos es %d \n",puntero_ts);
    printf("Lista de elementos: \n");
    for (i=0; i < puntero_ts;i++){
            printf("%d => %s | %s | %s | %s \n",i,tablaSimbolos[i].nombre,tablaSimbolos[i].tipo,tablaSimbolos[i].valor,tablaSimbolos[i].longitud );
    }

    printf("\n====== FIN DEBUG TABLA SIMBOLOS ======\n\n");
}

void escribirEnLista(int pos, char * val) {
    // Convierto en CHAR *
    aux = (char *) malloc(sizeof(char) * (strlen(val) + 1));
    strcpy(aux, val);

    // escribo en vector
    listaTokens[pos] = aux;

    printf("\tEscribio en %i el valor %s\n",pos,aux);
}

char * valorComparacionCICLO(char * val) {
    if(strcmp("=", val) == 0){
            return "BEQ";
    } else if(strcmp(">=", val) == 0) {
            return "BGE";
    } else if(strcmp(">", val) == 0) {
            return "BGT";
    } else if(strcmp("<=", val) == 0) {
            return "BLE";
    } else if(strcmp("<", val) == 0) {
            return "BLT";
    } else if(strcmp("><", val) == 0) {
            return "BNE";
    } else {
            // NUNCA DEBERIA CAER ACA
            return val;
    }
}

char * valorComparacion(char * val){
    if(strcmp("=", val) == 0) {
            return "BNE";
    } else if(strcmp(">=", val) == 0) {
            return "BLT";
    } else if(strcmp(">", val) == 0) {
            return "BLE";
    } else if(strcmp("<=", val) == 0) {
            return "BGT";
    } else if(strcmp("<", val) == 0) {
            return "BGE";
    } else if(strcmp("><", val) == 0) {
            return "BEQ";
    } else {
            // NUNCA DEBERIA CAER ACA
            return val;
    }
}

int yyerror() {
    printf("** FIN DEL PROGRAMA **\n\n");
    system ("Pause");
    exit (1);
}

void finAnormal(char * tipo, char * mensaje) {
    printf("[ERROR]: %s - %s\n",tipo,mensaje);
    yyerror();
}

int crearArchivoIntermedia() {
    FILE * archivo;
    int i;
    archivo = fopen("intermedia.txt", "wt");

    if (!archivo) {
        return ERROR;
    }

    for (i = 1; i < puntero_tokens; i++) {
            fprintf(archivo,"%s\n", listaTokens[i]);
            //fprintf(archivo,"CELDA %d: %s\n", i, listaTokens[i]);
    }
    fclose(archivo);

    return TODO_OK;
}

void escribirEnLista(int pos, char * val)
{
        // Convierto en CHAR *
        aux = (char *) malloc(sizeof(char) * (strlen(val) + 1));
    strcpy(aux, val);

        // escribo en vector
        listaTokens[pos] = aux;

        printf("\tEscribio en %i el valor %s\n",pos,aux);

}

void validarDeclaracionTipoDato(char * tipo) {
    int i;
    for (i=0; i < puntero_declaracion; i++) {
        //printf("Voy a verificar la existencia del elemento %s: \n",listaDeclaracion[i]);
        if(verificarExistencia(listaDeclaracion[i]) == NO_EXISTE) {
            //printf("No existe, la inserto en tabla de simbolos \n");
            insertar_TS(tipo,listaDeclaracion[i]);
            //debugListaDeclaracion();
            //debugTS();
        }
        else{
            printf("Syntax error: Variable ya declarada\n");
            system("Pause");
            exit(1);
        }
    }
    // reinicio el contador para leer otro tipo de dato
    puntero_declaracion = 0;
}

int crearArchivoIntermedia() {
    FILE * archivo;
    int i;
    archivo = fopen("intermedia.txt", "wt");

    if (!archivo){  return ERROR; }

    for (i = 1; i < puntero_tokens; i++)
    {
            fprintf(archivo,"%s\n", listaTokens[i]);
            //fprintf(archivo,"CELDA %d: %s\n", i, listaTokens[i]);
    }
    fclose(archivo);

    return TODO_OK;
}

int main(int argc, char *argv[]) {
    if ((yyin = fopen(argv[1], "rt")) == NULL) {
        printf("\nError al abrir archivo: %s\n", argv[1]);         
    } else {
        yyparse();
    }

    if(crearArchivoTS() == TODO_OK) {
        printf("Se genero el archivo de tabla de simbolos\n");
    } else {
        printf("ERROR - Syntax error\n");
        system ("Pause");
        exit(1);
    }

    fclose(yyin);
    return 0;
}
