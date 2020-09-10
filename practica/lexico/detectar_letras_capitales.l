/*** Definition Section has one variable 
which can be accessed inside yylex()  
and main() ***/
%{
    #include <stdio.h>
    #include <stdlib.h>
    FILE *yyin;
    int yylval;
    char *yyltext;

    int count = 0; 
%}

%%

[A-Z] { printf("%s capital letter\n", yytext); 
       count++; } 
.     { printf("%s not a capital letter\n", yytext); } 
\n    { return 0; }

%%
  
/*** Code Section prints the number of 
capital letter present in the given input***/
int yywrap(){} 

int main(int argc,char *argv[]){ 
    if ((yyin = fopen(argv[1], "rt")) == NULL) {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    } else {
        yylex(); 
        printf("\nNumber of Captial letters " 
            "in the given input: %d\n", count); 
    }
    
    fclose(yyin);
    return 0;
} 