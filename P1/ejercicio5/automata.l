%{
/*
 * automata.l
 * Simulacion de un AFD que modela el ciclo de estados de un coche.
 *
 * Estados:
 *   q0 (INITIAL) -> motor apagado (estado inicial)
 *   q1           -> motor encendido, en reposo
 *   q2           -> acelerando
 *   q3           -> frenando
 *   q4           -> manteniendo velocidad
 *   q5           -> parado (estado final de aceptacion)
 *
 * Transiciones:
 *   ar : q0 -> q1
 *   ac : q1 -> q2  |  q2 -> q2  |  q4 -> q2
 *   m  : q1 -> q4  |  q2 -> q4  |  q3 -> q4
 *   f  : q1 -> q3  |  q3 -> q3  |  q4 -> q3
 *   c  : q2 -> q1  |  q3 -> q1  |  q4 -> q1
 *   p  : q3 -> q5
 *
 * Uso:
 *   ./automata.exe
 *   ./automata.exe entrada.txt
 *   ./automata.exe entrada.txt salida.txt
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%option case-insensitive

%x q1 q2 q3 q4 q5 LINE_ERR

%%

    /* espacios (ignorados en cualquier estado) */
<INITIAL,q1,q2,q3,q4,q5>[ \t]+   { /* ignorar */ }

    /* saltos de linea: la EVALUACION FINAL del automata */
<q5>\n                  { fprintf(yyout, "correcto\n\n"); BEGIN(INITIAL); }
<INITIAL>\n             { fprintf(yyout, "\n"); }
<q1,q2,q3,q4>\n         { fprintf(yyout, "no correcto\n\n"); BEGIN(INITIAL); }

    /* --- ESTADO q0 (INITIAL) --- */
<INITIAL>"ar"           { fprintf(yyout, "arrancar\n"); BEGIN(q1); }

    /* --- ESTADO q1 --- */
<q1>"ac"                { fprintf(yyout, "acelerar\n"); BEGIN(q2); }
<q1>"m"                 { fprintf(yyout, "mantener\n"); BEGIN(q4); }
<q1>"f"                 { fprintf(yyout, "frenar\n");   BEGIN(q3); }

    /* --- ESTADO q2 --- */
<q2>"ac"                { fprintf(yyout, "acelerar\n"); /* loop en q2 */ }
<q2>"c"                 { fprintf(yyout, "cambiar\n");  BEGIN(q1); }
<q2>"m"                 { fprintf(yyout, "mantener\n"); BEGIN(q4); }

    /* --- ESTADO q3 --- */
<q3>"f"                 { fprintf(yyout, "frenar\n");   /* loop en q3 */ }
<q3>"c"                 { fprintf(yyout, "cambiar\n");  BEGIN(q1); }
<q3>"m"                 { fprintf(yyout, "mantener\n"); BEGIN(q4); }
<q3>"p"                 { fprintf(yyout, "parar\n");    BEGIN(q5); }

    /* --- ESTADO q4 --- */
<q4>"ac"                { fprintf(yyout, "acelerar\n"); BEGIN(q2); }
<q4>"c"                 { fprintf(yyout, "cambiar\n");  BEGIN(q1); }
<q4>"f"                 { fprintf(yyout, "frenar\n");   BEGIN(q3); }

    /* --- ESTADO q5 (Aceptacion Final) --- */
    /* No tiene transiciones salientes. Cualquier cosa que no sea \n es error */

    /* --- TRANSICIONES INVALIDAS --- */
    /* Cualquier palabra suelta incorrecta (incluyendo 'm' en q4 si la evalua) */
<INITIAL,q1,q2,q3,q4,q5>[a-zA-Z]+  { fprintf(yyout, "no correcto\n"); BEGIN(LINE_ERR); }
    /* Simbolos extranos */
<INITIAL,q1,q2,q3,q4,q5>.          { fprintf(yyout, "no correcto\n"); BEGIN(LINE_ERR); }

    /* --- MODO PANICO (LINE_ERR) --- */
<LINE_ERR>[^\n]*\n      { fprintf(yyout, "\n"); BEGIN(INITIAL); }
<LINE_ERR>[^\n]*        { BEGIN(INITIAL); }

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
            if (strcmp(argv[1], argv[2]) == 0) 
            {
                fprintf(stderr, "Error: El archivo de salida debe ser diferente del archivo de entrada.\n");
                return EXIT_FAILURE;
            }

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
