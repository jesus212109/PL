#!/bin/bash
# test.sh - Compila y prueba un ejercicio
# Uso: bash scripts/test.sh <numero_ejercicio>
#   bash scripts/test.sh 1   → ejecuta ejercicios/01-*/test.sh

DIR="$(cd "$(dirname "$0")/.." && pwd)"
EJERCICIO=$(printf "%02d" "$1" 2>/dev/null || echo "$1")

if [ -z "$EJERCICIO" ]; then
    echo "Uso: bash scripts/test.sh <numero>"
    echo "Ej:  bash scripts/test.sh 1"
    exit 1
fi

# Buscar el directorio del ejercicio
EJ_DIR=$(ls -d "$DIR/ejercicios/"$EJERCICIO-* 2>/dev/null | head -1)
if [ -z "$EJ_DIR" ]; then
    echo "Error: no se encuentra ejercicios/$EJERCICIO-*"
    exit 1
fi

echo "=== Test: $(basename $EJ_DIR) ==="

# Compilar
echo "Compilando ..."
make -C "$DIR" 2>&1
if [ $? -ne 0 ]; then
    echo "FAIL: error de compilacion"
    exit 1
fi

# Verificar 0 sr conflicts en la salida de bison
# (algunos ejercicios como if-then-end_if pueden tener 1, se chequea en el test especifico)

# Ejecutar test especifico del ejercicio
if [ -f "$EJ_DIR/test.sh" ]; then
    bash "$EJ_DIR/test.sh" "$DIR"
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
        echo "=== PASS ==="
    else
        echo "=== FAIL ==="
    fi
    exit $RESULT
else
    echo "No hay test.sh en $EJ_DIR"
    echo "=== SKIP ==="
    exit 0
fi
