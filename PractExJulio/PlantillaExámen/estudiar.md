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

## Plan TDD — Implementación orientada a tests

Estrategia: implementar de lo más simple a lo más complejo, verificando cada paso con un test.

### Estado actual (verificado)
- [x] `make clean && make` → 0 conflictos
- [x] `C_condicionales.p` → PASA (5/5 prints correctos)
- [x] `:=` funciona (asignación simple y múltiple)
- [x] `if/entonces/si_no/fin_si` funciona
- [x] Strings con `'...'` funcionan (con escapes `\n`, `\t`, `\\`, `\'`)
- [x] Comentarios `#` funcionan

### Pasos restantes (en orden de prioridad)

#### Paso 1: Operadores lógicos como keywords
**Test**: `B_basicos.p` (líneas de operadores lógicos)
**Qué hacer**:
- Añadir a `interpreter.l`:
  ```lex
  "y"  { return AND; }
  "o"  { return OR; }
  "no" { return NOT; }
  ```
- Verificar: `escribir verdadero y verdadero;` → true

#### Paso 2: `mod` como keyword
**Test**: `B_basicos.p` (línea `7 mod 3`)
**Qué hacer**:
- Añadir a `interpreter.l`:
  ```lex
  "mod" { return MODULO; }
  ```
- Verificar: `7 mod 3` → 1

#### Paso 3: División entera `//`
**Test**: `B_basicos.p` (línea `7 // 3`)
**Qué hacer**:
- Añadir a `interpreter.l`:
  ```lex
  "//" { return DIV_ENTERA; }
  ```
- Verificar: `7 // 3` → 2

#### Paso 4: `mientras/hacer/fin_mientras`
**Test**: `C_bucles.p` (primer bloque)
**Qué hacer**:
- Añadir tokens a `.y`: `WHILE`, `HACER`, `FIN_MIENTRAS`
- Añadir regla:
  ```bison
  while: WHILE controlSymbol cond HACER stmtlist FIN_MIENTRAS SEMICOLON
  ;
  ```
- Añadir a `interpreter.l`:
  ```lex
  "mientras"    { return WHILE; }
  "hacer"       { /* HACER no es token, parte de la sintaxis */ }
  "fin_mientras" { return FIN_MIENTRAS; }
  ```
- Verificar: bucle while imprime 1,2,3,4,5

#### Paso 5: `repetir/hasta_que`
**Test**: `C_bucles.p`
**Qué hacer**:
- Similar al while, con `REPETIR` y `HASTA_QUE`
- AST: `RepeatStmt`

#### Paso 6: `hacer{...}mientras`
**Test**: `C_bucles.p`
**Qué hacer**:
- Usa `HACER` y `MIENTRAS` (ya existen)
- AST: `DoWhileStmt`

#### Paso 7: `para/desde/hasta/paso/fin_para`
**Test**: `C_bucles.p`
**Qué hacer**:
- AST: `ForStmt` (con paso opcional)

#### Paso 8: `selector/caso/defecto/fin_selector`
**Test**: `C_bucles.p`
**Qué hacer**:
- AST: `SwitchStmt` + `CaseClause`

#### Paso 9: `borrar_pantalla` y `lugar`
**Test**: `E_pantalla.p`
**Qué hacer**:
- Ya están en el AST, solo añadir reglas Bison

#### Paso 10: Operadores avanzados
**Test**: `B_avanzados.p` (ternario, `++`, `+:=`)
**Qué hacer**:
- Añadir tokens: `INCREMENT`, `DECREMENT`, `PLUS_ASSIGN`, `MINUS_ASSIGN`
- Añadir reglas con precedencia

#### Paso 11: `leer` y `leer_cadena`
**Test**: `D_io.p`
**Qué hacer**:
- Añadir tokens: `LEER`, `LEER_CADENA`
- Ya están los nodos AST `ReadStmt` y `ReadStringStmt`
- Añadir keywords a `init.hpp`

#### Paso 12: Cambio de tipo dinámico
**Test**: `G_integracion.p` (cambio_tipo)
**Qué hacer**:
- El AST ya soporta cambio de tipo en `AssignmentStmt::evaluate()`

### Resumen de archivos a tocar por paso

| Paso | Archivos |
|------|----------|
| 1-3 | `interpreter.l` (1 línea cada uno) |
| 4-8 | `interpreter.y` + `interpreter.l` + `init.hpp` + `ast/ast.hpp` + `ast/ast.cpp` |
| 9 | `interpreter.y` + `interpreter.l` + `init.hpp` |
| 10 | `interpreter.l` + `interpreter.y` + `ast/` |
| 11 | `interpreter.y` + `interpreter.l` + `init.hpp` |
| 12 | Nada (ya implementado en AST) |

---

## Restaurar estado limpio

```bash
./backups/restore.sh
```
