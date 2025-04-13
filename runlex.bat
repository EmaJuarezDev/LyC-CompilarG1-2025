:: Script para windows
flex Lexico.l
gcc lex.yy.c -o lexer

./lexer ./ejemplos./assignments.txt