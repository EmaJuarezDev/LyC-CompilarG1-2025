:: Script para windows
flex Lexico.l
bison -dyv Sintactico.y

gcc main.c tablaDeSimbolos.c funcionesEspeciales.c lex.yy.c y.tab.c -o lexer

.\lexer .\ejemplos.\reorder.txt
