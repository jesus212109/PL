%{
/*
 * conversor.l
 * Conversor basico de C a pseudocodigo.
 * Sustituye palabras clave de C por sus equivalentes en pseudocodigo.
 * Protege comentarios, cadenas y caracteres para no traducir su interior.
 *
 * Traducciones:
 *   int     -> entero     double  -> real      main   -> principal
 *   const   -> constante  printf  -> escribir  scanf  -> leer
 *   if      -> si         return  -> devolver  do     -> hacer
 *   while   -> mientras   #include-> #incluir  { -> inicio  } -> fin
 *
 * El resto se transcribe sin modificar.
 *
 * Uso:
 *   ./conversor.exe
 *   ./conversor.exe entrada.c
 *   ./conversor.exe entrada.c salida.txt
 */

#include <stdio.h>
#include <stdlib.h>
%}

/* --- Definiciones regulares --- */
letter      [a-zA-Z_]
digit       [0-9]
identifier  {letter}({letter}|{digit})*

%x COMMENT_C
%x COMMENT_PSEUDO

%%

"//".*      { fprintf(yyout, "%s", yytext); }
"!!".*      { fprintf(yyout, "%s", yytext); }
\"([^\"\\]|\\.)*\"  { fprintf(yyout, "%s", yytext); }
'([^'\\]|\\.)*'     { fprintf(yyout, "%s", yytext); }

"/*"        { fprintf(yyout, "%s", yytext); BEGIN(COMMENT_C); }
<COMMENT_C>"*/"   { fprintf(yyout, "%s", yytext); BEGIN(INITIAL); }
<COMMENT_C>(.|\n) { fprintf(yyout, "%s", yytext); }

"<<"        { fprintf(yyout, "%s", yytext); BEGIN(COMMENT_PSEUDO); }
<COMMENT_PSEUDO>">>"  { fprintf(yyout, "%s", yytext); BEGIN(INITIAL); }
<COMMENT_PSEUDO>(.|\n) { fprintf(yyout, "%s", yytext); }

"int"       { fprintf(yyout, "entero"); }
"double"    { fprintf(yyout, "real"); }
"main"      { fprintf(yyout, "principal"); }
"const"     { fprintf(yyout, "constante"); }
"printf"    { fprintf(yyout, "escribir"); }
"scanf"     { fprintf(yyout, "leer"); }
"if"        { fprintf(yyout, "si"); }
"return"    { fprintf(yyout, "devolver"); }
"do"        { fprintf(yyout, "hacer"); }
"while"     { fprintf(yyout, "mientras"); }
"#include"  { fprintf(yyout, "#incluir"); }
"{"         { fprintf(yyout, "inicio"); }
"}"         { fprintf(yyout, "fin"); }

{identifier} { fprintf(yyout, "%s", yytext); }

.|\n        { fprintf(yyout, "%s", yytext); }

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
            {
                FILE *existe = fopen(argv[2], "r");
                if (existe != NULL)
                {
                    fprintf(stderr, "Error: el fichero de salida '%s' ya existe.\n", argv[2]);
                    fclose(existe);
                    return EXIT_FAILURE;
                }
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
