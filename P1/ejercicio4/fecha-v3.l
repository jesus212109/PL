%{
/* fecha-v3.l
 * Version 3: validacion campo a campo mediante estados Flex exclusivos.
 * Los estados recorren el token de fecha: DIA -> SEP1 -> MES -> SEP2 -> ANYO
 * Cada campo se valida al reconocerse; al primer error se descarta el resto
 * de la linea (estado DATE_ERR).
 *
 * Maquina de estados:
 *   INITIAL  -> espera dos digitos (dia)
 *   SEP1     -> espera el primer '/'
 *   MES_ST   -> espera dos digitos (mes)
 *   SEP2     -> espera el segundo '/'
 *   ANYO_ST  -> espera cuatro digitos (anyo); hace la validacion completa
 *   DATE_ERR -> recuperacion de error: descarta hasta fin de linea
 *
 * Uso: igual que fecha-v1 y fecha-v2
 */
#include <stdio.h>
#include <stdlib.h>

static int dias_del_mes(int m, int y);

static int g_dia, g_mes, g_anyo;
%}

digit   [0-9]
spaces  [ \t\n]+

%x SEP1 MES_ST SEP2 ANYO_ST DATE_ERR

%%

{spaces}            { /* ignorar espacios */ }

{digit}{digit}      {
    g_dia = atoi(yytext);
    if (g_dia >= 1 && g_dia <= 31)
        BEGIN(SEP1);
    else {
        fprintf(yyout, "Fecha invalida --> dia %02d fuera de rango\n", g_dia);
        BEGIN(DATE_ERR);
    }
}

.   { /* ignorar silenciosamente token desconocido */ }

<SEP1>"/"           { BEGIN(MES_ST); }
<SEP1>[^/]          {
    fprintf(yyout, "Fecha invalida --> esperado '/' tras dia %02d\n", g_dia);
    BEGIN(DATE_ERR);
}

<MES_ST>{digit}{digit}  {
    g_mes = atoi(yytext);
    if (g_mes >= 1 && g_mes <= 12)
        BEGIN(SEP2);
    else {
        fprintf(yyout, "Fecha invalida --> mes %02d fuera de rango\n", g_mes);
        BEGIN(DATE_ERR);
    }
}
<MES_ST>(.|[\n])    {
    fprintf(yyout, "Fecha invalida --> esperados dos digitos de mes\n");
    BEGIN(DATE_ERR);
}

<SEP2>"/"           { BEGIN(ANYO_ST); }
<SEP2>[^/]          {
    fprintf(yyout, "Fecha invalida --> esperado '/' tras mes %02d\n", g_mes);
    BEGIN(DATE_ERR);
}

<ANYO_ST>{digit}{digit}{digit}{digit}   {
    g_anyo = atoi(yytext);
    if (g_dia >= 1 && g_dia <= dias_del_mes(g_mes, g_anyo))
        fprintf(yyout, "Fecha valida   --> %02d/%02d/%04d\n",
                g_dia, g_mes, g_anyo);
    else
        fprintf(yyout, "Fecha invalida --> %02d/%02d/%04d (dia fuera de rango)\n",
                g_dia, g_mes, g_anyo);
    BEGIN(INITIAL);
}
<ANYO_ST>(.|[\n])   {
    fprintf(yyout, "Fecha invalida --> esperados cuatro digitos de anyo\n");
    BEGIN(DATE_ERR);
}

<DATE_ERR>[^\n]*\n  { BEGIN(INITIAL); }
<DATE_ERR>[^\n]*    { BEGIN(INITIAL); }

%%

extern FILE *yyin;
extern FILE *yyout;

static int dias_del_mes(int m, int y) {
    int max_dias = 31;
    if (m == 4 || m == 6 || m == 9 || m == 11) max_dias = 30;
    else if (m == 2) max_dias = (y % 4 == 0 && (y % 100 != 0 || y % 400 == 0)) ? 29 : 28;
    return max_dias;
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
