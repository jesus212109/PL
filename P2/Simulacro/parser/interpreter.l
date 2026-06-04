/*! 
  \file interpreter.l
  \brief Lexical scanner file - Ejemplo 17 extendido para la practica PL
*/

/*
 * CAMBIOS vs Ejemplo 17 original:
 * - %option case-insensitive añadido
 * - Strings con comillas simples y secuencias de escape
 * - Comentarios de bloque (* ... *) y de línea # ...
 * - Identificadores con guiones bajos
 * - Nuevos operadores: :=, //, <>, ||, ++, --, +:=, -:=
 * - Operadores eliminados: =, ==, !=, &&, || (OR antiguo), !, %, {, }
 * - or, and, not, mod pasan a ser keywords registradas en la tabla
 */

%{
#include <iostream>
#include <stdlib.h>
#include <string.h>

#include "../includes/macros.hpp"
#include "../ast/ast.hpp"
#include "interpreter.tab.h"
#include "../error/error.hpp"
#include "../table/table.hpp"
#include "../table/numericVariable.hpp"

extern lp::Table table;
extern int lineNumber;
%}

/* --- OPTIONS --- */
%option case-insensitive
%option noyywrap

/* --- REGULAR DEFINITIONS --- */
DIGIT       [0-9]
LETTER      [a-zA-Z]
NUMBER      {DIGIT}+(\.{DIGIT}+)?([eE][+-]?{DIGIT}+)?
NUMBER1     {DIGIT}+\.?
NUMBER2     {DIGIT}*\.{DIGIT}+

/* NEW: identificador con guiones bajos (no puede terminar en _ ni tener __) */
IDENTIFIER  {LETTER}(_?({LETTER}|{DIGIT})+)*
BAD_ID      {LETTER}({LETTER}|{DIGIT}|_)*

/* NEW: cadena con comillas simples y escapes */
STRING_LIT  \'([^'\\]|\\.)*\'

/* NEW: estado para comentarios de bloque */
%x COMMENT

/* STATE (original de Ejemplo 17, para errores léxicos) */
%x ERROR

%%


[ \t]       { ; }

\n          { lineNumber++; }

";"         { return SEMICOLON; }

","         { return COMMA; }

{NUMBER}    {
    yylval.number = atof(yytext);
    return NUMBER;
}

#.*         { }

"(*"        { BEGIN(COMMENT); }
<COMMENT>"*)"   { BEGIN(INITIAL); }
<COMMENT>\n     { lineNumber++; }
<COMMENT>.      { }
<COMMENT><<EOF>> {
    warning("Lexical error", "Comment without closing");
    BEGIN(INITIAL);
    return 0;
}

{STRING_LIT}    {
    yytext[yyleng-1] = '\0';       /* quitar comilla final */
    char* content = yytext + 1;    /* saltar comilla inicial */
    char* result  = (char*)malloc(strlen(content) + 1);
    char* dest    = result;
    char* src     = content;

    while (*src) {
        if (*src == '\\') {
            src++;
            switch (*src) {
                case 'n':  *dest = '\n'; break;
                case 't':  *dest = '\t'; break;
                case '\\': *dest = '\\'; break;
                case '\'': *dest = '\''; break;
                case '0':  *dest = '\0'; break;
                default:   *dest = *src; break;
            }
        } else {
            *dest = *src;
        }
        dest++; src++;
    }
    *dest = '\0';

    yylval.string = result;
    return STRING;
}

{IDENTIFIER}    {

    if (yytext[yyleng-1] == '_') {
        warning("Lexical error", "Identifier cannot end with '_'");
        return 0;
    }
    if (strstr(yytext, "__") != NULL) {
        warning("Lexical error", "Identifier cannot contain '__'");
        return 0;
    }

    std::string identifier(yytext);
    yylval.string = strdup(yytext);

    if (table.lookupSymbol(identifier) == false) {

        lp::NumericVariable *n = new lp::NumericVariable(identifier, VARIABLE, UNDEFINED, 0.0);
        table.installSymbol(n);
        return VARIABLE;
    } else {
        lp::Symbol *s = table.getSymbol(identifier);
        return s->getToken();
    }
}

{BAD_ID}    {
    warning("Lexical error", "Malformed identifier");
}

"+:="   { return MAS_IGUAL; }       /* NEW */
"-:="   { return MENOS_IGUAL; }     /* NEW */
":="    { return ASSIGNMENT; }      /* MODIFIED: was '=' */
"++"    { return INCREMENTO; }      /* NEW */
"--"    { return DECREMENTO; }      /* NEW */
"<="    { return LESS_OR_EQUAL; }
">="    { return GREATER_OR_EQUAL; }
"<>"    { return NOT_EQUAL; }        /* MODIFIED: was '!=' */
"="     { return EQUAL; }           /* MODIFIED: equality comparison */
"<"     { return LESS_THAN; }
">"     { return GREATER_THAN; }
"||"    { return CONCAT; }          /* MODIFIED: was OR */
"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return MULTIPLICATION; }
"/"     { return DIVISION; }
"^"     { return POWER; }
"//"    { return DIV_ENTERA; }      /* NEW */
"?"     { return '?'; }
":"     { return ':'; }
"("     { return LPAREN; }
")"     { return RPAREN; }

<<EOF>> { return 0; }

.       { BEGIN(ERROR); yymore(); }

<ERROR>[^0-9+\-*/()\^% \t\n\;a-zA-Z=<>!&|?:] { yymore(); }

<ERROR>(.|\n) {
    yyless(yyleng-1);
    warning("Lexical error", yytext);
    BEGIN(INITIAL);
}

%%
