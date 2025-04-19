#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tablaDeSimbolos.h"

t_simbolo tablaSimbolos[TAM_TABLA];
int ultimoSimbolo = 0;

int insertarEnTabla(char* nombre, char* tipo, char* valor, char* longitud) {
	
  if(ultimoSimbolo == TAM_TABLA)
    return -1;
		
  strncpy(tablaSimbolos[ultimoSimbolo].nombre, nombre, TAM_LEXEMA + 1);
  strncpy(tablaSimbolos[ultimoSimbolo].tipoDato, tipo, 6);
  strncpy(tablaSimbolos[ultimoSimbolo].valor, valor, 52);
  strncpy(tablaSimbolos[ultimoSimbolo].longitud, longitud, 3);

return ultimoSimbolo++;
}

int buscarEnTabla(char *nombre) {

	int pos = 0;
	
    while(pos != ultimoSimbolo)
    {
		if(strcmp(nombre, tablaSimbolos[pos].nombre) == 0)
			return pos;
	
        pos++;
	}

	return -1;
}

int getCantidadSimbolos() {
	return ultimoSimbolo;
}

void generarArchivo()
{
    FILE *fp;
  
    fp = fopen ("tablaDeSimbolos.txt", "w+t");
  
    fprintf(fp, "\n                NOMBRE              |   TIPODATO    |               VALOR               |   LONGITUD    ");
    fprintf(fp, "\n________________________________________________________________________________________________________\n");
  
    size_t i;
  
    for(i = 0; i < getCantidadSimbolos(); i++) {

      t_simbolo *punteroSimbolo = &tablaSimbolos[i];

      fprintf(fp, " %-*s | %-*s | %*s | %*d |\n", 52, punteroSimbolo->nombre,
        16, punteroSimbolo->tipoDato, 52, punteroSimbolo->valor, 3, punteroSimbolo->longitud);
    }

    fclose (fp);
}
