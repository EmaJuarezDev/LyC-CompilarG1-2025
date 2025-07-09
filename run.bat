:: Script para windows
flex Lexico.l
bison -dyv Sintactico.y

gcc.exe main.c tablaDeSimbolos.c lex.yy.c y.tab.c -o lyc-compiler-3.0.0.exe

lyc-compiler-3.0.0.exe test.txt

::tasm final.asm tlink final.obj

@echo off
::del final.exe
::del final.obj
::del final.asm
del lyc-compiler-3.0.0.exe
del lex.yy.c
del y.tab.c
del y.tab.h
del y.output

pause
