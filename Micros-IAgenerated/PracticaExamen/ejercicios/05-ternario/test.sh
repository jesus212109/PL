#!/bin/bash
# Test para ejercicio 5: operador ternario ?:
DIR="$1"
cd "$DIR"

echo "=== Test 5: ternario ?: ==="

output=$(./interpreter.exe ejercicios/05-ternario/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

if ! echo "$output" | grep -q "print: 5"; then
    echo "FAIL: falta 'print: 5' (x > 3 ? x : y)"
    exit 1
fi
if ! echo "$output" | grep -q "print: 10"; then
    echo "FAIL: falta 'print: 10' (x > 10 ? x : y)"
    exit 1
fi

echo "PASS: ternario funciona"
exit 0
