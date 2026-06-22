#!/bin/bash
# Test para ejercicio 2: do-while
DIR="$1"
cd "$DIR"

echo "=== Test 2: do-while ==="

output=$(./interpreter.exe ejercicios/02-do-while/input.txt 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
echo "$output"

for i in 0 1 2 3 4; do
    if ! echo "$output" | grep -q "print: $i"; then
        echo "FAIL: falta 'print: $i'"
        exit 1
    fi
done

echo "PASS: do-while funciona"
exit 0
