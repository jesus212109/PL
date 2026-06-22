/*! 
  \file interpreter.l
  \brief Lexical or scanner file
*/
%{
#include <iostream>

/*********************/
/* NEW in example 4 */
/* atof */
#include <stdlib.h>
/*********************/

/* Macros for the screen */
#include "../includes/macros.hpp"

/* Error recovery functions */
#include "../error/error.hpp"

/*********************/
/* 
  NEW in example 16 
  AST class
  IMPORTANT: must be written before interpreter.tab.h
*/
#include "../ast/ast.hpp"
/*********************/

/*  interpreter.tab.h contains the numeric values of the tokens produced by the parser */
#include "interpreter.tab.h"

/********************/
/* NEW in example 3 */
#include "../error/error.hpp"
/********************/


/*********************************************/
/* NEW in example 7 */
/* Table of symbols */
#include "../table/table.hpp"

#include "../table/numericVariable.hpp"

extern lp::Table table; //!< External Table of Symbols
/*********************************************/

extern int lineNumber; //!< External line counter

/* uso de strdup */
#include <string.h>


%}


/*! \name REGULAR DEFINITIONS  */

DIGIT  [0-9] 

LETTER [a-zA-Z]

NUMBER {DIGIT}+(\.{DIGIT}+)?([eE][+-]?{DIGIT}+)? 

IDENTIFIER  {LETTER}(_?({LETTER}|{DIGIT})+)*

/* NEW in example 3 */
/* STATE  */
%x ERROR COMMENT

/*! \name REGULAR EXPRESSIONS  */

STRING_LIT  \'([^'\\]|\\.)*\'

%%

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

[ \t] 	{ ; }    /* skip white space and tabular */

\n      { 
			/* Line counter */
           	lineNumber++; 
	
			/* MODIFIED in example 3 */
			/* COMMENTED in example 5 */
        	/* return NEWLINE; */
        }

";"		{
			/* NEW in example 5 */
			return SEMICOLON;
		}


","		{
			/* NEW in example 14 */
			return COMMA;
		}

{NUMBER}  {
					  /* MODIFIED in example 4 */
					  /* Conversion of type and sending of the numerical value to the parser */
					   yylval.number = atof(yytext); 

                       return NUMBER; 
                      }


{IDENTIFIER}   		 {
						 /* NEW in example 7 */
						 std::string identifier(yytext);

						// Check for invalid identifiers
						if (identifier[identifier.length()-1] == '_')
						{
							execerror("Invalid identifier: cannot end with underscore", yytext);
						}
						if (identifier.find("__") != std::string::npos)
						{
							execerror("Invalid identifier: cannot contain double underscore", yytext);
						}

						/* 
                          strdup() function returns a pointer to a new string 
                          which  is a duplicate of the string yytext
                        */
						
						// AÑADIR AQUÍ: convertir identifier a minúsculas
						for (size_t i = 0; i < identifier.length(); i++)
							identifier[i] = tolower(identifier[i]);

						  yylval.string =  strdup(yytext);

						/* If the identifier is not in the table of symbols then it is inserted */	
						 if (table.lookupSymbol(identifier) == false)
							{
								/* 
								 The identifier is inserted into the symbol table 
								 as undefined Variable with value 0.0
								*/
								lp::NumericVariable *n = new lp::NumericVariable(identifier,VARIABLE,UNDEFINED,0.0);

								/* A pointer to the new NumericVariable is inserted into the table of symbols */
								table.installSymbol(n);

								return VARIABLE;
							}

						/* MODIFIED in example 11 */
						/* 
							If the identifier is in the table of symbols then its token is returned 
								The identifier can be a variable or a numeric constant
						*/
						else 
							{
								lp::Symbol	*s = table.getSymbol(identifier);

/*
								std::cout << "lex: "<< s->getName() 
										  << "token " << s->getToken()
  										  << std::endl; 
*/

								/*  If the identifier is in the table then its token is returned  */
								return s->getToken();
							}
                     }

"-"		{ return MINUS;  } 			/* NEW in example 3 */
"+"		{ return PLUS;   } 			/* NEW in example 3 */

"*"	    { return MULTIPLICATION; } 	/* NEW in example 3 */
"/"     { return DIVISION; } 		/* NEW in example 3 */

"//"	{ return DIV_ENTERA; }

"("     { return LPAREN; } 			/* NEW in example 3 */
")"	    { return RPAREN; } 			/* NEW in example 3 */


"^"	    { return POWER; }			/* NEW in example 5 */

":=" 	{ return ASSIGNMENT; }		/* NEW in example 7 */


"="	{ return EQUAL; }			/* NEW in example 15 */

"<>"	{ return NOT_EQUAL; }		/* NEW in example 15 */

">="	{ return GREATER_OR_EQUAL; }/* NEW in example 15 */

"<="	{ return LESS_OR_EQUAL; }	/* NEW in example 15 */

">"		{ return GREATER_THAN; }	/* NEW in example 15 */

"<"		{ return LESS_THAN; }		/* NEW in example 15 */

"||"	{ return CONCAT; }

"{"		{ return LETFCURLYBRACKET; } 	/* NEW in example 17 */

"}"		{ return RIGHTCURLYBRACKET; }	/* NEW in example 17 */

":" { return ':'; }


<<EOF>> { /* The interpreter finishes when finds the end of file character */
		/*  PLACE(24,10);
	  	  std::cout <<  BICYAN;
	   	  std::cout <<  ">>>>>>> End of program <<<<<<<";
	 	  std::cout << std::endl;
	   	  std::cout << RESET;
		  PLACE(25,1);
		*/
	  	  return 0;
	}


.								{ 	
									/* Any other character */
									/* MODIFIIED in example 3 */
									/* Change to error state */
									BEGIN(ERROR); 

									/* 
										The current value of yytext 
										will be concatenated with the next character
									*/
									yymore();  
								}

<ERROR>[^0-9+\-*/()\^% \t\n\;a-zA-Z=<>!&]	{ /* MODIFIED in examples 5, 7, 15 */
								  /* NEW in example 3 */
								  /* 
									The current value of yytext 
									will be concatenated with the next character
								  */
									yymore(); 
								}

<ERROR>(.|\n)                { 
								/* NEW in example 3 */
								/* Rewind one position */
								yyless(yyleng-1); 

								/* Display the error message */
								warning("Lexical error", yytext);

								/* Restore the initial state */
   								BEGIN(INITIAL);
							}
%%

