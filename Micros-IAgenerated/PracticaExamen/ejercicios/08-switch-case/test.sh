#!/bin/bash
# Test para ejercicio 8: switch-case-default
DIR="$1"
cd "$DIR"

echo "=== Test 8: switch-case ==="

output=$(./interpreter.exe ejercicios/08-switch-case/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

if ! echo "$output" | grep -q "print: 20"; then
    echo "FAIL: debería imprimir '20' (case 2)"
    exit 1
fi

# No debe imprimir 10, 30, ni 0
for v in 10 30 0; do
    if echo "$output" | grep -q "print: $v"; then
        echo "FAIL: 'print: $v' no debería aparecer"
        exit 1
    fi
done

echo "PASS: switch-case funciona"
exit 0
