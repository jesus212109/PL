/*!	
	\file   init.hpp
	\brief   Prototype of the function for the initialization of table of symbols
	\author  
	\date    2017-12-5
	\version 1.0
*/

#ifndef _INIT_HPP_
#define _INIT_HPP_

// sin, cos, atan, fabs, ...
#include <math.h>

#include "table.hpp"

// IMPORTANT: This file must be before y.tab.h
#include "../ast/ast.hpp"
///////////////////////////////////////

//  interpreter.tab.h contains the number values of the tokens produced by the parser
#include "../parser/interpreter.tab.h"

///////////////////////////////////////
// NEW in example 13
#include "mathFunction.hpp"
#include "builtinParameter1.hpp"
///////////////////////////////////////

///////////////////////////////////////
// NEW in example 14
#include "builtinParameter0.hpp"
#include "builtinParameter2.hpp"
///////////////////////////////////////

/*!
  \ brief Predefined numeric constants
*/
static struct {
          std::string name ;
	      double value;
	      } numericConstant[] = {
	                    {"pi",    3.14159265358979323846},
	                    {"e",     2.71828182845904523536},
	                    {"gamma", 0.57721566490153286060},
	                    {"deg",  57.29577951308232087680},
	                    {"phi",   1.61803398874989484820},
	                    {"",      0}
	                   };

/*!
  \ brief Predefined logical constants
*/
// NEW in example 16
static struct {
          std::string name ;
	      bool value;
	      } logicalConstant[] = { 
	                    {"verdadero", true},
	                    {"falso", false},
	                    {"",      0}
	                   };


// NEW in example 12 
/*!
  \ brief Predefined keywords
*/
static struct {
          std::string name ;
	      int token;
	      } keyword[] = { 
						{"escribir", ESCRIBIR},
						{"leer", LEER},
						{"leer_cadena", LEER_CADENA},
						{"si", SI},
						{"entonces", ENTONCES},
						{"si_no", SI_NO},
						{"fin_si", FIN_SI},
						{"mientras", MIENTRAS},
						{"hacer", HACER},
						{"fin_mientras", FIN_MIENTRAS},
						{"repetir", REPETIR},
						{"hasta", HASTA},        /* TO en para */
						{"hasta_que", HASTA_QUE}, /* UNTIL en repetir */
						{"para", PARA},
						{"desde", DESDE},
						{"paso", PASO},
						{"fin_para", FIN_PARA},
						{"selector", SELECCION},
						{"caso", CASO},
						{"defecto", DEFECTO},
						{"fin_selector", FIN_SELECCION},
						{"borrar_pantalla", BORRAR_PANTALLA},
						{"lugar", LUGAR},

						{"y", AND},
						{"o", OR},
						{"no", NOT},

						{"mod", MOD},						



	                    {"",      0}
	                   };



// NEW in example 13

static struct {    /* Predefined functions names */ 
                std::string name ;
				lp::TypePointerDoubleFunction_1 function;
              } function_1 [] = {
	                   {"seno",     sin},
		               {"coseno",     cos},
		               {"arctan",    atan},
		               {"log",     Log},
		               {"log10",   Log10},
		               {"exp",     Exp},
		               {"raiz",    Sqrt},
		               {"parte_entera", integer},
						{"valor_absoluto",     abs},
						{"abs",     fabs},
		               {"",       0}
		              };

// NEW in example 14
static struct {   
                std::string name ;
				lp::TypePointerDoubleFunction_0 function;
              } function_0 [] = {
						{"azar", Random},
		                {"",       0}
		              };


// NEW in example 14

static struct {    /* Nombres predefinidos de funciones con 2 argumentos */ 
                std::string name ;
				lp::TypePointerDoubleFunction_2 function;
              } function_2 [] = {
	                   {"arctan2",   Atan2},
		               {"",       0}
		              };







/*!		
	\brief   Initialize the table of symbols
	\return  void 
*/

void init(lp::Table &t);

// End of _INIT_HPP_
#endif
