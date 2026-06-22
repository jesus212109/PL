#!/bin/bash
# Test para ejercicio 11: operadores pseudocodigo
DIR="$1"
cd "$DIR"

echo "=== Test 11: operadores pseudocodigo ==="

output=$(./interpreter.exe ejercicios/11-operadores-pseudocodigo/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

for v in 8 1 2; do
    if ! echo "$output" | grep -q "print: $v"; then
        echo "FAIL: falta 'print: $v'"
        exit 1
    fi
done

echo "PASS: operadores pseudocodigo OK"
exit 0
