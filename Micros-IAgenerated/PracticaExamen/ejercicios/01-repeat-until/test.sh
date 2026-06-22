#!/bin/bash
# Test para ejercicio 1: repeat-until
DIR="$1"
cd "$DIR"

echo "=== Test 1: repeat-until ==="

# Ejecutar con input.txt
output=$(./interpreter.exe ejercicios/01-repeat-until/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

# Verificar salida esperada (print: 1 a print: 5)
for i in 1 2 3 4 5; do
    if ! echo "$output" | grep -q "print: $i"; then
        echo "FAIL: falta 'print: $i' en la salida"
        exit 1
    fi
done

echo "PASS: repeat-until funciona"
exit 0
