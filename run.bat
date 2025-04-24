:: Script para windows
flex Lexico.l
bison -dyv Sintactico.y

gcc.exe main.c tablaDeSimbolos.c funcionesEspeciales.c lex.yy.c y.tab.c -o compilador.exe

compilador.exe ejemplos\write.txt

@echo off
del compilador.exe
del lex.yy.c
del y.tab.c
del y.tab.h
del y.output

pause
