:: Script para windows
flex Lexico.l
gcc tablaDeSimbolos.c lex.yy.c -o lexer

.\lexer .\ejemplos.\assignments.txt
