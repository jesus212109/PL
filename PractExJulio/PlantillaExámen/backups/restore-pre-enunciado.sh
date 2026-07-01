#!/bin/bash
# Restaura al estado PRE-ENUNCIADO (nada implementado, listo para practicar)
# Uso: ./restore-pre-enunciado.sh
# Diferencia con restore.sh: este restaura al estado donde el alumno
# tiene que implementar todo lo que pide el enunciado.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TODO_DIR=$(dirname "$SCRIPT_DIR")

echo "Restaurando al estado pre-enunciado (nada implementado)..."
rm -rf "$TODO_DIR/parser"
cp -r "$SCRIPT_DIR/parser-pre-enunciado" "$TODO_DIR/parser"
rm -rf "$TODO_DIR/table"
cp -r "$SCRIPT_DIR/table-pre-enunciado" "$TODO_DIR/table"
rm -rf "$TODO_DIR/ast"
cp -r "$SCRIPT_DIR/ast-pre-enunciado" "$TODO_DIR/ast"
echo "Hecho."
echo ""
echo "Estado actual:"
echo "  - AST: declaraciones de nodos nuevos (sin implementaciones)"
echo "  - Parser: Ejemplo 17 puro (1 SR conflict, en ingles)"
echo "  - Lexer: Ejemplo 17 puro (sin keywords en espanol)"
echo "  - Init: keywords solo en ingles"
echo "  - Token STRING declarado pero sin regla en lexer ni parser"
