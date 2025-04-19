#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef TAM_TABLA
#define TAM_TABLA 1000
#endif
#ifndef TAM_LEXEMA
#define TAM_LEXEMA 100
#endif

typedef struct t_simbolo {
	char nombre[TAM_LEXEMA + 1];
 	char tipoDato[6];
 	char valor[52];
 	char longitud[3];
} t_simbolo;

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

char* getNombre(int pos) {
	return (tablaSimbolos[pos].nombre);
}

char* getTipo(int pos) {
	return (tablaSimbolos[pos].tipoDato);
}

char* getValor(int pos) {
	return (tablaSimbolos[pos].valor);
}

char* getLongitud(int pos) {
	return (tablaSimbolos[pos].longitud);
}

void borrarTiposDato() {
	ultimoSimbolo = ultimoSimbolo - 5;
}

int getCantidadSimbolos() {
	return ultimoSimbolo;
}

/*void imprimirTabla() {

  //printf("\n\n");
  //printf("Cantidad de elementos: %d\n", getCantidadSimbolos());
  
  //printf("---------------------------------------------------- TABLA DE SIMBOLOS -----------------|\n");
  printf("\n                NOMBRE              |   TIPODATO    |               VALOR               |   LONGITUD    ");
  printf("\n________________________________________________________________________________________________________\n");

  size_t i;

  for(i = 0; i < getCantidadSimbolos(); i++) {

    t_simbolo* punteroSimbolo = &tablaSimbolos[i];

    char linea[1024];
    memset( linea, 0, sizeof( linea ) );

    sprintf(linea, " %-*s | %*s | %*s | %*d |\n", (TAM_LEXEMA + 1), punteroSimbolo->nombre,
         16, punteroSimbolo->tipoDato, 52, punteroSimbolo->valor, 3, punteroSimbolo->longitud);
    printf("%s", linea );
  }

  printf("\n");
}*/

void generarArchivo()
{
    FILE *fp;
  
    fp = fopen ("tablaSimbolos.txt", "w+");
  
    printf("\n                NOMBRE              |   TIPODATO    |               VALOR               |   LONGITUD    ");
    printf("\n________________________________________________________________________________________________________\n");
  
    size_t i;
  
    for(i = 0; i < getCantidadSimbolos(); i++) {

      t_simbolo *punteroSimbolo = &tablaSimbolos[i];

        fprintf(fp, " %-*s | %*s | %*s | %*d |\n", (TAM_LEXEMA + 1), punteroSimbolo->nombre,
            16, punteroSimbolo->tipoDato, 52, punteroSimbolo->valor, 3, punteroSimbolo->longitud);
    }

    fclose (fp);
}
