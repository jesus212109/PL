#!/bin/bash
# Genera los ficheros .expected ejecutando el interprete contra cada .p
# Uso: ./generate-expected.sh
# ATENCION: Ejecutar cuando el interprete este completamente implementado

ROOT=$(cd "$(dirname "$0")" && pwd)
INTERP="../interpreter.exe"

if [ ! -f "$INTERP" ]; then
    echo "ERROR: No se encuentra $INTERP. Compila primero con 'make'."
    exit 1
fi

for test in "$ROOT"/*.p; do
    [ -f "$test" ] || continue
    expected="${test%.p}.expected"
    input_file="${test%.p}.input"
    echo "Generando: $(basename "$test" .p)"
    if [ -f "$input_file" ]; then
        "$INTERP" "$test" < "$input_file" > "$expected" 2>&1
    else
        "$INTERP" "$test" > "$expected" 2>&1
    fi
done

echo ""
echo "Todos los .expected generados."
echo "Revisa el contenido antes de commitear."
