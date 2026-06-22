# Ejercicio 4: `for` con FROM/TO/STEP

## Objetivo
Añadir el bucle `for` con las palabras clave `for`, `from`, `to`, `step`, `end_for`.

Sintaxis:
```
for id from exp to exp do
    sentencias
end_for
```

`step exp` es **opcional**. Si no se especifica, `step` = 1.

## Ficheros a modificar

1. **`parser/interpreter.y`**
2. **`table/init.hpp`**

## Cambios en `parser/interpreter.y`

### 1. Declarar tokens
```
%token FOR FROM TO STEP END_FOR
```
(`DO` ya debería estar del ejercicio 2)

### 2. Añadir al `%type <st>`
```
%type <st> ... for_stmt
```

### 3. Añadir regla gramatical (dos alternativas)

**Sin STEP (usa valor por defecto 1):**
```
for_stmt: FOR controlSymbol VARIABLE FROM exp TO exp DO stmtlist END_FOR
    {
        $$ = new lp::ForStmt($3, $5, $7, new lp::BlockStmt($9), NULL);
        control--;
    }
;
```

**Con STEP:**
```
for_stmt: FOR controlSymbol VARIABLE FROM exp TO exp STEP exp DO stmtlist END_FOR
    {
        $$ = new lp::ForStmt($3, $5, $7, new lp::BlockStmt($11), $9);
        control--;
    }
;
```

**¡Ojo con `$N`!** Las posiciones cambian entre ambas reglas.

Sin STEP:
| $1 | $2 | $3 | $4 | $5 | $6 | $7 | $8 | $9 | $10 |
|----|----|----|----|----|----|----|----|----|-----|
| FOR | controlSymbol | VARIABLE | FROM | exp | TO | exp | DO | stmtlist | END_FOR |

Con STEP:
| $1 | $2 | $3 | $4 | $5 | $6 | $7 | $8 | $9 | $10 | $11 | $12 |
|----|----|----|----|----|----|----|----|----|-----|-----|-----|
| FOR | controlSymbol | VARIABLE | FROM | exp | TO | exp | STEP | exp | DO | stmtlist | END_FOR |

En la versión con STEP, `$9` es `step exp` y `$11` es `stmtlist`.

### 4. Añadir a `stmt`
```
| for_stmt
 {
 }
```

## Cambios en `table/init.hpp`
```
{"for",     FOR},
{"from",    FROM},
{"to",      TO},
{"step",    STEP},
{"end_for", END_FOR},
{"do",      DO},     // si no está ya
```

## Clase AST

`ForStmt` ya existe. Constructor: `ForStmt(id, from, to, body, step = NULL)`. Si `step` es `NULL`, se usa `1.0` como paso.

## Verificación

```
make && ./interpreter.exe ejercicios/04-for-step-to/input.txt
```

Salida esperada:
```
0
1
2
3
4
```
