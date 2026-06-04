%{
/* fecha-v2.l
 * Versión 2: regex + extracción con sscanf + validación semántica.
 * El regex captura la forma dd/mm/aaaa; luego sscanf extrae los campos
 * y fecha_valida() comprueba:
 *   - Mes en [1, 12]
 *   - Día en [1, días_del_mes(mes, año)]
 *   - Año bisiesto: divisible por 4, excepto siglos salvo múltiplos de 400
 *
 * Uso: igual que fecha-v1
 */
#include <stdio.h>
#include <stdlib.h>

static int fecha_valida(int dia, int mes, int anyo);

int dia, mes, anyo;
%}

digit   [0-9]
date    {digit}{2}"/"{digit}{2}"/"{digit}{4}
spaces  [ \t\n]+

%%

{spaces}    { /* ignorar espacios */ }

{date}      {
    sscanf(yytext, "%2d/%2d/%4d", &dia, &mes, &anyo);
    if (fecha_valida(dia, mes, anyo))
        fprintf(yyout, "Fecha valida   --> %02d/%02d/%04d\n", dia, mes, anyo);
    else
        fprintf(yyout, "Fecha invalida --> %02d/%02d/%04d\n", dia, mes, anyo);
}

.           { /* ignorar silenciosamente token desconocido */ }

%%

extern FILE *yyin;
extern FILE *yyout;

static int fecha_valida(int d, int m, int y) {
    int max_dias = 31;
    if (m == 4 || m == 6 || m == 9 || m == 11) max_dias = 30;
    else if (m == 2) max_dias = (y % 4 == 0 && (y % 100 != 0 || y % 400 == 0)) ? 29 : 28;
    return (m >= 1 && m <= 12) && (d >= 1 && d <= max_dias);
}

int main(int argc, char *argv[])
{
    if(argc > 3)
    {
        fprintf(stderr, "Numero de argumentos incorrecto, el formato debe ser:\n"
                        "\t- %s\n"
                        "\t- %s entrada.txt\n"
                        "\t- %s entrada.txt salida.txt\n", argv[0], argv[0], argv[0]);
        return EXIT_FAILURE;
    }

    switch(argc)
    {
        case 3:
            yyout = fopen(argv[2], "w");
            if (yyout == NULL) 
            {
                fprintf(stderr, "Error creando el archivo de salida: %s\n", argv[2]);
                return EXIT_FAILURE;
            }
            yyin = fopen(argv[1], "r");
            if (yyin == NULL) 
            {
                fprintf(stderr, "El archivo de entrada no existe: %s\n", argv[1]);
                fclose(yyout);
                return EXIT_FAILURE;
            }
            break;

        case 2:
            yyin = fopen(argv[1], "r");
            if (yyin == NULL) 
            {
                fprintf(stderr, "El archivo de entrada no existe: %s\n", argv[1]);
                return EXIT_FAILURE;
            }
            yyout = stdout;
            break;

        default:
            yyin = stdin;
            yyout = stdout;
            break;
    }

    yylex();

    if (yyin != stdin) fclose(yyin);
    if (yyout != stdout) fclose(yyout);

    return EXIT_SUCCESS;
}
