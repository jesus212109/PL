%{
/* analizador_lexico.l
 * Analizador léxico para un pseudolenguaje.
 * Tokens reconocidos:
 *   - Palabras reservadas: inicio fin si entonces si_no fin_si
 *                          leer escribir repetir hasta_que
 *   - Identificadores:     [a-zA-Z_][a-zA-Z0-9_]*
 *   - Enteros, reales, cadenas (comillas simples)
 *   - Operadores: := + - * / < > <= >= = <> ||
 *   - Puntuación: ( ) ;
 *   - Comentarios multilínea: << ... >>  (estado exclusivo COMMENT)
 *
 * Uso:
 *   ./analizador_lexico.exe
 *   ./analizador_lexico.exe entrada.txt
 *   ./analizador_lexico.exe entrada.txt salida.txt
 */

#include <stdio.h>
#include <stdlib.h>
%}

%option case-insensitive

/* --- Definiciones regulares --- */
letter      [a-zA-Z]
digit       [0-9]
identifier  {letter}(_?({letter}|{digit})+)*
number      {digit}+(\.{digit}+)?([eE][+-]?{digit}+)?
string_lit  \'([^'\\]|\\.)*\'
spaces      [ \t\n]+

bad_ident   {letter}({letter}|{digit}|_)*
bad_number  {digit}+(\.{digit}+){2,}

bad_sym         [$#@\?!~]
bad_ident_sym   {identifier}({bad_sym}({letter}|{digit}|_|{bad_sym})*)

/* Estado exclusivo para comentarios << >> */
%x COMMENT

%%

{spaces}            { /* descartar espacios */ }

"!!"[^\n]*\n        { /* comentario de línea */ }
"!!"[^\n]*          { /* comentario de línea sin newline */ }

"<<"                { BEGIN(COMMENT); }
<COMMENT>"<<"       { 
    fprintf(yyout, "[ERROR]         No se pueden anidar comentarios\n"); 
    return EXIT_FAILURE; 
}
<COMMENT>">>"       { BEGIN(INITIAL); }
<COMMENT>(.|\\n)    { /* descartar cuerpo del comentario */ }
<COMMENT><<EOF>>    { BEGIN(INITIAL); yyterminate(); }

"inicio"|"fin"|"si"|"entonces"|"si_no"|"fin_si"|"leer"|"escribir"|"mientras"|"hacer"|"fin_mientras"|"repetir"|"hasta_que"|"para"|"desde"|"hasta"|"paso"|"fin_para" { 
    fprintf(yyout, "[RESERVADA]   %s\n", yytext); 
}

{identifier}        { fprintf(yyout, "[IDENTIFICADOR] %s\n", yytext); }
{bad_ident}         { fprintf(yyout, "[ERROR]         Identificador mal formado: %s\n", yytext); }

{number}            { fprintf(yyout, "[NUMERO]        %s\n", yytext); }
{bad_number}        { fprintf(yyout, "[ERROR]         Numero mal formado: %s\n", yytext); }

{string_lit}        { 
    yytext[yyleng-1] = '\0'; 
    fprintf(yyout, "[CADENA]        %s\n", yytext + 1); 
}

":="|"+="|"-="|"*="|"/="|"++"|"--"|"//"|"%"|"**"|"||"|"+"|"-"|"*"|"/"|"=="|"<="|">="|"<>"|"<"|">"|"=" { 
    fprintf(yyout, "[OPERADOR]      %s\n", yytext); 
}

"#o"|"#y"|"#no"     { fprintf(yyout, "[OPERADOR_LOG]  %s\n", yytext); }

"("|")"|";"         { fprintf(yyout, "[PUNTUACION]    %s\n", yytext); }

{bad_ident_sym}     { fprintf(yyout, "[ERROR]         Identificador con simbolos invalidos: %s\n", yytext); }
.                   { fprintf(yyout, "[ERROR]         Token desconocido: %s\n", yytext); }

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
