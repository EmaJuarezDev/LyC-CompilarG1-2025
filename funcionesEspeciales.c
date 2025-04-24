#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <float.h>
#include "tablaDeSimbolos.h"
#include "funcionesEspeciales.h"

char* sliceAndConcat(int li, int lf, const char* str1, const char* str2, int enPalabra1) {
    static char resultado[1024];  // buffer de salida

    // Validar límites
    if (li < 0 || lf > strlen(str1) || li >= lf) {
        sprintf(resultado, "ERROR");
        return resultado;
    }

    // Cortar substring
    char corte[1024];
    strncpy(corte, str1 + li, lf - li);
    corte[lf - li] = '\0';

    // Concatenar según bandera
    if (enPalabra1) {
        snprintf(resultado, sizeof(resultado), "%s%s", str2, corte);
    } else {
        snprintf(resultado, sizeof(resultado), "%s%s", str1, corte);
    }

    return resultado;
}