%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
CTEENTERO		        "-"?{DIGITO}+
CTENUMEROCONCOMA		"-"?{DIGITO}+"."{DIGITO}*|{DIGITO}*"."{DIGITO}+
CTETIPOCADENITA			\"({DIGITO}|{LETRA})+\"

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
/*{INICHISME}                 {printf("\nInicio comentario: %s\n", yytext);return ID;}*/
/*{FINCHISME}                 {printf("\nFin comentario: %s\n", yytext);return ID;} */

%%
{CTEENTERO}			        funcionValidarRangoInt(yytext); //{printf("\nConstante entera: %s\n", yytext);}
{CTENUMEROCONCOMA}			funcionValidarRangoFloat(yytext); //{printf("\nConstante flotante: %s\n", yytext);}
{CTETIPOCADENITA}			funcionValidarRangoString(yytext); //{printf("\nConstante string: %s\n", yytext);}

{INT}			            {printf("\nTipo int: %s\n", yytext);}
{FLOAT}			            {printf("\nTipo flotante: %s\n", yytext);}
{STRING}			        {printf("\nTipo string: %s\n", yytext);}

{ID}			            {printf("\nIdentificador: %s\n", yytext);}
{INICIARVARIABLE}           {printf("\nInicio declaracion variable: %s\n", yytext);}
{DOSPUNTITOS}               {printf("\nDos puntitos: %s\n", yytext);}
{COMA}                      {printf("\nComa: %s\n", yytext);}

{CHISMECITO}                {}

{OP_AS}			            {printf("\nAsignacion: %s\n", yytext);}

{OP_SUM}		            {printf("\nSuma: %s\n", yytext);}
{OP_MUL}		            {printf("\nMultiplicacion: %s\n", yytext);}
{OP_RES}		            {printf("\nResta: %s\n", yytext);}
{OP_DIV}		            {printf("\nDivision: %s\n", yytext);}

{COMP_MAYOR}		        {printf("\nMayor: %s\n", yytext);}
{COMP_MENOR}		        {printf("\nMenor: %s\n", yytext);}
{COMP_IGUAL}		        {printf("\nIgual: %s\n", yytext);}
{COMP_DIST}		            {printf("\nDistinto: %s\n", yytext);}
{COMP_MAYORIGUAL}		    {printf("\nMayor e igual: %s\n", yytext);}
{COMP_MENORIGUAL}		    {printf("\nMenor e igual: %s\n", yytext);}

{OP_AND}		            {printf("\nAnd: %s\n", yytext);}
{OP_OR}		                {printf("\nOr: %s\n", yytext);}
{OP_NOT}		            {printf("\nNot: %s\n", yytext);}

{PA}			            {printf("\nParAbre: %s\n", yytext);}
{PC}			            {printf("\nParCierra: %s\n", yytext);}
{CA}			            {printf("\nCorAbre: %s\n", yytext);}
{CC}			            {printf("\nCorCierra: %s\n", yytext);}
{LA}			            {printf("\nLlaCierra: %s\n", yytext);}
{LC}			            {printf("\nLlaCierra: %s\n", yytext);}

{WHILE}			            {printf("\nMientras: %s\n", yytext);}
{IF}			            {printf("\nSi: %s\n", yytext);}
{ELSE}			            {printf("\nSino: %s\n", yytext);}
{READ}			            {printf("\nLeer: %s\n", yytext);}
{WRITE}			            {printf("\nDecir: %s\n", yytext);}

{REORDER}			        {printf("\nReorder: %s\n", yytext);}
{SLICEANDCONCAT}			{printf("\nSliceAndConcat: %s\n", yytext);}

"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			                {printf( "Error lexico. Caracter no reconocido: %s\n", yytext ); exit (0);}

%%

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

int funcionValidarRangoInt(char* cte)
{
    int entero = atoi(cte);

    if((entero >= (-32768)) && (entero < 32768))
        printf("Constante entera valida: %s\n", cte);
    else
        printf("Constante entera invalida: %s\n", cte);
}

int funcionValidarRangoFloat(char* cte)
{
    float numero = atof(cte);

    if (numero >= (-3.4e38) && numero <= 3.4e38)
        printf("Constante flotante valida: %s\n", cte);
    else
        printf("Constante flotante invalida: %s\n", cte);
    
}

int funcionValidarRangoString(char* cte) {

    int longitud = (strlen(cte) - 2);
    char cadena[longitud + 1];

    strncpy(cadena, cte + 1, longitud);
    cadena[longitud] = '\0';

    if(longitud <= 50)
        printf("Constante String valida: \"%s\"\n", cadena);
    else 
        printf("Constante String invalida: \"%s\"\n", cadena);
}
