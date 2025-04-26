/*Usa Lexico_ClasePractica*/
/*Solo expresiones sin ()*/
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

%start compOkey




/*TIPO DE DATOS*/
%token CTEENTERO
%token CTENUMEROCONCOMA
%token CTETIPOCADENITA
/*%token CTEBOOLEANO*/
%token INT
%token FLOAT
%token STRING
//%token BOOLEAN

/* DECLARACION DE VARIABLES*/
%token ID
%token INICIARVARIABLE
%token DOSPUNTITOS
%token COMA
 
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
%token FALSO
%token VERDADERO
 
/*Funciones adicionales */
%token REORDER
%token SLICEANDCONCAT

%%
compOkey:
    programa {printf("\tSintactico:Compilacion okey. \n");};


programa:
    sentencia {printf("\tSintactico:Programa. \n");}
    | programa sentencia {printf("\tSintactico:Programa. \n");};

sentencia:
    sentenciaAsignacion {printf("\tSintactico:Sentencia de asignacion. \n");}
    | sentenciaIf {printf("\tSintactico:Sentencia If. \n");}
    | sentenciaInit {printf("\tSintactico:Sentencia Init. \n");}
    | sentenciaRead {printf("\tSintactico:Sentencia Read. \n");}
    | sentenciaWrite {printf("\tSintactico:Sentencia Write. \n");}
    | sentenciaWhile {printf("\tSintactico:Sentencia While. \n");}
    | sentenciaSlice {printf("\tSintactico:Sentencia Slice. \n");}
    | sentenciaReorder {printf("\tSintactico:Sentencia Reorder. \n");};

condicion:
    comparacion {printf("\tSintactico:Condicion simple. \n");}
    | comparacion opLogico comparacion {printf("\tSintactico:Condicion. \n");};

opLogico:
    OP_AND {printf("\tSintactico:Operador Y. \n");}
    | OP_OR {printf("\tSintactico:Operador O. \n");};

comparacion:
    factor opComparacion factor {printf("\tSintactico:Comparacion. \n");}
    | not factor opComparacion factor {printf("\tSintactico:Comparacion negada. \n");};

not:
    OP_NOT {printf("\tSintactico:Operador NO. \n");};

opComparacion:
    COMP_MAYOR {printf("\tSintactico:Comparador mayor. \n");}
    | COMP_MENOR {printf("\tSintactico:Comparador menor. \n");}
    | COMP_MAYORIGUAL {printf("\tSintactico:Comparador mayor igual. \n");}
    | COMP_MENORIGUAL {printf("\tSintactico:Comparador menor igual. \n");}
    | COMP_IGUAL {printf("\tSintactico:Comparador igual. \n");}
    | COMP_DIST {printf("\tSintactico:Comparador distinto. \n");};

sentenciaAsignacion:
    ID OP_AS expresion {printf("\tSintactico:Asignacion. \n");}
    | ID OP_AS texto {printf("\tSintactico:Asignacion de texto. \n");};

texto:
    CTETIPOCADENITA {printf("\tSintactico:CTECADENITA es texto. \n");};

expresion:
    termino
    | expresion OP_RES termino {printf("\tSintactico:Expresion de resta. \n");}
    | expresion OP_SUM termino {printf("\tSintactico:Expresion de suma. \n");};

termino:
    factor
    | termino OP_DIV factor {printf("\tSintactico:Termino de division. \n");}
    | termino OP_MUL factor {printf("\tSintactico:Termino de multiplicacion. \n");};

factor:
    ID {printf("\tSintactico:ID es factor. \n");}
    | CTEENTERO {printf("\tSintactico:CTEENTERO es factor. \n");}
    | CTENUMEROCONCOMA {printf("\tSintactico:CTECONCOMA es factor. \n");}
    | PA expresion PC {printf("\tSintactico:Expresion es factor. \n");};
    //| CTEBOOLEANO {printf("\tCTEBOOLEANO es factor. \n");}
 
sentenciaIf:
    IF PA condicion PC LA programa LC {printf("\tSintactico:If. \n");}
    | IF PA condicion PC LA programa LC ELSE LA programa LC {printf("\tSintactico:If y else. \n");};
    
sentenciaInit:
    INICIARVARIABLE LA listaIniVar LC {printf("\tSintactico:Declaracion de variables. \n");};

listaIniVar:
    iniVar {printf("\tSintactico:Una linea de tipo. \n");}
    | listaIniVar iniVar {printf("\tSintactico:Varias lineas de tipo. \n");};

iniVar:
    variablesSeguidas DOSPUNTITOS tipo {printf("\tSintactico:Declaracion de tipo. \n");};

variablesSeguidas:
    ID {printf("\tSintactico:Una variable. \n");}
    | variablesSeguidas COMA ID {printf("\tSintactico:Mas de una variable. \n");};


tipo:
    INT {printf("\tSintactico:Tipo entero. \n");}
    | FLOAT {printf("\tSintactico:Tipo flotante. \n");}
    | STRING {printf("\tSintactico:Tipo string. \n");};
 
sentenciaRead:
    READ PA ID PC {printf("\tSintactico:Read. \n");};

sentenciaWrite:
    WRITE PA ID PC {printf("\tSintactico:Write de variable. \n");}
    | WRITE PA texto PC {printf("\tSintactico:Write de texto. \n");};
 
sentenciaWhile:
    WHILE PA condicion PC LA programa LC {printf("\tSintactico:While. \n");};

sentenciaSlice:
    ID OP_AS SLICEANDCONCAT PA listaParametros PC {printf("\tSintactico:Slice and concat. \n");};

listaParametros:
    CTEENTERO COMA CTEENTERO COMA CTETIPOCADENITA COMA CTETIPOCADENITA COMA FALSO
        {printf("\tSintactico:Lista de parametros del slice and concat. \n");} |
    CTEENTERO COMA CTEENTERO COMA CTETIPOCADENITA COMA CTETIPOCADENITA COMA VERDADERO 
        {printf("\tSintactico:Lista de parametros del slice and concat. \n");};

sentenciaReorder:
    REORDER PA listaParametrosReorder PC {printf("\tSintactico:Reorder. \n");}

listaParametrosReorder:
     CA listaExpresiones CC COMA VERDADERO COMA CTEENTERO
        {printf("\tSintactico:Lista de parametros de reorder. \n");} |
    CA listaExpresiones CC COMA FALSO COMA CTEENTERO
        {printf("\tSintactico:Lista de parametros de reorder. \n");};

listaExpresiones:
    expresion {printf("\tSintactico:Expresion. \n");}
    | listaExpresiones COMA expresion {printf("\tSintactico:Expresiones. \n");};


/*sentenciaReorder:
    reorder {printf("\tFIN\n");};
reorder:
    ID OP_AS REORDER PA CA listaexpresiones CC COMA CTEENTERO COMA CTEENTERO PC
listaexpresiones:
    expresion
    | listaexpresiones COMA expresion*/

%%

int yyerror(void)
    {
        printf("\nError Sintactico\n");
        exit (1);
    }
     
