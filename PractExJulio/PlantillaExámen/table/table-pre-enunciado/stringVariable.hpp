/*!	
	\file    stringVariable.hpp
	\brief   Declaration of StringVariable class
	\author  
	\date    2026-06-12
	\version 1.0
*/

#ifndef _STRINGVARIABLE_HPP_
#define _STRINGVARIABLE_HPP_

#include <string>
#include <iostream>

#include "variable.hpp"

namespace lp{

class StringVariable : public lp::Variable
{
	private:
		std::string _value;

	public:
		inline StringVariable(std::string name="", int token = 0, int type = 0,
		                       std::string value = ""):
			Variable(name, token, type)
		{
			this->_value = value;
		}

		inline std::string getValue() const
		{
			return this->_value;
		}

		inline void setValue(std::string value)
		{
			this->_value = value;
		}

		void read();

		void write() const;

};

}

#endif
