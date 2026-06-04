/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_INTERPRETER_TAB_H_INCLUDED
# define YY_YY_INTERPRETER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    SEMICOLON = 258,               /* SEMICOLON  */
    COMMA = 259,                   /* COMMA  */
    LPAREN = 260,                  /* LPAREN  */
    RPAREN = 261,                  /* RPAREN  */
    PLUS = 262,                    /* PLUS  */
    MINUS = 263,                   /* MINUS  */
    MULTIPLICATION = 264,          /* MULTIPLICATION  */
    DIVISION = 265,                /* DIVISION  */
    GREATER_THAN = 266,            /* GREATER_THAN  */
    LESS_THAN = 267,               /* LESS_THAN  */
    GREATER_OR_EQUAL = 268,        /* GREATER_OR_EQUAL  */
    LESS_OR_EQUAL = 269,           /* LESS_OR_EQUAL  */
    PRINT = 270,                   /* PRINT  */
    READ = 271,                    /* READ  */
    READ_STRING = 272,             /* READ_STRING  */
    IF = 273,                      /* IF  */
    THEN = 274,                    /* THEN  */
    ELSE = 275,                    /* ELSE  */
    END_IF = 276,                  /* END_IF  */
    WHILE = 277,                   /* WHILE  */
    DO = 278,                      /* DO  */
    END_WHILE = 279,               /* END_WHILE  */
    REPEAT = 280,                  /* REPEAT  */
    UNTIL = 281,                   /* UNTIL  */
    FOR = 282,                     /* FOR  */
    END_FOR = 283,                 /* END_FOR  */
    FROM = 284,                    /* FROM  */
    STEP = 285,                    /* STEP  */
    TO = 286,                      /* TO  */
    SWITCH = 287,                  /* SWITCH  */
    CASE = 288,                    /* CASE  */
    DEFAULT = 289,                 /* DEFAULT  */
    END_SWITCH = 290,              /* END_SWITCH  */
    CLEAR_SCREEN = 291,            /* CLEAR_SCREEN  */
    PLACE = 292,                   /* PLACE  */
    OR = 293,                      /* OR  */
    AND = 294,                     /* AND  */
    NOT = 295,                     /* NOT  */
    LETFCURLYBRACKET = 296,        /* LETFCURLYBRACKET  */
    RIGHTCURLYBRACKET = 297,       /* RIGHTCURLYBRACKET  */
    DIV_ENTERA = 298,              /* DIV_ENTERA  */
    CONCAT = 299,                  /* CONCAT  */
    EQUAL = 300,                   /* EQUAL  */
    NOT_EQUAL = 301,               /* NOT_EQUAL  */
    MODULO = 302,                  /* MODULO  */
    ASSIGNMENT = 303,              /* ASSIGNMENT  */
    MAS_IGUAL = 304,               /* MAS_IGUAL  */
    MENOS_IGUAL = 305,             /* MENOS_IGUAL  */
    INCREMENTO = 306,              /* INCREMENTO  */
    DECREMENTO = 307,              /* DECREMENTO  */
    STRING = 308,                  /* STRING  */
    NUMBER = 309,                  /* NUMBER  */
    BOOL = 310,                    /* BOOL  */
    VARIABLE = 311,                /* VARIABLE  */
    UNDEFINED = 312,               /* UNDEFINED  */
    CONSTANT = 313,                /* CONSTANT  */
    BUILTIN = 314,                 /* BUILTIN  */
    UNARY = 315,                   /* UNARY  */
    POWER = 316                    /* POWER  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 144 "parser/interpreter.y"

  double number;
  char * string; 				 /* NEW in example 7 */
  bool logic;						 /* NEW in example 15 */
  lp::ExpNode *expNode;  			 /* NEW in example 16 */
  std::list<lp::ExpNode *>  *parameters;    // New in example 16; NOTE: #include<list> must be in interpreter.l, init.cpp, interpreter.cpp
  std::list<lp::Statement *> *stmts; /* NEW in example 16 */
  lp::Statement *st;				 /* NEW in example 16 */
  lp::AST *prog;					 /* NEW in example 16 */

#line 136 "interpreter.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_INTERPRETER_TAB_H_INCLUDED  */
