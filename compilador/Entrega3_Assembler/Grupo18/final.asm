include number.asm
include macros2.asm

.MODEL LARGE                  ; Modelo de mem4oria          
.386                          ; Tipo de procesador          
.STACK 200h                   ; Bytes en el stack           

.DATA

nombre         dd             ?              ; Variable int 
_80            dd             80.0           ; Constante int
@ifI           dd             ?              ; Variable para condición izquierda
@ifD           dd             ?              ; Variable para condición derecha

.CODE

inicio:

mov AX,@DATA                  ; Inicializa el segmento de datos
mov DS,AX                     
mov ES,AX                     

fld nombre
displayFloat nombre
NEWLINE

mov AX,4C00h                  ; Indica que debe finalizar la ejecución
int 21h

END inicio