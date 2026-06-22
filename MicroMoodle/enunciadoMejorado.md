# Enunciado del Intérprete de Pseudocódigo en Español

## 1. Objetivo

Construir un intérprete para pseudocódigo en **español** basado en el Ejemplo 17, con las siguientes características:

- Keywords en español (escribir, si, mientras, repetir, para, selector, etc.)
- Case-insensitive (ESCRIBIR, Escribir, escribir son equivalentes)
- Operadores clásicos de pseudocódigo: `:=`, `=`, `<>`, `//`, `mod`, `^`, `||`, `?:`
- Sentencias de control: si-entonces-si_no, mientras-hacer, repetir-hasta_que, hacer-mientras, para-desde-hasta, selector-caso
- Comentarios: `#` línea y `(* bloque *)`
- Strings con comillas simples y escapes (`\n`, `\t`, `\\`, `\'`)
- Identificadores con guiones bajos (no pueden terminar en `_` ni contener `__`)

---

## 2. Keywords en español (mapeo completo)

### Sentencias

| Token (parser) | Keyword inglés | Keyword español |
|---------------|----------------|-----------------|
| `PRINT` | `print` | `escribir` |
| `READ` | `read` | `leer` |
| `READ_STRING` | `read_string` | `leer_cadena` |
| `IF` | `if` | `si` |
| `THEN` | `then` | `entonces` |
| `ELSE` | `else` | `si_no` |
| `END_IF` | `end_if` | `fin_si` |
| `WHILE` | `while` | `mientras` |
| `DO` | `do` | `hacer` |
| `END_WHILE` | `end_while` | `fin_mientras` |
| `REPEAT` | `repeat` | `repetir` |
| `UNTIL` | `until` | `hasta_que` |
| `FOR` | `for` | `para` |
| `FROM` | `from` | `desde` |
| `TO` | `to` | `hasta` |
| `STEP` | `step` | `paso` |
| `END_FOR` | `end_for` | `fin_para` |
| `SWITCH` | `switch` | `selector` |
| `CASE` | `case` | `caso` |
| `DEFAULT` | `default` | `defecto` |
| `END_SWITCH` | `end_switch` | `fin_selector` |
| `CLEAR_SCREEN` | `clear_screen` | `borrar_pantalla` |
| `PLACE` | `place` | `lugar` |

### Operadores lógicos

| Token | Inglés | Español |
|-------|--------|---------|
| `OR` | `or` | `o` |
| `AND` | `and` | `y` |
| `NOT` | `not` | `no` |

### Constantes lógicas

| Token | Inglés | Español |
|-------|--------|---------|
| `true` | `true` | `verdadero` |
| `false` | `false` | `falso` |

### Constantes numéricas

(Los nombres se pasan a minúsculas para coincidir con case-insensitive)

| Constante | Valor |
|-----------|-------|
| `pi` | 3.14159265358979323846 |
| `e` | 2.71828182845904523536 |
| `gamma` | 0.57721566490153286060 |
| `deg` | 57.29577951308232087680 |
| `phi` | 1.61803398874989484820 |

### Funciones predefinidas

| Token | Inglés | Español | Parámetros |
|-------|--------|---------|------------|
| `sin` | `seno` | 1 |
| `cos` | `coseno` | 1 |
| `atan` | `arctan` | 1 |
| `log` | `log` | 1 |
| `log10` | `log10` | 1 |
| `exp` | `exp` | 1 |
| `sqrt` | `raiz` | 1 |
| `integer` | `parte_entera` | 1 |
| `abs` | `valor_absoluto` | 1 |
| `random` | `azar` | 0 |
| `atan2` | `arctan2` | 2 |

---

## 3. Decisiones de diseño

### 3.1 `hasta` vs `hasta_que` (TO vs UNTIL)

**Decisión:** `hasta` = TO (para bucle `para`), `hasta_que` = UNTIL (bucle `repetir`).

**Motivación:**
- Evita conflicto léxico (ambos serían la misma palabra)
- `repetir ... hasta_que (condición)` es más natural en pseudocódigo español
- El parser distingue claramente: `hasta` aparece tras `desde exp`, `hasta_que` aparece tras el cuerpo del `repetir`
- Se registra `"hasta_que"` como keyword → token `UNTIL` en `init.hpp`. El guión bajo lo hace un único identificador para el lexer.

### 3.2 `si_no` como ELSE (dos palabras unidas)

**Decisión:** `si_no` con guión bajo → token `ELSE`.

**Motivación:**
- `else` significa literalmente "si no" en español
- Unido con guión bajo (`si_no`) es un único identificador para el lexer
- Alternativa `sino` sin espacio es confusa visualmente
- Alternativa `si no` con espacio requeriría manejo de tokens múltiples

### 3.3 Case-insensitive real

**Decisión:** Se añade conversión a minúsculas en la regla `{IDENTIFIER}` del lexer antes de la búsqueda en tabla.

```c
std::string identifier(yytext);
for (size_t i = 0; i < identifier.length(); i++) {
    identifier[i] = tolower(identifier[i]);
}
yylval.string = strdup(yytext);  // Conservar original para nombre de variable
```

**Efectos:**
- `ESCRIBIR`, `Escribir`, `escribir` → todas reconocidas como keyword
- Variables `X` y `x` son la **misma** variable (case-insensitive)
- Se conserva el case original en `yylval.string` para depuración y mensajes

**Archivo a modificar:** `parser/interpreter.l`

### 3.4 Tokens compuestos multi-palabra

Varios keywords españoles contienen guión bajo (`_`) para formar una única palabra compuesta:

| Keyword | Razón |
|---------|-------|
| `si_no` | else (evita espacio ambiguo) |
| `fin_si` | end_if |
| `fin_mientras` | end_while |
| `fin_para` | end_for |
| `fin_selector` | end_switch |
| `hasta_que` | until (evita conflicto con hasta) |
| `leer_cadena` | read_string |
| `borrar_pantalla` | clear_screen |
| `valor_absoluto` | abs |
| `parte_entera` | integer |

Todos siguen la regla de identificadores: letras, dígitos, guiones bajos, sin `__` ni `_` final.

### 3.5 `hacer` compartido entre mientras y para y hacer-mientras

El keyword `hacer` (DO) se usa en tres construcciones:
1. `mientras condicion hacer ... fin_mientras` (while)
2. `para var desde exp hasta exp hacer ... fin_para` (for)
3. `hacer ... mientras condicion ;` (do-while)

El parser LALR(1) distingue sin conflictos porque el contexto previo es diferente en cada caso.

### 3.6 Precedencia de operadores (de menor a mayor)

```
  %right '?' ':'            # Ternario (mínima precedencia)
  %left OR                  # o
  %left AND                 # y
  %nonassoc EQUAL NOT_EQUAL GREATER_OR_EQUAL LESS_OR_EQUAL GREATER_THAN LESS_THAN
  %left NOT                 # no
  %left PLUS MINUS          # + -
  %left CONCAT              # || (concatenación)
  %left MULTIPLICATION DIVISION MODULO DIV_ENTERA  # * / mod //
  %left LPAREN RPAREN
  %right INCREMENTO DECREMENTO  # ++ -- (prefijo/sufijo)
  %nonassoc UNARY
  %right POWER              # ^ (máxima precedencia)
  %nonassoc THEN
  %nonassoc ELSE
```

---

## 4. Ficheros a modificar para la implementación

### 4.1 `table/init.hpp`
- Renombrar todas las keywords de inglés a español
- Renombrar constantes numéricas a minúsculas
- Renombrar funciones predefinidas
- No cambian los tokens (PRINT, IF, WHILE, etc. siguen siendo los mismos)

### 4.2 `parser/interpreter.l`
- Añadir conversión `tolower()` en la regla `{IDENTIFIER}` para case-insensitive real
- No requiere cambios de patrones (los keywords se buscan en tabla, no con reglas fijas)

### 4.3 `parser/interpreter.y`
- **No requiere cambios** — los tokens (PRINT, IF, THEN, ELSE, etc.) permanecen idénticos
- Solo se renombran los strings en `init.hpp`
- Verificar 0 sr conflicts tras los cambios

### 4.4 `ast/ast.cpp` / `ast/ast.hpp`
- **No requieren cambios** — la lógica de evaluación es la misma
- Los mensajes de error (`printAST()`) muestran nombres de nodos, no keywords

---

## 5. Tests

### 5.1 Tests en inglés (`tests/`)
- 36 tests verificados contra `main/interpreter.exe`
- Sirven como referencia de funcionalidad
- **No pasarán** tras la traducción a español (usarán keywords en inglés)

### 5.2 Tests en español (`tests-es/`)
- 36 tests paralelos con keywords en español
- Requieren generar `.expected` con `bash generate-es.sh` tras implementar
- Mismos casos de prueba, distinta sintaxis

### 5.3 Cómo ejecutar

```bash
# Tests en inglés (siempre funcionan con main/)
cd PreparaciónExMoodle/tests && bash runner.sh

# Tests en español (requieren intérprete traducido)
cd PreparaciónExMoodle/tests-es && bash generate-es.sh && bash runner-es.sh
```

---

## 6. Ejemplos de sintaxis final

### 6.1 Hola mundo
```
escribir 'Hola mundo';
```

### 6.2 If-else
```
si (x > 0) entonces
  escribir 'positivo';
si_no
  escribir 'negativo';
fin_si;
```

### 6.3 While
```
mientras (x <= 10) hacer
  escribir x;
  x := x + 1;
fin_mientras;
```

### 6.4 Repeat-until
```
repetir
  escribir x;
  x := x + 1;
hasta_que (x > 10);
```

### 6.5 Do-while
```
hacer
  escribir x;
  x := x + 1;
mientras (x <= 10);
```

### 6.6 For
```
para i desde 1 hasta 10 paso 2 hacer
  escribir i;
fin_para;
```

### 6.7 Switch
```
selector (opcion)
  caso 1: escribir 'uno';
  caso 2: escribir 'dos';
  defecto: escribir 'otro';
fin_selector;
```

### 6.8 Programa completo
```
(* factorial.p - Calcula el factorial de un numero *)
escribir 'Introduce un numero: ';
leer(n);
fact := 1;
para i desde 1 hasta n hacer
  fact := fact * i;
fin_para;
escribir 'El factorial es: ';
escribir fact;
```

---

## 7. Restricciones

1. **0 sr conflicts** — ni uno. Usar `controlSymbol` si es necesario.
2. **`%option case-insensitive`** en flex.
3. **Makefiles con `-ansi`** (C++98) para coincidir con Ejemplo 17.
4. **No modificar el AST** a menos que sea estrictamente necesario.
5. **Modificar solo** `parser/interpreter.l`, `parser/interpreter.y`, `table/init.hpp` si es posible.
6. **Verificar** que `si_no` y `hasta_que` no introducen conflictos SR.
