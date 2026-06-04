/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 7 "parser/interpreter.y"

#include <iostream>
#include <string>

/*******************************************/
/* NEW in example 5 */
/* pow */
#include <math.h>
/*******************************************/

/*******************************************/
/* NEW in example 6 */
/* Use for recovery of runtime errors */
#include <setjmp.h>
#include <signal.h>
/*******************************************/

/* Error recovery functions */
#include "../error/error.hpp"

/* Macros for the screen */
#include "../includes/macros.hpp"


/*******************************************/
/* 
  NEW in example 16
  AST class
  IMPORTANT: this file must be before init.hpp
*/
#include "../ast/ast.hpp"


/*******************************************/
/* NEW in example 7 */
/* Table of symbol */
#include "../table/table.hpp"
/*******************************************/

/*******************************************/
#include "../table/numericVariable.hpp"
/*******************************************/

/* NEW in example 15 */
#include "../table/logicalVariable.hpp"

/* NEW for practice */
#include "../table/stringVariable.hpp"

/*******************************************/
/* NEW in example 11 */
#include "../table/numericConstant.hpp"
/*******************************************/

/*******************************************/
/* NEW in example 15 */
#include "../table/logicalConstant.hpp"
/*******************************************/

/*******************************************/
/* NEW in example 13 */
#include "../table/builtinParameter1.hpp"
/*******************************************/

/*******************************************/
/* NEW in example 14 */
#include "../table/builtinParameter0.hpp"
#include "../table/builtinParameter2.hpp"
/*******************************************/


/*******************************************/
/* NEW in example 10 */
#include "../table/init.hpp"
/*******************************************/

/*! 
	\brief  Lexical or scanner function
	\return int
	\note   C++ requires that yylex returns an int value
	\sa     yyparser
*/
int yylex();


extern int lineNumber; //!< External line counter


/* NEW in example 15 */
extern bool interactiveMode; //!< Control the interactive mode of execution of the interpreter

/* New in example 17 */
extern int control; //!< External: to control the interactive mode in "if" and "while" sentences 




/***********************************************************/
/* NEW in example 2 */
extern std::string progname; //!<  Program name
/***********************************************************/

/*******************************************/
/* NEW in example 6 */
/*
 jhmp_buf
    This is an array type capable of storing the information of a calling environment to be restored later.
   This information is filled by calling macro setjmp and can be restored by calling function longjmp.
*/
jmp_buf begin; //!<  It enables recovery of runtime errors 
/*******************************************/


/*******************************************/
/* NEW in example 7 */
extern lp::Table table; //!< Extern Table of Symbols

/*******************************************/
/* NEW in example 16 */
extern lp::AST *root; //!< External root of the abstract syntax tree AST


#line 194 "interpreter.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "interpreter.tab.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_SEMICOLON = 3,                  /* SEMICOLON  */
  YYSYMBOL_COMMA = 4,                      /* COMMA  */
  YYSYMBOL_LPAREN = 5,                     /* LPAREN  */
  YYSYMBOL_RPAREN = 6,                     /* RPAREN  */
  YYSYMBOL_PLUS = 7,                       /* PLUS  */
  YYSYMBOL_MINUS = 8,                      /* MINUS  */
  YYSYMBOL_MULTIPLICATION = 9,             /* MULTIPLICATION  */
  YYSYMBOL_DIVISION = 10,                  /* DIVISION  */
  YYSYMBOL_GREATER_THAN = 11,              /* GREATER_THAN  */
  YYSYMBOL_LESS_THAN = 12,                 /* LESS_THAN  */
  YYSYMBOL_GREATER_OR_EQUAL = 13,          /* GREATER_OR_EQUAL  */
  YYSYMBOL_LESS_OR_EQUAL = 14,             /* LESS_OR_EQUAL  */
  YYSYMBOL_PRINT = 15,                     /* PRINT  */
  YYSYMBOL_READ = 16,                      /* READ  */
  YYSYMBOL_READ_STRING = 17,               /* READ_STRING  */
  YYSYMBOL_IF = 18,                        /* IF  */
  YYSYMBOL_THEN = 19,                      /* THEN  */
  YYSYMBOL_ELSE = 20,                      /* ELSE  */
  YYSYMBOL_END_IF = 21,                    /* END_IF  */
  YYSYMBOL_WHILE = 22,                     /* WHILE  */
  YYSYMBOL_DO = 23,                        /* DO  */
  YYSYMBOL_END_WHILE = 24,                 /* END_WHILE  */
  YYSYMBOL_REPEAT = 25,                    /* REPEAT  */
  YYSYMBOL_UNTIL = 26,                     /* UNTIL  */
  YYSYMBOL_FOR = 27,                       /* FOR  */
  YYSYMBOL_END_FOR = 28,                   /* END_FOR  */
  YYSYMBOL_FROM = 29,                      /* FROM  */
  YYSYMBOL_STEP = 30,                      /* STEP  */
  YYSYMBOL_TO = 31,                        /* TO  */
  YYSYMBOL_SWITCH = 32,                    /* SWITCH  */
  YYSYMBOL_CASE = 33,                      /* CASE  */
  YYSYMBOL_DEFAULT = 34,                   /* DEFAULT  */
  YYSYMBOL_END_SWITCH = 35,                /* END_SWITCH  */
  YYSYMBOL_CLEAR_SCREEN = 36,              /* CLEAR_SCREEN  */
  YYSYMBOL_PLACE = 37,                     /* PLACE  */
  YYSYMBOL_OR = 38,                        /* OR  */
  YYSYMBOL_AND = 39,                       /* AND  */
  YYSYMBOL_NOT = 40,                       /* NOT  */
  YYSYMBOL_LETFCURLYBRACKET = 41,          /* LETFCURLYBRACKET  */
  YYSYMBOL_RIGHTCURLYBRACKET = 42,         /* RIGHTCURLYBRACKET  */
  YYSYMBOL_DIV_ENTERA = 43,                /* DIV_ENTERA  */
  YYSYMBOL_CONCAT = 44,                    /* CONCAT  */
  YYSYMBOL_EQUAL = 45,                     /* EQUAL  */
  YYSYMBOL_NOT_EQUAL = 46,                 /* NOT_EQUAL  */
  YYSYMBOL_MODULO = 47,                    /* MODULO  */
  YYSYMBOL_ASSIGNMENT = 48,                /* ASSIGNMENT  */
  YYSYMBOL_MAS_IGUAL = 49,                 /* MAS_IGUAL  */
  YYSYMBOL_MENOS_IGUAL = 50,               /* MENOS_IGUAL  */
  YYSYMBOL_INCREMENTO = 51,                /* INCREMENTO  */
  YYSYMBOL_DECREMENTO = 52,                /* DECREMENTO  */
  YYSYMBOL_STRING = 53,                    /* STRING  */
  YYSYMBOL_NUMBER = 54,                    /* NUMBER  */
  YYSYMBOL_BOOL = 55,                      /* BOOL  */
  YYSYMBOL_VARIABLE = 56,                  /* VARIABLE  */
  YYSYMBOL_UNDEFINED = 57,                 /* UNDEFINED  */
  YYSYMBOL_CONSTANT = 58,                  /* CONSTANT  */
  YYSYMBOL_BUILTIN = 59,                   /* BUILTIN  */
  YYSYMBOL_60_ = 60,                       /* '?'  */
  YYSYMBOL_61_ = 61,                       /* ':'  */
  YYSYMBOL_UNARY = 62,                     /* UNARY  */
  YYSYMBOL_POWER = 63,                     /* POWER  */
  YYSYMBOL_YYACCEPT = 64,                  /* $accept  */
  YYSYMBOL_program = 65,                   /* program  */
  YYSYMBOL_stmtlist = 66,                  /* stmtlist  */
  YYSYMBOL_stmt = 67,                      /* stmt  */
  YYSYMBOL_controlSymbol = 68,             /* controlSymbol  */
  YYSYMBOL_if = 69,                        /* if  */
  YYSYMBOL_while = 70,                     /* while  */
  YYSYMBOL_for_stmt = 71,                  /* for_stmt  */
  YYSYMBOL_repeat = 72,                    /* repeat  */
  YYSYMBOL_do_while = 73,                  /* do_while  */
  YYSYMBOL_clear_screen = 74,              /* clear_screen  */
  YYSYMBOL_place = 75,                     /* place  */
  YYSYMBOL_switch_stmt = 76,               /* switch_stmt  */
  YYSYMBOL_case_list = 77,                 /* case_list  */
  YYSYMBOL_asgn = 78,                      /* asgn  */
  YYSYMBOL_print = 79,                     /* print  */
  YYSYMBOL_read = 80,                      /* read  */
  YYSYMBOL_exp = 81,                       /* exp  */
  YYSYMBOL_listOfExp = 82,                 /* listOfExp  */
  YYSYMBOL_restOfListOfExp = 83            /* restOfListOfExp  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if 1

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* 1 */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1079

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  64
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  20
/* YYNRULES -- Number of rules.  */
#define YYNRULES  75
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  181

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   316


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    61,     2,
       2,     2,     2,    60,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    62,    63
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   242,   242,   256,   261,   284,   295,   300,   305,   310,
     316,   320,   324,   328,   332,   336,   340,   344,   352,   358,
     363,   371,   379,   384,   392,   400,   409,   415,   422,   428,
     437,   443,   453,   459,   466,   470,   474,   478,   484,   488,
     494,   499,   505,   512,   517,   523,   530,   536,   541,   546,
     551,   556,   562,   567,   572,   577,   582,   587,   592,   597,
     602,   636,   641,   646,   651,   657,   662,   667,   672,   677,
     683,   689,   698,   703,   714,   719
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if 1
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "\"end of file\"", "error", "\"invalid token\"", "SEMICOLON", "COMMA",
  "LPAREN", "RPAREN", "PLUS", "MINUS", "MULTIPLICATION", "DIVISION",
  "GREATER_THAN", "LESS_THAN", "GREATER_OR_EQUAL", "LESS_OR_EQUAL",
  "PRINT", "READ", "READ_STRING", "IF", "THEN", "ELSE", "END_IF", "WHILE",
  "DO", "END_WHILE", "REPEAT", "UNTIL", "FOR", "END_FOR", "FROM", "STEP",
  "TO", "SWITCH", "CASE", "DEFAULT", "END_SWITCH", "CLEAR_SCREEN", "PLACE",
  "OR", "AND", "NOT", "LETFCURLYBRACKET", "RIGHTCURLYBRACKET",
  "DIV_ENTERA", "CONCAT", "EQUAL", "NOT_EQUAL", "MODULO", "ASSIGNMENT",
  "MAS_IGUAL", "MENOS_IGUAL", "INCREMENTO", "DECREMENTO", "STRING",
  "NUMBER", "BOOL", "VARIABLE", "UNDEFINED", "CONSTANT", "BUILTIN", "'?'",
  "':'", "UNARY", "POWER", "$accept", "program", "stmtlist", "stmt",
  "controlSymbol", "if", "while", "for_stmt", "repeat", "do_while",
  "clear_screen", "place", "switch_stmt", "case_list", "asgn", "print",
  "read", "exp", "listOfExp", "restOfListOfExp", YY_NULLPTR
};

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  return yytname[yysymbol];
}
#endif

#define YYPACT_NINF (-52)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-32)

#define yytable_value_is_error(Yyn) \
  ((Yyn) == YYTABLE_NINF)

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     -52,     5,   271,   -52,   -52,   -52,   906,     1,     6,   -52,
     -52,   -52,   -52,   -52,    16,     7,    20,   -30,   -22,   100,
      15,   -52,   -52,   -52,   -52,   -52,   -52,   -52,   -52,   -52,
      61,    62,    65,   906,   906,   906,   906,   -52,   -52,   -52,
     -52,    66,   995,   -38,    17,   906,   906,   -52,   -52,    19,
     906,   -52,   906,   -52,   -52,   865,   906,   906,   -52,   -52,
     865,   -52,   -52,   -52,   402,     9,     9,    70,   906,   906,
     906,   906,   906,   906,   906,   906,   906,   906,   906,   906,
     906,   906,   906,   906,   906,   906,    68,    75,    76,   744,
     785,   713,   441,    54,   473,   199,   100,    15,   -52,   995,
     995,   995,   -52,   995,   -52,   222,    88,    23,    23,     9,
       9,   680,   680,   680,   680,   177,  1016,     9,    52,   680,
     680,     9,   808,     9,   -52,   -52,   -52,   -52,   -52,   -52,
     906,   906,    63,   906,   906,   -52,   -52,   906,   370,   507,
     906,   155,   849,   906,   -19,   539,   222,   995,   -52,   -52,
     -52,   132,   -52,   906,   890,   906,    41,   -52,   102,   -52,
     573,   -52,    46,   -52,   931,   -52,   -52,   -52,   -52,   906,
     303,   -52,   605,   649,   972,   347,   -52,   -52,   -52,   681,
     -52
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       3,     0,     0,     1,     5,     6,     0,     0,     0,    18,
      18,    18,    18,    18,     0,     0,     0,     0,     0,     0,
       0,     4,    10,    11,    12,    13,    14,    15,    16,    17,
       0,     0,     0,     0,     0,     0,     0,    47,    46,    58,
      59,     0,    42,     0,     0,     0,     0,     3,     3,     0,
       0,    26,     0,    34,    35,     0,     0,     0,    36,    37,
       0,     7,     8,     9,     0,    54,    55,    69,    72,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    58,    59,    33,    32,
      38,    39,    41,    40,    53,    74,     0,    48,    49,    50,
      51,    61,    63,    62,    64,    68,    67,    52,    70,    65,
      66,    56,     0,    57,    43,    44,    45,     3,     3,    18,
       0,     0,     0,     0,     0,    73,    60,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    74,    71,     3,    19,
      21,     0,    24,     0,     0,     0,     0,    28,     0,    75,
       0,    25,     0,     3,     0,     3,    27,    20,     3,     0,
       0,     3,     0,     0,     0,     0,    29,    22,     3,     0,
      23
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -52,   -52,   -40,   -52,    18,   -52,   -52,   -52,   -52,   -52,
     -52,   -52,   -52,   -52,   -51,   -52,   -52,   -33,   -52,   -43
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_uint8 yydefgoto[] =
{
       0,     1,     2,    21,    45,    22,    23,    24,    25,    26,
      27,    28,    29,   144,    30,    31,    32,    42,   106,   135
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      64,    65,    66,    67,    98,     3,    43,    91,    92,   102,
      51,    44,    89,    90,   155,   156,   157,    94,    86,    95,
      87,    50,    99,   100,   101,    52,    53,   103,    46,    47,
      48,    49,    71,    72,    54,   105,   107,   108,   109,   110,
     111,   112,   113,   114,   115,   116,   117,   118,   119,   120,
     121,   122,   123,    69,    70,    71,    72,    73,    74,    75,
      76,    71,    72,    60,    61,    62,    79,    80,    63,   168,
      83,    68,    85,    88,   124,    93,   169,    69,    70,    71,
      72,   125,   126,   131,    77,    78,    85,   138,   139,    79,
      80,    81,    82,    83,   136,    79,   143,   141,   142,    83,
     145,   146,   165,   159,   147,   166,    84,   151,   160,    85,
     154,     0,     0,    79,    80,    85,     0,    83,     0,     0,
     162,     0,   164,   170,     0,   172,     0,     0,   173,     0,
       0,   175,     0,    85,     0,   161,   174,     0,   179,    69,
      70,    71,    72,    73,    74,    75,    76,   140,    55,    56,
      57,    58,    59,     0,     0,   128,     0,     0,   152,     0,
       0,     0,    69,    70,    71,    72,    73,    74,    75,    76,
      77,    78,     0,     0,     0,    79,    80,    81,    82,    83,
       0,     0,     0,     0,    69,    70,    71,    72,    73,    74,
      75,    76,    84,    77,    78,    85,     0,     0,    79,    80,
      81,    82,    83,   133,     0,     0,    69,    70,    71,    72,
      73,    74,    75,    76,     0,    84,    78,     0,    85,     0,
      79,    80,    81,    82,    83,     0,   134,     0,     0,    69,
      70,    71,    72,    73,    74,    75,    76,    77,    78,     0,
      85,     0,    79,    80,    81,    82,    83,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    84,
      77,    78,    85,     0,     0,    79,    80,    81,    82,    83,
       0,    -2,     4,     0,     5,     0,     0,     0,     0,     0,
       0,     0,    84,     0,     0,    85,     6,     7,     8,     9,
       0,     0,     0,    10,    11,     0,    12,     0,    13,     0,
       0,     0,     0,    14,     4,     0,     5,    15,    16,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     6,     7,
       8,     9,    17,    18,     0,    10,    11,    19,    12,    20,
      13,     0,     0,     0,     0,    14,   -31,   -31,   -31,    15,
      16,     0,     0,     0,     0,     0,     0,     0,     4,     0,
       5,     0,     0,     0,    17,    18,     0,     0,     0,    19,
       0,    20,     6,     7,     8,     9,     0,     0,     0,    10,
      11,     4,    12,     5,    13,     0,     0,     0,     0,    14,
     -30,   -30,   -30,    15,    16,     6,     7,     8,     9,     0,
     148,   149,    10,    11,     0,    12,     0,    13,    17,    18,
       0,     0,    14,    19,     0,    20,    15,    16,   104,    69,
      70,    71,    72,    73,    74,    75,    76,     0,     0,     0,
       0,    17,    18,     0,     0,     0,    19,     0,    20,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      77,    78,     4,     0,     5,    79,    80,    81,    82,    83,
       0,     0,     0,     0,     0,     0,     6,     7,     8,     9,
       0,     0,    84,    10,    11,    85,    12,   130,    13,     0,
       0,     0,     0,    14,     0,     0,     0,    15,    16,   132,
      69,    70,    71,    72,    73,    74,    75,    76,     0,     0,
       0,     0,    17,    18,     0,     0,     0,    19,     0,    20,
       0,     0,     0,     0,     0,     0,     0,     0,     4,     0,
       5,    77,    78,     0,     0,     0,    79,    80,    81,    82,
      83,     0,     6,     7,     8,     9,     0,     0,     0,    10,
      11,   150,    12,    84,    13,     0,    85,     0,     0,    14,
       0,     0,     0,    15,    16,   158,    69,    70,    71,    72,
      73,    74,    75,    76,     0,     0,     0,     0,    17,    18,
       0,     0,     0,    19,     0,    20,     0,     0,     0,     0,
       0,     0,     0,     0,     4,     0,     5,    77,    78,     0,
       0,     0,    79,    80,    81,    82,    83,     0,     6,     7,
       8,     9,     0,     0,   167,    10,    11,     0,    12,    84,
      13,     0,    85,     0,     0,    14,     4,     0,     5,    15,
      16,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       6,     7,     8,     9,    17,    18,     0,    10,    11,    19,
      12,    20,    13,     0,     0,     0,     0,    14,     0,     0,
     176,    15,    16,     0,     0,     0,     0,     0,     0,     0,
       4,     0,     5,     0,     0,     0,    17,    18,     0,     0,
       0,    19,     0,    20,     6,     7,     8,     9,     0,     0,
       0,    10,    11,     0,    12,     0,    13,   177,     0,     0,
       0,    14,     4,     0,     5,    15,    16,    69,    70,    71,
      72,   -32,   -32,   -32,   -32,     0,     6,     7,     8,     9,
      17,    18,     0,    10,    11,    19,    12,    20,    13,   180,
       0,     0,     0,    14,     4,     0,     5,    15,    16,     0,
       0,     0,     0,    79,    80,   -32,   -32,    83,     6,     7,
       8,     9,    17,    18,     0,   129,    11,    19,    12,    20,
      13,     0,     0,    85,     0,    14,     0,     0,     0,    15,
      16,    69,    70,    71,    72,    73,    74,    75,    76,     0,
       0,     0,     0,   127,    17,    18,     0,     0,     0,    19,
       0,    20,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    77,    78,     0,     0,     0,    79,    80,    81,
      82,    83,    69,    70,    71,    72,    73,    74,    75,    76,
       0,     0,     0,     0,    84,     0,     0,    85,   128,     0,
       0,     0,     0,     0,     0,    69,    70,    71,    72,    73,
      74,    75,    76,    77,    78,     0,     0,     0,    79,    80,
      81,    82,    83,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    84,    77,    78,    85,     0,
       0,    79,    80,    81,    82,    83,    69,    70,    71,    72,
      73,    74,    75,    76,     0,     0,     0,     0,    84,   137,
      33,    85,    34,    35,     0,     0,     0,     0,     0,     0,
     153,     0,     0,     0,     0,     0,     0,    77,    78,     0,
       0,     0,    79,    80,    81,    82,    83,    69,    70,    71,
      72,    73,    74,    75,    76,    36,     0,     0,     0,    84,
       0,    33,    85,    34,    35,     0,    17,    18,    37,    38,
       0,    96,     0,    97,    41,     0,     0,     0,    77,    78,
       0,     0,     0,    79,    80,    81,    82,    83,    69,    70,
      71,    72,    73,    74,    75,    76,    36,     0,     0,     0,
      84,   163,     0,    85,     0,     0,     0,     0,     0,    37,
      38,     0,    39,     0,    40,    41,     0,     0,     0,    77,
      78,     0,     0,     0,    79,    80,    81,    82,    83,    69,
      70,    71,    72,    73,    74,    75,    76,     0,     0,     0,
       0,    84,   171,     0,    85,   178,     0,     0,     0,     0,
       0,     0,    69,    70,    71,    72,    73,    74,    75,    76,
      77,    78,     0,     0,     0,    79,    80,    81,    82,    83,
       0,     0,     0,    69,    70,    71,    72,    73,    74,    75,
      76,     0,    84,    77,    78,    85,     0,     0,    79,    80,
      81,    82,    83,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    84,     0,     0,    85,    79,
      80,    81,    82,    83,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    85
};

static const yytype_int16 yycheck[] =
{
      33,    34,    35,    36,    55,     0,     5,    47,    48,    60,
       3,     5,    45,    46,    33,    34,    35,    50,    56,    52,
      58,     5,    55,    56,    57,     5,    56,    60,    10,    11,
      12,    13,     9,    10,    56,    68,    69,    70,    71,    72,
      73,    74,    75,    76,    77,    78,    79,    80,    81,    82,
      83,    84,    85,     7,     8,     9,    10,    11,    12,    13,
      14,     9,    10,    48,     3,     3,    43,    44,     3,    23,
      47,     5,    63,    56,     6,    56,    30,     7,     8,     9,
      10,     6,     6,    29,    38,    39,    63,   127,   128,    43,
      44,    45,    46,    47,     6,    43,    33,   130,   131,    47,
     133,   134,    61,   146,   137,     3,    60,   140,   148,    63,
     143,    -1,    -1,    43,    44,    63,    -1,    47,    -1,    -1,
     153,    -1,   155,   163,    -1,   165,    -1,    -1,   168,    -1,
      -1,   171,    -1,    63,    -1,     3,   169,    -1,   178,     7,
       8,     9,    10,    11,    12,    13,    14,   129,    48,    49,
      50,    51,    52,    -1,    -1,    23,    -1,    -1,     3,    -1,
      -1,    -1,     7,     8,     9,    10,    11,    12,    13,    14,
      38,    39,    -1,    -1,    -1,    43,    44,    45,    46,    47,
      -1,    -1,    -1,    -1,     7,     8,     9,    10,    11,    12,
      13,    14,    60,    38,    39,    63,    -1,    -1,    43,    44,
      45,    46,    47,     4,    -1,    -1,     7,     8,     9,    10,
      11,    12,    13,    14,    -1,    60,    39,    -1,    63,    -1,
      43,    44,    45,    46,    47,    -1,     4,    -1,    -1,     7,
       8,     9,    10,    11,    12,    13,    14,    38,    39,    -1,
      63,    -1,    43,    44,    45,    46,    47,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    60,
      38,    39,    63,    -1,    -1,    43,    44,    45,    46,    47,
      -1,     0,     1,    -1,     3,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    60,    -1,    -1,    63,    15,    16,    17,    18,
      -1,    -1,    -1,    22,    23,    -1,    25,    -1,    27,    -1,
      -1,    -1,    -1,    32,     1,    -1,     3,    36,    37,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    15,    16,
      17,    18,    51,    52,    -1,    22,    23,    56,    25,    58,
      27,    -1,    -1,    -1,    -1,    32,    33,    34,    35,    36,
      37,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     1,    -1,
       3,    -1,    -1,    -1,    51,    52,    -1,    -1,    -1,    56,
      -1,    58,    15,    16,    17,    18,    -1,    -1,    -1,    22,
      23,     1,    25,     3,    27,    -1,    -1,    -1,    -1,    32,
      33,    34,    35,    36,    37,    15,    16,    17,    18,    -1,
      20,    21,    22,    23,    -1,    25,    -1,    27,    51,    52,
      -1,    -1,    32,    56,    -1,    58,    36,    37,     6,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    -1,    -1,
      -1,    51,    52,    -1,    -1,    -1,    56,    -1,    58,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      38,    39,     1,    -1,     3,    43,    44,    45,    46,    47,
      -1,    -1,    -1,    -1,    -1,    -1,    15,    16,    17,    18,
      -1,    -1,    60,    22,    23,    63,    25,    26,    27,    -1,
      -1,    -1,    -1,    32,    -1,    -1,    -1,    36,    37,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    -1,    -1,
      -1,    -1,    51,    52,    -1,    -1,    -1,    56,    -1,    58,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     1,    -1,
       3,    38,    39,    -1,    -1,    -1,    43,    44,    45,    46,
      47,    -1,    15,    16,    17,    18,    -1,    -1,    -1,    22,
      23,    24,    25,    60,    27,    -1,    63,    -1,    -1,    32,
      -1,    -1,    -1,    36,    37,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    -1,    -1,    -1,    -1,    51,    52,
      -1,    -1,    -1,    56,    -1,    58,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,     1,    -1,     3,    38,    39,    -1,
      -1,    -1,    43,    44,    45,    46,    47,    -1,    15,    16,
      17,    18,    -1,    -1,    21,    22,    23,    -1,    25,    60,
      27,    -1,    63,    -1,    -1,    32,     1,    -1,     3,    36,
      37,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      15,    16,    17,    18,    51,    52,    -1,    22,    23,    56,
      25,    58,    27,    -1,    -1,    -1,    -1,    32,    -1,    -1,
      35,    36,    37,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
       1,    -1,     3,    -1,    -1,    -1,    51,    52,    -1,    -1,
      -1,    56,    -1,    58,    15,    16,    17,    18,    -1,    -1,
      -1,    22,    23,    -1,    25,    -1,    27,    28,    -1,    -1,
      -1,    32,     1,    -1,     3,    36,    37,     7,     8,     9,
      10,    11,    12,    13,    14,    -1,    15,    16,    17,    18,
      51,    52,    -1,    22,    23,    56,    25,    58,    27,    28,
      -1,    -1,    -1,    32,     1,    -1,     3,    36,    37,    -1,
      -1,    -1,    -1,    43,    44,    45,    46,    47,    15,    16,
      17,    18,    51,    52,    -1,    22,    23,    56,    25,    58,
      27,    -1,    -1,    63,    -1,    32,    -1,    -1,    -1,    36,
      37,     7,     8,     9,    10,    11,    12,    13,    14,    -1,
      -1,    -1,    -1,    19,    51,    52,    -1,    -1,    -1,    56,
      -1,    58,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    38,    39,    -1,    -1,    -1,    43,    44,    45,
      46,    47,     7,     8,     9,    10,    11,    12,    13,    14,
      -1,    -1,    -1,    -1,    60,    -1,    -1,    63,    23,    -1,
      -1,    -1,    -1,    -1,    -1,     7,     8,     9,    10,    11,
      12,    13,    14,    38,    39,    -1,    -1,    -1,    43,    44,
      45,    46,    47,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    60,    38,    39,    63,    -1,
      -1,    43,    44,    45,    46,    47,     7,     8,     9,    10,
      11,    12,    13,    14,    -1,    -1,    -1,    -1,    60,    61,
       5,    63,     7,     8,    -1,    -1,    -1,    -1,    -1,    -1,
      31,    -1,    -1,    -1,    -1,    -1,    -1,    38,    39,    -1,
      -1,    -1,    43,    44,    45,    46,    47,     7,     8,     9,
      10,    11,    12,    13,    14,    40,    -1,    -1,    -1,    60,
      -1,     5,    63,     7,     8,    -1,    51,    52,    53,    54,
      -1,    56,    -1,    58,    59,    -1,    -1,    -1,    38,    39,
      -1,    -1,    -1,    43,    44,    45,    46,    47,     7,     8,
       9,    10,    11,    12,    13,    14,    40,    -1,    -1,    -1,
      60,    61,    -1,    63,    -1,    -1,    -1,    -1,    -1,    53,
      54,    -1,    56,    -1,    58,    59,    -1,    -1,    -1,    38,
      39,    -1,    -1,    -1,    43,    44,    45,    46,    47,     7,
       8,     9,    10,    11,    12,    13,    14,    -1,    -1,    -1,
      -1,    60,    61,    -1,    63,    23,    -1,    -1,    -1,    -1,
      -1,    -1,     7,     8,     9,    10,    11,    12,    13,    14,
      38,    39,    -1,    -1,    -1,    43,    44,    45,    46,    47,
      -1,    -1,    -1,     7,     8,     9,    10,    11,    12,    13,
      14,    -1,    60,    38,    39,    63,    -1,    -1,    43,    44,
      45,    46,    47,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    60,    -1,    -1,    63,    43,
      44,    45,    46,    47,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    63
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,    65,    66,     0,     1,     3,    15,    16,    17,    18,
      22,    23,    25,    27,    32,    36,    37,    51,    52,    56,
      58,    67,    69,    70,    71,    72,    73,    74,    75,    76,
      78,    79,    80,     5,     7,     8,    40,    53,    54,    56,
      58,    59,    81,     5,     5,    68,    68,    68,    68,    68,
       5,     3,     5,    56,    56,    48,    49,    50,    51,    52,
      48,     3,     3,     3,    81,    81,    81,    81,     5,     7,
       8,     9,    10,    11,    12,    13,    14,    38,    39,    43,
      44,    45,    46,    47,    60,    63,    56,    58,    56,    81,
      81,    66,    66,    56,    81,    81,    56,    58,    78,    81,
      81,    81,    78,    81,     6,    81,    82,    81,    81,    81,
      81,    81,    81,    81,    81,    81,    81,    81,    81,    81,
      81,    81,    81,    81,     6,     6,     6,    19,    23,    22,
      26,    29,     6,     4,     4,    83,     6,    61,    66,    66,
      68,    81,    81,    33,    77,    81,    81,    81,    20,    21,
      24,    81,     3,    31,    81,    33,    34,    35,     6,    83,
      66,     3,    81,    61,    81,    61,     3,    21,    23,    30,
      66,    61,    66,    66,    81,    66,    35,    28,    23,    66,
      28
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr1[] =
{
       0,    64,    65,    66,    66,    66,    67,    67,    67,    67,
      67,    67,    67,    67,    67,    67,    67,    67,    68,    69,
      69,    70,    71,    71,    72,    73,    74,    75,    76,    76,
      77,    77,    78,    78,    78,    78,    78,    78,    78,    78,
      78,    78,    79,    80,    80,    80,    81,    81,    81,    81,
      81,    81,    81,    81,    81,    81,    81,    81,    81,    81,
      81,    81,    81,    81,    81,    81,    81,    81,    81,    81,
      81,    81,    82,    82,    83,    83
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     0,     2,     2,     1,     2,     2,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     0,     6,
       8,     6,    10,    12,     6,     7,     2,     7,     6,     9,
       5,     4,     3,     3,     2,     2,     2,     2,     3,     3,
       3,     3,     2,     4,     4,     4,     1,     1,     3,     3,
       3,     3,     3,     3,     2,     2,     3,     3,     1,     1,
       4,     3,     3,     3,     3,     3,     3,     3,     3,     2,
       3,     5,     0,     2,     0,     3
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)




# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  yy_symbol_value_print (yyo, yykind, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)]);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


/* Context of a parse error.  */
typedef struct
{
  yy_state_t *yyssp;
  yysymbol_kind_t yytoken;
} yypcontext_t;

/* Put in YYARG at most YYARGN of the expected tokens given the
   current YYCTX, and return the number of tokens stored in YYARG.  If
   YYARG is null, return the number of expected tokens (guaranteed to
   be less than YYNTOKENS).  Return YYENOMEM on memory exhaustion.
   Return 0 if there are more than YYARGN expected tokens, yet fill
   YYARG up to YYARGN. */
static int
yypcontext_expected_tokens (const yypcontext_t *yyctx,
                            yysymbol_kind_t yyarg[], int yyargn)
{
  /* Actual size of YYARG. */
  int yycount = 0;
  int yyn = yypact[+*yyctx->yyssp];
  if (!yypact_value_is_default (yyn))
    {
      /* Start YYX at -YYN if negative to avoid negative indexes in
         YYCHECK.  In other words, skip the first -YYN actions for
         this state because they are default actions.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;
      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yyx;
      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
        if (yycheck[yyx + yyn] == yyx && yyx != YYSYMBOL_YYerror
            && !yytable_value_is_error (yytable[yyx + yyn]))
          {
            if (!yyarg)
              ++yycount;
            else if (yycount == yyargn)
              return 0;
            else
              yyarg[yycount++] = YY_CAST (yysymbol_kind_t, yyx);
          }
    }
  if (yyarg && yycount == 0 && 0 < yyargn)
    yyarg[0] = YYSYMBOL_YYEMPTY;
  return yycount;
}




#ifndef yystrlen
# if defined __GLIBC__ && defined _STRING_H
#  define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
# else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
# endif
#endif

#ifndef yystpcpy
# if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#  define yystpcpy stpcpy
# else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
# endif
#endif

#ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;
      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
#endif


static int
yy_syntax_error_arguments (const yypcontext_t *yyctx,
                           yysymbol_kind_t yyarg[], int yyargn)
{
  /* Actual size of YYARG. */
  int yycount = 0;
  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yyctx->yytoken != YYSYMBOL_YYEMPTY)
    {
      int yyn;
      if (yyarg)
        yyarg[yycount] = yyctx->yytoken;
      ++yycount;
      yyn = yypcontext_expected_tokens (yyctx,
                                        yyarg ? yyarg + 1 : yyarg, yyargn - 1);
      if (yyn == YYENOMEM)
        return YYENOMEM;
      else
        yycount += yyn;
    }
  return yycount;
}

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return -1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return YYENOMEM if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                const yypcontext_t *yyctx)
{
  enum { YYARGS_MAX = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  yysymbol_kind_t yyarg[YYARGS_MAX];
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* Actual size of YYARG. */
  int yycount = yy_syntax_error_arguments (yyctx, yyarg, YYARGS_MAX);
  if (yycount == YYENOMEM)
    return YYENOMEM;

  switch (yycount)
    {
#define YYCASE_(N, S)                       \
      case N:                               \
        yyformat = S;                       \
        break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
#undef YYCASE_
    }

  /* Compute error message size.  Don't count the "%s"s, but reserve
     room for the terminator.  */
  yysize = yystrlen (yyformat) - 2 * yycount + 1;
  {
    int yyi;
    for (yyi = 0; yyi < yycount; ++yyi)
      {
        YYPTRDIFF_T yysize1
          = yysize + yytnamerr (YY_NULLPTR, yytname[yyarg[yyi]]);
        if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
          yysize = yysize1;
        else
          return YYENOMEM;
      }
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return -1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yytname[yyarg[yyi++]]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep)
{
  YY_USE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2: /* program: stmtlist  */
#line 243 "parser/interpreter.y"
                  { 
		    // Create a new AST
			(yyval.prog) = new lp::AST((yyvsp[0].stmts)); 

			// Assign the AST to the root
			root = (yyval.prog); 

			// End of parsing
			//	return 1;
		  }
#line 1838 "interpreter.tab.c"
    break;

  case 3: /* stmtlist: %empty  */
#line 256 "parser/interpreter.y"
                  { 
			// create a empty list of statements
			(yyval.stmts) = new std::list<lp::Statement *>(); 
		  }
#line 1847 "interpreter.tab.c"
    break;

  case 4: /* stmtlist: stmtlist stmt  */
#line 262 "parser/interpreter.y"
                  { 
			// copy up the list and add the stmt to it
			(yyval.stmts) = (yyvsp[-1].stmts);
			(yyval.stmts)->push_back((yyvsp[0].st));

			// Control the interative mode of execution of the interpreter
			if (interactiveMode == true && control == 0)
 			{
				for(std::list<lp::Statement *>::iterator it = (yyval.stmts)->begin(); 
						it != (yyval.stmts)->end(); 
						it++)
				{
					(*it)->printAST();
					(*it)->evaluate();
					
				}

				// Delete the AST code, because it has already run in the interactive mode.
				(yyval.stmts)->clear();
			}
		}
#line 1873 "interpreter.tab.c"
    break;

  case 5: /* stmtlist: stmtlist error  */
#line 285 "parser/interpreter.y"
      { 
			 // just copy up the stmtlist when an error occurs
			 (yyval.stmts) = (yyvsp[-1].stmts);

			 // The previous look-ahead token ought to be discarded with `yyclearin;'
			 yyclearin; 
       }
#line 1885 "interpreter.tab.c"
    break;

  case 6: /* stmt: SEMICOLON  */
#line 296 "parser/interpreter.y"
          {
		// Create a new empty statement node
		(yyval.st) = new lp::EmptyStmt(); 
	  }
#line 1894 "interpreter.tab.c"
    break;

  case 7: /* stmt: asgn SEMICOLON  */
#line 301 "parser/interpreter.y"
          {
		// Default action
		// $$ = $1;
	  }
#line 1903 "interpreter.tab.c"
    break;

  case 8: /* stmt: print SEMICOLON  */
#line 306 "parser/interpreter.y"
          {
		// Default action
		// $$ = $1;
	  }
#line 1912 "interpreter.tab.c"
    break;

  case 9: /* stmt: read SEMICOLON  */
#line 311 "parser/interpreter.y"
          {
		// Default action
		// $$ = $1;
	  }
#line 1921 "interpreter.tab.c"
    break;

  case 10: /* stmt: if  */
#line 317 "parser/interpreter.y"
         {
	 }
#line 1928 "interpreter.tab.c"
    break;

  case 11: /* stmt: while  */
#line 321 "parser/interpreter.y"
         {
	 }
#line 1935 "interpreter.tab.c"
    break;

  case 12: /* stmt: for_stmt  */
#line 325 "parser/interpreter.y"
         {
	 }
#line 1942 "interpreter.tab.c"
    break;

  case 13: /* stmt: repeat  */
#line 329 "parser/interpreter.y"
         {
	 }
#line 1949 "interpreter.tab.c"
    break;

  case 14: /* stmt: do_while  */
#line 333 "parser/interpreter.y"
         {
	 }
#line 1956 "interpreter.tab.c"
    break;

  case 15: /* stmt: clear_screen  */
#line 337 "parser/interpreter.y"
         {
	 }
#line 1963 "interpreter.tab.c"
    break;

  case 16: /* stmt: place  */
#line 341 "parser/interpreter.y"
         {
	 }
#line 1970 "interpreter.tab.c"
    break;

  case 17: /* stmt: switch_stmt  */
#line 345 "parser/interpreter.y"
         {
	 }
#line 1977 "interpreter.tab.c"
    break;

  case 18: /* controlSymbol: %empty  */
#line 352 "parser/interpreter.y"
                {
			control++;
		}
#line 1985 "interpreter.tab.c"
    break;

  case 19: /* if: IF controlSymbol exp THEN stmtlist END_IF  */
#line 359 "parser/interpreter.y"
    {
		(yyval.st) = new lp::IfStmt((yyvsp[-3].expNode), new lp::BlockStmt((yyvsp[-1].stmts)));
		control--;
	}
#line 1994 "interpreter.tab.c"
    break;

  case 20: /* if: IF controlSymbol exp THEN stmtlist ELSE stmtlist END_IF  */
#line 364 "parser/interpreter.y"
         {
		(yyval.st) = new lp::IfStmt((yyvsp[-5].expNode), new lp::BlockStmt((yyvsp[-3].stmts)), new lp::BlockStmt((yyvsp[-1].stmts)));
		control--;
	 }
#line 2003 "interpreter.tab.c"
    break;

  case 21: /* while: WHILE controlSymbol exp DO stmtlist END_WHILE  */
#line 372 "parser/interpreter.y"
                {
			(yyval.st) = new lp::WhileStmt((yyvsp[-3].expNode), new lp::BlockStmt((yyvsp[-1].stmts)));
			control--;
    }
#line 2012 "interpreter.tab.c"
    break;

  case 22: /* for_stmt: FOR controlSymbol VARIABLE FROM exp TO exp DO stmtlist END_FOR  */
#line 380 "parser/interpreter.y"
    {
        (yyval.st) = new lp::ForStmt((yyvsp[-7].string), (yyvsp[-5].expNode), (yyvsp[-3].expNode), new lp::BlockStmt((yyvsp[-1].stmts)));
        control--;
    }
#line 2021 "interpreter.tab.c"
    break;

  case 23: /* for_stmt: FOR controlSymbol VARIABLE FROM exp TO exp STEP exp DO stmtlist END_FOR  */
#line 385 "parser/interpreter.y"
    {
        (yyval.st) = new lp::ForStmt((yyvsp[-9].string), (yyvsp[-7].expNode), (yyvsp[-5].expNode), new lp::BlockStmt((yyvsp[-1].stmts)), (yyvsp[-3].expNode));
        control--;
    }
#line 2030 "interpreter.tab.c"
    break;

  case 24: /* repeat: REPEAT controlSymbol stmtlist UNTIL exp SEMICOLON  */
#line 393 "parser/interpreter.y"
    {
        (yyval.st) = new lp::RepeatStmt(new lp::BlockStmt((yyvsp[-3].stmts)), (yyvsp[-1].expNode));
        control--;
    }
#line 2039 "interpreter.tab.c"
    break;

  case 25: /* do_while: DO controlSymbol stmtlist WHILE controlSymbol exp SEMICOLON  */
#line 401 "parser/interpreter.y"
    {
        (yyval.st) = new lp::DoWhileStmt(new lp::BlockStmt((yyvsp[-4].stmts)), (yyvsp[-1].expNode));
        control--;
        control--;
    }
#line 2049 "interpreter.tab.c"
    break;

  case 26: /* clear_screen: CLEAR_SCREEN SEMICOLON  */
#line 410 "parser/interpreter.y"
    {
        (yyval.st) = new lp::ClearScreenStmt();
    }
#line 2057 "interpreter.tab.c"
    break;

  case 27: /* place: PLACE LPAREN exp COMMA exp RPAREN SEMICOLON  */
#line 416 "parser/interpreter.y"
    {
        (yyval.st) = new lp::PlaceStmt((yyvsp[-4].expNode), (yyvsp[-2].expNode));
    }
#line 2065 "interpreter.tab.c"
    break;

  case 28: /* switch_stmt: SWITCH LPAREN exp RPAREN case_list END_SWITCH  */
#line 423 "parser/interpreter.y"
    {
        lp::SwitchStmt *sw = (lp::SwitchStmt *) (yyvsp[-1].st);
        sw->setSwitchExp((yyvsp[-3].expNode));
        (yyval.st) = sw;
    }
#line 2075 "interpreter.tab.c"
    break;

  case 29: /* switch_stmt: SWITCH LPAREN exp RPAREN case_list DEFAULT ':' stmtlist END_SWITCH  */
#line 429 "parser/interpreter.y"
    {
        lp::SwitchStmt *sw = (lp::SwitchStmt *) (yyvsp[-4].st);
        sw->setSwitchExp((yyvsp[-6].expNode));
        sw->setDefault(new lp::BlockStmt((yyvsp[-1].stmts)));
        (yyval.st) = sw;
    }
#line 2086 "interpreter.tab.c"
    break;

  case 30: /* case_list: case_list CASE exp ':' stmtlist  */
#line 438 "parser/interpreter.y"
    {
        lp::SwitchStmt *sw = (lp::SwitchStmt *) (yyvsp[-4].st);
        sw->addCase((yyvsp[-2].expNode), new lp::BlockStmt((yyvsp[0].stmts)));
        (yyval.st) = sw;
    }
#line 2096 "interpreter.tab.c"
    break;

  case 31: /* case_list: CASE exp ':' stmtlist  */
#line 444 "parser/interpreter.y"
    {
        lp::SwitchStmt *sw = new lp::SwitchStmt(NULL);
        sw->addCase((yyvsp[-2].expNode), new lp::BlockStmt((yyvsp[0].stmts)));
        (yyval.st) = (lp::Statement *) sw;
    }
#line 2106 "interpreter.tab.c"
    break;

  case 32: /* asgn: VARIABLE ASSIGNMENT exp  */
#line 454 "parser/interpreter.y"
                { 
			// Create a new assignment node
			(yyval.st) = new lp::AssignmentStmt((yyvsp[-2].string), (yyvsp[0].expNode));
		}
#line 2115 "interpreter.tab.c"
    break;

  case 33: /* asgn: VARIABLE ASSIGNMENT asgn  */
#line 460 "parser/interpreter.y"
                { 
			// Create a new assignment node
			(yyval.st) = new lp::AssignmentStmt((yyvsp[-2].string), (lp::AssignmentStmt *) (yyvsp[0].st));
		}
#line 2124 "interpreter.tab.c"
    break;

  case 34: /* asgn: INCREMENTO VARIABLE  */
#line 467 "parser/interpreter.y"
                {
			(yyval.st) = new lp::PreIncrementStmt((yyvsp[0].string), true);
		}
#line 2132 "interpreter.tab.c"
    break;

  case 35: /* asgn: DECREMENTO VARIABLE  */
#line 471 "parser/interpreter.y"
                {
			(yyval.st) = new lp::PreIncrementStmt((yyvsp[0].string), false);
		}
#line 2140 "interpreter.tab.c"
    break;

  case 36: /* asgn: VARIABLE INCREMENTO  */
#line 475 "parser/interpreter.y"
                {
			(yyval.st) = new lp::PostIncrementStmt((yyvsp[-1].string), true);
		}
#line 2148 "interpreter.tab.c"
    break;

  case 37: /* asgn: VARIABLE DECREMENTO  */
#line 479 "parser/interpreter.y"
                {
			(yyval.st) = new lp::PostIncrementStmt((yyvsp[-1].string), false);
		}
#line 2156 "interpreter.tab.c"
    break;

  case 38: /* asgn: VARIABLE MAS_IGUAL exp  */
#line 485 "parser/interpreter.y"
                {
			(yyval.st) = new lp::CompoundAssignmentStmt((yyvsp[-2].string), (yyvsp[0].expNode), PLUS);
		}
#line 2164 "interpreter.tab.c"
    break;

  case 39: /* asgn: VARIABLE MENOS_IGUAL exp  */
#line 489 "parser/interpreter.y"
                {
			(yyval.st) = new lp::CompoundAssignmentStmt((yyvsp[-2].string), (yyvsp[0].expNode), MINUS);
		}
#line 2172 "interpreter.tab.c"
    break;

  case 40: /* asgn: CONSTANT ASSIGNMENT exp  */
#line 495 "parser/interpreter.y"
                {   
 			execerror("Semantic error in assignment: it is not allowed to modify a constant ", (yyvsp[-2].string));
		}
#line 2180 "interpreter.tab.c"
    break;

  case 41: /* asgn: CONSTANT ASSIGNMENT asgn  */
#line 500 "parser/interpreter.y"
                {   
 			execerror("Semantic error in multiple assignment: it is not allowed to modify a constant ",(yyvsp[-2].string));
		}
#line 2188 "interpreter.tab.c"
    break;

  case 42: /* print: PRINT exp  */
#line 506 "parser/interpreter.y"
                {
			// Create a new print node
			 (yyval.st) = new lp::PrintStmt((yyvsp[0].expNode));
		}
#line 2197 "interpreter.tab.c"
    break;

  case 43: /* read: READ LPAREN VARIABLE RPAREN  */
#line 513 "parser/interpreter.y"
                {
			 (yyval.st) = new lp::ReadStmt((yyvsp[-1].string));
		}
#line 2205 "interpreter.tab.c"
    break;

  case 44: /* read: READ LPAREN CONSTANT RPAREN  */
#line 518 "parser/interpreter.y"
                {   
 			execerror("Semantic error in \"read statement\": it is not allowed to modify a constant ",(yyvsp[-1].string));
		}
#line 2213 "interpreter.tab.c"
    break;

  case 45: /* read: READ_STRING LPAREN VARIABLE RPAREN  */
#line 524 "parser/interpreter.y"
                {
			 (yyval.st) = new lp::ReadStmt((yyvsp[-1].string));
		}
#line 2221 "interpreter.tab.c"
    break;

  case 46: /* exp: NUMBER  */
#line 531 "parser/interpreter.y"
                { 
			(yyval.expNode) = new lp::NumberNode((yyvsp[0].number));
		}
#line 2229 "interpreter.tab.c"
    break;

  case 47: /* exp: STRING  */
#line 537 "parser/interpreter.y"
                {
			(yyval.expNode) = new lp::StringNode(std::string((yyvsp[0].string)));
		}
#line 2237 "interpreter.tab.c"
    break;

  case 48: /* exp: exp PLUS exp  */
#line 542 "parser/interpreter.y"
                { 
			 (yyval.expNode) = new lp::PlusNode((yyvsp[-2].expNode), (yyvsp[0].expNode));
		 }
#line 2245 "interpreter.tab.c"
    break;

  case 49: /* exp: exp MINUS exp  */
#line 547 "parser/interpreter.y"
        {
			(yyval.expNode) = new lp::MinusNode((yyvsp[-2].expNode), (yyvsp[0].expNode));
		}
#line 2253 "interpreter.tab.c"
    break;

  case 50: /* exp: exp MULTIPLICATION exp  */
#line 552 "parser/interpreter.y"
                { 
			(yyval.expNode) = new lp::MultiplicationNode((yyvsp[-2].expNode), (yyvsp[0].expNode));
		}
#line 2261 "interpreter.tab.c"
    break;

  case 51: /* exp: exp DIVISION exp  */
#line 557 "parser/interpreter.y"
                {
		  (yyval.expNode) = new lp::DivisionNode((yyvsp[-2].expNode), (yyvsp[0].expNode));
	   }
#line 2269 "interpreter.tab.c"
    break;

  case 52: /* exp: exp DIV_ENTERA exp  */
#line 563 "parser/interpreter.y"
                {
		  (yyval.expNode) = new lp::IntegerDivisionNode((yyvsp[-2].expNode), (yyvsp[0].expNode));
	   }
#line 2277 "interpreter.tab.c"
    break;

  case 53: /* exp: LPAREN exp RPAREN  */
#line 568 "parser/interpreter.y"
        { 
			(yyval.expNode) = (yyvsp[-1].expNode);
		 }
#line 2285 "interpreter.tab.c"
    break;

  case 54: /* exp: PLUS exp  */
#line 573 "parser/interpreter.y"
                { 
   		  (yyval.expNode) = new lp::UnaryPlusNode((yyvsp[0].expNode));
		}
#line 2293 "interpreter.tab.c"
    break;

  case 55: /* exp: MINUS exp  */
#line 578 "parser/interpreter.y"
                { 
   		  (yyval.expNode) = new lp::UnaryMinusNode((yyvsp[0].expNode));
		}
#line 2301 "interpreter.tab.c"
    break;

  case 56: /* exp: exp MODULO exp  */
#line 583 "parser/interpreter.y"
                {
		  (yyval.expNode) = new lp::ModuloNode((yyvsp[-2].expNode), (yyvsp[0].expNode));
       }
#line 2309 "interpreter.tab.c"
    break;

  case 57: /* exp: exp POWER exp  */
#line 588 "parser/interpreter.y"
        { 
   		  (yyval.expNode) = new lp::PowerNode((yyvsp[-2].expNode), (yyvsp[0].expNode));
		}
#line 2317 "interpreter.tab.c"
    break;

  case 58: /* exp: VARIABLE  */
#line 593 "parser/interpreter.y"
                {
		  (yyval.expNode) = new lp::VariableNode((yyvsp[0].string));
		}
#line 2325 "interpreter.tab.c"
    break;

  case 59: /* exp: CONSTANT  */
#line 598 "parser/interpreter.y"
                {
		  (yyval.expNode) = new lp::ConstantNode((yyvsp[0].string));
		}
#line 2333 "interpreter.tab.c"
    break;

  case 60: /* exp: BUILTIN LPAREN listOfExp RPAREN  */
#line 603 "parser/interpreter.y"
                {
			lp::Builtin *f= (lp::Builtin *) table.getSymbol((yyvsp[-3].string));
			if (f->getNParameters() ==  (int) (yyvsp[-1].parameters)->size())
			{
				switch(f->getNParameters())
				{
					case 0:
						{
							(yyval.expNode) = new lp::BuiltinFunctionNode_0((yyvsp[-3].string));
						}
						break;
					case 1:
						{
							lp::ExpNode *e = (yyvsp[-1].parameters)->front();
							(yyval.expNode) = new lp::BuiltinFunctionNode_1((yyvsp[-3].string),e);
						}
						break;
					case 2:
						{
							lp::ExpNode *e1 = (yyvsp[-1].parameters)->front();
							(yyvsp[-1].parameters)->pop_front();
							lp::ExpNode *e2 = (yyvsp[-1].parameters)->front();
							(yyval.expNode) = new lp::BuiltinFunctionNode_2((yyvsp[-3].string),e1,e2);
						}
						break;
					default:
				  			 execerror("Syntax error: too many parameters for function ", (yyvsp[-3].string));
				} 
			}
			else
	  			 execerror("Syntax error: incompatible number of parameters for function", (yyvsp[-3].string));
		}
#line 2370 "interpreter.tab.c"
    break;

  case 61: /* exp: exp GREATER_THAN exp  */
#line 637 "parser/interpreter.y"
                {
  			(yyval.expNode) = new lp::GreaterThanNode((yyvsp[-2].expNode),(yyvsp[0].expNode));
		}
#line 2378 "interpreter.tab.c"
    break;

  case 62: /* exp: exp GREATER_OR_EQUAL exp  */
#line 642 "parser/interpreter.y"
                {
  			(yyval.expNode) = new lp::GreaterOrEqualNode((yyvsp[-2].expNode),(yyvsp[0].expNode));
		}
#line 2386 "interpreter.tab.c"
    break;

  case 63: /* exp: exp LESS_THAN exp  */
#line 647 "parser/interpreter.y"
                {
  			(yyval.expNode) = new lp::LessThanNode((yyvsp[-2].expNode),(yyvsp[0].expNode));
		}
#line 2394 "interpreter.tab.c"
    break;

  case 64: /* exp: exp LESS_OR_EQUAL exp  */
#line 652 "parser/interpreter.y"
                {
  			(yyval.expNode) = new lp::LessOrEqualNode((yyvsp[-2].expNode),(yyvsp[0].expNode));
		}
#line 2402 "interpreter.tab.c"
    break;

  case 65: /* exp: exp EQUAL exp  */
#line 658 "parser/interpreter.y"
                {
  			(yyval.expNode) = new lp::EqualNode((yyvsp[-2].expNode),(yyvsp[0].expNode));
		}
#line 2410 "interpreter.tab.c"
    break;

  case 66: /* exp: exp NOT_EQUAL exp  */
#line 663 "parser/interpreter.y"
                {
  			(yyval.expNode) = new lp::NotEqualNode((yyvsp[-2].expNode),(yyvsp[0].expNode));
		}
#line 2418 "interpreter.tab.c"
    break;

  case 67: /* exp: exp AND exp  */
#line 668 "parser/interpreter.y"
                {
  			(yyval.expNode) = new lp::AndNode((yyvsp[-2].expNode),(yyvsp[0].expNode));
		}
#line 2426 "interpreter.tab.c"
    break;

  case 68: /* exp: exp OR exp  */
#line 673 "parser/interpreter.y"
                {
  			(yyval.expNode) = new lp::OrNode((yyvsp[-2].expNode),(yyvsp[0].expNode));
		}
#line 2434 "interpreter.tab.c"
    break;

  case 69: /* exp: NOT exp  */
#line 678 "parser/interpreter.y"
                {
  			(yyval.expNode) = new lp::NotNode((yyvsp[0].expNode));
		}
#line 2442 "interpreter.tab.c"
    break;

  case 70: /* exp: exp CONCAT exp  */
#line 684 "parser/interpreter.y"
                {
			(yyval.expNode) = new lp::ConcatenationNode((yyvsp[-2].expNode), (yyvsp[0].expNode));
		}
#line 2450 "interpreter.tab.c"
    break;

  case 71: /* exp: exp '?' exp ':' exp  */
#line 690 "parser/interpreter.y"
                {
			(yyval.expNode) = new lp::TernaryNode((yyvsp[-4].expNode), (yyvsp[-2].expNode), (yyvsp[0].expNode));
		}
#line 2458 "interpreter.tab.c"
    break;

  case 72: /* listOfExp: %empty  */
#line 698 "parser/interpreter.y"
                        {
			    // Create a new list STL
				(yyval.parameters) = new std::list<lp::ExpNode *>(); 
			}
#line 2467 "interpreter.tab.c"
    break;

  case 73: /* listOfExp: exp restOfListOfExp  */
#line 704 "parser/interpreter.y"
                        {
				(yyval.parameters) = (yyvsp[0].parameters);

				// Insert the expression in the list of expressions
				(yyval.parameters)->push_front((yyvsp[-1].expNode));
			}
#line 2478 "interpreter.tab.c"
    break;

  case 74: /* restOfListOfExp: %empty  */
#line 714 "parser/interpreter.y"
                        {
			    // Create a new list STL
				(yyval.parameters) = new std::list<lp::ExpNode *>(); 
			}
#line 2487 "interpreter.tab.c"
    break;

  case 75: /* restOfListOfExp: COMMA exp restOfListOfExp  */
#line 720 "parser/interpreter.y"
                        {
				// Get the list of expressions
				(yyval.parameters) = (yyvsp[0].parameters);

				// Insert the expression in the list of expressions
				(yyval.parameters)->push_front((yyvsp[-1].expNode));
			}
#line 2499 "interpreter.tab.c"
    break;


#line 2503 "interpreter.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      {
        yypcontext_t yyctx
          = {yyssp, yytoken};
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = yysyntax_error (&yymsg_alloc, &yymsg, &yyctx);
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == -1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *,
                             YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (yymsg)
              {
                yysyntax_error_status
                  = yysyntax_error (&yymsg_alloc, &yymsg, &yyctx);
                yymsgp = yymsg;
              }
            else
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = YYENOMEM;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == YYENOMEM)
          YYNOMEM;
      }
    }

  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
  return yyresult;
}

#line 731 "parser/interpreter.y"




