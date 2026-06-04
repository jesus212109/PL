#!/bin/bash
#=====================================================
# simulacro.sh - Simulacro de examen PL
#   Preparacion y evaluacion automatica de 4 preguntas
#=====================================================

DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$DIR/backups"
TESTS_DIR="$DIR/tests"

ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================
# Funciones auxiliares
# ============================================================

hacer_backup() {
    mkdir -p "$BACKUP_DIR"
    for f in parser/interpreter.l parser/interpreter.y ast/ast.hpp ast/ast.cpp; do
        cp "$DIR/$f" "$BACKUP_DIR/$(basename "$f").bak" 2>/dev/null
    done
}

restaurar_backup() {
    for f in parser/interpreter.l parser/interpreter.y ast/ast.hpp ast/ast.cpp; do
        cp "$BACKUP_DIR/$(basename "$f").bak" "$DIR/$f" 2>/dev/null
    done
}

compilar() {
    make -C "$DIR" clean > /dev/null 2>&1
    make -C "$DIR" 2>/dev/null
    return $?
}

extraer_print() {
    sed 's/\x1b\[[0-9;]*m//g' | grep '^print:' | sed 's/^print: *//'
}

# ============================================================
# SETUP: eliminar codigo de cada pregunta
# ============================================================

setup_a() {
    echo -e "${CYAN}[SETUP A] Eliminando division entera //...${NC}"

    # interpreter.l: borrar linea del operador
    sed -i '/"\/\/".*DIV_ENTERA/d' "$DIR/parser/interpreter.l"

    # interpreter.y: quitar DIV_ENTERA de %token
    sed -i 's/%token DIV_ENTERA /%token /' "$DIR/parser/interpreter.y"
    # interpreter.y: quitar DIV_ENTERA de la linea de precedencia
    sed -i '/DIV_ENTERA/s/ DIV_ENTERA//' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar regla gramatical (5 lineas)
    sed -i '/\/\* NEW: integer division \*\//,+4d' "$DIR/parser/interpreter.y"

    # ast.hpp: borrar clase IntegerDivisionNode (7 lineas)
    sed -i '/\/\* NEW: Integer division node \*\//,+6d' "$DIR/ast/ast.hpp"

    # ast.cpp: borrar implementacion (14 lineas)
    sed -i '/IntegerDivisionNode implementation/,+13d' "$DIR/ast/ast.cpp"

    echo -e "${VERDE}  Hecho.${NC}"
}

setup_b() {
    echo -e "${CYAN}[SETUP B] Eliminando operador ternario ?:...${NC}"

    # interpreter.l: borrar lineas de ? y :
    sed -i '/"?"[[:space:]]*{ return .?.; }/d' "$DIR/parser/interpreter.l"
    sed -i '/":"[[:space:]]*{ return .:.; }/d' "$DIR/parser/interpreter.l"

    # interpreter.y: borrar declaracion de precedencia
    sed -i "/%right '?' ':'/d" "$DIR/parser/interpreter.y"
    # interpreter.y: borrar regla gramatical (5 lineas)
    sed -i '/\/\* NEW: ternary operator ?: \*\//,+4d' "$DIR/parser/interpreter.y"

    # ast.hpp: borrar clase TernaryNode (13 lineas)
    sed -i '/class TernaryNode : public ExpNode {/,/^};/{
      /^};/{
        s/^};/}/
        t
      }
      d
    }' "$DIR/ast/ast.hpp"
    # ast.hpp: borrar la linea vacia que queda + la linea del class (si falla lo de arriba)
    sed -i '/^}class TernaryNode/d' "$DIR/ast/ast.hpp"
}

setup_c() {
    echo -e "${CYAN}[SETUP C] Eliminando incremento/decremento/compuestos...${NC}"

    # interpreter.l: borrar +:=, -:=, ++, --
    sed -i '/"\+:=".*MAS_IGUAL/d' "$DIR/parser/interpreter.l"
    sed -i '/"-:=".*MENOS_IGUAL/d' "$DIR/parser/interpreter.l"
    sed -i '/"++".*INCREMENTO/d' "$DIR/parser/interpreter.l"
    sed -i '/"--".*DECREMENTO/d' "$DIR/parser/interpreter.l"

    # interpreter.y: quitar tokens de %token
    sed -i 's/ MAS_IGUAL MENOS_IGUAL INCREMENTO DECREMENTO//' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar linea de precedencia
    sed -i '/%right INCREMENTO DECREMENTO/d' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar increment/decrement + compound (27 lineas desde el comentario)
    sed -i '/\/\* NEW for practice: increment\/decrement \*\//,+26d' "$DIR/parser/interpreter.y"

    # ast.hpp: borrar PreIncrementStmt, PostIncrementStmt, CompoundAssignmentStmt
    sed -i '/class PreIncrementStmt : public Statement {/,/^};/d' "$DIR/ast/ast.hpp"
    sed -i '/class PostIncrementStmt : public Statement {/,/^};/d' "$DIR/ast/ast.hpp"
    sed -i '/class CompoundAssignmentStmt : public Statement {/,/^};/d' "$DIR/ast/ast.hpp"

    # ast.cpp: borrar implementaciones
    sed -i '/PreIncrementStmt evaluate/,/^}/d' "$DIR/ast/ast.cpp"
    sed -i '/PostIncrementStmt evaluate/,/^}/d' "$DIR/ast/ast.cpp"
    sed -i '/CompoundAssignmentStmt evaluate/,/^}/d' "$DIR/ast/ast.cpp"

    echo -e "${VERDE}  Hecho.${NC}"
}

setup_d() {
    echo -e "${CYAN}[SETUP D] Eliminando bucle repeat-until...${NC}"

    # interpreter.y: quitar REPEAT UNTIL de %token
    sed -i 's/ REPEAT UNTIL//' "$DIR/parser/interpreter.y"
    # interpreter.y: quitar repeat de %type
    sed -i 's/ repeat / /' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar stmt: repeat (4 lineas)
    sed -i '/\/\*  NEW for practice \*\//{
      /\/\*  NEW for practice \*\//{
        N
        /\n\t| repeat /!b
        d
      }
    }' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar regla repeat (7 lineas desde el comentario)
    sed -i '/\/\* NEW for practice: repeat-until \*\//,+6d' "$DIR/parser/interpreter.y"

    # ast.hpp: borrar RepeatStmt class
    sed -i '/class RepeatStmt : public Statement {/,/^};/d' "$DIR/ast/ast.hpp"

    # ast.cpp: borrar implementacion
    sed -i '/RepeatStmt evaluate/,/^}/d' "$DIR/ast/ast.cpp"

    echo -e "${VERDE}  Hecho.${NC}"
}

# ============================================================
# TEST: evaluar cada pregunta
# ============================================================

test_a() {
    local ok=0 total=2
    echo -e "\n${CYAN}--- Pregunta A: Division Entera // ---${NC}"

    compilar
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}  NO COMPILA → 0/10 puntos${NC}"
        return 1
    fi

    echo "  Test A1: 7 // 3 = 2"
    r1=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/a1_div.p" 2>/dev/null | extraer_print)
    if [ "$r1" = "2" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 2 | Obtenido: '$r1'${NC}"
    fi

    echo "  Test A2: 10 // 4 = 2, 3 // 7 = 0"
    r2=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/a2_div.p" 2>/dev/null | extraer_print)
    if [ "$r2" = $'2\n0' ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 2\\n0 | Obtenido: '$r2'${NC}"
    fi

    echo -e "${AMARILLO}  Puntuacion: $ok/$total ($((ok*5)) puntos)${NC}"
}

test_b() {
    local ok=0 total=3
    echo -e "\n${CYAN}--- Pregunta B: Operador Ternario ?: ---${NC}"

    compilar
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}  NO COMPILA → 0/10 puntos${NC}"
        return 1
    fi

    echo "  Test B1: 1<2 ? 10 : 20 = 10"
    r1=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/b1_tern.p" 2>/dev/null | extraer_print)
    if [ "$r1" = "10" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 10 | Obtenido: '$r1'${NC}"
    fi

    echo "  Test B2: 1>2 ? \"a\" : \"b\" = b"
    r2=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/b2_tern.p" 2>/dev/null | extraer_print)
    if [ "$r2" = "b" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: b | Obtenido: '$r2'${NC}"
    fi

    echo "  Test B3: x=1 ? \"si\" : \"no\" = si"
    r3=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/b3_tern.p" 2>/dev/null | extraer_print)
    if [ "$r3" = "si" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: si | Obtenido: '$r3'${NC}"
    fi

    echo -e "${AMARILLO}  Puntuacion: $ok/$total ($((ok*5)) puntos)${NC}"
}

test_c() {
    local ok=0 total=4
    echo -e "\n${CYAN}--- Pregunta C: Incremento/Decremento/Compuestos ---${NC}"

    compilar
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}  NO COMPILA → 0/15 puntos${NC}"
        return 1
    fi

    echo "  Test C1: ++x (x=5) → 6"
    r1=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/c1_incdec.p" 2>/dev/null | extraer_print | head -1)
    if [ "$r1" = "6" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 6 | Obtenido: '$r1'${NC}"
    fi

    echo "  Test C2: x-- (x=6) → 5"
    r2=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/c1_incdec.p" 2>/dev/null | extraer_print | tail -1)
    if [ "$r2" = "5" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 5 | Obtenido: '$r2'${NC}"
    fi

    echo "  Test C3: x+:=3 (x=5) → 8"
    r3=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/c2_comp.p" 2>/dev/null | extraer_print | head -1)
    if [ "$r3" = "8" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 8 | Obtenido: '$r3'${NC}"
    fi

    echo "  Test C4: x-:=2 (x=8) → 6"
    r4=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/c2_comp.p" 2>/dev/null | extraer_print | tail -1)
    if [ "$r4" = "6" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 6 | Obtenido: '$r4'${NC}"
    fi

    echo -e "${AMARILLO}  Puntuacion: $ok/$total ($((ok*5)) puntos)${NC}"
}

test_d() {
    local ok=0 total=2
    echo -e "\n${CYAN}--- Pregunta D: Bucle repeat-until ---${NC}"

    compilar
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}  NO COMPILA → 0/15 puntos${NC}"
        return 1
    fi

    echo "  Test D1: repeat print x; until x>3  → 1 2 3"
    r1=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/d1_repeat.p" 2>/dev/null | extraer_print)
    if [ "$r1" = $'1\n2\n3' ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 1\\n2\\n3 | Obtenido: '$r1'${NC}"
    fi

    echo "  Test D2: repeat x:=x-1; until x=0; print x  → 0"
    r2=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/d2_repeat.p" 2>/dev/null | extraer_print)
    if [ "$r2" = "0" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 0 | Obtenido: '$r2'${NC}"
    fi

    echo -e "${AMARILLO}  Puntuacion: $ok/$total ($((ok*5)) puntos)${NC}"
}

# ============================================================
# MAIN
# ============================================================

case "$1" in
    setup)
        case "$2" in
            a) hacer_backup; setup_a ;;
            b) hacer_backup; setup_b ;;
            c) hacer_backup; setup_c ;;
            d) hacer_backup; setup_d ;;
            *) echo "Uso: $0 setup {a|b|c|d}" >&2; exit 1 ;;
        esac
        ;;

    test)
        case "$2" in
            a) test_a ;;
            b) test_b ;;
            c) test_c ;;
            d) test_d ;;
            *) echo "Uso: $0 test {a|b|c|d}" >&2; exit 1 ;;
        esac
        ;;

    restore)
        restaurar_backup
        echo -e "${VERDE}Archivos restaurados desde backup.${NC}"
        ;;

    fulltest)
        echo -e "${AMARILLO}========================================${NC}"
        echo -e "${AMARILLO}  SIMULACRO COMPLETO - 4 PREGUNTAS${NC}"
        echo -e "${AMARILLO}========================================${NC}"
        for q in a b c d; do
            hacer_backup
            setup_$q
            test_$q
            restaurar_backup
        done
        echo -e "\n${AMARILLO}========================================${NC}"
        echo -e "${AMARILLO}  SIMULACRO COMPLETADO${NC}"
        echo -e "${AMARILLO}  Usa './simulacro.sh test {a|b|c|d}' para${NC}"
        echo -e "${AMARILLO}  evaluar preguntas individualmente.${NC}"
        echo -e "${AMARILLO}========================================${NC}"
        ;;

    *)
        echo "Uso: $0 {setup|test|restore|fulltest} [a|b|c|d]"
        echo ""
        echo "  setup a|b|c|d   - Prepara pregunta (guarda backup y elimina codigo)"
        echo "  test  a|b|c|d   - Compila y ejecuta tests de la pregunta"
        echo "  restore         - Restaura archivos desde backup"
        echo "  fulltest        - Ejecuta las 4 preguntas seguidas"
        exit 1
        ;;
esac
