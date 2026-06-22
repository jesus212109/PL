#!/bin/bash
# Test para ejercicio 7: while-do-end_while
DIR="$1"
cd "$DIR"

echo "=== Test 7: while-do-end_while ==="

output=$(./interpreter.exe ejercicios/07-while-do-end_while/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

for i in 0 1 2 3 4; do
    if ! echo "$output" | grep -q "print: $i"; then
        echo "FAIL: falta 'print: $i'"
        exit 1
    fi
done

echo "PASS: while-do-end_while funciona"
exit 0
