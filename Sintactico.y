// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

#include "funcionesEspeciales.h"

/*int yystopparser=0;*/
/*extern FILE  *yyin;*/

  int yyerror();
  int yylex();


%}

%start programa

/*TIPO DE DATOS*/
%token CTEENTERO
%token CTENUMEROCONCOMA
%token CTETIPOCADENITA

%token INT
%token FLOAT
%token STRING

/* DECLARACION DE VARIABLES*/
%token ID
%token INICIARVARIABLE
%token DOSPUNTITOS
%token COMA
 
/*Comentarios */
%token INICHISME
%token FINCHISME
%token CHISMECITO
/*Comillas*/
%token COMILLAS
/*Operador asignacion */
%token OP_AS
 
/*Operadores Aritmeticos */
%token OP_SUM
%token OP_MUL
%token OP_RES
%token OP_DIV
 
/*Operadorees Comparacion */
%token COMP_MAYOR
%token COMP_MENOR
%token COMP_IGUAL
%token COMP_DIST
%token COMP_MAYORIGUAL
%token COMP_MENORIGUAL
 
/*Operadores Logicos */
%token OP_AND
%token OP_OR
%token OP_NOT
 
/*BLOQUES */
%token PA
%token PC
%token CA
%token CC
%token LA
%token LC
 
/*Funciones base */
%token WHILE
%token IF
%token ELSE
%token READ
%token WRITE
 
/*Funciones adicionales */
%token REORDER
%token SLICEANDCONCAT

%%

programa:
    listaInstrucciones
listaInstrucciones:
    instruccion
    | listaInstrucciones instruccion
instruccion:
    sentencia
sentencia:
    sentenciaAsignacion
    | sentenciaAritmetica
    | sentenciaIf
    | sentenciaCadenita
    | sentenciaComentarios
    | sentenciaInit
    | sentenciaRead
    | sentenciaNot
    | sentenciaWrite
    | sentenciaWhile
    | sentenciaSlice

sentenciaAsignacion:
    asignacion {printf(" FIN\n");} ;
asignacion:
    ID OP_AS factorOtexto
factorOtexto:
    factor
    | texto
texto:
    CTETIPOCADENITA {printf(" CTECADENITA es texto\n");};
factor:
    ID {printf(" ID es Factor \n");}
    | CTEENTERO {printf("    CTEENTERO es Factor\n");}
    | CTENUMEROCONCOMA {printf(" CTECONCOMA es Factor\n");};
 
sentenciaAritmetica:
    cuentaAritmetica {printf(" FIN\n");} ;
cuentaAritmetica:
    ID OP_AS factor opArismetico factor
opArismetico:
    OP_MUL {printf(" POR es OpArismetico\n");}
    | OP_SUM {printf(" MAS es OpArismetico\n");}
    | OP_RES {printf(" MENOS es OpArismetico\n");}
    | OP_DIV {printf(" DIVIDIR es OpArismetico\n");};
 
sentenciaIf:
    si {printf(" FIN\n");} ;
si:
    IF PA expresion PC LA bloque LC
    | IF PA expresion PC LA bloque LC ELSE LA bloque LC
expresion:
    expresion opLogico expresion
    | factor opComparacion factor
    | texto opComparacion texto
opLogico:
    OP_AND
    | OP_OR
bloque:
    listaInstrucciones

opComparacion:
    COMP_MAYOR {printf(" COMP_MAYOR es opComparacion\n");}
    | COMP_MENOR {printf(" COMP_MENOR es opComparacion\n");}
    | COMP_IGUAL {printf(" COMP_IGUAL es opComparacion\n");}
    | COMP_DIST {printf(" COMP_DIST es opComparacion\n");}
    | COMP_MAYORIGUAL {printf(" COMP_MAYORIGUAL es opComparacion\n");}
    | COMP_MENORIGUAL {printf(" COMP_MENORIGUAL es opComparacion\n");};
 
sentenciaCadenita:
    cadenita {printf(" FIN\n");} ;
cadenita: COMILLAS texto COMILLAS
 
sentenciaComentarios:
    comentarios {printf(" FIN\n");} ;
comentarios:
    CHISMECITO
 
sentenciaInit:
    init {printf(" FIN\n");} ;
init:
    INICIARVARIABLE LA listaIniVar LC
listaIniVar:
    iniVar
    | listaIniVar iniVar
iniVar:
    variablesSeguidas DOSPUNTITOS tipos
variablesSeguidas:
    ID
    | variablesSeguidas COMA ID
tipos:
    INT
    | FLOAT
    | STRING

sentenciaNot:
    not {printf(" FIN\n");} ;
not:
    IF PA OP_NOT expresion PC LA bloque LC
    | WHILE PA OP_NOT expresion PC LA bloque LC
 
sentenciaRead:
    read {printf(" FIN\n");} ;
read:
    READ PA ID PC
 
sentenciaWrite:
    write {printf(" FIN\n");} ;
write:
    WRITE PA factorOtexto PC
 
sentenciaWhile:
    while {printf(" FIN\n");} ;
while: WHILE PA expresion PC LA bloque LC

sentenciaSlice:
    slice {printf(" FIN\n");};
slice:
    ID OP_AS SLICEANDCONCAT PA variables PC
variables:
    parametro
    | variables COMA parametro
parametro:
    ID
    | CTEENTERO
    | CTETIPOCADENITA
%%


     
