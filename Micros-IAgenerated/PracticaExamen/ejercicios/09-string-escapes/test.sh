#!/bin/bash
# Test para ejercicio 9: strings con escapes
DIR="$1"
cd "$DIR"

echo "=== Test 9: strings con escapes ==="

output=$(./interpreter.exe ejercicios/09-string-escapes/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

if ! echo "$output" | grep -q "Hola mundo"; then
    echo "FAIL: falta 'Hola mundo'"
    exit 1
fi
if ! echo "$output" | grep -q "Hello"; then
    echo "FAIL: falta 'Hello' (escape \\n)"
    exit 1
fi

echo "PASS: strings con escapes OK"
exit 0
