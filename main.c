#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <float.h>

#include "tablaDeSimbolos.h"
#include "y.tab.h"

#include "funcionesEspeciales.h"

extern FILE  *yyin;
/*extern yylval;*/
extern char *yytext;

/*Viene de sintactico*/
extern int yystopparser;

int yyerror(void);
int validarRangoInt(char*);
int validarRangoFloat(char*);
int validarRangoString(char*);
int insertarId(char*);

int yylex(void);
int yyparse(void);

int main(int argc, char **argv)  {
   
    if (argc != 2) {
        fprintf(stderr, "Uso %s <archivo>. \n", argv[0]);
        exit(1);
    }

    yyin = fopen(argv[1], "r");
    
    if (!yyin) {
        perror("No se es posible abrir el archivo. \n");
        exit(1);
    }

    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);    
    }
    else
    {       
        yyparse();        
    }

    /*yylex();*/
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

int yyerror(void)
    {
        printf("Error Sintactico\n");
        exit (1);
    }

