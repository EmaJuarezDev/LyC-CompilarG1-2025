#ifndef TABLADESIMBOLOS_H_INCLUDED
#define TABLADESIMBOLOS_H_INCLUDED
#ifndef TAM_TABLA
#define TAM_TABLA 1000
#endif
#ifndef TAM_LEXEMA
#define TAM_LEXEMA 100
#endif

int insertarEnTabla(char*, char*, char*, char*);
int buscarEnTabla(char*);
int getCantidadSimbolos();
void generarArchivo();

typedef struct t_simbolo {
	char nombre[TAM_LEXEMA + 1];
 	char tipoDato[7];
 	char valor[53];
 	char longitud[4];
} t_simbolo;

#endif