#!/bin/bash
# Test para ejercicio 4: for con from/to/step
DIR="$1"
cd "$DIR"

echo "=== Test 4: for step to ==="

output=$(./interpreter.exe ejercicios/04-for-step-to/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

for i in 0 1 2 3 4; do
    if ! echo "$output" | grep -q "print: $i"; then
        echo "FAIL: falta 'print: $i'"
        exit 1
    fi
done

echo "PASS: for-step-to funciona"
exit 0
