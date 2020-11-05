"C:\Users\mdilorenzo\Documents\Universidad\LyC\Instalables\FLEX-y-Bison\Flex\bin\flex.exe" "Lexico.l"
"C:\Users\mdilorenzo\Documents\Universidad\LyC\Instalables\FLEX-y-Bison\Bison\bin\bison.exe" -dyv Sintactico.y
gcc.exe lex.yy.c y.tab.c -o compilador
./compilador prueba.txt

rm lex.yy.c
rm y.tab.c
rm y.output
rm y.tab.h
rm compilador
