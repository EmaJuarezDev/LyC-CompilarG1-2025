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

/*Tipo de datos */
/*CTEBOOLEANO             {1|0}*/
CTEENTERO		        {DIGITO}+
CTENUMEROCONCOMA		(({DIGITO}+"."{DIGITO}*)|({DIGITO}*"."{DIGITO}+))
CTETIPOCADENITA			\"[^\"]*\"

FALSO                   "FALSO"
VERDADERO               "VERDADERO"


INT                     "TIPOENTERO"
FLOAT                   "TIPONUMEROCONCOMA"
STRING                  "TIPOCADENITA"
/*BOOL                  "TIPOBOOLEANO"*/

/*Declaración de variables */
ID                      [a-z]({LETRA}|{DIGITO})*
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
/*{CTEBOOLEANO}                 {validarRangoBoolean(yytext);return CTETIPOBOOLEANO;}*/
/*{BOOLEAN}                     {printf("\nTipo boolean: %s\n", yytext);return BOOLEAN;}*/
/*{CTEBOOLEANO}               {validarRangoBoolean(yytext);return CTEBOOLEANO;}*/
/*{CTEBOOLEANO}               {validarRangoBoolean(yytext);return CTEBOOLEANO;}*/

%%
{CTEENTERO}			        {validarRangoInt(yytext); return CTEENTERO;} //{printf("\nConstante entera: %s\n", yytext);}
{CTENUMEROCONCOMA}			{validarRangoFloat(yytext); return CTENUMEROCONCOMA;} //{printf("\nConstante flotante: %s\n", yytext);}
{CTETIPOCADENITA}			{validarRangoString(yytext); return CTETIPOCADENITA;} //{printf("\nConstante string: %s\n", yytext);}
{FALSO}			            {printf("\nLexico:Falso: %s\n", yytext); return FALSO;}
{VERDADERO}			        {printf("\nLexico:Verdadero: %s\n", yytext); return VERDADERO;}


{INT}			            {printf("\nLexico:Tipo int: %s\n", yytext); return INT;}
{FLOAT}			            {printf("\nLexico:Tipo flotante: %s\n", yytext); return FLOAT;}
{STRING}			        {printf("\nLexico:Tipo string: %s\n", yytext); return STRING;}

{INICIARVARIABLE}           {printf("\nLexico:Inicio declaracion variable: %s\n", yytext); return INICIARVARIABLE;}
{DOSPUNTITOS}               {printf("\nLexico:Dos puntitos: %s\n", yytext); return DOSPUNTITOS;}
{COMA}                      {printf("\nLexico:Coma: %s\n", yytext); return COMA;}

{CHISMECITO}                

{OP_AS}			            {printf("\nLexico:Asignacion: %s\n", yytext); return OP_AS;}

{OP_SUM}		            {printf("\nLexico:Suma: %s\n", yytext); return OP_SUM;}
{OP_MUL}		            {printf("\nLexico:Multiplicacion: %s\n", yytext); return OP_MUL;}
{OP_RES}		            {printf("\nLexico:Resta: %s\n", yytext); return OP_RES;}
{OP_DIV}		            {printf("\nLexico:Division: %s\n", yytext); return OP_DIV;}

{COMP_MAYOR}		        {printf("\nLexico:Mayor: %s\n", yytext); return COMP_MAYOR;}
{COMP_MENOR}		        {printf("\nLexico:Menor: %s\n", yytext); return COMP_MENOR;}
{COMP_IGUAL}		        {printf("\nLexico:Igual: %s\n", yytext); return COMP_IGUAL;}
{COMP_DIST}		            {printf("\nLexico:Distinto: %s\n", yytext); return COMP_DIST;}
{COMP_MAYORIGUAL}		    {printf("\nLexico:Mayor e igual: %s\n", yytext); return COMP_MAYORIGUAL;}
{COMP_MENORIGUAL}		    {printf("\nLexico:Menor e igual: %s\n", yytext); return COMP_MENORIGUAL;}

{OP_AND}		            {printf("\nLexico:And: %s\n", yytext); return OP_AND;}
{OP_OR}		                {printf("\nLexico:Or: %s\n", yytext); return OP_OR;}
{OP_NOT}		            {printf("\nLexico:Not: %s\n", yytext); return OP_NOT;}

{PA}			            {printf("\nLexico:ParAbre: %s\n", yytext); return PA;}
{PC}			            {printf("\nLexico:ParCierra: %s\n", yytext); return PC;}
{CA}			            {printf("\nLexico:CorAbre: %s\n", yytext); return CA;}
{CC}			            {printf("\nLexico:CorCierra: %s\n", yytext); return CC;}
{LA}			            {printf("\nLexico:LlaAbre: %s\n", yytext); return LA;}
{LC}			            {printf("\nLexico:LlaCierra: %s\n", yytext); return LC;}

{WHILE}			            {printf("\nLexico:while: %s\n", yytext); return WHILE;}
{IF}			            {printf("\nLexico:if: %s\n", yytext); return IF;}
{ELSE}			            {printf("\nLexico:else: %s\n", yytext); return ELSE;}
{READ}			            {printf("\nLexico:read: %s\n", yytext); return READ;}
{WRITE}			            {printf("\nLexico:write: %s\n", yytext); return WRITE;}

{REORDER}			        {printf("\nLexico:Reorder: %s\n", yytext); return REORDER;}
{SLICEANDCONCAT}			{printf("\nLexico:SliceAndConcat: %s\n", yytext); return SLICEANDCONCAT;}

{ID}			            {insertarId(yytext); return ID;} //{printf("\nIdentificador: %s\n", yytext);}

"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			                {printf( "\nError lexico. Caracter no reconocido: %s\n", yytext ); exit (0);}
%%




