# Generic makefile for Flex exercises
#
# Usage:
#   make              -> builds automata.exe (default)
#   make NAME=other   -> builds other.exe from other.l
#   make clean        -> removes generated files

NAME = automata

CFLAGS = -c -g -Wall -ansi -O2 \
         -Wno-unused-function -Wno-sign-compare -Wno-implicit-function-declaration

LFLAGS = -lfl

$(NAME).exe: $(NAME).o
	@echo "Linking $<  ->  $@"
	@gcc $< $(LFLAGS) -o $@

$(NAME).o: lex.yy.c
	@echo "Compiling lex.yy.c  ->  $@"
	@gcc $(CFLAGS) $< -o $@
	@echo "--> Removing auxiliary file: lex.yy.c"
	@rm -f lex.yy.c

lex.yy.c: $(NAME).l
	@echo "Running flex on $<"
	@flex $<

.PHONY: clean
clean:
	@echo "--> Cleaning generated files"
	@rm -f lex.yy.c *.o *.exe
