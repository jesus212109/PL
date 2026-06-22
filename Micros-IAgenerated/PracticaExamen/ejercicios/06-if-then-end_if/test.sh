#!/bin/bash
# Test para ejercicio 6: if-then-end_if
DIR="$1"
cd "$DIR"

echo "=== Test 6: if-then-end_if ==="

output=$(./interpreter.exe ejercicios/06-if-then-end_if/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

# Debe imprimir 10 (x > 3 es true)
if ! echo "$output" | grep -q "print: 10"; then
    echo "FAIL: falta 'print: 10'"
    exit 1
fi

# No debe imprimir 20 (else no se ejecuta)
if echo "$output" | grep -q "print: 20"; then
    echo "FAIL: 'print: 20' no debería aparecer (else ejecutado incorrectamente)"
    exit 1
fi

echo "PASS: if-then-end_if funciona"
exit 0
