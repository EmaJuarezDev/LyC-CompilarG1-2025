/*Usa Lexico_ClasePractica*/
/*Solo expresiones sin ()*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "funcionesEspeciales.h"
#define TAM_NOMBRE 50
//int yystopparser = 0;
//extern FILE *yyin;
char *yytext;


  int yyerror();
  int yylex();

char* insertar(char*);
void avanzar();
void apilar(char*);
char* desapilar();
void generarPolacaInversa();

char nomId[TAM_NOMBRE];
char vecPolaca[500][50];
int pilaPolaca[50];
int pilaWhile[50];
char pilaMult[500][50];
char cadAux[50];
int posActual=0,tope=-1,topeW=-1,topeMult=-1;
char* ptr;
char *ptrMult;
char *ptrCadMult;
char auxBet[50],cadMult[50],msg[100];
int vecTipo[10];
int indtipo=0;
int posAnt, pos2Ant;
int posWhile=0;

%}

%union {
    char* str; // Asignación de tipo semántico char* al token ID, para utilizarlo como parámetro de strcpy o de insertar.
        // Si no, sería de tipo YYSTYPE (el tipo de los valores semánticos en Bison) según la IA.
        // Agregado también código en la declaración del token de la línea 59 y en la acción léxica del ID (línea 150 del archivo Léxico).
}

%start compOkey

/*TIPOS DE DATO*/
%token CTEENTERO
%token CTENUMEROCONCOMA
%token CTETIPOCADENITA
%token INT
%token FLOAT
%token STRING

/*DECLARACION DE VARIABLES*/
%token <str> ID // Agregada la línea.
/*%type <str> texto*/
%token INICIARVARIABLE
%token DOSPUNTITOS
%token COMA
 
/*Comillas*/
%token COMILLAS

/*Operador asignacion*/
%token OP_AS
 
/*Operadores aritmeticos*/
%token OP_SUM
%token OP_MUL
%token OP_RES
%token OP_DIV
 
/*Operadores comparacion*/
%token COMP_MAYOR
%token COMP_MENOR
%token COMP_IGUAL
%token COMP_DIST
%token COMP_MAYORIGUAL
%token COMP_MENORIGUAL
 
/*Operadores logicos*/
%token OP_AND
%token OP_OR
%token OP_NOT
 
/*BLOQUES*/
%token PA
%token PC
%token CA
%token CC
%token LA
%token LC
 
/*Funciones base*/
%token WHILE
%token IF
%token ELSE
%token READ
%token WRITE
%token FALSO
%token VERDADERO
 
/*Funciones adicionales*/
%token REORDER
%token SLICEANDCONCAT

%%
compOkey:
    programa {printf("\tSintactico: Compilacion OK. \n");
    generarPolacaInversa();};

programa:
    sentenciaInit bloque {printf("\tSintactico: Programa. \n");}

bloque:
    sentencia {printf("\tSintactico: Bloque. \n");}
    | bloque sentencia {printf("\tSintactico: Bloque. \n");}

sentencia:
    sentenciaAsignacion {printf("\tSintactico: Sentencia de asignacion. \n");}
    | sentenciaIf {printf("\tSintactico: Sentencia If. \n");}
    | sentenciaRead {printf("\tSintactico: Sentencia Read. \n");}
    | sentenciaWrite {printf("\tSintactico: Sentencia Write. \n");}
    | sentenciaWhile {printf("\tSintactico: Sentencia While. \n");}
    | sentenciaSlice {printf("\tSintactico: Sentencia Slice. \n");}
    | sentenciaReorder {printf("\tSintactico: Sentencia Reorder. \n");};

condicion:
    comparacion {printf("\tSintactico: Condicion simple. \n");}
    | comparacion opLogico comparacion {printf("\tSintactico: Condicion doble. \n");};

opLogico:
    OP_AND {printf("\tSintactico: Operador Y. \n");}
    | OP_OR {printf("\tSintactico: Operador O. \n");};

comparacion:
    factor opComparacion factor {printf("\tSintactico: Comparacion. \n");}
    | not factor opComparacion factor {printf("\tSintactico: Comparacion negada. \n");};

not:
    OP_NOT {printf("\tSintactico: Operador NO. \n");};

opComparacion:
    COMP_MAYOR {printf("\tSintactico: Comparador mayor. \n");}
    | COMP_MENOR {printf("\tSintactico: Comparador menor. \n");}
    | COMP_MAYORIGUAL {printf("\tSintactico: Comparador mayor o igual. \n");}
    | COMP_MENORIGUAL {printf("\tSintactico: Comparador menor o igual. \n");}
    | COMP_IGUAL {printf("\tSintactico: Comparador igual. \n");}
    | COMP_DIST {printf("\tSintactico: Comparador distinto. \n");};

sentenciaAsignacion:
    ID OP_AS {strcpy(nomId, $1);} expresion {printf("\tSintactico: Asignacion. \n");
        insertar(nomId);
        insertar(":=");}
    | ID OP_AS texto {printf("\tSintactico: Asignacion de texto. \n");
        insertar(nomId);
        insertar(":=");};

texto:
    CTETIPOCADENITA {printf("\tSintactico: CTECADENITA es texto. \n");};

expresion:
    termino
    | expresion OP_RES termino {printf("\tSintactico: Expresion de resta. \n");
        insertar("MENOS");}
    | expresion OP_SUM termino {printf("\tSintactico: Expresion de suma. \n");
        insertar("MAS");};

termino:
    factor
    | termino OP_DIV factor {printf("\tSintactico: Termino de division. \n");
        insertar("DIVIDIR");}
    | termino OP_MUL factor {printf("\tSintactico: Termino de multiplicacion. \n");
        insertar("POR");};

factor:
    ID {printf("\tSintactico: ID es factor. \n");
        insertar(yytext);}
    | CTEENTERO {printf("\tSintactico: CTEENTERO es factor. \n");
        insertar(yytext);}
    | CTENUMEROCONCOMA {printf("\tSintactico: CTECONCOMA es factor. \n");
        insertar(yytext);}
    | PA expresion PC {printf("\tSintactico: Expresion es factor. \n");};
 
sentenciaIf:
    IF PA condicion PC LA bloque LC {printf("\tSintactico: If. \n");}
    | IF PA condicion PC LA bloque LC ELSE LA bloque LC {printf("\tSintactico: If y else. \n");};
    
sentenciaInit:
    INICIARVARIABLE LA listaIniVar LC {printf("\tSintactico: Declaracion de variables. \n");};

listaIniVar:
    iniVar {printf("\tSintactico: Una linea de tipo. \n");}
    | listaIniVar iniVar {printf("\tSintactico: Mas de una linea de tipo. \n");};

iniVar:
    variablesSeguidas DOSPUNTITOS tipo {printf("\tSintactico: Declaracion de tipo. \n");};

variablesSeguidas:
    ID {printf("\tSintactico: Una variable. \n");}
    | variablesSeguidas COMA ID {printf("\tSintactico: Mas de una variable. \n");};

tipo:
    INT {printf("\tSintactico: Tipo entero. \n");}
    | FLOAT {printf("\tSintactico: Tipo flotante. \n");}
    | STRING {printf("\tSintactico: Tipo String. \n");};
 
sentenciaRead:
    READ PA ID PC {printf("\tSintactico: Read. \n");};

sentenciaWrite:
    WRITE PA ID PC {printf("\tSintactico: Write de variable. \n");}
    | WRITE PA texto PC {printf("\tSintactico: Write de texto. \n");};
 
sentenciaWhile:
    WHILE PA condicion PC LA bloque LC {printf("\tSintactico: While. \n");};

sentenciaSlice:
    ID OP_AS SLICEANDCONCAT PA listaParametros PC {printf("\tSintactico: Slice and concat. \n");};

listaParametros:
    CTEENTERO COMA CTEENTERO COMA CTETIPOCADENITA COMA CTETIPOCADENITA COMA FALSO
        {printf("\tSintactico: Lista de parametros Slice and concat. \n");} |
    CTEENTERO COMA CTEENTERO COMA CTETIPOCADENITA COMA CTETIPOCADENITA COMA VERDADERO 
        {printf("\tSintactico: Lista de parametros Slice and concat. \n");};

sentenciaReorder:
    REORDER PA listaParametrosReorder PC {printf("\tSintactico: Reorder. \n");}

listaParametrosReorder:
     CA listaExpresiones CC COMA VERDADERO COMA CTEENTERO
        {printf("\tSintactico:Lista de parametros Reorder. \n");} |
    CA listaExpresiones CC COMA FALSO COMA CTEENTERO
        {printf("\tSintactico:Lista de parametros Reorder. \n");};

listaExpresiones:
    expresion {printf("\tSintactico: Expresion. \n");}
    | listaExpresiones COMA expresion {printf("\tSintactico: Expresiones. \n");};
%%

int yyerror(void)
    {
        printf("\nError Sintactico. \n");
        exit (1);
    }
     
/* Funciones de notación polaca inversa */

char* insertar(char* cadena) {
	strcpy(vecPolaca[posActual], cadena);
	posActual++;
	return cadena;
}

void avanzar() {
	posActual++;
}

void apilar(char* cadena) {
	topeMult++; 
	strcpy(pilaMult[topeMult], cadena);
}

char* desapilar() {
	strcpy(cadMult, pilaMult[topeMult]);
	ptrCadMult = cadMult;
	return ptrCadMult;
}

void generarPolacaInversa() {
    FILE  *fp = fopen("intermediate-code.txt", "w+t");
    printf("Archivo. \n");
    int i;
        for (i=0; i<posActual; i++) {
        fprintf(fp, "pos: %d, valor: %s \r\n", i, vecPolaca[i]);
        }
}