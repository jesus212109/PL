#!/bin/bash
# Genera los ficheros .expected para los tests en español
# Ejecutar DESPUES de haber implementado las keywords en español
# Uso: bash generate-es.sh

INTERP="/home/jesus/PL/P2/Simulacro/interpreter.exe"
BASEDIR="/home/jesus/PL/PreparaciónExMoodle/tests-es"

echo "Generando ficheros .expected para tests en español..."
echo "Usando intérprete: $INTERP"
echo ""

for dir in "$BASEDIR"/*/; do
    [ -d "$dir" ] || continue
    for f in "$dir"/*.p; do
        [ -f "$f" ] || continue
        base=$(basename "$f" .p)
        expected="${f%.p}.expected"
        input_file="${f%.p}.input"
        
        if [ -f "$input_file" ]; then
            "$INTERP" "$f" < "$input_file" 2>&1 | sed 's/\x1b\[[0-9;]*m//g' > "$expected"
        else
            "$INTERP" "$f" 2>&1 | sed 's/\x1b\[[0-9;]*m//g' > "$expected"
        fi
        echo "  Generado: $(basename "$dir")/$base.expected"
    done
done

echo ""
echo "¡Listo! Ahora ejecuta: bash runner-es.sh"
