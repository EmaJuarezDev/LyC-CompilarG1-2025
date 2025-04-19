:: Script para windows

bison -dyv Sintactico.y
flex Lexico.l
gcc y.tab.c lex.yy.c tablaDeSimbolos.c -o lexer
.\lexer .\ejemplos.\while.txt
