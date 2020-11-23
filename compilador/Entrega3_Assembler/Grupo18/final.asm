include number.asm
include macros2.asm

.MODEL LARGE                  ; Modelo de mem4oria          
.386                          ; Tipo de procesador          
.STACK 200h                   ; Bytes en el stack           

.DATA

numeroF01      dd             ?              ; Variable float
numeroI01      dd             ?              ; Variable int 
_12            dd             12.0           ; Constante int
_90_6          dd             90.6           ; Constante float
palabra                            db             "prueba", '$', 6 dup (?); Constante string
S_prueba3_2                        db             "prueba3", '$', 7 dup (?); Constante string
@cont          dd             ?              ; Variable para almacenar el resultado de contar
@valorAEvaluar dd             ?              ; Variable para almacenar el primer parametro de contar
@calculoAux    dd             ?              ; Variable para almacenar cada valor de la lista de expresiones de contar
@ifI           dd             ?              ; Variable para condición izquierda
@ifD           dd             ?              ; Variable para condición derecha

.CODE

inicio:

mov AX,@DATA                  ; Inicializa el segmento de datos
mov DS,AX                     
mov ES,AX                     

fld numeroI01
fstp palabra 

displayString S_prueba3_2
NEWLINE

mov AX,4C00h                  ; Indica que debe finalizar la ejecución
int 21h

END inicio