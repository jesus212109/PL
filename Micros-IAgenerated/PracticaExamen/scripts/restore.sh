#!/bin/bash
# restore.sh - Limpia y restaura desde base/
# Uso: bash scripts/restore.sh

DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "Limpiando ..."
make -C "$DIR" clean 2>/dev/null
rm -f "$DIR"/interpreter.exe
echo "Restaurando desde base/ ..."
cp -a "$DIR/base/"* "$DIR/"
echo "Hecho."
