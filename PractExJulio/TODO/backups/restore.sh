#!/bin/bash
# Restaura los archivos del skeleton a su estado limpio
# Uso: ./restore.sh
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
TODO_DIR=$(dirname "$SCRIPT_DIR")

echo "Restaurando skeleton a estado limpio..."
rm -rf "$TODO_DIR/parser"
cp -r "$SCRIPT_DIR/parser-clean" "$TODO_DIR/parser"
rm -rf "$TODO_DIR/table"
cp -r "$SCRIPT_DIR/table-clean" "$TODO_DIR/table"
rm -rf "$TODO_DIR/ast"
cp -r "$SCRIPT_DIR/ast-clean" "$TODO_DIR/ast"
cp "$SCRIPT_DIR/interpreter.cpp-clean" "$TODO_DIR/interpreter.cpp"
echo "Hecho."
