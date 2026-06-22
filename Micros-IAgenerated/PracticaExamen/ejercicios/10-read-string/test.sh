#!/bin/bash
# Test para ejercicio 10: read_string y concatenacion
DIR="$1"
cd "$DIR"

echo "=== Test 10: concatenacion strings ==="

output=$(./interpreter.exe ejercicios/10-read-string/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

if ! echo "$output" | grep -q "Hola Mundo"; then
    echo "FAIL: falta 'Hola Mundo' (concatenacion)"
    exit 1
fi

echo "PASS: concatenacion OK"
exit 0
