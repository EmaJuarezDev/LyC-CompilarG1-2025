%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <float.h>
#include "tablaDeSimbolos.h"

#include "funcionesEspeciales.h"

extern FILE  *yyin;
/*extern yylval;*/
extern char *yytext;

int yyerror(void);
int validarRangoInt(char*);
int validarRangoFloat(char*);
int validarRangoString(char*);
int insertarId(char*);

int yyparse(void);

%}

%option noyywrap  
%option yylineno 

/* Conjutos */
DIGITO			        [0-9]
LETRA			        [a-zA-Z]
SIMBOLOS                [@]

/*Tipo de datos */
CTEENTERO		        "-"?{DIGITO}+
CTENUMEROCONCOMA		"-"?(({DIGITO}+"."{DIGITO}*)|({DIGITO}*"."{DIGITO}+))
CTETIPOCADENITA			\"[^\"]*\"

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

/*Cadenas*/
COMILLAS                "\""

/*Operador asignacion */
OP_AS   		        ":="

/*Operadores Aritmeticos */
OP_SUM		            "MAS"
OP_MUL                  "POR"
OP_RES		            "MENOS"
OP_DIV                  "DIVIDIR"

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

/*{printf("\nTipo numero: %s\n", yytext);return INT;}*/
/*TODO: Realizar validacion de rango */
/*{INICHISME}                 {printf("\nInicio comentario: %s\n", yytext);return ID;}*/
/*{FINCHISME}                 {printf("\nFin comentario: %s\n", yytext);return ID;} */

%%
{CTEENTERO}			        {validarRangoInt(yytext);return CTEENTERO;} //{printf("\nConstante entera: %s\n", yytext);}
{CTENUMEROCONCOMA}			{validarRangoFloat(yytext);return CTENUMEROCONCOMA;} //{printf("\nConstante flotante: %s\n", yytext);}
{CTETIPOCADENITA}			{validarRangoString(yytext);return CTETIPOCADENITA;} //{printf("\nConstante string: %s\n", yytext);}

{INT}			            {printf("\nTipo int: %s\n", yytext);return INT;}
{FLOAT}			            {printf("\nTipo flotante: %s\n", yytext);return FLOAT;}
{STRING}			        {printf("\nTipo string: %s\n", yytext);return STRING;}

{INICIARVARIABLE}           {printf("\nInicio declaracion variable: %s\n", yytext);return INICIARVARIABLE;}
{DOSPUNTITOS}               {printf("\nDos puntitos: %s\n", yytext);return DOSPUNTITOS;}
{COMA}                      {printf("\nComa: %s\n", yytext);return COMA;}

{CHISMECITO}                {printf("\nChisme: %s\n", yytext);return CHISMECITO;}

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
{LA}			            {printf("\nLlaAbre: %s\n", yytext);return LA;}
{LC}			            {printf("\nLlaCierra: %s\n", yytext); return LC;}

{WHILE}			            {printf("\nwhile: %s\n", yytext);return WHILE;}
{IF}			            {printf("\nif: %s\n", yytext);return IF;}
{ELSE}			            {printf("\nelse: %s\n", yytext);return ELSE;}
{READ}			            {printf("\nread: %s\n", yytext);return READ;}
{WRITE}			            {printf("\nwrite: %s\n", yytext);return WRITE;}

{REORDER}			        {printf("\nReorder: %s\n", yytext);return REORDER;}
{SLICEANDCONCAT}			{printf("\nSliceAndConcat: %s\n", yytext);return SLICEANDCONCAT;}

{ID}			            {insertarId(yytext);return ID;} //{printf("\nIdentificador: %s\n", yytext);}

"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			                {printf( "Error lexico. Caracter no reconocido: %s\n", yytext ); exit (0);}

%%




