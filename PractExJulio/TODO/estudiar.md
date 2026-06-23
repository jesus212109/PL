# Notas de estudio — Detalles técnicos

## Diseño Bison para 0 conflictos

### Dangling else

El Ejemplo 17 tiene 1 SR conflict. Para eliminarlo:

```bison
%nonassoc THEN
%nonassoc ELSE

si:
    SI controlSymbol cond ENTONCES stmtlist FIN_SI SEMICOLON %prec THEN
    | SI controlSymbol cond ENTONCES stmtlist SI_NO stmtlist FIN_SI SEMICOLON
;
```

`THEN` es un token ficticio (no se usa en el lexer). Su único propósito es dar precedencia a la regla simple.

### controlSymbol

```bison
controlSymbol:
    /* epsilon */
    { control++; }
;
```

Regla epsilon que incrementa `control` para modo interactivo. Los `$N` se desplazan al añadirla.

### Tokens compuestos vs tokens simples

- `si_no`, `fin_si`, `hasta_que`, `fin_mientras`, `fin_para`, `fin_selector`, `borrar_pantalla`, `leer_cadena` → tokens únicos registrados en `init.hpp`
- `hasta` (TO en `para`) ≠ `hasta_que` (UNTIL en `repetir`) → tokens diferentes

### Precedencia ternario

```bison
%right '?' ':'
%left OR
%left AND
%nonassoc GREATER_OR_EQUAL LESS_OR_EQUAL GREATER_THAN LESS_THAN EQUAL NOT_EQUAL
%left NOT
%left PLUS MINUS
%left MULTIPLICATION DIVISION DIV_ENTERA MOD
%nonassoc UNARY
%right POWER
```

El `? :` va **antes** de OR, no entre los relacionales.

---

## AST pre-implementado

Nodos que ya existen y no necesitas crear:

**Expresiones**: `NumberNode`, `VariableNode`, `ConstantNode`, `StringNode`, `ConcatNode`, `PlusNode`, `MinusNode`, `MultiplicationNode`, `DivisionNode`, `ModuloNode`, `PowerNode`, `UnaryMinusNode`, `UnaryPlusNode`, `GreaterThanNode`, `GreaterOrEqualNode`, `LessThanNode`, `LessOrEqualNode`, `EqualNode`, `NotEqualNode`, `AndNode`, `OrNode`, `NotNode`, `BuiltinFunctionNode_0/1/2`

**Sentencias**: `AssignmentStmt` (con STRING), `PrintStmt` (con STRING), `ReadStmt`, `ReadStringStmt` (`// AÑADIDO PARA EXAMEN`), `EmptyStmt`, `IfStmt`, `WhileStmt`, `BlockStmt`, `ClearScreenStmt` (usa `CLEAR_SCREEN`), `PlaceStmt`

**Nodos que debes crear tú**: `DivEnteraNode`, `DoWhileStmt`, `RepeatStmt`, `ForStmt`, `SwitchStmt`

---

## Tests

9 tests en `tests/` cubriendo léxico, operadores, sentencias, I/O, errores e integración. Los `.expected` se generan con `./tests/generate-expected.sh` cuando el intérprete funcione.

---

## Estructura de ficheros

```
.
├── ast/ast.hpp, ast.cpp      ← MODIFICAR (nodos nuevos)
├── table/init.hpp             ← MODIFICAR (keywords español)
├── parser/interpreter.l       ← MODIFICAR (lexer español)
├── parser/interpreter.y       ← MODIFICAR (parser español, 0 conflicts)
├── interpreter.cpp            ← MODIFICAR (control argumentos)
├── error/                     ← Sin cambios
├── includes/macros.hpp        ← Sin cambios (CLEAR_SCREEN, PLACE, colores)
├── tests/                     ← 9 tests de referencia
├── backups/                   ← restore.sh para estado limpio
└── enunciado.md               ← Especificación del examen
```

### Archivos que NO se tocan

`error/*`, `includes/*`, `table/table.*`, `table/symbol.*`, `table/variable.*`, `table/numericVariable.*`, `table/logicalVariable.*`, `table/constant.*`, `table/numericConstant.*`, `table/logicalConstant.*`, `table/keyword.*`, `table/builtin*.*`, `table/mathFunction.*`, `table/stringVariable.*`

---

## Restaurar estado limpio

```bash
./backups/restore.sh
```
