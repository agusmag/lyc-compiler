include number.asm
include macros2.asm

.MODEL LARGE                  ; Modelo de mem4oria          
.386                          ; Tipo de procesador          
.STACK 200h                   ; Bytes en el stack           

.DATA

suma           dd             ?              ; Variable float
actual         dd             ?              ; Variable float
promedio       dd             ?              ; Variable float
contador       dd             ?              ; Variable int 
nombre         dd             80.0           ; Constante con nombre int
S_Prueba_txt_LyC_Tema_4___1        db             "Prueba.txt LyC Tema 4!", '$', 22 dup (?); Constante string
S_Ingrese_un_valor_float____2      db             "Ingrese un valor float: ", '$', 24 dup (?); Constante string
_0             dd             0.0            ; Constante int
_2_5           dd             2.5            ; Constante float
_92            dd             92.0           ; Constante int
_1             dd             1.0            ; Constante int
_0_342         dd             0.342          ; Constante float
_256           dd             256.0          ; Constante int
_52            dd             52.0           ; Constante int
_4             dd             4.0            ; Constante int
S_La_suma_es____3                  db             "La suma es: ", '$', 12 dup (?); Constante string
_2             dd             2.0            ; Constante int
S_actual_es___que_2_y____de_0__4   db             "actual es > que 2 y != de 0", '$', 27 dup (?); Constante string
S_no_es_mayor_que_2__5             db             "no es mayor que 2", '$', 17 dup (?); Constante string
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

fstp nombre

displayString S_Prueba_txt_LyC_Tema_4___1
NEWLINE
displayString S_Ingrese_un_valor_float____2
NEWLINE
getString actual
NEWLINE
fld contador
fld nombre
fadd
branch17:

fld contador
fstp @ifI

fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
jae branch107

fld contador
fadd
fld contador
fld contador
fdiv
fld contador
fld 0
fstp =

fmul
fadd
fld actual
fld actual
fadd
jmp branch17

branch107:

displayString S_La_suma_es____3
NEWLINE
displayFloat suma
NEWLINE
fld actual
fstp @ifI

fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
jbe branch125

fld actual
fstp @ifI

fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
je branch125

displayString S_actual_es___que_2_y____de_0__4
NEWLINE
jmp branch132

branch125:

fld actual
fstp @ifI

fld nombre
fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
jae branch132

displayString S_no_es_mayor_que_2__5
NEWLINE
branch132:


mov AX,4C00h                  ; Indica que debe finalizar la ejecución
int 21h

END inicio