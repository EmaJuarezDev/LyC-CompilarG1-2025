%{
/*Usa Lexico_ClasePractica*/
/*Solo expresiones sin ()*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "tablaDeSimbolos.h"

int yystopparser = 0;
extern FILE *yyin;
char *yytext;

    int yyerror();
    int yylex();

//Funciones de código intermedio (polaca inversa):
char* insertarPolInv(char*);
void avanzar();
int desapilarPos();
void apilarPos(int);
void insertarPosPI(int, int);
char* quitarCom(char*);
void intercambiarUltPos();
void negarCom();
int pilaVac(); 
void validarTipoDato(char*);
void eliminarTipoAct();
void generarPolInv();

//Funciones de código Assembler:
void generarAsm();
void imprimirHeader(FILE*);
void imprimirVariables(FILE*);
void generarFadd(FILE*);
void generarFmul(FILE*);
void generarFdiv(FILE*);
void generarFsub(FILE*);
void generarCmp(FILE*, char*);
void generarAsig(FILE*);
void generarWri(FILE*);
//void generarRea(FILE*);
void desapilarAsm(char*);
void apilarAsm(char*);
void agregarCerDec(char*);
void agregarCerEnt(char*);
void reemplazarPunto(char*);

//Variables auxiliares:
int posicionAct = 0, topePil = -1, posicion = -1, topeAsm = -1, cantidadVarTip, posicionIniTip, cantidadCop = 0;
char vectorPolInv[1000][53];
int pilaPolInv[50];
char cadenaAux[5];
char tipoDatoAct[8] = "SINTIPO";
char tipoVar[8];
char variablePil[20];
char topePilAsm[53];
char siguientePil[53];
char pilaASM[1000][53];
int indiceVecSal = 0;
char vecSaltos [500][50];
char textoAux[51];

//Slice and concat:
int limiteIni, limiteFin, concatenarEnPal1, longitud, posicionPal, aux;
char palabra1[51];
char palabra2[51];
char palabraAux[51];
char palabraRes[102];

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
    generarPolInv();
    generarAsm();}

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
        avanzar();
        eliminarTipoAct();}
    | factor COMP_MENOR factor {printf("\tSintactico: Comparacion menor. \n");
        insertarPolInv("CMP");
        insertarPolInv("BGE");
        apilarPos(posicionAct);
        avanzar();
        eliminarTipoAct();}
    | factor COMP_MAYORIGUAL factor {printf("\tSintactico: Comparacion mayor o igual. \n");
        insertarPolInv("CMP");
        insertarPolInv("BLT");
        apilarPos(posicionAct);
        avanzar();
        eliminarTipoAct();}
    | factor COMP_MENORIGUAL factor {printf("\tSintactico: Comparacion menor o igual. \n");
        insertarPolInv("CMP");
        insertarPolInv("BGT");
        apilarPos(posicionAct);
        avanzar();
        eliminarTipoAct();}
    | factor COMP_IGUAL factor {printf("\tSintactico: Comparacion igual. \n");
        insertarPolInv("CMP");
        insertarPolInv("BNE");
        apilarPos(posicionAct);
        avanzar();
        eliminarTipoAct();}
    | factor COMP_DIST factor {printf("\tSintactico: Comparacion distinto. \n");
        insertarPolInv("CMP");
        insertarPolInv("BEQ");
        apilarPos(posicionAct);
        avanzar();
        eliminarTipoAct();};

sentenciaAsignacion:
    ID OP_AS expresion {printf("\tSintactico: Asignacion. \n");
        insertarPolInv($1);
        insertarPolInv(":=");
        getTipoDato($1, tipoVar);
        validarTipoDato(tipoVar);
        eliminarTipoAct();}
    | ID OP_AS texto {printf("\tSintactico: Asignacion de texto. \n");
        insertarPolInv($1);
        insertarPolInv(":=");
        getTipoDato($1, tipoVar);
        validarTipoDato(tipoVar);
        eliminarTipoAct();};

texto:
    CTETIPOCADENITA {printf("\tSintactico: CTECADENITA es texto. \n");
        strcpy(textoAux, yytext);
        insertarPolInv(quitarCom(textoAux));
        agregarConstanteStr($1);
        validarTipoDato("TIPOCAD");};

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
        insertarPolInv(yytext);
        getTipoDato($1, tipoVar);
        validarTipoDato(tipoVar);}
    | CTEENTERO {printf("\tSintactico: CTEENTERO es factor. \n");
        insertarPolInv(yytext);
        agregarConstanteInt($1);
        validarTipoDato("TIPOENT");}
    | CTENUMEROCONCOMA {printf("\tSintactico: CTECONCOMA es factor. \n");
        insertarPolInv(yytext);
        agregarConstanteFlo(yytext);
        validarTipoDato("TIPONUM");}
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
    variablesSeguidas DOSPUNTITOS tipo {printf("\tSintactico: Declaracion de tipo. \n");
        agregarTipoDato(yytext, cantidadVarTip, posicionIniTip);};

variablesSeguidas:
    ID {printf("\tSintactico: Una variable. \n"); agregarVariable(yytext);
        cantidadVarTip = 1;
        posicionIniTip = getCantidadSimbolos() - 1;}
    | variablesSeguidas COMA ID {printf("\tSintactico: Mas de una variable. \n"); agregarVariable(yytext);
        cantidadVarTip++;};

tipo:
    INT {printf("\tSintactico: Tipo entero. \n");}
    | FLOAT {printf("\tSintactico: Tipo flotante. \n");}
    | STRING {printf("\tSintactico: Tipo String. \n");};
 
sentenciaRead:
    READ PA ID PC {printf("\tSintactico: Read. \n");
        insertarPolInv($3);
        insertarPolInv("READ");
        eliminarTipoAct();};

sentenciaWrite:
    WRITE PA ID PC {printf("\tSintactico: Write de variable. \n");
        insertarPolInv($3);
        insertarPolInv("WRITE");
        eliminarTipoAct();}
    | WRITE PA texto PC {printf("\tSintactico: Write de texto. \n");
        insertarPolInv("WRITE");
        eliminarTipoAct();};

sentenciaWhile:
    WHILE {apilarPos(posicionAct); insertarPolInv("ET");}
        PA condicion PC LA bloque LC {printf("\tSintactico: While. \n");
            insertarPolInv("BI");
            posicion = desapilarPos();
            insertarPosPI(posicionAct + 1, posicion);
            posicion = desapilarPos();
            insertarPolInv(itoa(posicion, cadenaAux, 10));};         

sentenciaSlice:
    ID OP_AS SLICEANDCONCAT PA listaParametros PC {printf("\tSintactico: Slice and concat. \n");
        
        if(limiteIni > limiteFin)
            printf("\tError semantico: Slice and concat. \n");

        if(concatenarEnPal1 == 1) {

            strcpy(palabraAux, palabra1);
            strcpy(palabra1, palabra2);
            strcpy(palabra2, palabraAux);
        }

        longitud = limiteFin - limiteIni;
        posicionPal = 0;

        while(limiteIni <= limiteFin) {

            palabraAux[posicionPal] = palabra1[limiteIni];
            posicionPal++;
            limiteIni++;
        }

        posicionPal = 0;

        while(palabra2[posicionPal] != '\0') {

            palabraRes[posicionPal] = palabra2[posicionPal];
            posicionPal++;
        }
        
        aux = 0;

        while(longitud >= aux) {

            palabraRes[posicionPal] = palabraAux[aux];
            posicionPal++;
            aux++;
        }

        palabraRes[posicionPal] = '\0';
        insertarPolInv(palabraRes);
        strcpy(palabraAux, "\"");
        strcat(palabraRes, palabraAux);
        strcat(palabraAux, palabraRes);
        agregarConstanteStr(palabraAux);
        insertarPolInv($1);
        insertarPolInv(":=");};

listaParametros:
    CTEENTERO COMA CTEENTERO COMA CTETIPOCADENITA COMA CTETIPOCADENITA COMA FALSO {
        printf("\tSintactico: Lista de parametros Slice and concat. \n");
        concatenarEnPal1 = 0;
        limiteIni = atoi($1);
        limiteFin = atoi($3);
        strcpy(palabra1, (quitarCom($5)));
        strcpy(palabra2, (quitarCom($7)));};
    | CTEENTERO COMA CTEENTERO COMA CTETIPOCADENITA COMA CTETIPOCADENITA COMA VERDADERO {
        printf("\tSintactico: Lista de parametros Slice and concat. \n");
        concatenarEnPal1 = 1;
        limiteIni = atoi($1);
        limiteFin = atoi($3);
        strcpy(palabra1, (quitarCom($5)));
        strcpy(palabra2, (quitarCom($7)));};

sentenciaReorder:
    REORDER PA listaParametrosReorder PC {printf("\tSintactico: Reorder. \n");}

listaParametrosReorder:
    CA listaExpresiones CC COMA VERDADERO COMA CTEENTERO {printf("\tSintactico:Lista de parametros Reorder. \n");
        insertarPolInv($7);
        agregarConstanteInt($7);
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
        insertarPolInv(":=");
        eliminarTipoAct();}
    | listaExpresiones COMA expresion {printf("\tSintactico: Expresiones. \n");
        insertarPolInv("@lis[@can]");
        insertarPolInv(":=");
        insertarPolInv("@can");
        insertarPolInv("1");
        insertarPolInv("+");
        insertarPolInv("@can");
        insertarPolInv(":=");
        eliminarTipoAct();};
%%

int yyerror(void)
    {
        printf("\nError Sintactico. \n");
        system ("Pause");
        exit (1);
    }
     
/* Funciones de notación polaca inversa */

char* insertarPolInv(char* cadena) {
	
    strncpy(vectorPolInv[posicionAct], cadena, strlen(cadena));
    vectorPolInv[posicionAct][strlen(cadena)] = '\0';

    //Bucle para recorrer y mostrar la pila de la PI durante la compilación.
    /*printf("\nContenido de la polaca inversa: ", vectorPolInv[posicionAct]);
    int i;
    for (i = 0; i < posicionAct; i++)
        printf("%s; ", vectorPolInv[i]);
    printf("%s", vectorPolInv[posicionAct]);*/

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
    int aux = pilaPolInv[topePil];
    pilaPolInv[topePil] = pilaPolInv[topePil - 1];
    pilaPolInv[topePil - 1] = aux;
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

void validarTipoDato(char* tipoDato) {
  
	  if(strcmp(tipoDatoAct, "SINTIPO") == 0) {
	    	strncpy(tipoDatoAct, tipoDato, 8);
		    return;
	  }

	  if(strcmp(tipoDatoAct, tipoDato) != 0){
		    printf("Error semantico: El tipo de dato '%s' no es compatible con '%s'. \n", tipoDatoAct, tipoDato);
		    exit(4);
	  }
}

void eliminarTipoAct() {
    strncpy(tipoDatoAct, "SINTIPO", 8);
}

void generarPolInv() {

    FILE* fCI = fopen("intermediate-code.txt", "w+t");

    fprintf(fCI, "|----|---------------------------------------------------|\n");

    int i;
   
    for (i = 0; i < posicionAct; i++) {

        fprintf(fCI, "|%-*d|%*s|\r", 4, i, 51, vectorPolInv[i]);
        fprintf(fCI, "|----|---------------------------------------------------|\n");
    }
}

/* Funciones de Assembler */

void imprimirHeader(FILE* fPun) {
	
    fprintf(fPun,"include macros2.asm\ninclude number.asm\n\n");
    fprintf(fPun,".MODEL LARGE\n.386\n.STACK 200h\n\n.DATA\n");//;MAXTEXTSIZE equ 50\n \n.DATA\n\n.DATA\n");
}

void imprimirVariables(FILE* fPun) { 

	char valor[52], nombre[52], auxNombre[52];
    char *punto;
    float aux;
	int i, j, longitud, ultimoSimbolo = getCantidadSimbolos();
    t_simbolo auxSimbolo;

	for(i = 0; i < ultimoSimbolo; i++) {

        auxSimbolo = getSimboloDeTabla(i);

		if(auxSimbolo.nombre[0] == '_') {                

            if(strcmp(auxSimbolo.tipoDato, "TIPONUM") == 0) {

                if(auxSimbolo.nombre[1] == '.') {

                    strcpy(nombre, "_cte0_");
                    strcat(nombre, auxSimbolo.nombre + 2);
                    strcpy(valor, auxSimbolo.valor);
                    aux = atof(valor);
                    fprintf(fPun,"%s\t%s\t%.4g\n", nombre, "dd", aux);
                } else if(auxSimbolo.nombre[strlen(auxSimbolo.nombre) - 1] == '.') {

                    strcpy(nombre, "_cte");
                    strcpy(auxNombre, auxSimbolo.nombre);
                    longitud = strlen(auxNombre);
                    auxNombre[longitud - 1] = '\0';
                    strcat(nombre, auxNombre + 1);
                    strcpy(auxNombre, "_0");
                    strcat(nombre, auxNombre);
                    strcpy(valor, auxSimbolo.valor);
                    aux = atof(valor);
                    fprintf(fPun,"%s\t%s\t%.1f\n", nombre, "dd", aux);
                } else {

                    strcpy(nombre, "_cte");
                    strcat(nombre, auxSimbolo.nombre + 1);
                    if(punto = strchr(nombre, '.'))
                        *punto = '_';
                    strcpy(valor, auxSimbolo.valor);
                    aux = atof(valor);
                    fprintf(fPun,"%s\t%s\t%.4g\n", nombre, "dd", aux);
                }
            } else if(strcmp(auxSimbolo.tipoDato, "TIPOENT") == 0) {

                strcpy(nombre, "_cte");
                strcat(nombre, auxSimbolo.nombre + 1);
                fprintf(fPun,"%s\t%s\t%s\n", nombre, "dd", auxSimbolo.valor);
            } else if(strcmp(auxSimbolo.tipoDato, "TIPOCAD") == 0) {
                
                strcpy(nombre, "_T");
                strcat(nombre, auxSimbolo.nombre);
                strcpy(valor, "\"");
                strcpy(auxNombre, auxSimbolo.valor);
                strcat(valor, auxNombre);
                strcpy(auxNombre, "\", '$', 3 dup(?)");
                strcat(valor, auxNombre);

                for(j = 0; j < strlen(nombre); j++) {
                    
                    if(nombre[j] == ' ')
                        nombre[j] = '_';
                }

                fprintf(fPun,"%s\t%s\t%s\n", nombre, "db", valor);
            }
        }
        else {
            if(strcmp(auxSimbolo.tipoDato, "TIPOCAD") == 0) 
                fprintf(fPun,"%s\t%s\n", auxSimbolo.nombre, "db\t51 dup('$')");
            else {

                strcpy(valor, "?");
                fprintf(fPun,"%s\t%s\t%s\n", auxSimbolo.nombre, "dd", valor);
            }
        }
    }

	//fprintf(fPun, "_@AUX dd ?\n");
	fprintf(fPun, "\n.CODE\nmain:\n"); //START:\n");
	fprintf(fPun, "MOV AX, @DATA\nMOV DS, AX\nMOV ES, AX\n\n");
}

void apilarAsm(char *cadena) {
	
    topeAsm++;
	strcpy(pilaASM[topeAsm], cadena);
}

void desapilarAsm(char *cadena) {
	
    strcpy(cadena, pilaASM[topeAsm]);
	topeAsm--;
}

void reemplazarPunto(char *numero) {

    char *punto;
    
    if(punto = strchr(numero, '.'))
        *punto = '_';
    
    return;
}

void generarFadd(FILE *fPun) {
	
    int i, variable;
    char auxTipo[8];

	desapilarAsm(topePilAsm);
	desapilarAsm(siguientePil);
	getTipoDato(siguientePil, auxTipo);
    variable = esVariable(siguientePil);

    if(strcmp(siguientePil, "@AUX") != 0) {
    
        if(variable) {

            if(strcmp(auxTipo, "TIPONUM") == 0) {

                agregarCerDec(siguientePil);
                agregarCerEnt(siguientePil);
                reemplazarPunto(siguientePil);
            }

            fprintf(fPun, "FLD _cte%s\n", siguientePil);
        }
        else
            fprintf(fPun, "FLD %s\n", siguientePil);
    }
    
    getTipoDato(topePilAsm, auxTipo);
    variable = esVariable(topePilAsm);
 
    if(variable) {

        if(strcmp(auxTipo, "TIPONUM") == 0) {

            agregarCerDec(topePilAsm);
            agregarCerEnt(topePilAsm);
            reemplazarPunto(topePilAsm);
        }

        fprintf(fPun, "FLD _cte%s\n", topePilAsm);
    }
    else
        fprintf(fPun, "FLD %s\n", topePilAsm);

	fprintf(fPun, "%s\n", "FADD");
	//fprintf(fPun, "FSTP _@AUX\n");	
	apilarAsm("@AUX");
}

void generarFmul(FILE *fPun) {

	int i, variable;
    char auxTipo[8];

	desapilarAsm(topePilAsm);
	desapilarAsm(siguientePil);
	getTipoDato(siguientePil, auxTipo);
    variable = esVariable(siguientePil);

    if(strcmp(siguientePil, "@AUX") != 0) {

        if(variable) {

            if(strcmp(auxTipo, "TIPONUM") == 0) {

                agregarCerDec(siguientePil);
                agregarCerEnt(siguientePil);
                reemplazarPunto(siguientePil);
            }

            fprintf(fPun, "FLD _cte%s\n", siguientePil);
        }
        else
            fprintf(fPun, "FLD %s\n", siguientePil);
    }

    getTipoDato(topePilAsm, auxTipo);
    variable = esVariable(topePilAsm);
 
    if(variable) {

        if(strcmp(auxTipo, "TIPONUM") == 0) {

            agregarCerDec(topePilAsm);
            agregarCerEnt(topePilAsm);
            reemplazarPunto(topePilAsm);
        }

        fprintf(fPun, "FLD _cte%s\n", topePilAsm);
    }
    else
        fprintf(fPun, "FLD %s\n", topePilAsm);

	fprintf(fPun, "%s\n", "FMUL");
	//fprintf(fPun, "FSTP _@AUX\n");	
	apilarAsm("@AUX");
}

void generarFdiv(FILE *fPun) {
	
	int i, variable;
    char auxTipo[8];

	desapilarAsm(topePilAsm);
	desapilarAsm(siguientePil);
	getTipoDato(siguientePil, auxTipo);
    variable = esVariable(siguientePil);

    if(strcmp(siguientePil, "@AUX") != 0) {
    
        if(variable) {

            if(strcmp(auxTipo, "TIPONUM") == 0) {

                agregarCerDec(siguientePil);
                agregarCerEnt(siguientePil);
                reemplazarPunto(siguientePil);
            }

            fprintf(fPun, "FLD _cte%s\n", siguientePil);
        }
        else
            fprintf(fPun, "FLD %s\n", siguientePil);
    }

    getTipoDato(topePilAsm, auxTipo);
    variable = esVariable(topePilAsm);
 
    if(variable) {

        if(strcmp(auxTipo, "TIPONUM") == 0) {

            agregarCerDec(topePilAsm);
            agregarCerEnt(topePilAsm);
            reemplazarPunto(topePilAsm);
        }

        fprintf(fPun, "FLD _cte%s\n", topePilAsm);
    }
    else
        fprintf(fPun, "FLD %s\n", topePilAsm);

	fprintf(fPun, "%s\n", "FDIV");
	//fprintf(fPun, "FSTP _@AUX\n");	
	apilarAsm("@AUX");
}

void generarCmp(FILE *fPun, char *linea) {

	int i, variable;
    char auxTipo[8];

	desapilarAsm(topePilAsm);
	desapilarAsm(siguientePil);
	getTipoDato(siguientePil, auxTipo);
    variable = esVariable(siguientePil);

    if(strcmp(siguientePil, "@AUX") != 0) {
    
        if(variable) {

            if(strcmp(auxTipo, "TIPONUM") == 0) {

                agregarCerDec(siguientePil);
                agregarCerEnt(siguientePil);
                reemplazarPunto(siguientePil);
            }

            fprintf(fPun, "FLD _cte%s\n", siguientePil);
        }
        else
            fprintf(fPun, "FLD %s\n", siguientePil);
    }
    
    getTipoDato(topePilAsm, auxTipo);
    variable = esVariable(topePilAsm);
 
    if(variable) {

        if(strcmp(auxTipo, "TIPONUM") == 0) {

            agregarCerDec(topePilAsm);
            agregarCerEnt(topePilAsm);
            reemplazarPunto(topePilAsm);
        }

        fprintf(fPun, "FLD _cte%s\n", topePilAsm);
    }
    else
        fprintf(fPun, "FLD %s\n", topePilAsm);
    
	fprintf(fPun, "FXCH\nFCOM\nFSTSW AX\nSAHF\n");	
}

void generarAsig(FILE *fPun) {

	int j, variable = 0;
    char auxTipo[8], auxNombre[51];

	desapilarAsm(topePilAsm);
	desapilarAsm(siguientePil);
	getTipoDato(siguientePil, auxTipo);
	variable = esVariable(siguientePil);

    if(strcmp(auxTipo, "TIPOCAD") == 0) {
    
        strcpy(auxNombre, siguientePil);
        
        for(j = 0; j < strlen(auxNombre); j++) {
                    
            if(auxNombre[j] == ' ')
                auxNombre[j] = '_';
        }

        fprintf(fPun, "lea SI, _T_%s\nlea DI, %s\nET_C%d:\nlodsb\n", auxNombre, topePilAsm, cantidadCop);
        fprintf(fPun, "stosb\ncmp AL, '$'\nJNE ET_C%d\nlea DX, %s\nmov AH, 09h\nint 21h\n\n", cantidadCop, topePilAsm);
        fprintf(fPun, "NEWLINE 1\n\n");
        cantidadCop++;
    }
    else if(strcmp(siguientePil, "@AUX") != 0) {
        
        if(variable) {

            if(strcmp(auxTipo, "TIPONUM") == 0) {

                agregarCerDec(siguientePil);
                agregarCerEnt(siguientePil);
                reemplazarPunto(siguientePil);
                fprintf(fPun, "FLD _cte%s\n", siguientePil);
            }
            else if(strcmp(auxTipo, "TIPOENT") == 0) 
                fprintf(fPun, "FLD _cte%s\n", siguientePil);
        }
        else
            fprintf(fPun, "FLD %s\n", siguientePil);
        
        fprintf(fPun, "FSTP %s\nDisplayFloat %s, 2\n\nNEWLINE 1\n\n", topePilAsm, topePilAsm);
    }
}	

void agregarCerEnt(char *cadena) {
	
    char aux[50];

	if(cadena[(strlen(cadena)) - 1] != '.') 
        return;
    
    strcpy(aux, "0\0");
	strcat(cadena, aux);   
}

void agregarCerDec(char *cadena) {
	
    char aux[50];

	if(*cadena != '.')
		return;

	strcpy(aux, "0");
	strcat(aux, cadena);
	strcpy(cadena, aux);
}

void generarFsub(FILE *fPun) {
	
    int i, variable;
    char auxTipo[8];

	desapilarAsm(topePilAsm);
	desapilarAsm(siguientePil);
	getTipoDato(siguientePil, auxTipo);
    variable = esVariable(siguientePil);

    if(strcmp(siguientePil, "@AUX") != 0) {

        if(variable) {

            if(strcmp(auxTipo, "TIPONUM") == 0) {

                agregarCerDec(siguientePil);
                agregarCerEnt(siguientePil);
                reemplazarPunto(siguientePil);
            }

            fprintf(fPun, "FLD _cte%s\n", siguientePil);
        }
        else
            fprintf(fPun, "FLD %s\n", siguientePil);
    }

    getTipoDato(topePilAsm, auxTipo);
    variable = esVariable(topePilAsm);
 
    if(variable) {

        if(strcmp(auxTipo, "TIPONUM") == 0) {

            agregarCerDec(topePilAsm);
            agregarCerEnt(topePilAsm);
            reemplazarPunto(topePilAsm);
        }

        fprintf(fPun, "FLD _cte%s\n", topePilAsm);
    }
    else
        fprintf(fPun, "FLD %s\n", topePilAsm);
        
	fprintf(fPun, "%s\n", "FSUB"); //St(0),St(1)\n");
	//fprintf(fPun, "FSTP _@AUX\n");	
	apilarAsm("@AUX");
}

void generarWri(FILE *fPun) {
	
    int i, variable;
    char auxTipo[8];

	desapilarAsm(topePilAsm);
	getTipoDato(topePilAsm, auxTipo);

    if(strcmp(auxTipo, "TIPOCAD") == 0) {
        
        fprintf(fPun, "MOV DX, OFFSET %s\n\tMOV AH, 9\n\tINT 21h\nNEWLINE 1\n", topePilAsm);
    }
    /*else {

    }*/
    
}

void generarAsm() {

	FILE* fCA = fopen("final.asm","w+t");
	
	char linea[52];
	char cmp[10] = "FCOMP";
    int i, j, k, ban, cantidadSal = -1, cantidadWhi = -1;
    int vecSaltos[500]; 
    int vecWhile[500];

	imprimirHeader(fCA);
	imprimirVariables(fCA);

	for (i = 0; i < posicionAct; i++) {

		strcpy(variablePil, vectorPolInv[i]);
		printf("Contenido de la polaca inversa:\t%s\n", variablePil);

        for(j = cantidadSal; j >= 0; j--) {
            
            if(vecSaltos[j] == i)
                fprintf(fCA,"_ET_%d\n", j);
        }

		if(strcmp(variablePil, "+") == 0)
			generarFadd(fCA);
		else if(strcmp(variablePil, "*") == 0)
            generarFmul(fCA);
        else if(strcmp(variablePil, "-") == 0)
			generarFsub(fCA);
		else if(strcmp(variablePil, "/") == 0)
			generarFdiv(fCA);
		else if(strcmp(variablePil, ":=") == 0)
			generarAsig(fCA);
		else if(strcmp(variablePil, "WRITE") == 0)
			generarWri(fCA);
		/*else if(strcmp(variablePil, "READ") == 0 )
			generarRea(fCA);*/
		else if(strcmp(variablePil, "CMP") == 0)
			generarCmp(fCA, variablePil);
		else if(strcmp(variablePil, "BGE") == 0) {
            
            cantidadSal++;
            vecSaltos[cantidadSal] = atoi(vectorPolInv[i + 1]);
            fprintf(fCA, "JNB _ET_%d\n", cantidadSal);
        }
		else if(strcmp(variablePil, "BGT") == 0) {

            cantidadSal++;
            vecSaltos[cantidadSal] = atoi(vectorPolInv[i + 1]);
            fprintf(fCA, "JNBE _ET_%d\n", cantidadSal);
        }
        
		else if(strcmp(variablePil, "BLE") == 0) {

            cantidadSal++;
            vecSaltos[cantidadSal] = atoi(vectorPolInv[i + 1]);
            fprintf(fCA, "JNA _ET_%d\n", cantidadSal);
        }

		else if(strcmp(variablePil, "BEQ") == 0) {

            cantidadSal++;
            vecSaltos[cantidadSal] = atoi(vectorPolInv[i + 1]);
            fprintf(fCA, "JE _ET_%d\n", cantidadSal);
        }

		else if(strcmp(variablePil,"BNE") == 0) {

            cantidadSal++;
            vecSaltos[cantidadSal] = atoi(vectorPolInv[i + 1]);
            fprintf(fCA, "JNE _ET_%d\n", cantidadSal);
        }

		else if(strcmp(variablePil, "BLT") == 0) {

            cantidadSal++;
            vecSaltos[cantidadSal] = atoi(vectorPolInv[i + 1]);
            fprintf(fCA, "JNAE _ET_%d\n", cantidadSal);
        }

		else if(strcmp(variablePil, "ET") == 0) {
            
            cantidadWhi++;
            vecWhile[cantidadWhi] = i;
            fprintf(fCA, "_ET_W%d\n", cantidadWhi);
        }

		else if(strcmp(variablePil, "BI") == 0) {

            ban = 0;

            for(k = 0; k <= cantidadWhi; k++) {

                if(vecWhile[k] == atoi(vectorPolInv[i + 1])) {

                    fprintf(fCA, "JMP _ET_W%d\n", cantidadWhi);
                    ban = 1;
                }
            }

            if(ban == 0) {

                cantidadSal++;
                vecSaltos[cantidadSal] = atoi(vectorPolInv[i + 1]);
                fprintf(fCA, "JMP _ET_%d\n", cantidadSal);
            }
        }

		else
			apilarAsm(variablePil);
	}
    
    for(j = cantidadSal; j >= 0; j--) {

        if(vecSaltos[j] == i) 
            fprintf(fCA,"_ET_%d\n", j);
    }

    fprintf(fCA,"MOV AH, 1\nINT 21h\n");
	fprintf(fCA,"MOV AX, 4c00h\n");
    //fprintf(final,"mov al,0\n" );
    fprintf(fCA,"INT 21h\n");
	/*fprintf(final,"\nSTRLEN PROC NEAR\n");
	fprintf(final,"\tmov BX,0\n");
	fprintf(final,"\nSTRL01:\n");
	fprintf(final,"\tcmp BYTE PTR [SI+BX],'$'\n");
	fprintf(final,"\tje STREND\n");
	fprintf(final,"\tinc BX\n");
	fprintf(final,"\tjmp STRL01\n");
	fprintf(final,"\nSTREND:\n");
	fprintf(final,"\tret\n");
	fprintf(final,"\nSTRLEN ENDP\n");
	fprintf(final,"\nCOPIAR PROC NEAR\n");
	fprintf(final,"\tcall STRLEN\n");
	fprintf(final,"\tcmp BX,MAXTEXTSIZE\n");
	fprintf(final,"\tjle COPIARSIZEOK\n");
	fprintf(final,"\tmov BX,MAXTEXTSIZE\n");
	fprintf(final,"\nCOPIARSIZEOK:\n");
	fprintf(final,"\tmov CX,BX\n");
	fprintf(final,"\tcld\n");
	fprintf(final,"\trep movsb\n");
	fprintf(final,"\tmov al,'$'\n");
	fprintf(final,"\tmov BYTE PTR [DI],al\n");
	fprintf(final,"\tret\n");
	fprintf(final,"\nCOPIAR ENDP\n");
	fprintf(final,"\nEND START\n");*/
    fprintf(fCA,"END main\n");
	fclose(fCA);
}