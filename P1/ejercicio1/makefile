# Makefile genérico para ejercicios Flex
#
# Uso:
#   make              -> compila cadena.exe
#   make NAME=otro    -> compila otro.exe desde otro.l
#   make clean        -> elimina archivos generados

NAME = cadena

CFLAGS = -c -g -Wall -ansi -O2 \
         -Wno-unused-function -Wno-sign-compare -Wno-implicit-function-declaration
LFLAGS = -lfl

$(NAME).exe: $(NAME).o
	@echo "Enlazando $< -> $@"
	@gcc $< $(LFLAGS) -o $@

$(NAME).o: lex.yy.c
	@echo "Compilando lex.yy.c -> $@"
	@gcc $(CFLAGS) $< -o $@
	@rm -f lex.yy.c

lex.yy.c: $(NAME).l
	@echo "Ejecutando flex en $<"
	@flex $<

.PHONY: clean
clean:
	@rm -f lex.yy.c *.o *.exe
