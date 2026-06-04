/*! 
  \file interpreter.y
  \brief Grammar file
*/


%{
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

%}

/* In case of a syntactic error, more information is shown */
/* DEPRECATED */
/* %error-verbose */

/* ALTERNATIVA a %error-verbose */
%define parse.error verbose


/* Initial grammar symbol */
%start program

/*******************************************/
/* Data type YYSTYPE  */
/* NEW in example 4 */
%union {
  double number;
  char * string; 				 /* NEW in example 7 */
  bool logic;						 /* NEW in example 15 */
  lp::ExpNode *expNode;  			 /* NEW in example 16 */
  std::list<lp::ExpNode *>  *parameters;    // New in example 16; NOTE: #include<list> must be in interpreter.l, init.cpp, interpreter.cpp
  std::list<lp::Statement *> *stmts; /* NEW in example 16 */
  lp::Statement *st;				 /* NEW in example 16 */
  lp::AST *prog;					 /* NEW in example 16 */
}

/* Type of the non-terminal symbols */
%type <expNode> exp

/* NEW in example 14 */
%type <parameters> listOfExp  restOfListOfExp

%type <stmts> stmtlist

%type <st> stmt asgn print read if while
%type <st> for_stmt repeat do_while clear_screen place switch_stmt case_list /* NEW */

%type <prog> program

/* ===== ALL TOKEN DECLARATIONS ===== */
/* Basic tokens */
%token SEMICOLON
%token COMMA
%token LPAREN RPAREN
%token PLUS MINUS MULTIPLICATION DIVISION
%token GREATER_THAN LESS_THAN GREATER_OR_EQUAL LESS_OR_EQUAL


/* Keywords */
%token PRINT READ READ_STRING IF THEN ELSE END_IF
%token WHILE DO END_WHILE REPEAT UNTIL
%token FOR END_FOR FROM STEP TO
%token SWITCH CASE DEFAULT END_SWITCH
%token CLEAR_SCREEN PLACE
%token OR AND NOT 

/* Legacy braces */
%token LETFCURLYBRACKET RIGHTCURLYBRACKET

/* Operator tokens */
%token DIV_ENTERA CONCAT
%token EQUAL NOT_EQUAL MODULO
%token ASSIGNMENT MAS_IGUAL MENOS_IGUAL INCREMENTO DECREMENTO
%token <string> STRING

/* Token type declarations */
%token <number> NUMBER
%token <logic> BOOL
%token <string> VARIABLE UNDEFINED CONSTANT BUILTIN

/* Left associativity */

/*******************************************************/
/* NEW in example 15 */

%right '?' ':'            /* NEW: ternary operator */

%left OR

%left AND

%nonassoc EQUAL NOT_EQUAL GREATER_OR_EQUAL LESS_OR_EQUAL GREATER_THAN LESS_THAN

%left NOT

/*******************************************************/

/* MODIFIED in example 3 */
%left PLUS MINUS

%left CONCAT               /* NEW: string concatenation || */

/* MODIFIED in example 5 */
%left MULTIPLICATION DIVISION MODULO DIV_ENTERA

%left LPAREN RPAREN

%right INCREMENTO DECREMENTO /* NEW: pre/post increment/decrement */

%nonassoc  UNARY

// Maximum precedence 
/* MODIFIED in example 5 */
%right POWER

/* NEW: dangling-else resolution */
%nonassoc THEN
%nonassoc ELSE


%%
 //! \name Grammar rules

/* MODIFIED  Grammar in example 16 */

program : stmtlist
		  { 
		    // Create a new AST
			$$ = new lp::AST($1); 

			// Assign the AST to the root
			root = $$; 

			// End of parsing
			//	return 1;
		  }
;

stmtlist:  /* empty: epsilon rule */
		  { 
			// create a empty list of statements
			$$ = new std::list<lp::Statement *>(); 
		  }  

        | stmtlist stmt 
		  { 
			// copy up the list and add the stmt to it
			$$ = $1;
			$$->push_back($2);

			// Control the interative mode of execution of the interpreter
			if (interactiveMode == true && control == 0)
 			{
				for(std::list<lp::Statement *>::iterator it = $$->begin(); 
						it != $$->end(); 
						it++)
				{
					(*it)->printAST();
					(*it)->evaluate();
					
				}

				// Delete the AST code, because it has already run in the interactive mode.
				$$->clear();
			}
		}

    | stmtlist error 
      { 
			 // just copy up the stmtlist when an error occurs
			 $$ = $1;

			 // The previous look-ahead token ought to be discarded with `yyclearin;'
			 yyclearin; 
       } 
;
 

stmt: SEMICOLON  /* Empty statement: ";" */
	  {
		// Create a new empty statement node
		$$ = new lp::EmptyStmt(); 
	  }
	| asgn  SEMICOLON
	  {
		// Default action
		// $$ = $1;
	  }
	| print SEMICOLON
	  {
		// Default action
		// $$ = $1;
	  }
	| read SEMICOLON
	  {
		// Default action
		// $$ = $1;
	  }
	/*  NEW for practice */
	| if 
	 {
	 }
	/*  NEW for practice */
	| while 
	 {
	 }
	/*  NEW for practice */
	| for_stmt 
	 {
	 }
	/*  NEW for practice */
	| repeat 
	 {
	 }
	/*  NEW for practice */
	| do_while 
	 {
	 }
	/*  NEW for practice */
	| clear_screen 
	 {
	 }
	/*  NEW for practice */
	| place 
	 {
	 }
	/*  NEW for practice */
	| switch_stmt 
	 {
	 }
;


/* NEW for practice: control symbol prevents premature interactive evaluation */
controlSymbol:  /* Epsilon rule*/
		{
			control++;
		}
	;

/* NEW for practice: if-then-else-end_if */
if:	IF controlSymbol exp THEN stmtlist END_IF 
    {
		$$ = new lp::IfStmt($3, new lp::BlockStmt($5));
		control--;
	}
	| IF controlSymbol exp THEN stmtlist ELSE stmtlist END_IF 
	 {
		$$ = new lp::IfStmt($3, new lp::BlockStmt($5), new lp::BlockStmt($7));
		control--;
	 }
;

/* NEW for practice: while-do-end_while */
while:  WHILE controlSymbol exp DO stmtlist END_WHILE 
		{
			$$ = new lp::WhileStmt($3, new lp::BlockStmt($5));
			control--;
    }
;

/* NEW for practice: for loop */
for_stmt: FOR controlSymbol VARIABLE FROM exp TO exp DO stmtlist END_FOR
    {
        $$ = new lp::ForStmt($3, $5, $7, new lp::BlockStmt($9));
        control--;
    }
    | FOR controlSymbol VARIABLE FROM exp TO exp STEP exp DO stmtlist END_FOR
    {
        $$ = new lp::ForStmt($3, $5, $7, new lp::BlockStmt($11), $9);
        control--;
    }
;

/* NEW for practice: repeat-until */
repeat: REPEAT controlSymbol stmtlist UNTIL exp SEMICOLON
    {
        $$ = new lp::RepeatStmt(new lp::BlockStmt($3), $5);
        control--;
    }
;

/* NEW for practice: do-while */
do_while: DO controlSymbol stmtlist WHILE controlSymbol exp SEMICOLON
    {
        $$ = new lp::DoWhileStmt(new lp::BlockStmt($3), $6);
        control--;
        control--;
    }
;

/* NEW for practice: clear_screen */
clear_screen: CLEAR_SCREEN SEMICOLON
    {
        $$ = new lp::ClearScreenStmt();
    }
;

place: PLACE LPAREN exp COMMA exp RPAREN SEMICOLON
    {
        $$ = new lp::PlaceStmt($3, $5);
    }
;

/* NEW for practice: switch-case-default-end_switch */
switch_stmt: SWITCH LPAREN exp RPAREN case_list END_SWITCH
    {
        lp::SwitchStmt *sw = (lp::SwitchStmt *) $5;
        sw->setSwitchExp($3);
        $$ = sw;
    }
    | SWITCH LPAREN exp RPAREN case_list DEFAULT ':' stmtlist END_SWITCH
    {
        lp::SwitchStmt *sw = (lp::SwitchStmt *) $5;
        sw->setSwitchExp($3);
        sw->setDefault(new lp::BlockStmt($8));
        $$ = sw;
    }
;

case_list: case_list CASE exp ':' stmtlist
    {
        lp::SwitchStmt *sw = (lp::SwitchStmt *) $1;
        sw->addCase($3, new lp::BlockStmt($5));
        $$ = sw;
    }
    | CASE exp ':' stmtlist
    {
        lp::SwitchStmt *sw = new lp::SwitchStmt(NULL);
        sw->addCase($2, new lp::BlockStmt($4));
        $$ = (lp::Statement *) sw;
    }
;



asgn:   VARIABLE ASSIGNMENT exp 
		{ 
			// Create a new assignment node
			$$ = new lp::AssignmentStmt($1, $3);
		}

	|  VARIABLE ASSIGNMENT asgn 
		{ 
			// Create a new assignment node
			$$ = new lp::AssignmentStmt($1, (lp::AssignmentStmt *) $3);
		}

	/* NEW for practice: increment/decrement */
	| INCREMENTO VARIABLE
		{
			$$ = new lp::PreIncrementStmt($2, true);
		}
	| DECREMENTO VARIABLE
		{
			$$ = new lp::PreIncrementStmt($2, false);
		}
	| VARIABLE INCREMENTO
		{
			$$ = new lp::PostIncrementStmt($1, true);
		}
	| VARIABLE DECREMENTO
		{
			$$ = new lp::PostIncrementStmt($1, false);
		}

	/* NEW: compound assignment +:= and -:= */
	| VARIABLE MAS_IGUAL exp
		{
			$$ = new lp::CompoundAssignmentStmt($1, $3, PLUS);
		}
	| VARIABLE MENOS_IGUAL exp
		{
			$$ = new lp::CompoundAssignmentStmt($1, $3, MINUS);
		}

	   /* NEW in example 11 */ 
	| CONSTANT ASSIGNMENT exp 
		{   
 			execerror("Semantic error in assignment: it is not allowed to modify a constant ", $1);
		}
	   /* NEW in example 11 */ 
	| CONSTANT ASSIGNMENT asgn 
		{   
 			execerror("Semantic error in multiple assignment: it is not allowed to modify a constant ",$1);
		}
;

print:  PRINT exp 
		{
			// Create a new print node
			 $$ = new lp::PrintStmt($2);
		}
;	

read:  READ LPAREN VARIABLE RPAREN
		{
			 $$ = new lp::ReadStmt($3);
		}

	| READ LPAREN CONSTANT RPAREN
		{   
 			execerror("Semantic error in \"read statement\": it is not allowed to modify a constant ",$3);
		}

	/* NEW: read_string */
	| READ_STRING LPAREN VARIABLE RPAREN
		{
			 $$ = new lp::ReadStmt($3);
		}
;


exp:	NUMBER 
		{ 
			$$ = new lp::NumberNode($1);
		}

	/* NEW: string literal */
	| 	STRING
		{
			$$ = new lp::StringNode(std::string($1));
		}

	| 	exp PLUS exp 
		{ 
			 $$ = new lp::PlusNode($1, $3);
		 }

	| 	exp MINUS exp
      	{
			$$ = new lp::MinusNode($1, $3);
		}

	| 	exp MULTIPLICATION exp 
		{ 
			$$ = new lp::MultiplicationNode($1, $3);
		}

	| 	exp DIVISION exp
		{
		  $$ = new lp::DivisionNode($1, $3);
	   }

	/* NEW: integer division */
	| 	exp DIV_ENTERA exp
		{
		  $$ = new lp::IntegerDivisionNode($1, $3);
	   }

	| 	LPAREN exp RPAREN
       	{ 
			$$ = $2;
		 }

  	| 	PLUS exp %prec UNARY
		{ 
   		  $$ = new lp::UnaryPlusNode($2);
		}

	| 	MINUS exp %prec UNARY
		{ 
   		  $$ = new lp::UnaryMinusNode($2);
		}

	|	exp MODULO exp 
		{
		  $$ = new lp::ModuloNode($1, $3);
       }
	   	|	exp '?' exp ':' exp %prec '?'
		{
		  $$ = new lp::TernaryNode($1, $3, $5);
       }

	|	exp POWER exp 
      	{ 
   		  $$ = new lp::PowerNode($1, $3);
		}

	| VARIABLE
		{
		  $$ = new lp::VariableNode($1);
		}

	| CONSTANT
		{
		  $$ = new lp::ConstantNode($1);
		}

	| BUILTIN LPAREN listOfExp RPAREN
		{
			lp::Builtin *f= (lp::Builtin *) table.getSymbol($1);
			if (f->getNParameters() ==  (int) $3->size())
			{
				switch(f->getNParameters())
				{
					case 0:
						{
							$$ = new lp::BuiltinFunctionNode_0($1);
						}
						break;
					case 1:
						{
							lp::ExpNode *e = $3->front();
							$$ = new lp::BuiltinFunctionNode_1($1,e);
						}
						break;
					case 2:
						{
							lp::ExpNode *e1 = $3->front();
							$3->pop_front();
							lp::ExpNode *e2 = $3->front();
							$$ = new lp::BuiltinFunctionNode_2($1,e1,e2);
						}
						break;
					default:
				  			 execerror("Syntax error: too many parameters for function ", $1);
				} 
			}
			else
	  			 execerror("Syntax error: incompatible number of parameters for function", $1);
		}

	| exp GREATER_THAN exp
	 	{
  			$$ = new lp::GreaterThanNode($1,$3);
		}

	| exp GREATER_OR_EQUAL exp 
	 	{
  			$$ = new lp::GreaterOrEqualNode($1,$3);
		}

	| exp LESS_THAN exp 	
	 	{
  			$$ = new lp::LessThanNode($1,$3);
		}

	| exp LESS_OR_EQUAL exp 
	 	{
  			$$ = new lp::LessOrEqualNode($1,$3);
		}

	/* NEW: equality and inequality with = and <> */
	| exp EQUAL exp 	
	 	{
  			$$ = new lp::EqualNode($1,$3);
		}

    | exp NOT_EQUAL exp 	
	 	{
  			$$ = new lp::NotEqualNode($1,$3);
		}

    | exp AND exp 
	 	{
  			$$ = new lp::AndNode($1,$3);
		}

    | exp OR exp 
	 	{
  			$$ = new lp::OrNode($1,$3);
		}

    | NOT exp 
	 	{
  			$$ = new lp::NotNode($2);
		}

	/* NEW: string concatenation */
	| exp CONCAT exp
		{
			$$ = new lp::ConcatenationNode($1, $3);
		}

;


listOfExp: 
			/* Empty list of numeric expressions */
			{
			    // Create a new list STL
				$$ = new std::list<lp::ExpNode *>(); 
			}

	|  exp restOfListOfExp
			{
				$$ = $2;

				// Insert the expression in the list of expressions
				$$->push_front($1);
			}
;

restOfListOfExp:
			/* Empty list of numeric expressions */
			{
			    // Create a new list STL
				$$ = new std::list<lp::ExpNode *>(); 
			}

		|	COMMA exp restOfListOfExp
			{
				// Get the list of expressions
				$$ = $3;

				// Insert the expression in the list of expressions
				$$->push_front($2);
			}
;



%%



