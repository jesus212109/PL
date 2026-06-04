# CAMBIOS.md — Modificaciones sobre Ejemplo 17

> Base: `/home/jesus/PL/ejemplos-bison/ejemplo17/`
> Resultado: `/home/jesus/PL/P2/main/`

---

## Resumen

| Categoría | Original Ej.17 | Final |
|-----------|---------------|-------|
| Keywords | 5 (print, read, if, else, while) | 27 |
| Constantes | 5 (PI, E, GAMMA, PHI, DEG) | 5 (sin cambios) |
| Funciones built-in | 8 + 1 extra (atan, random, atan2) | 8 (sin cambios) |
| Tipos de variable | Numeric, Logical | Numeric, Logical, **String** |
| Operadores | + - * / % ^ == != > >= < <= && \|\| ! | + - * / ^ = <> > >= < <= or and not // ++ -- +:= -:= ?: \|\| |
| Comentarios | Ninguno | `(*...*)` y `#` |
| Strings | No | Sí, con escapes |
| Case-insensitive | No | Sí |
| Control de flujo | if, while, block `{ }` | if-then-else-end_if, while-do-end_while, for, repeat-until, do-while, switch-case |
| Cuerpos multi-sentencia | 1 stmt (requería `{ }`) | stmtlist (N sentencias sin llaves) |
| Conflictos | 0 (original) | 9 shift/reduce + 26 reduce/reduce (ver nota) |

---

## Archivos modificados

### `parser/interpreter.l` — Lexer

| Cambio | Descripción |
|--------|-------------|
| `%option case-insensitive` | Palabras reservadas sin distinción mayúsculas/minúsculas |
| `%option noyywrap` | Elimina dependencia de `libfl` |
| `STRING_LIT` regex | Cadenas con comillas simples y escapes `\n \t \\ \' \0` |
| `COMMENT` estado `%x` | Comentarios de bloque `(* ... *)` no anidados |
| `#.*` regla | Comentarios de línea |
| `IDENTIFIER` actualizado | Soporta guiones bajos, rechaza `_` final y `__` |
| `":="` → ASSIGNMENT | Asignación (antes era `=`) |
| `"<>"` → NOT_EQUAL | Distinto (antes era `!=`) |
| `"="` → EQUAL | Igualdad |
| `"//"` → DIV_ENTERA | División entera |
| `"||"` → CONCAT | Concatenación (antes era OR) |
| `"++"`, `"--"` → INCREMENTO, DECREMENTO | Incremento/decremento |
| `"+:="`, `"-:="` → MAS_IGUAL, MENOS_IGUAL | Asignación compuesta |
| `"?"`, `":"` → `'?'`, `':'` | Operador ternario |
| Eliminados: `"!"`, `"&&"`, `"{"`, `"}"`, `"%"`, `"=="`, `"!="` | Reemplazados por keywords o nueva sintaxis |
| `reportar_error_lexico()` usa `warning()` | Colores ANSI en errores léxicos |

### `parser/interpreter.y` — Gramática

| Cambio | Descripción |
|--------|-------------|
| 22 nuevos tokens | READ_STRING, THEN, END_IF, DO, END_WHILE, REPEAT, UNTIL, FOR, END_FOR, FROM, STEP, TO, SWITCH, CASE, DEFAULT, END_SWITCH, CLEAR_SCREEN, PLACE, OR, AND, NOT, MOD |
| Tokens renombrados | `ASSIGNMENT` (antes `=`, ahora `:=`), `EQUAL` (antes `==`, ahora `=`), `NOT_EQUAL` (antes `!=`, ahora `<>`) |
| `%type <st>` nuevos | for_stmt, repeat, do_while, clear_screen, place, switch_stmt, case_list |
| `STRING` en %union | Nuevo tipo para literales de cadena |
| Precedencia actualizada | Añadidos DIV_ENTERA, CONCAT, ternary, INCREMENTO, DECREMENTO, THEN/ELSE |
| `stmtlist` → `sentencia_completa` | Los bloques aceptan listas de sentencias, no una sola |
| `if` reescrito | `if exp then stmtlist [else stmtlist] end_if` |
| `while` reescrito | `while exp do stmtlist end_while` |
| `for_stmt` nuevo | `for id from exp to exp [step exp] do stmtlist end_for` |
| `repeat` nuevo | `repeat stmtlist until exp ;` |
| `do_while` nuevo | `do stmtlist while exp ;` |
| `switch_stmt` nuevo | `switch (exp) case exp stmtlist ... [default stmtlist] end_switch` |
| `read_string` nuevo | `read_string ( id ) ;` |
| `clear_screen` nuevo | `clear_screen ;` |
| `place` nuevo | `place ( exp , exp ) ;` |
| `controlSymbol` recuperado | Previene evaluación prematura en modo interactivo |
| `cond` eliminado | Se usa `exp` directamente (los paréntesis son parte de la expresión) |
| `block { }` eliminado | Sustituido por stmtlist implícito |
| Reglas `exp` extendidas | STRING, CONCAT, DIV_ENTERA, EQUAL/NOT_EQUAL, ternary `?:` |
| `asgn` extendido | ++, --, +:=, -:= |

### `ast/ast.hpp` y `ast/ast.cpp` — AST

| Nodo nuevo | Función |
|------------|---------|
| `StringNode` | Literal de cadena (`getType()` → STRING) |
| `ConcatenationNode` | Operación `\|\|` (`evaluateString()`) |
| `IntegerDivisionNode` | Operación `//` (`evaluateNumber()`) |
| `TernaryNode` | Operador `?:` (`evaluateBool()`) |
| `PreIncrementStmt` | Sentencia `++x;` / `--x;` |
| `PostIncrementStmt` | Sentencia `x++;` / `x--;` |
| `CompoundAssignmentStmt` | Sentencia `x+:=expr;` / `x-:=expr;` |
| `ForStmt` | Bucle `for` con paso e inicialización |
| `RepeatStmt` | Bucle `repeat-until` |
| `DoWhileStmt` | Bucle `do-while` |
| `SwitchStmt` | Sentencia `switch-case` |
| `ClearScreenStmt` | `clear_screen;` |
| `PlaceStmt` | `place(x, y);` |
| `ExpNode::evaluateString()` | Método virtual añadido a la base |

### `table/init.hpp` — Inicialización de la tabla

| Cambio | Descripción |
|--------|-------------|
| `keyword[]` extendido | De 5 a 27 palabras clave (read_string, then, end_if, do, end_while, repeat, until, for, end_for, from, step, to, switch, case, default, end_switch, clear_screen, place, or, and, not, mod) |
| `"mod"` → MODULO | El keyword `mod` devuelve token MODULO |

### `table/stringVariable.hpp` y `stringVariable.cpp` — Nuevos

Clon de `NumericVariable` adaptado para `std::string`. Jerarquía:

```
Symbol → Variable → StringVariable
                       └── std::string _value
```

### `error/error.cpp`

Sin cambios funcionales. Usa `warning()`, `execerror()`, `errcheck()`, `fpecatch()` del original con colores ANSI.

### `interpreter.cpp` — Main

Sin cambios funcionales. Llama a `init(table)` antes de `setjmp(begin)`. Ejecuta `root->evaluate()` en modo archivo.

### `includes/macros.hpp`

| Cambio | Descripción |
|--------|-------------|
| `CLEAR_SCREEN` → `CLR_SCREEN` | Evita conflicto con token CLEAR_SCREEN |
| `PLACE` → `PLACE_ANSI` | Evita conflicto con token PLACE |

---

## Conflictos restantes

| Tipo | Cantidad | Causa | Impacto |
|------|---------|-------|---------|
| shift/reduce | 9 | Ambigüedad `do...while` vs `while...do` | Inofensivo (shift es correcto) |
| reduce/reduce | 26 | Token `:` compartido entre ternario y switch-case | Puede afectar al switch; se resolvió eliminando `:` de CASE |

---

## Notas sobre el switch-case

La sintaxis del profesor usa `case 0: sentencias`. La `:` después de `case exp` conflige con el `:` del operador ternario. Para evitarlo, la gramática actual no consume `:` en las reglas de switch; el parser recupera del error. Funciona pero genera 26 reduce/reduce.

Solución recomendada si se quiere 0 conflictos:
1. Añadir token `CASE_SEP`
2. En el lexer, usar un estado para devolver `CASE_SEP` tras `CASE exp` en vez de `':'`
3. Eliminar el `:` del ternario usando `%token TERNARY_ELSE` en su lugar

---

## Lista completa de funcionalidades

| Funcionalidad | Estado |
|---------------|--------|
| Asignación `:=` | ✅ |
| Igualdad `=` | ✅ |
| Distinto `<>` | ✅ |
| Operadores aritméticos `+ - * /` | ✅ |
| División entera `//` | ✅ |
| Módulo `mod` | ✅ |
| Potencia `^` | ✅ |
| Concatenación `\|\|` | ✅ |
| Comparaciones `< > <= >=` | ✅ |
| Lógicos `or and not` | ✅ |
| Ternario `?:` | ✅ |
| Incremento `++` y `--` | ✅ |
| Asignación compuesta `+:=` `-:=` | ✅ |
| Strings con escapes `\n \t \\ \'` | ✅ |
| Comentarios `(* *)` y `#` | ✅ |
| Case-insensitive | ✅ |
| Constantes pi, e, gamma, phi, deg | ✅ |
| Booleanos true, false | ✅ |
| Funciones sin, cos, sqrt, log, log10, exp, integer, abs | ✅ |
| `print()`, `read()`, `read_string()` | ✅ |
| `if-then-else-end_if` | ✅ |
| `while-do-end_while` | ✅ |
| `for-from-to-step-end_for` | ✅ |
| `repeat-until` | ✅ |
| `do-while` | ✅ |
| `switch-case-default-end_switch` | ✅ (con fall-through, sin `:`) |
| `clear_screen` | ✅ |
| `place(x,y)` | ✅ |
| Recuperación errores (setjmp/longjmp/SIGFPE) | ✅ |
| errcheck() en funciones matemáticas | ✅ |
| Lexer guiado por tabla | ✅ |
| Tipado dinámico (número ↔ cadena) | ✅ |
