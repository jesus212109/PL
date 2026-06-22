# Simulacro de Examen — Intérprete de Pseudocódigo (PL)

## Instrucciones

Este simulacro contiene **4 preguntas independientes** (A, B, C, D).
Cada pregunta consiste en **reimplementar una funcionalidad** que ha sido
eliminada del intérprete. Debes modificar los archivos necesarios
(`interpreter.l`, `interpreter.y`, `ast.hpp`, `ast.cpp`) hasta que
`make` compile sin errores **y** los tests pasen.

### Archivos que puedes modificar

| Archivo | Ruta |
|---------|------|
| Analizador léxico | `parser/interpreter.l` |
| Gramática Bison | `parser/interpreter.y` |
| Árbol sintáctico (cabecera) | `ast/ast.hpp` |
| Árbol sintáctico (implementación) | `ast/ast.cpp` |

### No debes modificar

- `table/` (tabla de símbolos)
- `error/` (gestión de errores)
- `interpreter.cpp` (punto de entrada)
- `makefile` (compilación)

---

## Uso del simulacro

```bash
./simulacro.sh setup a      # Prepara pregunta A (borra el codigo)
./simulacro.sh test a       # Compila + ejecuta tests → puntuacion
./simulacro.sh restore      # Restaura archivos originales
./simulacro.sh fulltest     # Ejecuta las 4 preguntas seguidas
```

### Flujo de trabajo recomendado

1. `./simulacro.sh setup a` — habilita la pregunta A
2. Edita los archivos para reimplementar la funcionalidad
3. `make` — comprueba que compila
4. `./simulacro.sh test a` — evaluación automática
5. `./simulacro.sh restore` — vuelve al estado original
6. Repite con `b`, `c`, `d`

---

## Preguntas

### Pregunta A — División Entera `//` (10 puntos)

**Qué hace:** El operador `//` divide dos números y devuelve la parte
entera del cociente (ej: `7 // 3 = 2`, `10 // 4 = 2`).

**Qué debes implementar:**

| Capa | Qué añadir |
|------|-----------|
| **Flex** | Token `DIV_ENTERA` para el operador `"//"` |
| **Bison** | Token `DIV_ENTERA`, precedencia junto a `*/mod`, regla `exp DIV_ENTERA exp` |
| **AST** | Clase `IntegerDivisionNode` que hereda de `NumericOperatorNode` |
| **Evaluación** | `evaluateNumber()` que hace `(long)left / (long)right` (división entera, con check de división por cero) |

**Tests:**
- `print 7 // 3;` → `print: 2`
- `print 10 // 4; print 3 // 7;` → `print: 2\nprint: 0`

---

### Pregunta B — Operador Ternario `?:` (10 puntos)

**Qué hace:** `cond ? expr_true : expr_false` — evalúa la condición; si es
true devuelve `expr_true`, si no `expr_false`.

**Qué debes implementar:**

| Capa | Qué añadir |
|------|-----------|
| **Flex** | Literales `"?"` y `":"` devolviendo `'?'` y `':'` |
| **Bison** | `%right '?' ':'`, regla `exp '?' exp ':' exp %prec '?'` |
| **AST** | Clase `TernaryNode` que hereda de `ExpNode` con tres hijos: `_cond`, `_true`, `_false` |
| **Evaluación** | `evaluateNumber()`/`evaluateBool()`/`evaluateString()` según el tipo de la rama elegida |

**Tests:**
- `print (1<2 ? 10 : 20);` → `print: 10`
- `print (1>2 ? 'a' : 'b');` → `print: b`
- `x:=1; print (x=1 ? 'si' : 'no');` → `print: si`

---

### Pregunta C — Incremento/Decremento y Asignación Compuesta (15 puntos)

**Qué hace:** Cuatro operadores que modifican una variable in-place:

| Operador | Ejemplo | Efecto |
|----------|---------|--------|
| Pre-incremento | `++x` | `x := x + 1` |
| Pre-decremento | `--x` | `x := x - 1` |
| Post-incremento | `x++` | `x := x + 1` |
| Post-decremento | `x--` | `x := x - 1` |
| Suma compuesta | `x+:=3` | `x := x + 3` |
| Resta compuesta | `x-:=2` | `x := x - 2` |

**Qué debes implementar:**

| Capa | Qué añadir |
|------|-----------|
| **Flex** | `"++"` → `INCREMENTO`, `"--"` → `DECREMENTO`, `"+:="` → `MAS_IGUAL`, `"-:="` → `MENOS_IGUAL` |
| **Bison** | Tokens, `%right INCREMENTO DECREMENTO`, 6 reglas en `asgn` |
| **AST** | `PreIncrementStmt`, `PostIncrementStmt`, `CompoundAssignmentStmt` |
| **Evaluación** | Cada `evaluate()` modifica la variable en la tabla de símbolos |

**Tests:**
- `++x` (x=5) → `print: 6`
- `x--` (x=6) → `print: 5`
- `x+:=3` (x=5) → `print: 8`
- `x-:=2` (x=8) → `print: 6`

---

### Pregunta D — Bucle `repeat-until` (15 puntos)

**Qué hace:** Ejecuta el cuerpo **al menos una vez** y repite hasta que
la condición se cumpla (repeat-until = do-while con lógica invertida).

```
x:=1;
repeat
  print x;
  x:=x+1;
until x>3;
```
Imprime: 1, 2, 3

**Qué debes implementar:**

| Capa | Qué añadir |
|------|-----------|
| **Flex** | (los tokens `REPEAT` y `UNTIL` se registran en la tabla de símbolos, no hace falta tocarla) |
| **Bison** | Tokens `REPEAT UNTIL`, %type `repeat`, regla `stmt: repeat`, regla `repeat: REPEAT controlSymbol stmtlist UNTIL exp SEMICOLON` |
| **AST** | Clase `RepeatStmt` con `_body` (Statement*) y `_cond` (ExpNode*) |
| **Evaluación** | `do { body->evaluate(); } while (!cond->evaluateBool());` con detección de bucle infinito |

**Tests:**
- `repeat print x; x:=x+1; until x>3;` → `print: 1\nprint: 2\nprint: 3`
- `repeat x:=x-1; until x=0; print x;` → `print: 0`

---

## Criterios de evaluación

| Concepto | Puntos |
|----------|--------|
| Compila sin errores | Obligatorio (si no compila → 0 en la pregunta) |
| Cada test superado | 5 puntos |
| **Pregunta A** (2 tests) | **10 puntos** |
| **Pregunta B** (3 tests) | **10 puntos** |
| **Pregunta C** (4 tests) | **15 puntos** |
| **Pregunta D** (2 tests) | **15 puntos** |
| **Total** | **50 puntos** |

### Consejos

1. **Flex**: Mira cómo están implementados los demás operadores (`.l:143-164`)
2. **Bison**: Fíjate en las reglas existentes similares (if, while, for) para
   entender el patrón con `controlSymbol`
3. **AST**: Usa las clases base adecuadas (`NumericOperatorNode` para //,
   `ExpNode` para ternario, `Statement` para las sentencias)
4. **Evaluación**: `evaluateNumber()` para operandos numéricos,
   `evaluateString()` para strings, `evaluateBool()` para booleanos
5. No olvides la protección contra **división por cero** y **bucles infinitos**
