#!bin/bash

flex $1
gcc lex.yy.c -o Primera
./Primera $2

rm lex.yy.c
rm Primera
