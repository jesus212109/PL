/*! 
  \file    stringVariable.cpp
  \brief   Code of functions of StringVariable class
  \author  
  \date    2026-06-12
  \version 1.0
*/

#include <iostream>
#include <string>

#include "stringVariable.hpp"
#include "../includes/macros.hpp"


void lp::StringVariable::read()
{
    std::cout << BIYELLOW;
    std::cout << "Insert a string value --> ";
    std::cout << RESET;
    std::getline(std::cin, this->_value);
}


void lp::StringVariable::write() const
{
    std::cout << this->_value;
}
