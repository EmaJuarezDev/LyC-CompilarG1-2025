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
/*Viene de sintactico*/
extern int yystopparser;

int yyerror(void);
int validarRangoInt(char*);
int validarRangoFloat(char*);
int validarRangoString(char*);
int insertarId(char*);
int yylex(void);
int yyparse(void);

int main(int argc, char **argv) {
   
    if (argc != 2) {
        fprintf(stderr, "Uso %s <archivo>. \n", argv[0]);
        exit(1);
    }

    if((yyin = fopen(argv[1], "rt")) == NULL)
        printf("No es posible abrir el archivo de prueba '%s'. \n", argv[1]);    
    else     
        yyparse();        

    /*yylex();*/
    fclose(yyin);
    generarArchivo();

    return 0;
}

int validarRangoInt(char* cte) {

    int numero = atoi(cte);
    char nombre[6];

    if((numero >= 0) && (numero <= SHRT_MAX))
        printf("\nLexico:Constante entera valida: %s\n", cte);
    else {
        printf( "\nError lexico. Constante entera invalida: %s\n", yytext ); 
        exit(5);
    }
}

int validarRangoFloat(char* cte) {
    
    float numero = atof(cte);
    char nombre[41];
    char aux[53];
    char* punto;

    if ((numero > FLT_MIN && numero < FLT_MAX))
        printf("\nLexico:Constante flotante valida: %s\n", cte);
    else {
        printf( "\nError lexico. Constante flotante invalida: %s\n", yytext ); 
        exit(6);
    }
    
}

int validarRangoString(char* cte) {

    int longitud = (strlen(cte) - 2);
    char cadena[longitud + 1];
    char nombre[longitud + 2];
    char auxLongitud[4];

    strncpy(cadena, cte + 1, longitud);
    cadena[longitud] = '\0';

    if(longitud <= 50) {
        printf("\nLexico: Constante String valida: \"%s\"\n", cadena);
    } else {
        printf( "\nError lexico. Constante String invalida: %s\n", yytext ); 
        exit(7);
    }
}

int insertarId(char* id) {
    
    if((strlen(id)) <= 50)
        printf("\nLexico:Identificador: %s\n", yytext);
    
    else {
        
        printf( "\nError lexico. Constante String invalida: %s\n", yytext ); 
        exit(7);
    }
}

