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
    for f in parser/interpreter.l parser/interpreter.y ast/ast.hpp ast/ast.cpp table/init.hpp; do
        cp "$DIR/$f" "$BACKUP_DIR/$(basename "$f").bak" 2>/dev/null
    done
}

restaurar_backup() {
    for f in parser/interpreter.l parser/interpreter.y ast/ast.hpp ast/ast.cpp table/init.hpp; do
        cp "$BACKUP_DIR/$(basename "$f").bak" "$DIR/$f" 2>/dev/null
    done
}

compilar() {
    make -C "$DIR" clean > /dev/null 2>&1
    make -C "$DIR" 2>&1
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
    sed -i '/^"?"/{N;d}' "$DIR/parser/interpreter.l"
    sed -i '/^":"/{N;d}' "$DIR/parser/interpreter.l"

    # interpreter.y: borrar declaracion de precedencia
    sed -i "/%right '?' ':'/d" "$DIR/parser/interpreter.y"
    # interpreter.y: borrar regla gramatical (busca | exp seguido de '?' )
    sed -i '/^[[:space:]]*|[[:space:]]*exp .[?]/{N;N;N;d}' "$DIR/parser/interpreter.y"

    # ast.hpp: borrar clase TernaryNode
    sed -i '/^class TernaryNode : public ExpNode {/,/^};/d' "$DIR/ast/ast.hpp"

    echo -e "${VERDE}  Hecho.${NC}"
}

setup_c() {
    echo -e "${CYAN}[SETUP C] Eliminando incremento/decremento/compuestos...${NC}"

    # interpreter.l: borrar +:=, -:=, ++, --
    sed -i '/"+:=".*MAS_IGUAL/d' "$DIR/parser/interpreter.l"
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
    echo -e "${CYAN}[SETUP D] Eliminando repeat-until (debes anadir repeat N times)...${NC}"

    # interpreter.y: quitar REPEAT UNTIL de %token
    sed -i 's/ REPEAT UNTIL//' "$DIR/parser/interpreter.y"
    # interpreter.y: quitar repeat de %type (solo linea %type con for_stmt)
    sed -i '/%type.*for_stmt/ s/ repeat / /' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar stmt: repeat (3 lineas: | repeat, {, })
    sed -i '/^[[:space:]]*|[[:space:]]*repeat[[:space:]]*$/{N;N;d}' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar regla repeat (7 lineas desde el comentario)
    sed -i '/\/\* NEW for practice: repeat-until \*\//,+6d' "$DIR/parser/interpreter.y"

    # init.hpp: quitar repeat y until de keyword[]
    sed -i '/{"repeat",[[:space:]]*REPEAT}/d' "$DIR/table/init.hpp"
    sed -i '/{"until",[[:space:]]*UNTIL}/d' "$DIR/table/init.hpp"

    echo -e "${VERDE}  Hecho.${NC}"
}

setup_f() {
    echo -e "${CYAN}[SETUP F] Eliminando if con END_IF y block (debes anadir dangling else + block)...${NC}"

    # interpreter.y: quitar %nonassoc THEN y %nonassoc ELSE
    sed -i '/%nonassoc THEN/,+1d' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar regla if (11 lineas)
    sed -i '/^if:[[:space:]]*IF/,+10d' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar regla block (5 lineas)
    sed -i '/^block:[[:space:]]*LETFCURLYBRACKET/,+4d' "$DIR/parser/interpreter.y"
    # interpreter.y: quitar if de %type (solo linea %type con stmt)
    sed -i '/%type.*stmt asgn/ s/ if//' "$DIR/parser/interpreter.y"
    # interpreter.y: quitar block de %type (solo linea %type con for_stmt)
    sed -i '/%type.*for_stmt/ s/ block//' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar stmt: if (3 lineas)
    sed -i '/^[[:space:]]*|[[:space:]]*if[[:space:]]*$/{N;N;d}' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar stmt: block (3 lineas)
    sed -i '/^[[:space:]]*|[[:space:]]*block[[:space:]]*$/{N;N;d}' "$DIR/parser/interpreter.y"
    # interpreter.y: quitar END_IF de %token (al FINAL para no romper comentarios)
    sed -i 's/ END_IF//' "$DIR/parser/interpreter.y"

    # init.hpp: quitar end_if de keyword[]
    sed -i '/{"end_if",[[:space:]]*END_IF}/d' "$DIR/table/init.hpp"

    echo -e "${VERDE}  Hecho.${NC}"
}

setup_g() {
    echo -e "${CYAN}[SETUP G] Eliminando pre/post incremento/decremento (++x, x++, --x, x--)...${NC}"

    # interpreter.l: borrar ++ y --
    sed -i '/"++".*INCREMENTO/d' "$DIR/parser/interpreter.l"
    sed -i '/"--".*DECREMENTO/d' "$DIR/parser/interpreter.l"

    # interpreter.y: borrar linea de precedencia PRIMERO (antes de modificar tokens)
    sed -i '/%right INCREMENTO DECREMENTO/d' "$DIR/parser/interpreter.y"
    # interpreter.y: quitar INCREMENTO DECREMENTO de %token
    sed -i 's/ INCREMENTO DECREMENTO//' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar increment/decrement (17 lineas desde el comentario)
    sed -i '/\/\* NEW for practice: increment\/decrement \*\//,+16d' "$DIR/parser/interpreter.y"

    # ast.hpp: borrar PreIncrementStmt y PostIncrementStmt
    sed -i '/class PreIncrementStmt : public Statement {/,/^};/d' "$DIR/ast/ast.hpp"
    sed -i '/class PostIncrementStmt : public Statement {/,/^};/d' "$DIR/ast/ast.hpp"

    # ast.cpp: borrar implementaciones
    sed -i '/PreIncrementStmt evaluate/,/^}/d' "$DIR/ast/ast.cpp"
    sed -i '/PostIncrementStmt evaluate/,/^}/d' "$DIR/ast/ast.cpp"

    echo -e "${VERDE}  Hecho.${NC}"
}

setup_p() {
    echo -e "${CYAN}[SETUP P] Eliminando operador potencia ^...${NC}"

    # interpreter.l: borrar ^
    sed -i '/"\^".*POWER/d' "$DIR/parser/interpreter.l"

    # interpreter.y: borrar %right POWER
    sed -i '/%right POWER/d' "$DIR/parser/interpreter.y"
    # interpreter.y: borrar regla exp POWER exp (4 lineas)
    sed -i '/^[[:space:]]*|[[:space:]]*exp POWER exp/,+3d' "$DIR/parser/interpreter.y"

    # ast.hpp: borrar clase PowerNode
    sed -i '/^class PowerNode : public NumericOperatorNode/,/^};/d' "$DIR/ast/ast.hpp"

    # ast.cpp: borrar PowerNode (printAST + evaluateNumber = 25 lineas)
    sed -i '/^void lp::PowerNode::printAST/,+24d' "$DIR/ast/ast.cpp"

    echo -e "${VERDE}  Hecho.${NC}"
}

setup_e1() {
    echo -e "${CYAN}[SETUP E1] Eliminando constantes logicas de init.hpp...${NC}"

    # init.hpp: eliminar true y false de logicalConstant[], dejar solo {"", 0}
    sed -i '/{"true", true}/d' "$DIR/table/init.hpp"
    sed -i '/{"false", false}/d' "$DIR/table/init.hpp"

    echo -e "${VERDE}  Hecho (debes anadir {\"yes\", true} en logicalConstant[]).${NC}"
}

setup_e2() {
    echo -e "${CYAN}[SETUP E2] Eliminando constantes numericas de init.hpp...${NC}"

    # init.hpp: dejar solo PI y {"", 0} en numericConstant[]
    sed -i '/{"E",[[:space:]]*2\./d' "$DIR/table/init.hpp"
    sed -i '/{"GAMMA",/d' "$DIR/table/init.hpp"
    sed -i '/{"DEG",/d' "$DIR/table/init.hpp"
    sed -i '/{"PHI",/d' "$DIR/table/init.hpp"

    echo -e "${VERDE}  Hecho (debes anadir {\"tau\", 6.283185307179586} en numericConstant[]).${NC}"
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
    echo -e "\n${CYAN}--- Pregunta D: Bucle repeat N times ---${NC}"

    compilar
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}  NO COMPILA → 0/15 puntos${NC}"
        return 1
    fi

    echo "  Test D1: repeat 3 times {x++; print x} → 1 2 3"
    r1=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/d3_repeat.p" 2>/dev/null | extraer_print)
    if [ "$r1" = $'1\n2\n3' ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 1\\n2\\n3 | Obtenido: '$r1'${NC}"
    fi

    echo "  Test D2: repeat 4 times {x*=2}; print x → 16"
    r2=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/d4_repeat.p" 2>/dev/null | extraer_print)
    if [ "$r2" = "16" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 16 | Obtenido: '$r2'${NC}"
    fi

    echo -e "${AMARILLO}  Puntuacion: $ok/$total ($((ok*5)) puntos)${NC}"
}

test_f() {
    local ok=0 total=4
    echo -e "\n${CYAN}--- Pregunta F: Dangling else + block ---${NC}"

    compilar
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}  NO COMPILA → 0/15 puntos${NC}"
        return 1
    fi

    echo "  Test F1: if (x>0) then print \"si\" → si"
    r1=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/f1_if.p" 2>/dev/null | extraer_print)
    if [ "$r1" = "si" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: si | Obtenido: '$r1'${NC}"
    fi

    echo "  Test F2: if (x>0) then \"si\" else \"no\" → no (x=0)"
    r2=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/f2_if.p" 2>/dev/null | extraer_print)
    if [ "$r2" = "no" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: no | Obtenido: '$r2'${NC}"
    fi

    echo "  Test F3: if anidado (dangling else asocia a if interior)"
    r3=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/f3_if.p" 2>/dev/null | extraer_print)
    if [ "$r3" = "A" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: A | Obtenido: '$r3'${NC}"
    fi

    echo "  Test F4: if con bloque { } (multiples stmts)"
    r4=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/f4_if.p" 2>/dev/null | extraer_print)
    if [ "$r4" = $'hello\nworld' ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: hello\\nworld | Obtenido: '$r4'${NC}"
    fi

    echo -e "${AMARILLO}  Puntuacion: $ok/$total ($((ok*5)) puntos)${NC}"
}

test_e1() {
    local ok=0 total=1
    echo -e "\n${CYAN}--- Pregunta E1: Constante logica yes ---${NC}"

    compilar
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}  NO COMPILA → 0/5 puntos${NC}"
        return 1
    fi

    echo "  Test E1: print yes → true"
    r1=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/e1_yes.p" 2>/dev/null | extraer_print)
    if [ "$r1" = "true" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: true | Obtenido: '$r1'${NC}"
    fi

    echo -e "${AMARILLO}  Puntuacion: $ok/$total ($((ok*5)) puntos)${NC}"
}

test_e2() {
    local ok=0 total=2
    echo -e "\n${CYAN}--- Pregunta E2: Constante numerica tau ---${NC}"

    compilar
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}  NO COMPILA → 0/5 puntos${NC}"
        return 1
    fi

    echo "  Test E2a: print tau → 6.283185"
    r1=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/e2_tau.p" 2>/dev/null | extraer_print | head -1)
    if [ "$r1" = "6.283185" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 6.283185 | Obtenido: '$r1'${NC}"
    fi

    echo "  Test E2b: tau / 2 → 3.141593"
    r2=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/e2_tau.p" 2>/dev/null | extraer_print | tail -1)
    if [ "$r2" = "3.141593" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 3.141593 | Obtenido: '$r2'${NC}"
    fi

    echo -e "${AMARILLO}  Puntuacion: $ok/$total ($((ok*5)) puntos)${NC}"
}

test_g() {
    local ok=0 total=4
    echo -e "\n${CYAN}--- Pregunta G: Pre/Post incremento/decremento ---${NC}"

    compilar
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}  NO COMPILA → 0/15 puntos${NC}"
        return 1
    fi

    echo "  Test G1: ++x (x=5) → 6 (tipo PreIncrementStmt en AST)"
    raw1=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/g1_prepost.p" 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g')
    val1=$(echo "$raw1" | grep '^print:' | sed 's/^print: *//' | head -1)
    if echo "$raw1" | grep -q "PreIncrementStmt: x" && [ "$val1" = "6" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: PreIncrementStmt: x y print: 6${NC}"
    fi

    echo "  Test G2: x++ (x=5) → 6 (tipo PostIncrementStmt en AST)"
    val2=$(echo "$raw1" | grep '^print:' | sed 's/^print: *//' | tail -1)
    if echo "$raw1" | grep -q "PostIncrementStmt: x" && [ "$val2" = "6" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: PostIncrementStmt: x y print: 6${NC}"
    fi

    echo "  Test G3: --x (x=5) → 4 (tipo PreIncrementStmt decremento)"
    raw2=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/g2_prepost.p" 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g')
    val3=$(echo "$raw2" | grep '^print:' | sed 's/^print: *//' | head -1)
    if echo "$raw2" | grep -q "PreIncrementStmt: x" && [ "$val3" = "4" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: PreIncrementStmt: x y print: 4${NC}"
    fi

    echo "  Test G4: x-- (x=5) → 4 (tipo PostIncrementStmt decremento)"
    val4=$(echo "$raw2" | grep '^print:' | sed 's/^print: *//' | tail -1)
    if echo "$raw2" | grep -q "PostIncrementStmt: x" && [ "$val4" = "4" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: PostIncrementStmt: x y print: 4${NC}"
    fi

    echo -e "${AMARILLO}  Puntuacion: $ok/$total ($((ok*5)) puntos)${NC}"
}

test_p() {
    local ok=0 total=2
    echo -e "\n${CYAN}--- Pregunta P: Potencia ^ ---${NC}"

    compilar
    if [ $? -ne 0 ]; then
        echo -e "${ROJO}  NO COMPILA → 0/10 puntos${NC}"
        return 1
    fi

    echo "  Test P1: 2^3 = 8"
    r1=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/p1_power.p" 2>/dev/null | extraer_print)
    if [ "$r1" = "8" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 8 | Obtenido: '$r1'${NC}"
    fi

    echo "  Test P2: 2^3^2 = 512 (asociativo a derecha)"
    r2=$(echo "" | "$DIR/interpreter.exe" "$TESTS_DIR/p2_power.p" 2>/dev/null | extraer_print)
    if [ "$r2" = "512" ]; then
        echo -e "    ${VERDE}✅ OK${NC}"; ok=$((ok+1))
    else
        echo -e "    ${ROJO}❌ Esperado: 512 | Obtenido: '$r2'${NC}"
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
            e1) hacer_backup; setup_e1 ;;
            e2) hacer_backup; setup_e2 ;;
            f) hacer_backup; setup_f ;;
            g) hacer_backup; setup_g ;;
            p) hacer_backup; setup_p ;;
            *) echo "Uso: $0 setup {a|b|c|d|e1|e2|f|g|p}" >&2; exit 1 ;;
        esac
        ;;

    test)
        case "$2" in
            a) test_a ;;
            b) test_b ;;
            c) test_c ;;
            d) test_d ;;
            e1) test_e1 ;;
            e2) test_e2 ;;
            f) test_f ;;
            g) test_g ;;
            p) test_p ;;
            *) echo "Uso: $0 test {a|b|c|d|e1|e2|f|g|p}" >&2; exit 1 ;;
        esac
        ;;

    restore)
        restaurar_backup
        echo -e "${VERDE}Archivos restaurados desde backup.${NC}"
        ;;

    fulltest)
        echo -e "${AMARILLO}========================================${NC}"
        echo -e "${AMARILLO}  SIMULACRO COMPLETO - 9 PREGUNTAS${NC}"
        echo -e "${AMARILLO}========================================${NC}"
        for q in a b c d e1 e2 f g p; do
            hacer_backup
            setup_$q
            test_$q
            restaurar_backup
        done
        echo -e "\n${AMARILLO}========================================${NC}"
        echo -e "${AMARILLO}  SIMULACRO COMPLETADO${NC}"
        echo -e "${AMARILLO}  Usa './simulacro.sh test {a|b|c|d|e1|e2|f|g|p}' para${NC}"
        echo -e "${AMARILLO}  evaluar preguntas individualmente.${NC}"
        echo -e "${AMARILLO}========================================${NC}"
        ;;

    *)
        echo "Uso: $0 {setup|test|restore|fulltest} [a|b|c|d|e1|e2|f|g|p]"
        echo ""
        echo "  setup a|b|c|d|e1|e2|f|g|p  - Prepara pregunta (guarda backup y elimina codigo)"
        echo "  test  a|b|c|d|e1|e2|f|g|p  - Compila y ejecuta tests de la pregunta"
        echo "  restore              - Restaura archivos desde backup"
        echo "  fulltest             - Ejecuta las 9 preguntas seguidas"
        exit 1
        ;;
esac
