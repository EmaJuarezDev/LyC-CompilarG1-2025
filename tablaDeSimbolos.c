#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tablaDeSimbolos.h"

t_simbolo tablaSimbolos[TAM_TABLA];
int ultimoSimbolo = 0;

int buscarEnTabla(char *nombre) {

    int pos = 0;
    
        while(pos != ultimoSimbolo) {
            if(strcmp(nombre, tablaSimbolos[pos].nombre) == 0)
                return pos;
            pos++;
        }

    return -1;
}

t_simbolo getSimboloDeTabla(int posicion) {
    return tablaSimbolos[posicion];
}

int getCantidadSimbolos() {
	  return ultimoSimbolo;
}

char* getNombreSimbolo(int i) {
    return tablaSimbolos[i].nombre;
}

char* getValorSimbolo(int i) {
	  return tablaSimbolos[i].valor;
}

void agregarVariable(char* nombre) {

    if(ultimoSimbolo >= TAM_TABLA - 1) {
        printf("No existe espacio disponible en la tabla de simbolos. \n");
        exit(1);
    }

    if(buscarEnTabla(nombre) == -1) {
        strncpy(tablaSimbolos[ultimoSimbolo].nombre, nombre, TAM_LEXEMA + 1);
        ultimoSimbolo++;
    }
    else {
        printf("Error: Se declaró dos veces la variable '%s'. \n", nombre);
        exit(2);
    }
}

void agregarConstanteInt(char* valor) {

    if(ultimoSimbolo >= TAM_TABLA - 1) {
        printf("No existe espacio disponible en la tabla de simbolos. \n");
        exit(1);
    }

    char nombre[TAM_LEXEMA + 1];
    sprintf(nombre, "_%s", valor);

    if(buscarEnTabla(nombre) == -1) {
        strncpy(tablaSimbolos[ultimoSimbolo].nombre, nombre, TAM_LEXEMA + 1);
        strncpy(tablaSimbolos[ultimoSimbolo].tipoDato, "TIPOENT", 8);
        strncpy(tablaSimbolos[ultimoSimbolo].valor, valor, TAM_LEXEMA + 1);
        ultimoSimbolo++;
    }
}

/*void agregarCerEnt(char *cadena) {
	
    char aux[50];

	if(siguientePil[(strlen(siguientePil)) - 1] != '.') 
        return;

    strcpy(aux, "0\0");
	strcat (siguientePil, aux);    
}*/

void agregarConstanteFlo(char* valor) {

    if(ultimoSimbolo >= TAM_TABLA - 1) {
        printf("No existe espacio disponible en la tabla de simbolos. \n");
        exit(1);
    }
    
    char nombre[TAM_LEXEMA + 1];
    sprintf(nombre, "_%s", valor);

    if(buscarEnTabla(nombre) == -1) {
        strncpy(tablaSimbolos[ultimoSimbolo].nombre, nombre, TAM_LEXEMA + 1);
        strncpy(tablaSimbolos[ultimoSimbolo].tipoDato, "TIPONUM", 8);
        strncpy(tablaSimbolos[ultimoSimbolo].valor, valor, TAM_LEXEMA + 1);
        ultimoSimbolo++;
    }
}

void agregarConstanteStr(char* valor) {

    if(ultimoSimbolo >= TAM_TABLA - 1) {
        printf("No existe espacio disponible en la tabla de simbolos. \n");
        exit(1);
    }

    int longitud = (strlen(valor) - 1);
    char nombre[longitud + 1];
    strncpy(nombre + 1, valor + 1, longitud);
    nombre[0] = '_';
    nombre[longitud] = '\0';
    char* aux;
    strcpy(aux, itoa(longitud - 1, aux, 10));

    if(buscarEnTabla(nombre) == -1) {
        strncpy(tablaSimbolos[ultimoSimbolo].nombre, nombre, TAM_LEXEMA + 1);
        strncpy(tablaSimbolos[ultimoSimbolo].tipoDato, "TIPOCAD", 8);
        strncpy(tablaSimbolos[ultimoSimbolo].longitud, aux, 4);
        strncpy(tablaSimbolos[ultimoSimbolo].valor, nombre + 1, TAM_LEXEMA + 1);
        ultimoSimbolo++;
    }
}

void getTipoDato(char* nombre, char* tipo) {

    int posicion = buscarEnTabla(nombre);

    // Si no está, chequeo si es acceso tipo @lis[algo]
    if (posicion == -1 && strstr(nombre, "@lis[") == nombre) {
        posicion = buscarEnTabla("@lis");
    }

    if(posicion == -1 && strcmp(nombre, "@AUX") != 0) {

        char aux[TAM_LEXEMA + 1];
        sprintf(aux, "_%s", nombre);
        posicion = buscarEnTabla(aux); 
        
        if(posicion == -1) {   
        
            printf("Error: No se declaro la variable '%s'. \n", nombre);
            exit(3);
        }
    }

    strcpy(tipo, tablaSimbolos[posicion].tipoDato);
}

void agregarTipoDato(char* tipo, int cantidadVar, int inicio) {

    int i;

  	for(i = 0; i < cantidadVar; i++)
        strncpy(tablaSimbolos[inicio + i].tipoDato, tipo, 7);
}

void declararTemporalesReorder() {
    // Vector base @lis (simulado como variable común, sin soporte real de índices)
    if (buscarEnTabla("@lis") == -1) {
        strncpy(tablaSimbolos[ultimoSimbolo].nombre, "@lis", TAM_LEXEMA + 1);
        strncpy(tablaSimbolos[ultimoSimbolo].tipoDato, "TIPOENT", 8);  // o "VECTOR" si lo soportás
        strncpy(tablaSimbolos[ultimoSimbolo].valor, "", TAM_LEXEMA + 1);
        strncpy(tablaSimbolos[ultimoSimbolo].longitud, "50", 4); // suponiendo 50 elementos
        ultimoSimbolo++;
    }

    // Variables auxiliares (enteras)
    char* vars[] = { "@can", "@ori", "@des", "@aux", "@piv" };
    for (int i = 0; i < 5; i++) {
        if (buscarEnTabla(vars[i]) == -1) {
            strncpy(tablaSimbolos[ultimoSimbolo].nombre, vars[i], TAM_LEXEMA + 1);
            strncpy(tablaSimbolos[ultimoSimbolo].tipoDato, "TIPOENT", 8);
            strncpy(tablaSimbolos[ultimoSimbolo].valor, "0", TAM_LEXEMA + 1);
            tablaSimbolos[ultimoSimbolo].longitud[0] = '\0';
            ultimoSimbolo++;
        }
    }
}

void declararTemporalesSliceAndConcat() {
    char* enteros[] = { "@ini", "@fin", "@lon", "@aux", "@pos" };
    char* cadenas = "@res";

    // Declarar variables enteras auxiliares
    for (int i = 0; i < 5; i++) {
        if (buscarEnTabla(enteros[i]) == -1) {
            strncpy(tablaSimbolos[ultimoSimbolo].nombre, enteros[i], TAM_LEXEMA + 1);
            strncpy(tablaSimbolos[ultimoSimbolo].tipoDato, "TIPOENT", 8);
            strncpy(tablaSimbolos[ultimoSimbolo].valor, "0", TAM_LEXEMA + 1);
            tablaSimbolos[ultimoSimbolo].longitud[0] = '\0';
            ultimoSimbolo++;
        }
    }

    // Declarar @res como cadena (TIPOCAD) resultado
    if (buscarEnTabla("@res") == -1) {
        strncpy(tablaSimbolos[ultimoSimbolo].nombre, "@res", TAM_LEXEMA + 1);
        strncpy(tablaSimbolos[ultimoSimbolo].tipoDato, "TIPOCAD", 8);
        strncpy(tablaSimbolos[ultimoSimbolo].valor, "", TAM_LEXEMA + 1);
        strncpy(tablaSimbolos[ultimoSimbolo].longitud, "100", 4); // Podés ajustar este tamaño si querés
        ultimoSimbolo++;
    }

    // Declarar @tem como vector temporal (TIPOCAD)
    if (buscarEnTabla("@tem") == -1) {
        strncpy(tablaSimbolos[ultimoSimbolo].nombre, "@tem", TAM_LEXEMA + 1);
        strncpy(tablaSimbolos[ultimoSimbolo].tipoDato, "TIPOCAD", 8);
        strncpy(tablaSimbolos[ultimoSimbolo].valor, "", TAM_LEXEMA + 1);
        strncpy(tablaSimbolos[ultimoSimbolo].longitud, "100", 4);
        ultimoSimbolo++;
    }

    // Declarar @pal1 y @pal2 como TIPOCAD
    char* palabras[] = { "@pal1", "@pal2" };
    for (int i = 0; i < 2; i++) {
        if (buscarEnTabla(palabras[i]) == -1) {
            strncpy(tablaSimbolos[ultimoSimbolo].nombre, palabras[i], TAM_LEXEMA + 1);
            strncpy(tablaSimbolos[ultimoSimbolo].tipoDato, "TIPOCAD", 8);
            strncpy(tablaSimbolos[ultimoSimbolo].valor, "", TAM_LEXEMA + 1);
            strncpy(tablaSimbolos[ultimoSimbolo].longitud, "100", 4);
            ultimoSimbolo++;
        }
    }
}

void generarArchivo()
{
    FILE *fp;
  
    fp = fopen ("symbol-table.txt", "w+t");
  
    fprintf(fp, "\n                       NOMBRE                       | TIPODATO |                       VALOR                        | LONGITUD ");
    fprintf(fp, "\n----------------------------------------------------|----------|----------------------------------------------------|----------\n");
  
    size_t i;
  
    for(i = 0; i < getCantidadSimbolos(); i++) {

        t_simbolo *punteroSimbolo = &tablaSimbolos[i];

        fprintf(fp, "%-*s|%*s|%*s|%*s\n", 52, punteroSimbolo->nombre,
            10, punteroSimbolo->tipoDato, 52, punteroSimbolo->valor, 10, punteroSimbolo->longitud);
    }

    fclose (fp);
}


