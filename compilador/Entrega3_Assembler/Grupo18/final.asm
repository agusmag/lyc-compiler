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
_float_1       dd             2.5            ; Constante float
_92            dd             92.0           ; Constante int
_1             dd             1.0            ; Constante int
_float_2       dd             0.342          ; Constante float
_256           dd             256.0          ; Constante int
_52            dd             52.0           ; Constante int
_4             dd             4.0            ; Constante int
S_La_suma_es____3                  db             "La suma es: ", '$', 12 dup (?); Constante string
_2             dd             2.0            ; Constante int
S_actual_es___que_2_y____de_0__4   db             "actual es > que 2 y != de 0", '$', 27 dup (?); Constante string
S_no_es_mayor_que_2__5             db             "no es mayor que 2", '$', 17 dup (?); Constante string
@cont          dd             0              ; Variable para almacenar el resultado de contar
@1             dd             1              ; constante para sumar a @cont la cantidad 
@valorAEvaluar dd             ?              ; Variable para almacenar el primer parametro de contar
@calculoAux    dd             ?              ; Variable para almacenar cada valor de la lista de expresiones de contar
@ifI           dd             ?              ; Variable para condición izquierda
@ifD           dd             ?              ; Variable para condición derecha

.CODE

inicio:

mov AX,@DATA                  ; Inicializa el segmento de datos
mov DS,AX                     
mov ES,AX                     

displayString S_Prueba_txt_LyC_Tema_4___1
NEWLINE
displayString S_Ingrese_un_valor_float____2
NEWLINE
GetFloat actual
NEWLINE
fld _0
fstp contador

fld _float_1
fld nombre
fadd
fstp suma

branch17:

fld contador
fstp @ifI

fld _92
fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
ja branch104

fld contador
fld _1
fadd
fstp contador

fld contador
fld _float_2
fdiv
fld contador
fld actual
fld contador
fmul
fstp @ValorAEvaluar
fld _256
fstp @CalculoAux
fstp @ifI

fld @ValorAEvaluar
fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
jne branch51

fld @cont
fld @1
fadd
fstp @cont
branch51:

fld nombre
fld suma
fmul
fstp @CalculoAux
fstp @ifI

fld @ValorAEvaluar
fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
jne branch66

fld @cont
fld @1
fadd
fstp @cont
branch66:

fld _52
fstp @CalculoAux
fstp @ifI

fld @ValorAEvaluar
fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
jne branch79

fld @cont
fld @1
fadd
fstp @cont
branch79:

fld _4
fstp @CalculoAux
fstp @ifI

fld @ValorAEvaluar
fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
jne branch92

fld @cont
fld @1
fadd
fstp @cont
fmul
fadd
fstp actual

fld suma
fld actual
fadd
fstp suma

jmp branch17

branch104:

displayString S_La_suma_es____3
NEWLINE
displayFloat suma,2
NEWLINE
fld actual
fstp @ifI

fld _2
fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
jbe branch122

fld actual
fstp @ifI

fld _0
fstp @ifD

fld @ifI
fld @ifD
fxch
fcom
fstsw AX
sahf
je branch122

displayString S_actual_es___que_2_y____de_0__4
NEWLINE
jmp branch129

branch122:

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
jae branch129

displayString S_no_es_mayor_que_2__5
NEWLINE
branch129:


mov AX,4C00h                  ; Indica que debe finalizar la ejecución
int 21h

END inicio