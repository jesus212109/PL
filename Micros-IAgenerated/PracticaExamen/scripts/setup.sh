#!/bin/bash
# setup.sh - Copia base/ a PracticaExamen/ (sobrescribe)
# Uso: bash scripts/setup.sh

DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "Copiando base/ a $DIR ..."
cp -a "$DIR/base/"* "$DIR/"
echo "Hecho."
