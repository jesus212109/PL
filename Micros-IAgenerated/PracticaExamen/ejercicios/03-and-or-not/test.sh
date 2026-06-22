#!/bin/bash
# Test para ejercicio 3: and/or/not + case-insensitive
DIR="$1"
cd "$DIR"

echo "=== Test 3: and/or/not ==="

# Primero verificar que compila
output=$(./interpreter.exe ejercicios/03-and-or-not/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

if ! echo "$output" | grep -q "print: 0"; then
    echo "FAIL: falta print: 0 (and/x and y)"
    exit 1
fi
if ! echo "$output" | grep -q "print: 1"; then
    echo "FAIL: falta print: 1 (or/x or y)"
    exit 1
fi

# Test case-insensitive
echo "x = 1;" > /tmp/test_ci.txt
echo "PRINT x;" >> /tmp/test_ci.txt
output2=$(./interpreter.exe /tmp/test_ci.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
if ! echo "$output2" | grep -q "print: 1"; then
    echo "FAIL: case-insensitive no funciona (PRINT)"
    exit 1
fi

echo "PASS: and/or/not y case-insensitive OK"
exit 0
