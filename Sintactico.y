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
//%token CTETIPOBOOLEANO

%token INT
%token FLOAT
%token STRING
//%token BOOLEAN

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
compOkey:
    programa {printf("\tCompilacion okey. \n");};


programa:
    sentencia {printf("\tPrograma. \n");}
    | programa sentencia {printf("\tPrograma. \n");};

sentencia:
    sentenciaAsignacion {printf("\tSentencia de asignacion. \n");}
    | sentenciaIf {printf("\tSentencia If. \n");}
    | sentenciaInit {printf("\tSentencia Init. \n");}
    | sentenciaRead {printf("\tSentencia Read. \n");}
    | sentenciaWrite {printf("\tSentencia Write. \n");}
    | sentenciaWhile {printf("\tSentencia While. \n");}
    | sentenciaSlice {printf("\tSentencia Slice. \n");}
    | sentenciaReorder {printf("\tSentencia Reorder. \n");};

condicion:
    comparacion {printf("\tCondicion simple. \n");}
    | comparacion opLogico comparacion {printf("\tCondicion. \n");};

opLogico:
    OP_AND {printf("\tOperador Y. \n");}
    | OP_OR {printf("\tOperador O. \n");};

comparacion:
    factor opComparacion factor {printf("\tComparacion. \n");}
    | not factor opComparacion factor {printf("\tComparacion negada. \n");};

not:
    OP_NOT {printf("\tOperador NO. \n");};

opComparacion:
    COMP_MAYOR {printf("\tComparador mayor. \n");}
    | COMP_MENOR {printf("\tComparador menor. \n");};

sentenciaAsignacion:
    ID OP_AS expresion {printf("\tAsignacion. \n");}
    | ID OP_AS texto {printf("\tAsignacion de texto. \n");};

texto:
    CTETIPOCADENITA {printf("\tCTECADENITA es texto. \n");};

expresion:
    termino
    | expresion OP_RES termino {printf("\tExpresion de resta. \n");}
    | expresion OP_SUM termino {printf("\tExpresion de suma. \n");};

termino:
    factor
    | termino OP_DIV factor {printf("\tTermino de division. \n");}
    | termino OP_MUL factor {printf("\tTermino de multiplicacion. \n");};

factor:
    ID {printf("\tID es factor. \n");}
    | CTEENTERO {printf("\tCTEENTERO es factor. \n");}
    | CTENUMEROCONCOMA {printf("\tCTECONCOMA es factor. \n");}
    | PA expresion PC {printf("\tExpresion es factor. \n");};
    //| CTEBOOLEANO {printf("\tCTEBOOLEANO es factor. \n");}
 
sentenciaIf:
    IF PA condicion PC LA sentencia LC {printf("\tIf. \n");}
    | IF PA condicion PC LA sentencia LC ELSE LA programa LC {printf("\tIf y else. \n");};

sentenciaInit:
    INICIARVARIABLE LA listaIniVar LC {printf("\tDeclaracion de variables. \n");};

listaIniVar:
    iniVar
    | listaIniVar iniVar;

iniVar:
    variablesSeguidas DOSPUNTITOS tipo;
    /*| iniVar variablesSeguidas DOSPUNTITOS tipo;*/

variablesSeguidas:
    ID
    | variablesSeguidas COMA ID;

variable:
    ID;

tipo:
    INT
    | FLOAT
    | STRING;
 
sentenciaRead:
    READ PA ID PC {printf("\tRead. \n");};

sentenciaWrite:
    WRITE PA ID PC {printf("\tWrite de variable. \n");}
    | WRITE PA texto PC {printf("\tWrite de texto. \n");};
 
sentenciaWhile:
    WHILE PA condicion PC LA programa LC {printf("\tWhile. \n");};

sentenciaSlice:
    ID OP_AS SLICEANDCONCAT PA listaParametros PC {printf("\tSlice and concat. \n");};

listaParametros:
    parametroSlice COMA parametroSlice COMA parametroSlice COMA parametroSlice COMA parametroSlice;

parametroSlice:
    CTEENTERO {printf("\tCTEENTERO es parametro. \n");}
    | CTETIPOCADENITA {printf("\tCTECADENITA es parametro. \n");};
    //| CTEBOOLEANO {printf("\tCTEBOOLEANO es parametro. \n");}

/*sentenciaSlice:
    slice {printf("\tFIN\n");};
slice:
    ID OP_AS SLICEANDCONCAT PA variables PC
variables:
    parametro
    | variables COMA parametro
parametro:
    ID
    | CTEENTERO
    | CTETIPOCADENITA*/

sentenciaReorder:
    REORDER PA listaParametrosReorder PC {printf("\tReorder. \n");};

listaParametrosReorder:
     CA listaExpresiones CC COMA parametroReorder COMA parametroReorder;

listaExpresiones:
    expresion
    | listaExpresiones COMA expresion;

parametroReorder:
    CTEENTERO {printf("\tCTEENTERO es parametro. \n");};
    //| CTEBOOLEANO {printf("\tCTEBOOLEANO es parametro. \n");}

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
     
