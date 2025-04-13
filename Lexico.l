%{
#include <stdio.h>
#include <stdlib.h>

//#include "y.tab.h"
FILE  *yyin;
char *yytext;


int yyerror(void);

int funcionValidarRangoInt(char*);
int funcionValidarRangoFloat(char*);
int funcionValidarRangoString(char*);


%}

%option noyywrap  
%option yylineno 

/* Conjutos */
DIGITO			        [0-9]
LETRA			        [a-zA-Z]

/*Tipo de datos */
CTEENTERO		        {DIGITO}+
CTENUMEROCONCOMA		({DIGITO}+"."{DIGITO}* | {DIGITO}*"."{DIGITO}+)
CTETIPOCADENITA			\"[^"]*\"

INT                     "TIPOENTERO"
FLOAT                   "TIPONUMEROCONCOMA"
STRING                  "TIPOCADENITA"

/*Declaración de variables */
ID                      {LETRA}({LETRA}|{DIGITO})*
INICIARVARIABLE         "ARRANCAACA"
DOSPUNTITOS             ":"
COMA                    ","

/*Comentarios */
INICHISME               "#+"
FINCHISME               "+#"
CHISMECITO              {INICHISME}[^+#]*{FINCHISME}


/*Operador asignacion */
OP_AS   		        "="

/*Operadores Aritmeticos */
OP_SUM		            "+"
OP_MUL                  "*"
OP_RES		            "-"
OP_DIV                  "/"

/*Operadorees Comparacion */
COMP_MAYOR              "MAYOR"
COMP_MENOR              "MENOR"
COMP_IGUAL              "IGUALA"
COMP_DIST               "DISTINTASO"
COMP_MAYORIGUAL         "MAYORIGUAL"
COMP_MENORIGUAL         "MENORIGUAL"

/*Operadores Logicos */
OP_AND                  "YQUEMAS"
OP_OR                   "OQUEMAS"
OP_NOT                  "NOES"

/*BLOQUES */
PA			            "("
PC			            ")"
CA                      "["
CC                      "]"
LA                      "{"
LC                      "}"

/*Funciones base */
WHILE                   "MIENTRAS"
IF                      "SI"
ELSE                    "SINO"
READ                    "LEER"
WRITE                   "DECIR"

/*Funciones adicionales */
REORDER                 "MENJUNJE"
SLICEANDCONCAT          "CORTAYPEGAR"





/*{printf("\nTipo entero: %s\n", yytext);return INT;}*/
/*TODO: Realizar validacion de rango */
/*{INICHISME}                 {printf("\nInicio comentario: %s\n", yytext);return ID;}
{FINCHISME}                 {printf("\nFin comentario: %s\n", yytext);return ID;} */

%%


{CTEENTERO}			        {printf("\nConstante entera: %s\n", yytext);return CTEENTERO;}
{CTENUMEROCONCOMA}			{printf("\nConstante flotante: %s\n", yytext);return CTENUMEROCONCOMA;}
{CTETIPOCADENITA}			{printf("\nConstante string: %s\n", yytext);return CTETIPOCADENITA;}

{INT}			            {printf("\nTipo int: %s\n", yytext);return INT;}

{FLOAT}			            {printf("\nTipo flotante: %s\n", yytext);return FLOAT;}
{STRING}			        {printf("\nTipo string: %s\n", yytext);return STRING;}





{ID}			            {printf("\nIdentificador: %s\n", yytext);return ID;}
{INICIARVARIABLE}           {printf("\nInicio declaracion variable: %s\n", yytext);return INICIARVARIABLE;}
{DOSPUNTITOS}               {printf("\nDos puntitos: %s\n", yytext);return DOSPUNTITOS;}
{COMA}                      {printf("\nComa: %s\n", yytext);return COMA;}


{CHISMECITO}                {}


{OP_AS}			            {printf("\nAsignacion: %s\n", yytext);return OP_AS;}


{OP_SUM}		            {printf("\nSuma: %s\n", yytext);return OP_SUM;}
{OP_MUL}		            {printf("\nMultiplicacion: %s\n", yytext);return OP_MUL;}
{OP_RES}		            {printf("\nResta: %s\n", yytext);return OP_RES;}
{OP_DIV}		            {printf("\nDivision: %s\n", yytext);return OP_DIV;}


{COMP_MAYOR}		        {printf("\nMayor: %s\n", yytext);return COMP_MAYOR;}
{COMP_MENOR}		        {printf("\nMenor: %s\n", yytext);return COMP_MENOR;}
{COMP_IGUAL}		        {printf("\nIgual: %s\n", yytext);return COMP_IGUAL;}
{COMP_DIST}		            {printf("\nDistinto: %s\n", yytext);return COMP_DIST;}
{COMP_MAYORIGUAL}		    {printf("\nMayor e igual: %s\n", yytext);return COMP_MAYORIGUAL;}
{COMP_MENORIGUAL}		    {printf("\nMenor e igual: %s\n", yytext);return COMP_MENORIGUAL;}


{OP_AND}		            {printf("\nAnd: %s\n", yytext);return OP_AND;}
{OP_OR}		                {printf("\nOr: %s\n", yytext);return OP_OR;}
{OP_NOT}		            {printf("\nNot: %s\n", yytext);return OP_NOT;}



{PA}			            {printf("\nParAbre: %s\n", yytext);return PA;}
{PC}			            {printf("\nParCierra: %s\n", yytext);return PC;}
{CA}			            {printf("\nCorAbre: %s\n", yytext);return CA;}
{CC}			            {printf("\nCorCierra: %s\n", yytext);return CC;}
{LA}			            {printf("\nLlaCierra: %s\n", yytext);return LA;}
{LC}			            {printf("\nLlaCierra: %s\n", yytext);return LC;}


{WHILE}			            {printf("\nMientras: %s\n", yytext);return WHILE;}
{IF}			            {printf("\nSi: %s\n", yytext);return IF;}
{ELSE}			            {printf("\nSino: %s\n", yytext);return ELSE;}
{READ}			            {printf("\nLeer: %s\n", yytext);return READ;}
{WRITE}			            {printf("\nDecir: %s\n", yytext);return WRITE;}


{REORDER}			        {printf("\nReorder: %s\n", yytext);return REORDER;}
{SLICEANDCONCAT}			{printf("\nSliceAndConcat: %s\n", yytext);return SLICEANDCONCAT;}



"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			 { printf( "ERROR LEXICO : Caracter no reconocido: %s\n", yytext ); exit (0);}

%%

int funcionValidarRangoInt(char* pValor){

}

int funcionValidarRangoFloat(char* pValor){

}

int funcionValidarRangoString(char* pValor){
    
}


int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s <archivo>\n", argv[0]);
        exit(1);
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("No se pudo abrir el archivo");
        exit(1);
    }

    yylex();
    fclose(yyin);
    return 0;
}