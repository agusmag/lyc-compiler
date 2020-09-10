/* Decalring two counters one for number  
of lines other for number of characters */
%{ 
    int no_of_lines = 0; 
    int no_of_chars = 0; 

    int show_results(void);
    void print_char(char []);
%}
  

%% 
\n      { ++no_of_lines; print_char(yytext);  }
.       { ++no_of_chars; print_char(yytext);  }
end     { show_results(); }
%% 
  
/*** User code section***/
int yywrap(){} 

int main(int argc, char **argv) { 
    if ((yyin = fopen(argv[1], "rt")) == NULL) {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    } else {
        yylex();
    }
    
    fclose(yyin);
    return 0;
}

int show_results(void) {
    printf("\nNumero de caracteres: %d\nNumero de lineas: %d\n", no_of_chars, no_of_lines);
    return 0;
}

void print_char(char str[]) {
    printf("%s", str);
}