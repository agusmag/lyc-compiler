flex Lexico.l
bison -dyv Sintactico.y
gcc lex.yy.c y.tab.c -o Segunda
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h