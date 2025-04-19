%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <float.h>
#include "tablaDeSimbolos.h"
//#include "y.tab.h"

FILE  *yyin;
/*extern yylval;*/
char *yytext;

int yyerror(void);
int validarRangoInt(char*);
int validarRangoFloat(char*);
int validarRangoString(char*);
int insertarId(char*);
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
{CTEENTERO}			        validarRangoInt(yytext); //{printf("\nConstante entera: %s\n", yytext);}
{CTENUMEROCONCOMA}			validarRangoFloat(yytext); //{printf("\nConstante flotante: %s\n", yytext);}
{CTETIPOCADENITA}			validarRangoString(yytext); //{printf("\nConstante string: %s\n", yytext);}

{INT}			            {printf("\nTipo int: %s\n", yytext);}
{FLOAT}			            {printf("\nTipo flotante: %s\n", yytext);}
{STRING}			        {printf("\nTipo string: %s\n", yytext);}

{INICIARVARIABLE}           {printf("\nInicio declaracion variable: %s\n", yytext);}
{DOSPUNTITOS}               {printf("\nDos puntitos: %s\n", yytext);}
{COMA}                      {printf("\nComa: %s\n", yytext);}

{CHISMECITO}                {printf("\nChisme: %s\n", yytext);}

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
{LA}			            {printf("\nLlaAbre: %s\n", yytext);}
{LC}			            {printf("\nLlaCierra: %s\n", yytext);}

{WHILE}			            {printf("\nwhile: %s\n", yytext);}
{IF}			            {printf("\nif: %s\n", yytext);}
{ELSE}			            {printf("\nelse: %s\n", yytext);}
{READ}			            {printf("\nread: %s\n", yytext);}
{WRITE}			            {printf("\nwrite: %s\n", yytext);}

{REORDER}			        {printf("\nReorder: %s\n", yytext);}
{SLICEANDCONCAT}			{printf("\nSliceAndConcat: %s\n", yytext);}

{ID}			            insertarId(yytext); //{printf("\nIdentificador: %s\n", yytext);}

"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			                {printf( "Error lexico. Caracter no reconocido: %s\n", yytext ); exit (0);}

%%

int main(int argc, char **argv) {
    
    if (argc != 2) {
        fprintf(stderr, "Uso %s <archivo>. \n", argv[0]);
        exit(1);
    }

    yyin = fopen(argv[1], "r");
    
    if (!yyin) {
        perror("No se es posible abrir el archivo. \n");
        exit(1);
    }

    yylex();
    fclose(yyin);
    generarArchivo();
    return 0;
}

int validarRangoInt(char* cte)
{
    int numero = atoi(cte);
    char nombre[6];

    if((numero >= (SHRT_MIN)) && (numero <= SHRT_MAX)) {
        printf("Constante entera valida: %s\n", cte);
        sprintf(nombre, "_%d", numero);

        if(buscarEnTabla(nombre) == -1)
            insertarEnTabla(nombre, "", cte, "");
    } else
        printf("Constante entera invalida: %s\n", cte);
}

int validarRangoFloat(char* cte)
{
    float numero = atof(cte);
    char nombre[41];

    if ((numero > FLT_MIN && numero < FLT_MAX) || (numero < (-1 * FLT_MIN) && numero > (-1 * FLT_MAX))) {
        printf("Constante flotante valida: %s\n", cte);
        sprintf(nombre, "_%g", numero);

        if(buscarEnTabla(nombre) == -1)
            insertarEnTabla(nombre, "", cte, "");
    } else
        printf("Constante flotante invalida: %s\n", cte);
    
}

int validarRangoString(char* cte) {

    int longitud = (strlen(cte) - 2);
    char cadena[longitud + 1];
    char nombre[longitud + 2];
    char auxLongitud[4];

    strncpy(cadena, cte + 1, longitud);
    cadena[longitud] = '\0';

    if(longitud <= 50) {
        printf("Constante String valida: \"%s\"\n", cadena);
        sprintf(nombre, "_%s", cadena);

        if(buscarEnTabla(nombre) == -1)
            insertarEnTabla(nombre, "", cadena, itoa((longitud - 1), auxLongitud, 10));
    } else 
        printf("Constante String invalida: \"%s\"\n", cadena);
}

int insertarId(char* id) {
    
    printf("\nIdentificador: %s\n", yytext);
    
    if(buscarEnTabla(id) == -1)
            insertarEnTabla(id, "", "-", "");
}


