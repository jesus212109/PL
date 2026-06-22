#!/bin/bash
# Ejecuta todos los tests en español y reporta diferencias
# Uso: ./runner-es.sh [--no-color]
ROOT=$(cd "$(dirname "$0")" && pwd)
INTERP="/home/jesus/PL/P2/main/interpreter.exe"
COLOR=1

if [ "$1" = "--no-color" ]; then
    COLOR=0
fi

echo "============================================"
echo " Tests en ESPAÑOL"
echo " main/interpreter.exe soporta ambos idiomas"
echo "============================================"
echo ""

TOTAL=0
PASS=0
FAIL=0

for dir in "$ROOT"/*/; do
    DIRNAME=$(basename "$dir")
    for test in "$dir"/*.p; do
        [ -f "$test" ] || continue
        name="${DIRNAME}/$(basename "$test" .p)"
        expected="${test%.p}.expected"
        [ -f "$expected" ] || continue
        TOTAL=$((TOTAL + 1))
        input_file="${test%.p}.input"
        
        if [ -f "$input_file" ]; then
            output=$("$INTERP" "$test" < "$input_file" 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
        else
            output=$("$INTERP" "$test" 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
        fi
        expected_content=$(cat "$expected")
        if [ "$output" = "$expected_content" ]; then
            if [ $COLOR -eq 1 ]; then
                echo -e "\033[32m✓\033[0m $name"
            else
                echo "✓ $name"
            fi
            PASS=$((PASS + 1))
        else
            if [ $COLOR -eq 1 ]; then
                echo -e "\033[31m✗\033[0m $name"
            else
                echo "✗ $name"
            fi
            echo "  --- Esperado ---"
            echo "$expected_content"
            echo "  --- Obtenido ---"
            echo "$output"
            echo "  ---"
            FAIL=$((FAIL + 1))
        fi
    done
done

echo ""
if [ $COLOR -eq 1 ]; then
    echo -e "\033[36m$PASS/$TOTAL tests pasan, $FAIL fallan\033[0m"
else
    echo "$PASS/$TOTAL tests pasan, $FAIL fallan"
fi
exit $FAIL
