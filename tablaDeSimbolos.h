#ifndef TABLADESIMBOLOS_H_INCLUDED
#define TABLADESIMBOLOS_H_INCLUDED
#ifndef TAM_TABLA
#define TAM_TABLA 1000
#endif
#ifndef TAM_LEXEMA
#define TAM_LEXEMA 50
#endif

void agregarVariable(char*);
int buscarEnTabla(char*);
int getCantidadSimbolos();
void agregarConstanteInt(char*);
void agregarConstanteFlo(char*);
void agregarConstanteStr(char*);
void getTipoDato(char*, char*);
void agregarTipoDato(char*, int, int);
void generarArchivo();

typedef struct t_simbolo {
	char nombre[TAM_LEXEMA + 2];
 	char tipoDato[8];
 	char valor[TAM_LEXEMA + 2];
 	char longitud[4];
} t_simbolo;

#endif