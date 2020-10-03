#!bin/bash

flex $1
bison -dyv $2
gcc lex.yy.c y.tab.c -o compilador
./compilador $3

rm lex.yy.c
rm y.tab.c
rm y.output
rm y.tab.h
rm compilador
