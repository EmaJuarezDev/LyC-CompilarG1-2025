%{
/*Usa Lexico_ClasePractica*/
/*Solo expresiones sin ()*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "funcionesEspeciales.h"
int yystopparser = 0;
extern FILE *yyin;
char *yytext;

    int yyerror();
    int yylex();

//Primitivas de la PI:
char* insertarPolInv(char*);
void avanzar();
int desapilarPos();
void apilarPos(int);
void insertarPosPI(int, int);
char* quitarCom(char*);
void intercambiarUltPos();
void negarCom();
int pilaVac(); 
void generarPolInv();

//Variables auxiliares:
char vectorPolInv[1000][53];
int pilaPolInv[50];
char cadenaAux[5];
int posicionAct = 0, topePil = -1, posicion = -1;
%}

%union {
    char* str; 
}

%start compOkey

/*TIPOS DE DATO*/
%token <str> CTEENTERO
%token CTENUMEROCONCOMA
%token <str> CTETIPOCADENITA
%token INT
%token FLOAT
%token STRING

/*DECLARACION DE VARIABLES*/
%token <str> ID
%type <str> texto
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
%token ENDIF
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
    generarPolInv();};

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
    | comparacion OP_AND comparacion {printf("\tSintactico: Condicion doble. \n");}
    | comparacion {negarCom();} OP_OR comparacion {printf("\tSintactico: Condicion doble. \n");
        intercambiarUltPos();
        posicion = desapilarPos();
        insertarPosPI(posicionAct, posicion);}
    | OP_NOT comparacion {printf("\tSintactico: Condicion doble. \n");
        {negarCom();}};

comparacion:
    factor COMP_MAYOR factor {printf("\tSintactico: Comparacion mayor. \n");
        insertarPolInv("CMP");
        insertarPolInv("BLE");
        apilarPos(posicionAct);
        avanzar();}
    | factor COMP_MENOR factor {printf("\tSintactico: Comparacion menor. \n");
        insertarPolInv("CMP");
        insertarPolInv("BGE");
        apilarPos(posicionAct);
        avanzar();}
    | factor COMP_MAYORIGUAL factor {printf("\tSintactico: Comparacion mayor o igual. \n");
        insertarPolInv("CMP");
        insertarPolInv("BLT");
        apilarPos(posicionAct);
        avanzar();}
    | factor COMP_MENORIGUAL factor {printf("\tSintactico: Comparacion menor o igual. \n");
        insertarPolInv("CMP");
        insertarPolInv("BGT");
        apilarPos(posicionAct);
        avanzar();}
    | factor COMP_IGUAL factor {printf("\tSintactico: Comparacion igual. \n");
        insertarPolInv("CMP");
        insertarPolInv("BNE");
        apilarPos(posicionAct);
        avanzar();}
    | factor COMP_DIST factor {printf("\tSintactico: Comparacion distinto. \n");
        insertarPolInv("CMP");
        insertarPolInv("BEQ");
        apilarPos(posicionAct);
        avanzar();};

sentenciaAsignacion:
    ID OP_AS expresion {printf("\tSintactico: Asignacion. \n");
        insertarPolInv($1);
        insertarPolInv(":=");}
    | ID OP_AS texto {printf("\tSintactico: Asignacion de texto. \n");
        insertarPolInv($1);
        insertarPolInv(":=");};

texto:
    CTETIPOCADENITA {printf("\tSintactico: CTECADENITA es texto. \n");
        insertarPolInv(quitarCom(yytext));};

expresion:
    termino
    | expresion OP_RES termino {printf("\tSintactico: Expresion de resta. \n");
        insertarPolInv("-");}
    | expresion OP_SUM termino {printf("\tSintactico: Expresion de suma. \n");
        insertarPolInv("+");};

termino:
    factor
    | termino OP_DIV factor {printf("\tSintactico: Termino de division. \n");
        insertarPolInv("/");}
    | termino OP_MUL factor {printf("\tSintactico: Termino de multiplicacion. \n");
        insertarPolInv("*");};

factor:
    ID {printf("\tSintactico: ID es factor. \n");
        insertarPolInv(yytext);}
    | CTEENTERO {printf("\tSintactico: CTEENTERO es factor. \n");
        insertarPolInv(yytext);}
    | CTENUMEROCONCOMA {printf("\tSintactico: CTECONCOMA es factor. \n");
        insertarPolInv(yytext);}
    | PA expresion PC {printf("\tSintactico: Expresion es factor. \n");};

sentenciaIf:
    IF PA condicion PC LA bloque LC {printf("\tSintactico: If. \n");
        posicion = desapilarPos();
        insertarPosPI(posicionAct, posicion);
        if(!pilaVac()) {
            posicion = desapilarPos();
            insertarPosPI(posicionAct, posicion);
        }}
    | IF PA condicion PC LA bloque LC ELSE {insertarPolInv("BI");
        posicion = desapilarPos();
        insertarPosPI(posicionAct + 1, posicion);
        apilarPos(posicionAct);
        avanzar();} 
    LA bloque LC {printf("\tSintactico: If y else. \n");
        posicion = desapilarPos();
        insertarPosPI(posicionAct, posicion);};

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
    READ PA ID PC {printf("\tSintactico: Read. \n");
        insertarPolInv($3);
        insertarPolInv("READ");};

sentenciaWrite:
    WRITE PA ID PC {printf("\tSintactico: Write de variable. \n");
        insertarPolInv($3);
        insertarPolInv("WRITE");};
    | WRITE PA texto PC {printf("\tSintactico: Write de texto. \n");
        insertarPolInv("WRITE");};

sentenciaWhile:
    WHILE {apilarPos(posicionAct); insertarPolInv("ET");}
        PA condicion PC LA bloque LC {printf("\tSintactico: While. \n");
            insertarPolInv("BI");
            posicion = desapilarPos();
            insertarPosPI(posicionAct + 1, posicion);
            posicion = desapilarPos();
            insertarPolInv(itoa(posicion, cadenaAux, 10));};         

sentenciaSlice:
    ID OP_AS SLICEANDCONCAT PA listaParametros PC {printf("\tSintactico: Slice and concat. \n");};

listaParametros:
    CTEENTERO COMA CTEENTERO COMA CTETIPOCADENITA COMA CTETIPOCADENITA COMA FALSO {
            printf("\tSintactico: Lista de parametros Slice and concat. \n");
            insertarPolInv($1);
            insertarPolInv("@ini");
            insertarPolInv(":=");
            insertarPolInv($3);
            insertarPolInv("@fin");
            insertarPolInv(":=");
            insertarPolInv("@ini");
            insertarPolInv("@fin");
            insertarPolInv("CMP");
            insertarPolInv("BGT");
            apilarPos(posicionAct);
            avanzar();
            //Inicio de rama verdadera del if(@ord == 1)
            insertarPolInv($5);
            insertarPolInv("@pal1");
            insertarPolInv(":=");
            insertarPolInv($7);
            insertarPolInv("@pal2");
            insertarPolInv(":=");
            //Fin de rama verdadera del if(@ord == 1)
            //El siguiente código sólo existiría una vez en el programa cuando se unifiquen las dos reglas.
            insertarPolInv("@ini");
            insertarPolInv("@fin");
            insertarPolInv("-");
            insertarPolInv("@lon");
            insertarPolInv(":=");
            insertarPolInv("0");
            insertarPolInv("@pos");
            insertarPolInv(":=");
            apilarPos(posicionAct); 
            insertarPolInv("ET");
            insertarPolInv("@ini");
            insertarPolInv("@fin");
            insertarPolInv("CMP");
            insertarPolInv("BGT");
            apilarPos(posicionAct);
            avanzar();
            insertarPolInv("@pal1[@ini]");
            insertarPolInv("@tem[@pos]");
            insertarPolInv(":=");
            insertarPolInv("@pos");
            insertarPolInv("1");
            insertarPolInv("+");
            insertarPolInv("@pos");
            insertarPolInv(":=");
            insertarPolInv("@ini");
            insertarPolInv("1");
            insertarPolInv("+");
            insertarPolInv("@ini");
            insertarPolInv(":=");
            insertarPolInv("BI");
            posicion = desapilarPos();
            insertarPosPI(posicionAct + 1, posicion);
            posicion = desapilarPos();
            insertarPolInv(itoa(posicion, cadenaAux, 10));
            insertarPolInv("0");
            insertarPolInv("@pos");
            insertarPolInv(":=");
            apilarPos(posicionAct); 
            insertarPolInv("ET");
            insertarPolInv("@pal2[@pos]");
            insertarPolInv("'\\0'");
            insertarPolInv("CMP");
            insertarPolInv("BEQ");
            apilarPos(posicionAct);
            avanzar();
            insertarPolInv("@pal2[@pos]");
            insertarPolInv("@res[@pos]");
            insertarPolInv(":=");
            insertarPolInv("@pos");
            insertarPolInv("1");
            insertarPolInv("+");
            insertarPolInv("@pos");
            insertarPolInv(":=");
            insertarPolInv("BI");
            posicion = desapilarPos();
            insertarPosPI(posicionAct + 1, posicion);
            posicion = desapilarPos();
            insertarPolInv(itoa(posicion, cadenaAux, 10));
            insertarPolInv("0");
            insertarPolInv("@aux");
            insertarPolInv(":=");
            apilarPos(posicionAct); 
            insertarPolInv("ET");
            insertarPolInv("@lon");
            insertarPolInv("@aux");
            insertarPolInv("CMP");
            insertarPolInv("BLT");
            apilarPos(posicionAct);
            avanzar();
            insertarPolInv("@tem[@aux]");
            insertarPolInv("@res[@pos]");
            insertarPolInv(":=");
            insertarPolInv("@pos");
            insertarPolInv("1");
            insertarPolInv("+");
            insertarPolInv("@pos");
            insertarPolInv(":=");
            insertarPolInv("@aux");
            insertarPolInv("1");
            insertarPolInv("+");
            insertarPolInv("@aux");
            insertarPolInv(":=");
            insertarPolInv("BI");
            posicion = desapilarPos();
            insertarPosPI(posicionAct + 1, posicion);
            posicion = desapilarPos();
            insertarPolInv(itoa(posicion, cadenaAux, 10));
            insertarPolInv("'\\0'");
            insertarPolInv("@res[@pos]");
            insertarPolInv(":=");
            posicion = desapilarPos();
            insertarPosPI(posicionAct, posicion);};
    | CTEENTERO COMA CTEENTERO COMA CTETIPOCADENITA COMA CTETIPOCADENITA COMA VERDADERO {
            printf("\tSintactico: Lista de parametros Slice and concat. \n");
            insertarPolInv($1);
            insertarPolInv("@ini");
            insertarPolInv(":=");
            insertarPolInv($3);
            insertarPolInv("@fin");
            insertarPolInv(":=");
            insertarPolInv("@ini");
            insertarPolInv("@fin");
            insertarPolInv("CMP");
            insertarPolInv("BGT");
            apilarPos(posicionAct);
            avanzar();
            //Inicio de rama falsa del if(@ord == 1)
            insertarPolInv($5);
            insertarPolInv("@pal2");
            insertarPolInv(":=");
            insertarPolInv($7);
            insertarPolInv("@pal1");
            insertarPolInv(":=");
            //Fin de rama falsa del if(@ord == 1)
            //El siguiente código sólo existiría una vez en el programa cuando se unifiquen las dos reglas.
            insertarPolInv("@fin");
            insertarPolInv("@ini");
            insertarPolInv("-");
            insertarPolInv("@lon");
            insertarPolInv(":=");
            insertarPolInv("0");
            insertarPolInv("@pos");
            insertarPolInv(":=");
            apilarPos(posicionAct); 
            insertarPolInv("ET");
            insertarPolInv("@ini");
            insertarPolInv("@fin");
            insertarPolInv("CMP");
            insertarPolInv("BGT");
            apilarPos(posicionAct);
            avanzar();
            insertarPolInv("@pal1[@ini]");
            insertarPolInv("@tem[@pos]");
            insertarPolInv(":=");
            insertarPolInv("@pos");
            insertarPolInv("1");
            insertarPolInv("+");
            insertarPolInv("@pos");
            insertarPolInv(":=");
            insertarPolInv("@ini");
            insertarPolInv("1");
            insertarPolInv("+");
            insertarPolInv("@ini");
            insertarPolInv(":=");
            insertarPolInv("BI");
            posicion = desapilarPos();
            insertarPosPI(posicionAct + 1, posicion);
            posicion = desapilarPos();
            insertarPolInv(itoa(posicion, cadenaAux, 10));
            insertarPolInv("0");
            insertarPolInv("@pos");
            insertarPolInv(":=");
            apilarPos(posicionAct); 
            insertarPolInv("ET");
            insertarPolInv("@pal2[@pos]");
            insertarPolInv("'\\0'");
            insertarPolInv("CMP");
            insertarPolInv("BEQ");
            apilarPos(posicionAct);
            avanzar();
            insertarPolInv("@pal2[@pos]");
            insertarPolInv("@res[@pos]");
            insertarPolInv(":=");
            insertarPolInv("@pos");
            insertarPolInv("1");
            insertarPolInv("+");
            insertarPolInv("@pos");
            insertarPolInv(":=");
            insertarPolInv("BI");
            posicion = desapilarPos();
            insertarPosPI(posicionAct + 1, posicion);
            posicion = desapilarPos();
            insertarPolInv(itoa(posicion, cadenaAux, 10));
            insertarPolInv("0");
            insertarPolInv("@aux");
            insertarPolInv(":=");
            apilarPos(posicionAct); 
            insertarPolInv("ET");
            insertarPolInv("@lon");
            insertarPolInv("@aux");
            insertarPolInv("CMP");
            insertarPolInv("BLT");
            apilarPos(posicionAct);
            avanzar();
            insertarPolInv("@tem[@aux]");
            insertarPolInv("@res[@pos]");
            insertarPolInv(":=");
            insertarPolInv("@pos");
            insertarPolInv("1");
            insertarPolInv("+");
            insertarPolInv("@pos");
            insertarPolInv(":=");
            insertarPolInv("@aux");
            insertarPolInv("1");
            insertarPolInv("+");
            insertarPolInv("@aux");
            insertarPolInv(":=");
            insertarPolInv("BI");
            posicion = desapilarPos();
            insertarPosPI(posicionAct + 1, posicion);
            posicion = desapilarPos();
            insertarPolInv(itoa(posicion, cadenaAux, 10));
            insertarPolInv("'\\0'");
            insertarPolInv("@res[@pos]");
            insertarPolInv(":=");
            posicion = desapilarPos();
            insertarPosPI(posicionAct, posicion);};

sentenciaReorder:
    REORDER PA listaParametrosReorder PC {printf("\tSintactico: Reorder. \n");}

listaParametrosReorder:
    CA listaExpresiones CC COMA VERDADERO COMA CTEENTERO {printf("\tSintactico:Lista de parametros Reorder. \n");
        insertarPolInv($7);
        insertarPolInv("@piv");
        insertarPolInv(":=");
        insertarPolInv("@piv");
        insertarPolInv("@can");
        insertarPolInv("CMP");
        insertarPolInv("BGE");
        apilarPos(posicionAct);
        avanzar();
        //Inicio de rama verdadera del if (@dir == 1)
        insertarPolInv("0");
        insertarPolInv("@ori");
        insertarPolInv(":=");
        insertarPolInv("@piv");
        insertarPolInv("@des");
        insertarPolInv(":=");
        //Fin de rama verdadera del if (@dir == 1)
        //El siguiente código sólo existiría una vez en el programa cuando se unifiquen las dos reglas.
        apilarPos(posicionAct);
        insertarPolInv("ET");
        insertarPolInv("@ori");
        insertarPolInv("@des");
        insertarPolInv("CMP");
        insertarPolInv("BGE");
        apilarPos(posicionAct);
        avanzar();
        insertarPolInv("@lis[@ori]");
        insertarPolInv("@aux");
        insertarPolInv(":=");
        insertarPolInv("@lis[@des]");
        insertarPolInv("@lis[@ori]");
        insertarPolInv(":=");
        insertarPolInv("@aux");
        insertarPolInv("@lis[@des]");
        insertarPolInv(":=");
        insertarPolInv("@ori");
        insertarPolInv("1");
        insertarPolInv("+");
        insertarPolInv("@ori");
        insertarPolInv(":=");
        insertarPolInv("@des");
        insertarPolInv("1");
        insertarPolInv("-");
        insertarPolInv("@des");
        insertarPolInv(":=");
        insertarPolInv("BI");
        posicion = desapilarPos();
        insertarPosPI(posicionAct + 1, posicion);
        posicion = desapilarPos();
        insertarPolInv(itoa(posicion, cadenaAux, 10));
        posicion = desapilarPos();
        insertarPosPI(posicionAct, posicion);}
    | CA listaExpresiones CC COMA FALSO COMA CTEENTERO {printf("\tSintactico:Lista de parametros Reorder. \n");
        insertarPolInv($7);
        insertarPolInv("@piv");
        insertarPolInv(":=");
        insertarPolInv("@piv");
        insertarPolInv("@can");
        insertarPolInv("CMP");
        insertarPolInv("BGE");
        apilarPos(posicionAct);
        avanzar();
        //Inicio de rama falsa del if (@dir == 1)
        insertarPolInv("@piv");
        insertarPolInv("@ori");
        insertarPolInv(":=");
        insertarPolInv("@can");
        insertarPolInv("1");
        insertarPolInv("-");
        insertarPolInv("@des");
        insertarPolInv(":=");
        //Fin de rama falsa del if (@dir == 1)
        //El siguiente código sólo existiría una vez en el programa cuando se unifiquen las dos reglas.
        apilarPos(posicionAct);
        insertarPolInv("ET");
        insertarPolInv("@ori");
        insertarPolInv("@des");
        insertarPolInv("CMP");
        insertarPolInv("@BGE");
        apilarPos(posicionAct);
        avanzar();
        insertarPolInv("@lis[@ori]");
        insertarPolInv("@aux");
        insertarPolInv(":=");
        insertarPolInv("@lis[@des]");
        insertarPolInv("@lis[@ori]");
        insertarPolInv(":=");
        insertarPolInv("@aux");
        insertarPolInv("@lis[@des]");
        insertarPolInv(":=");
        insertarPolInv("@ori");
        insertarPolInv("1");
        insertarPolInv("+");
        insertarPolInv("@ori");
        insertarPolInv(":=");
        insertarPolInv("@des");
        insertarPolInv("1");
        insertarPolInv("-");
        insertarPolInv("@des");
        insertarPolInv(":=");
        insertarPolInv("BI");
        posicion = desapilarPos();
        insertarPosPI(posicionAct + 1, posicion);
        posicion = desapilarPos();
        insertarPolInv(itoa(posicion, cadenaAux, 10));
        posicion = desapilarPos();
        insertarPosPI(posicionAct, posicion);};

listaExpresiones:
    expresion {printf("\tSintactico: Expresion. \n");
        insertarPolInv("@lis[0]");
        insertarPolInv(":=");
        insertarPolInv("1");
        insertarPolInv("@can");
        insertarPolInv(":=");}
    | listaExpresiones COMA expresion {printf("\tSintactico: Expresiones. \n");
        insertarPolInv("@lis[@can]");
        insertarPolInv(":=");
        insertarPolInv("@can");
        insertarPolInv("1");
        insertarPolInv("+");
        insertarPolInv("@can");
        insertarPolInv(":=");};
%%

int yyerror(void)
    {
        printf("\nError Sintactico. \n");
        exit (1);
    }
     
/* Funciones de notación polaca inversa */

char* insertarPolInv(char* cadena) {
	strcpy(vectorPolInv[posicionAct], cadena);
    
    //Bucle para recorrer y mostrar la pila de la PI durante la compilación.
    /*printf("\n>>>>>", vectorPolInv[posicionAct]);
    int i;
    for (i = 0; i < posicionAct; i++)
        printf("%s - ", vectorPolInv[i]);
    printf("<<<<<\n", vectorPolInv[posicionAct]);*/

	posicionAct++;
	return cadena;
}

void avanzar() {
	posicionAct++;
}

void apilarPos(int numero) {
	topePil++;
	pilaPolInv[topePil] = numero;
}

void intercambiarUltPos() {
    printf("ULT: %d, ANT: %d", pilaPolInv[topePil], pilaPolInv[topePil - 1]);
    int aux = pilaPolInv[topePil];
    pilaPolInv[topePil] = pilaPolInv[topePil - 1];
    pilaPolInv[topePil - 1] = aux;
    printf("ULT: %d, ANT: %d", pilaPolInv[topePil], pilaPolInv[topePil - 1]);
}

int pilaVac() {
    if(topePil > -1)
        return 0;
    return 1;
}

int desapilarPos() {
	if(topePil > -1) {
	    int retorno = pilaPolInv[topePil];
	    topePil--;
	    return retorno;
	}
	return -1;
}

void insertarPosPI(int numero, int posicion) {
	char cadena[20];
	char aux[30];
	itoa(numero, cadena, 10);
	sprintf(aux, "%s", cadena);
    strcpy(vectorPolInv[posicion], aux);
}

char* quitarCom(char* cte) {
    int longitud = (strlen(cte) - 2);
    strncpy(cte, cte + 1, longitud);
    cte[longitud] = '\0';
    return cte;
}

void negarCom() {
	char comparador[5];
	strcpy(comparador, vectorPolInv[posicionAct - 2]);

	if(strcmp(comparador, "BGE") == 0) {
		strcpy(vectorPolInv[posicionAct - 2], "BLT");
		return;
	}

	if(strcmp(comparador, "BLT") == 0) {
		strcpy(vectorPolInv[posicionAct - 2], "BGE");
		return;
	}

	if(strcmp(comparador, "BLE") == 0) {
		strcpy(vectorPolInv[posicionAct - 2], "BGT");
		return;
	}

	if(strcmp(comparador, "BGT") == 0) {
		strcpy(vectorPolInv[posicionAct - 2], "BLE");
		return;
	}

	if(strcmp(comparador, "BEQ") == 0) {
		strcpy(vectorPolInv[posicionAct - 2], "BNE");
		return;
	}

	if(strcmp(comparador, "BNE") == 0) {
		strcpy(vectorPolInv[posicionAct - 2], "BEQ");
		return;
	}
}

void generarPolInv() {
    FILE *fp = fopen("intermediate-code.txt", "w+t");
    fprintf(fp, "|----|---------------------------------------------------|\n");
    int i;
    for (i = 0; i < posicionAct; i++) {
        fprintf(fp, "|%-*d|%*s|\r", 4, i, 51, vectorPolInv[i]);
        fprintf(fp, "|----|---------------------------------------------------|\n");
    }
}