#!bin/bash

flex $1
gcc lex.yy.c -o compilador
./compilador $2

rm lex.yy.c
rm compilador