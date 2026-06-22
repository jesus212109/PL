# EXAMEN PRÁCTICO — Pseudocódigo en español
## Procesadores de Lenguajes

---

## 1. Compilación y ejecución

```bash
make clean && clear && make
```

Debe compilar sin errores y con **0 conflictos** en Bison (ni shift/reduce ni reduce/reduce).

```bash
./interpreter.exe                   # Modo interactivo (Ctrl+D para salir)
./interpreter.exe programa.p        # Modo archivo
```

En modo archivo imprime el AST (`printAST()`) y luego ejecuta (`evaluate()`).

---

## 2. Léxico

### 2.1. Palabras reservadas

| Palabra | Uso |
|---------|-----|
| `escribir` | Impresión |
| `leer` | Lectura numérica |
| `leer_cadena` | Lectura de cadena |
| `si`, `entonces`, `si_no`, `fin_si` | Condicional |
| `mientras`, `hacer`, `fin_mientras` | Bucle mientras |
| `repetir`, `hasta_que` | Bucle repetir |
| `para`, `desde`, `hasta`, `paso`, `fin_para` | Bucle para |
| `selector`, `caso`, `defecto`, `fin_selector` | Selector |
| `borrar_pantalla` | Limpiar pantalla |
| `lugar` | Posicionar cursor |
| `y`, `o`, `no` | Operadores lógicos |
| `mod` | Módulo |
| `verdadero`, `falso` | Constantes lógicas |

**Constantes numéricas**: `pi`, `e`, `gamma`, `deg`, `phi` (en minúsculas).

**Funciones**: `seno`, `coseno`, `arctan`, `log`, `log10`, `exp`, `raiz`, `parte_entera`, `abs`, `azar`, `arctan2`.

**Case insensitive**: Todas las palabras clave y constantes se aceptan en mayúsculas o minúsculas. El lexer aplica `tolower()` a los identificadores.

**Keywords compuestos** (`si_no`, `fin_si`, `hasta_que`, `fin_mientras`, `fin_para`, `fin_selector`, `borrar_pantalla`, `leer_cadena`): son tokens únicos con guión bajo, registrados como keywords en `init.hpp`.

### 2.2. Identificadores

Letras, dígitos y `_`. Deben empezar por letra. El `_` no puede estar al final ni haber dos seguidos (`__`).
- Válidos: `dato`, `mi_var`, `x1`
- Inválidos: `_dato`, `dato_`, `dato__1`

### 2.3. Literales

- **Números**: enteros, reales, notación científica (`42`, `3.14`, `1.5e2`, `1.23e-4`).
- **Cadenas**: comillas simples `'...'`. Escapes: `\n`, `\t`, `\\`, `\'`.

### 2.4. Comentarios

- De línea: `#` hasta fin de línea.
- De bloque: `(* ... *)`. No anidados.

### 2.5. Operadores

| Operador | Uso |
|----------|-----|
| `:=` | Asignación |
| `=` | Igualdad relacional |
| `<>` | Desigualdad |
| `<`, `<=`, `>`, `>=` | Orden |
| `+`, `-`, `*`, `/` | Aritméticos |
| `//` | División entera |
| `mod` | Módulo |
| `^` | Potencia |
| `\|\|` | Concatenación de cadenas |
| `{`, `}` | Llaves (solo en `hacer-mientras`) |
| `;` | Fin de sentencia |
| `,` | Separador |
| `(`, `)` | Paréntesis |

---

## 3. Sentencias

Todas las sentencias simples terminan con `;`.

### Asignación
```
identificador := expresión ;
```
Permite asignación múltiple (`a := b := 5;`). Permite cambio de tipo dinámico. No permite asignar a constantes (`pi := 5;` → error).

### Impresión y lectura
```
escribir expresión ;
leer ( identificador ) ;
leer_cadena ( identificador ) ;
```

### Condicional
```
si ( condición ) entonces lista_de_sentencias fin_si ;
si ( condición ) entonces lista_de_sentencias si_no lista_de_sentencias fin_si ;
```

### Bucle mientras
```
mientras ( condición ) hacer lista_de_sentencias fin_mientras ;
```

### Bucle hacer-mientras
```
hacer { lista_de_sentencias } mientras ( condición ) ;
```

### Bucle repetir
```
repetir lista_de_sentencias hasta_que ( condición ) ;
```

### Bucle para
```
para identificador desde exp1 hasta exp2 [paso exp3] hacer lista_de_sentencias fin_para ;
```
El `paso` es opcional (por defecto `1`). Controlar paso cero (error de ejecución).

### Selector
```
selector ( expresión )
  caso expresión_1 : lista_de_sentencias
  caso expresión_2 : lista_de_sentencias
  [defecto : lista_de_sentencias]
fin_selector ;
```

---

## 4. Expresiones

Tipos: **numérico** (`double`), **lógico** (`bool`), **cadena** (`string`).

### Numéricas
```
número, variable, constante, función(exp1, exp2, ...)
exp + exp, exp - exp, exp * exp, exp / exp
exp // exp (división entera), exp mod exp, exp ^ exp
+exp, -exp (unarios)
```

### Lógicas
```
verdadero, falso
exp < exp, exp <= exp, exp > exp, exp >= exp
exp = exp (igualdad), exp <> exp (desigualdad)
exp y exp, exp o exp, no exp
```

### Cadenas
```
'literal de cadena'
exp || exp (concatenación)
```

### Precedencia (de menor a mayor)
```
? : (ternario)          ← ampliación
OR                      ← y
AND                     ← y
relacionales            ← =, <>, <, <=, >, >=
NOT                     ← no
+ -                     ← binarios y unarios
* / // mod              ← multiplicativos
^                       ← potencia (asociativa a derecha)
```

---

## 5. Tareas

1. **Control de argumentos** en `main()` — validar extensión `.p` y fichero existente.
2. **Resolver 1 SR conflict** del Ejemplo 17 (dangling else) → 0 conflictos.
3. **Lexer español** — `:=`, `<>`, `=`, `//`, `\|\|`, `tolower()`, strings con escapes, comentarios.
4. **Tabla de símbolos** — keywords, constantes y funciones en español en `init.hpp`.
5. **Sentencias de control** — `si`, `mientras`, `repetir`, `para`, `selector`, `hacer{}`, `borrar_pantalla`, `lugar`.
6. **AST nuevos** — `DivEnteraNode`, `DoWhileStmt`, `RepeatStmt`, `ForStmt`, `SwitchStmt`.
7. **Ampliaciones** (se valora) — ternario `?:`, `++`/`--`, `+:=`/`-:=`.
8. **Control de errores** — léxicos, sintácticos, semánticos y de ejecución.

---

## 6. Tests

Los tests están en `tests/` (34 ficheros `.p` con pseudocódigo en español). Los `.expected` se generan cuando el intérprete funcione.

```bash
./interpreter.exe tests/A-lexico/A3_numeros.p        # Test individual
./interpreter.exe tests/D-io/D2_leer.p < tests/D-io/D2_leer.input  # Con entrada
./tests/generate-expected.sh                           # Generar .expected
./tests/runner.sh                                      # Ejecutar todos
```
