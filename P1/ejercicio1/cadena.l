%{
/* cadena.l
 * Analizador léxico que interpreta secuencias de escape dentro de cadenas
 * delimitadas por comillas dobles.
 *   \"  -> "    \\  -> \    \n -> newline    \t -> tabulador
 * Las cadenas se muestran entre < y >.
 */
#include <stdio.h>
#include <stdlib.h>
%}

/* Estado exclusivo para el interior de una cadena */
%x STRING

%%

\"          { BEGIN(STRING); fprintf(yyout, "<"); }      /* abre cadena */

<STRING>\\t         { fprintf(yyout, "\t"); }            /* \t -> tab */
<STRING>\\n         { fprintf(yyout, "\n"); }            /* \n -> newline */
<STRING>\\\"        { fprintf(yyout, "\""); }            /* \" -> comilla */
<STRING>\\\\        { fprintf(yyout, "\\"); }            /* \\ -> barra */

<STRING>\"          { fprintf(yyout, ">"); BEGIN(INITIAL); }   /* cierra cadena */

<STRING>\n       { fprintf(yyout, ">"); BEGIN(INITIAL); }
<STRING><<EOF>>  { fprintf(yyout, ">"); BEGIN(INITIAL); yyterminate(); }

<STRING>[^\\\"\n]+  { fprintf(yyout, "%s", yytext); }   /* caracteres normales */

.|\n        { ECHO; }   /* fuera de cadena: pasar tal cual */

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
