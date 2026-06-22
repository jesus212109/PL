# TRABAJO DE PREPARACIÓN DEL EXAMEN DE PRÁCTICAS
## Procesadores de Lenguajes — Ejercicio Práctico

---

## 0. Punto de partida

Se parte del **Ejemplo 17** (intérprete básico con AST, tabla de símbolos y sentencias `if`/`while`/`block`). El código base incluye:

- **AST extendido** con `StringNode`, `ConcatNode`, `ReadStringStmt`, `ClearScreenStmt`, `PlaceStmt` y soporte de tipo STRING en asignación e impresión.
- **Tabla de símbolos** con `StringVariable` para variables de tipo cadena.
- **34 tests** en `tests/` que definen el comportamiento esperado del lenguaje final.

El Ejemplo 17 original usa keywords en inglés (`print`, `read`, `if`, `while`) y operadores C-style (`=`, `==`, `!=`). Tu trabajo es **traducirlo al pseudocódigo en español** descrito en este enunciado, añadir las estructuras de control nuevas, y resolver el conflicto SR del dangling else.

---

## 1. Requisitos de compilación (CRÍTICO)

El intérprete **debe** cumplir estas condiciones o es **suspenso**:

1. **Compila sin errores**: `make` produce `interpreter.exe` sin errores.
2. **0 conflictos Bison**: Ni un solo shift/reduce ni reduce/reduce. Verificar con:
   ```bash
   cd parser && bison -d -t -g interpreter.y 2>&1 | grep -i conflict
   ```
   Si muestra algún conflicto, examen suspenso. El Ejemplo 17 original tiene 1 SR conflict (dangling else). Debes eliminarlo.

---

## 2. Ejecución

```bash
./interpreter.exe                   # Modo interactivo (terminar con Ctrl+D)
./interpreter.exe programa.p        # Modo archivo (extensión .p obligatoria)
```

En modo archivo, el intérprete:
1. Imprime el AST (`printAST()`)
2. Ejecuta el programa (`evaluate()`)

---

## 3. Componentes léxicos (tokens)

### 3.1. Palabras reservadas en español

| Palabra | Token Bison | Uso |
|---------|-------------|-----|
| `escribir` | ESCRIBIR | Impresión |
| `leer` | LEER | Lectura numérica |
| `leer_cadena` | LEER_CADENA | Lectura de cadena |
| `si` | SI | Condicional |
| `entonces` | ENTONCES | Parte de `si` |
| `si_no` | SI_NO | Alternativa (**un solo token** con guión bajo) |
| `fin_si` | FIN_SI | Fin de `si` |
| `mientras` | MIENTRAS | Bucle `mientras` / fin de `hacer-mientras` |
| `hacer` | HACER | Parte de `mientras` / inicio de `hacer-mientras` |
| `fin_mientras` | FIN_MIENTRAS | Fin de `mientras` |
| `repetir` | REPETIR | Bucle `repetir` |
| `hasta_que` | HASTA_QUE | Fin de `repetir` (**un solo token**, NO confundir con `hasta`) |
| `para` | PARA | Bucle `para` |
| `desde` | DESDE | Inicio de rango en `para` |
| `hasta` | HASTA | Fin de rango en `para` |
| `paso` | PASO | Paso en `para` |
| `fin_para` | FIN_PARA | Fin de `para` |
| `selector` | SELECCION | Switch |
| `caso` | CASO | Case en `selector` |
| `defecto` | DEFECTO | Default en `selector` |
| `fin_selector` | FIN_SELECCION | Fin de `selector` |
| `borrar_pantalla` | BORRAR_PANTALLA | Limpiar pantalla |
| `lugar` | LUGAR | Posicionar cursor |

### 3.2. Operadores lógicos y módulo como keywords

| Palabra | Token Bison | Uso |
|---------|-------------|-----|
| `y` | AND | Conjunción lógica |
| `o` | OR | Disyunción lógica |
| `no` | NOT | Negación lógica |
| `mod` | MOD | Módulo |

### 3.3. Constantes predefinidas

| Nombre | Valor | Tipo |
|--------|-------|------|
| `verdadero` | true | Lógico |
| `falso` | false | Lógico |
| `pi` | 3.14159265... | Numérico |
| `e` | 2.71828182... | Numérico |
| `gamma` | 0.57721566... | Numérico |
| `deg` | 57.29577951... | Numérico |
| `phi` | 1.61803398... | Numérico |

### 3.4. Funciones predefinidas

| Nombre español | Parámetros | Función C |
|----------------|------------|-----------|
| `seno` | 1 | sin |
| `coseno` | 1 | cos |
| `arctan` | 1 | atan |
| `log` | 1 | Log |
| `log10` | 1 | Log10 |
| `exp` | 1 | Exp |
| `raiz` | 1 | Sqrt |
| `parte_entera` | 1 | integer |
| `abs` | 1 | fabs |
| `azar` | 0 | Random |
| `arctan2` | 2 | Atan2 |

### 3.5. Reglas léxicas

- **Case insensitive**: Todas las palabras clave se aceptan en mayúsculas o minúsculas. El lexer aplica `tolower()` a los identificadores antes de buscar en la tabla de símbolos. Ejemplo: `Escribir`, `ESCRIBIR` y `escribir` son equivalentes; `X` y `x` son la misma variable.

- **Identificadores**: Letras, dígitos y `_`. Deben empezar por letra. El `_` no puede estar al final ni haber dos seguidos (`__`).
  - Válidos: `dato`, `mi_var`, `x1`, `contador_2`
  - Inválidos: `_dato`, `dato_`, `dato__1`

- **Números**: Enteros, reales y notación científica. Ejemplos: `42`, `3.14`, `1.5e2`, `1.23e-4`, `0`.

- **Cadenas**: Delimitadas por comillas simples `'...'`. Soportan escapes: `\n` (nueva línea), `\t` (tabulador), `\\` (barra invertida), `\'` (comilla simple). Ejemplo: `'hola\nmundo'`.

- **Comentarios**:
  - De línea: todo lo que sigue a `#` hasta el fin de línea.
  - De bloque: entre `(*` y `*)`. No se permite anidamiento.

### 3.6. Operadores

| Operador | Token Bison | Tipo |
|----------|-------------|------|
| `:=` | ASSIGNMENT | Asignación |
| `=` | EQUAL | Igualdad relacional |
| `<>` | NOT_EQUAL | Desigualdad relacional |
| `<` | LESS_THAN | Menor que |
| `<=` | LESS_OR_EQUAL | Menor o igual |
| `>` | GREATER_THAN | Mayor que |
| `>=` | GREATER_OR_EQUAL | Mayor o igual |
| `+` | PLUS | Suma / unario positivo |
| `-` | MINUS | Resta / unario negativo |
| `*` | MULTIPLICATION | Producto |
| `/` | DIVISION | División real |
| `//` | DIV_ENTERA | División entera |
| `mod` | MOD | Módulo (keyword) |
| `^` | POWER | Potencia |
| `\|\|` | CONCAT | Concatenación de cadenas |
| `{` | LETFCURLYBRACKET | Llave izquierda (solo en `hacer-mientras`) |
| `}` | RIGHTCURLYBRACKET | Llave derecha (solo en `hacer-mientras`) |
| `;` | SEMICOLON | Fin de sentencia |
| `,` | COMMA | Separador de parámetros |
| `(` | LPAREN | Paréntesis izquierdo |
| `)` | RPAREN | Paréntesis derecho |
| `:` | ':' | Separador en `selector/caso` y ternario |
| `?` | '?' | Operador ternario (ampliación) |
| `++` | INCREMENT | Incremento (ampliación) |
| `--` | DECREMENT | Decremento (ampliación) |
| `+:=` | PLUS_ASSIGN | Asignación con suma (ampliación) |
| `-:=` | MINUS_ASSIGN | Asignación con resta (ampliación) |

---

## 4. Sentencias

Todas las sentencias simples terminan obligatoriamente con `;`.

### 4.1. Asignación

```
identificador := expresión ;
```

- La variable se declara o actualiza dinámicamente.
- Permite cambio de tipo en tiempo de ejecución (una variable numérica puede volverse string).
- Permite asignación múltiple: `a := b := 5;`
- **No** permite asignar a constantes predefinidas. Ejemplo: `pi := 5;` → error semántico.

### 4.2. Impresión

```
escribir expresión ;
```

- Acepta expresiones numéricas, lógicas y de cadena.
- Los booleanos se imprimen como `true` o `false`.
- Las cadenas se imprimen sin comillas exteriores.

### 4.3. Lectura

```
leer ( identificador ) ;
leer_cadena ( identificador ) ;
```

- `leer`: Lee un número por stdin y lo asigna a la variable.
- `leer_cadena`: Lee una línea de texto por stdin y la asigna como cadena (sin comillas).

### 4.4. Condicional `si`

**Simple:**
```
si ( condición )
entonces
  lista_de_sentencias
fin_si ;
```

**Compuesta:**
```
si ( condición )
entonces
  lista_de_sentencias
si_no
  lista_de_sentencias
fin_si ;
```

- `si_no` y `fin_si` son tokens únicos (con guión bajo).
- La condición debe ir entre paréntesis.
- Se permite anidamiento de `si` dentro de `si`.
- El conflicto de "dangling else" debe resolverse sin generar conflictos SR (ver sección 7).

### 4.5. Bucle `mientras`

```
mientras ( condición ) hacer
  lista_de_sentencias
fin_mientras ;
```

### 4.6. Bucle `hacer-mientras`

```
hacer {
  lista_de_sentencias
} mientras ( condición ) ;
```

- Las llaves `{ }` son **obligatorias**.
- Termina con `;` después del paréntesis de cierre.

### 4.7. Bucle `repetir`

```
repetir
  lista_de_sentencias
hasta_que ( condición ) ;
```

- `hasta_que` es un solo token (con guión bajo). **No confundir** con `hasta` (que es el TO de `para`).
- Termina con `;` después del paréntesis de cierre.

### 4.8. Bucle `para`

```
para identificador desde expresión_numérica hasta expresión_numérica
  [paso expresión_numérica]
hacer
  lista_de_sentencias
fin_para ;
```

- El `paso` es **opcional**; por defecto es `1`.
- La variable de control se crea o actualiza automáticamente.
- Se debe controlar bucles infinitos (paso cero debe dar error de ejecución).

### 4.9. Selector (switch)

```
selector ( expresión )
  caso expresión_1 : lista_de_sentencias
  caso expresión_2 : lista_de_sentencias
  [defecto : lista_de_sentencias]
fin_selector ;
```

- Los `caso` se evalúan en orden. Al encontrar coincidencia, se ejecuta el bloque y se sale.
- Si no hay coincidencia y existe `defecto`, se ejecuta ese bloque.

---

## 5. Expresiones

Las expresiones pueden ser de tipo **numérico** (`double`), **lógico** (`bool`) o **cadena** (`string`).

### 5.1. Expresiones numéricas

```
número                                          → NumberNode
variable                                        → VariableNode
constante_predefinida                           → ConstantNode
función_predefinida ( lista_de_expresiones )    → BuiltinFunctionNode
expresión + expresión                           → PlusNode
expresión - expresión                           → MinusNode
expresión * expresión                           → MultiplicationNode
expresión / expresión                           → DivisionNode
expresión // expresión                          → DivEnteraNode (NUEVO)
expresión mod expresión                         → ModuloNode
expresión ^ expresión                           → PowerNode
- expresión                                     → UnaryMinusNode
+ expresión                                     → UnaryPlusNode
```

### 5.2. Expresiones lógicas

```
verdadero                                       → ConstantNode (BOOL)
falso                                           → ConstantNode (BOOL)
expresión < expresión                           → LessThanNode
expresión <= expresión                          → LessOrEqualNode
expresión > expresión                           → GreaterThanNode
expresión >= expresión                          → GreaterOrEqualNode
expresión = expresión                           → EqualNode (igualdad, NO asignación)
expresión <> expresión                          → NotEqualNode
expresión y expresión                           → AndNode
expresión o expresión                           → OrNode
no expresión                                    → NotNode
```

### 5.3. Expresiones de cadena

```
'literal de cadena'                             → StringNode
expresión || expresión                          → ConcatNode (NUEVO)
```

### 5.4. Operador ternario (ampliación)

```
( condición ? expresión_verdadera : expresión_falsa )
```

### 5.5. Precedencia de operadores (de menor a mayor)

```
? : (ternario)          ← %right '?' ':'
OR                      ← %left OR
AND                     ← %left AND
relacionales            ← %nonassoc GREATER_OR_EQUAL LESS_OR_EQUAL GREATER_THAN LESS_THAN EQUAL NOT_EQUAL
NOT                     ← %left NOT
+ -                     ← %left PLUS MINUS
* / // mod              ← %left MULTIPLICATION DIVISION DIV_ENTERA MOD
unarios                 ← %nonassoc UNARY
^                       ← %right POWER
```

**IMPORTANTE**: El operador ternario `? :` va **antes** de OR en precedencia, no entre los relacionales.

---

## 6. AST pre-implementado (no necesitas crear estos nodos)

El código base ya incluye estos nodos del árbol sintáctico. Solo necesitas usarlos desde las reglas de Bison:

| Nodo AST | Qué hace | Estado |
|----------|----------|--------|
| `NumberNode` | Literal numérico | Completo |
| `VariableNode` | Variable (numérica, lógica o string) | Completo |
| `ConstantNode` | Constante predefinida (`pi`, `verdadero`, etc.) | Completo |
| `StringNode` | Literal de cadena `'...'` | Completo |
| `ConcatNode` | Concatenación `\|\|` | Completo |
| `PlusNode`, `MinusNode`, `MultiplicationNode`, `DivisionNode`, `ModuloNode`, `PowerNode` | Operadores aritméticos | Completo |
| `GreaterThanNode`, `GreaterOrEqualNode`, `LessThanNode`, `LessOrEqualNode`, `EqualNode`, `NotEqualNode` | Operadores relacionales | Completo |
| `AndNode`, `OrNode`, `NotNode` | Operadores lógicos | Completo |
| `UnaryMinusNode`, `UnaryPlusNode` | Unarios | Completo |
| `BuiltinFunctionNode_0/1/2` | Funciones predefinidas | Completo |
| `AssignmentStmt` | Asignación (con soporte STRING) | Completo |
| `PrintStmt` | Impresión (con soporte STRING) | Completo |
| `ReadStmt` | Lectura numérica `leer(x)` | Completo |
| `ReadStringStmt` | Lectura de cadena `leer_cadena(s)` | Completo, `// AÑADIDO PARA EXAMEN` |
| `EmptyStmt` | Sentencia vacía (`;` sola) | Completo |
| `IfStmt` | Condicional `si/entonces/si_no/fin_si` | Completo |
| `WhileStmt` | Bucle `mientras/hacer/fin_mientras` | Completo |
| `BlockStmt` | Bloque de sentencias `{ ... }` | Completo |
| `ClearScreenStmt` | `borrar_pantalla;` | Completo (usa macro `CLEAR_SCREEN`) |
| `PlaceStmt` | `lugar(fila, col);` | Completo (evaluate vacío, puedes implementarlo) |

---

## 7. Tareas del alumno

### Tarea 0: Control de argumentos en main
- **Archivo**: `interpreter.cpp`
- **Qué**: Validar que el fichero pasado como argumento tiene extensión `.p` y existe. Si no, mostrar error.

### Tarea 1: Resolver conflicto dangling else (OBLIGATORIO)
- **Archivo**: `parser/interpreter.y`
- **Qué**: El Ejemplo 17 tiene 1 SR conflict. Debe eliminarse.
- **Cómo**: Añadir `%nonassoc THEN` y `%nonassoc ELSE` (con ELSE después de THEN). La regla `si` simple lleva `%prec THEN`.
- **Verificar**: `bison -v` → `.output` debe mostrar 0 conflicts.

### Tarea 2: Traducir léxico al español
- **Archivo**: `parser/interpreter.l`
- **Qué**: 
  - Cambiar operadores: `=` → `:=` (asignación), `==` → `=` (igualdad), `!=` → `<>` (desigualdad)
  - Añadir operadores: `//` (división entera), `\|\|` (concatenación)
  - Añadir `tolower()` en la regla `{IDENTIFIER}`
  - Añadir regla para strings con escapes (`'...'`)
  - Añadir reglas para comentarios (`#` línea, `(* *)` bloque)

### Tarea 3: Traducir tabla de símbolos
- **Archivo**: `table/init.hpp`
- **Qué**: 
  - Constantes numéricas en minúsculas: `pi`, `e`, `gamma`, `deg`, `phi`
  - Constantes lógicas en español: `verdadero`, `falso`
  - Keywords en español: `escribir`, `leer`, `leer_cadena`, `si`, `entonces`, `si_no`, `fin_si`, `mientras`, `hacer`, `fin_mientras`, `repetir`, `hasta_que`, `para`, `desde`, `hasta`, `paso`, `fin_para`, `selector`, `caso`, `defecto`, `fin_selector`, `borrar_pantalla`, `lugar`, `y`, `o`, `no`, `mod`
  - Funciones en español: `seno`, `coseno`, `arctan`, `raiz`, `parte_entera`, `azar`, `arctan2`

### Tarea 4: Sentencias de control básicas
- **Archivos**: `parser/interpreter.y`, `ast/ast.hpp`, `ast/ast.cpp`
- **Qué**: 
  - Reglas Bison para `escribir`, `leer`, `leer_cadena`
  - Reglas Bison para `si/entonces/si_no/fin_si` (usando `controlSymbol` y `%prec THEN`)
  - Regla Bison para `mientras/hacer/fin_mientras`

### Tarea 5: Estructuras de control nuevas
- **Archivos**: `parser/interpreter.y`, `ast/ast.hpp`, `ast/ast.cpp`
- **Qué**: Crear nodos AST nuevos + reglas Bison para:
  - `DivEnteraNode`: división entera `//` (nodo de expresión)
  - `DoWhileStmt`: `hacer {...} mientras (cond);`
  - `RepeatStmt`: `repetir ... hasta_que (cond);`
  - `ForStmt`: `para i desde X hasta Y [paso Z] hacer ... fin_para;`
  - `SwitchStmt`: `selector (x) caso 1: ... caso 2: ... defecto: ... fin_selector;`

### Tarea 6: Ampliaciones (opcional, se valora)
- **Archivos**: `parser/interpreter.l`, `parser/interpreter.y`, `ast/`
- **Qué**:
  - Operador ternario `?:`
  - Operadores `++`/`--` (pre y post)
  - Asignación compuesta `+:=`/`-:=`

### Tarea 7: Control de errores
- **Archivos**: `parser/interpreter.l`, `parser/interpreter.y`
- **Qué**: Control de errores léxicos, sintácticos, semánticos y de ejecución. Bison ya tiene `stmtlist error` para recuperación de errores sintácticos.

---

## 8. Notas de diseño Bison (0 conflictos)

### 8.1. Dangling else

El Ejemplo 17 tiene 1 SR conflict por el dangling else. Para eliminarlo:

```bison
%nonassoc THEN
%nonassoc ELSE

si:
    SI controlSymbol cond ENTONCES stmtlist FIN_SI SEMICOLON %prec THEN
        { /* if simple */ }
    | SI controlSymbol cond ENTONCES stmtlist SI_NO stmtlist FIN_SI SEMICOLON
        { /* if-else */ }
;
```

`THEN` es un token ficticio (no se usa en el lexer). Su único propósito es dar precedencia a la regla simple sobre la compuesta.

### 8.2. controlSymbol

```bison
controlSymbol:
    /* epsilon */
    { control++; }
;
```

Regla epsilon que incrementa `control` antes de entrar en estructuras de control. Sirve para el modo interactivo. Los `$N` se desplazan al añadir esta regla — ¡cuidado al contar!

### 8.3. hacer-mientras

Las llaves `{` y `}` son tokens obligatorios. El `;` final es obligatorio:
```
hacer { lista } mientras ( condición ) ;
```

### 8.4. repetir vs hasta

- `hasta_que` (HASTA_QUE) → fin de `repetir`
- `hasta` (HASTA) → fin de rango en `para`

Son tokens diferentes. No confundir.

### 8.5. Keywords compuestos

`si_no`, `fin_si`, `hasta_que`, `fin_mientras`, `fin_para`, `fin_selector`, `borrar_pantalla`, `leer_cadena` — todos son tokens únicos con guión bajo. Se registran como keywords en `init.hpp` (no en el lexer).

### 8.6. Case insensitive

Hay dos opciones. La recomendada es `tolower()` en la regla `{IDENTIFIER}` del lexer, ya que es más compatible con el estilo del Ejemplo 17.

---

## 9. Sistema de tests

### 9.1. Estructura

Los tests están en `tests/` organizados por categoría:

```
tests/
├── A-lexico/       (5 tests)   — IDs, case insensitive, números, cadenas, comentarios
├── B-operadores/   (8 tests)   — Asignación, aritméticos, unarios, relacionales, lógicos,
│                                  concatenación, ternario, compuestos
├── C-sentencias/   (9 tests)   — si simple/compuesto/anidado, mientras, hacer-mientras,
│                                  repetir, para, para con paso, selector
├── D-io/           (3 tests)   — escribir, leer, leer_cadena
├── E-pantalla/     (2 tests)   — borrar_pantalla, lugar
├── F-errores/      (3 tests)   — léxico, sintáctico, semántico
├── G-integracion/  (4 tests)   — factorial, cambio_tipo, incremento, validación
├── runner.sh                    — Ejecuta todos los tests
└── generate-expected.sh         — Genera ficheros .expected
```

### 9.2. Ficheros de test

Cada test consta de:

| Fichero | Propósito |
|---------|-----------|
| `nombre.p` | Código fuente en pseudocódigo español |
| `nombre.expected` | Salida esperada (AST + ejecución) — **NO existe todavía** |
| `nombre.input` (opcional) | Entrada stdin para tests con `leer`/`leer_cadena` |

Los `.p` son tu **especificación**: definen qué código debe aceptar el intérprete. Los `.expected` se generan cuando el intérprete funciona.

### 9.3. Flujo de trabajo TDD

```
1. Leer el test .p                    → Saber qué debe hacer
2. Implementar la feature             → En .l, .y, init.hpp o ast/
3. Compilar: make                     → 0 errores, 0 conflicts
4. Ejecutar: ./interpreter.exe test.p → Verificar salida manualmente
5. Cuando todo funcione:
   ./tests/generate-expected.sh       → Genera todos los .expected
   ./tests/runner.sh                  → Verifica que todos pasan
```

### 9.4. Ejecutar tests individuales

```bash
./interpreter.exe tests/A-lexico/A3_numeros.p
```

Para tests con entrada (`.input`):
```bash
./interpreter.exe tests/D-io/D2_leer.p < tests/D-io/D2_leer.input
```

### 9.5. Ejecutar todos los tests

```bash
./tests/runner.sh                     # Ejecuta y compara con .expected
./tests/runner.sh --no-color          # Sin colores (para redirigir a fichero)
```

### 9.6. Generar ficheros .expected

```bash
./tests/generate-expected.sh          # Ejecuta cada .p y guarda salida como .expected
```

**Solo ejecutar esto cuando el intérprete esté completamente funcional.** Los `.expected` se generan ejecutando `./interpreter.exe test.p` y guardando la salida.

---

## 10. Estructura de ficheros

```
.
├── ast/
│   ├── ast.hpp              ← AST (MODIFICAR: añadir DivEnteraNode, DoWhileStmt, etc.)
│   ├── ast.cpp              ← AST (MODIFICAR: implementar printAST/evaluate de nodos nuevos)
│   └── makefile
├── table/
│   ├── init.hpp             ← Tabla de símbolos (MODIFICAR: keywords español, constantes, funciones)
│   ├── init.cpp             ← Sin cambios
│   ├── stringVariable.hpp   ← NUEVO (ya hecho, para soporte STRING)
│   ├── stringVariable.cpp   ← NUEVO (ya hecho)
│   ├── table.hpp            ← Sin cambios
│   ├── table.cpp            ← Sin cambios
│   └── makefile             ← Modificado (incluye stringVariable.o)
├── parser/
│   ├── interpreter.l        ← Lexer (MODIFICAR: español, tolower, operadores, strings, comentarios)
│   ├── interpreter.y        ← Parser (MODIFICAR: español, sentencias, 0 conflicts)
│   └── makefile
├── error/                   ← Sin cambios
├── includes/
│   └── macros.hpp           ← Sin cambios (CLEAR_SCREEN, PLACE, colores)
├── interpreter.cpp          ← Main (MODIFICAR: control de argumentos)
├── makefile                 ← Sin cambios
├── tests/                   ← 34 tests de referencia
├── backups/                 ← Copias limpias (restore.sh para restaurar)
├── enunciado.md             ← Este fichero
└── Doxyfile                 ← Documentación
```

### Archivos que NO debes modificar

- `error/*`, `includes/*`, `table/table.*`, `table/symbol.*`, `table/variable.*`, `table/numericVariable.*`, `table/logicalVariable.*`, `table/constant.*`, `table/numericConstant.*`, `table/logicalConstant.*`, `table/keyword.*`, `table/builtin*.*`, `table/mathFunction.*`, `table/stringVariable.*`
- `Doxyfile`, `makefile` (raíz)

### Archivos que SÍ debes modificar

- `interpreter.cpp` — Control de argumentos
- `parser/interpreter.l` — Lexer español
- `parser/interpreter.y` — Parser español + 0 conflicts
- `table/init.hpp` — Keywords, constantes y funciones en español
- `ast/ast.hpp` — Nodos AST nuevos (DivEnteraNode, DoWhileStmt, RepeatStmt, ForStmt, SwitchStmt)
- `ast/ast.cpp` — Implementaciones de los nodos nuevos

---

## 11. Restaurar estado limpio

Si necesitas empezar de cero:

```bash
./backups/restore.sh
```

Esto restaura `parser/`, `table/`, `ast/` e `interpreter.cpp` al estado original del skeleton.
