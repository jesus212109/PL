%{
/* fecha-v1.l
 * Versión 1: reconocimiento puro con expresión regular.
 * Acepta tokens de la forma dd/mm/aaaa sin validación semántica.
 * (p.ej. 99/99/9999 sería aceptado)
 *
 * Uso:
 *   ./fecha-v1.exe
 *   ./fecha-v1.exe entrada.txt
 *   ./fecha-v1.exe entrada.txt salida.txt
 */
#include <stdio.h>
#include <stdlib.h>

%}

digit   [0-9]
date    {digit}{2}"/"{digit}{2}"/"{digit}{4}
spaces  [ \t\n]+

%%

{spaces}    { /* ignorar espacios */ }

{date}      { fprintf(yyout, "Fecha encontrada --> %s\n", yytext); }

.           { /* ignorar silenciosamente token desconocido */ }

%%

extern FILE *yyin, *yyout;

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
