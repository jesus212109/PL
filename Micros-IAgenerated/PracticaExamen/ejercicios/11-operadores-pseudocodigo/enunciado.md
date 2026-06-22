# Ejercicio 11: Operadores pseudocódigo

## Objetivo
Migrar los operadores de estilo C a estilo pseudocódigo:

| Operación | Estilo C (actual) | Pseudocódigo (nuevo) |
|-----------|-------------------|----------------------|
| Asignación | `=` | `:=` |
| Igualdad | `==` | `=` |
| Distinto | `!=` | `<>` |
| Módulo | `%` | `mod` (keyword) |
| División entera | — | `//` |
| Incremento | — | `++` |
| Decremento | — | `--` |

## Ficheros a modificar

1. **`parser/interpreter.l`**
2. **`table/init.hpp`**

## Cambios en `parser/interpreter.l`

### Reemplazar reglas de operadores
```
// ASIGNACION (== → :=)
":="	{ return ASSIGNMENT; }
"="		{ return EQUAL; }
"<>"	{ return NOT_EQUAL; }
"//"	{ return DIV_ENTERA; }
"++"	{ return INCREMENTO; }
"--"	{ return DECREMENTO; }
```

### Eliminar reglas antiguas
Eliminar:
```
"="   { return ASSIGNMENT; }
"=="  { return EQUAL; }
"!="  { return NOT_EQUAL; }
"%"   { return MODULO; }
```

### Actualizar ERROR state
Añadir `:=`, `<>`, `//`, `++`, `--` a las exclusiones del ERROR (o asegurar que las reglas se apliquen antes que el ERROR).

## Cambios en `table/init.hpp`
```
{"mod", MODULO},
```

## Cambios en `parser/interpreter.y`

### Añadir nuevos tokens
```
%token DIV_ENTERA INCREMENTO DECREMENTO
```

### Añadir precedencia
```
%left PLUS MINUS
%left MULTIPLICATION DIVISION MODULO DIV_ENTERA
```

### Añadir reglas en `asgn`
Para `++` y `--`:
```
| INCREMENTO VARIABLE %prec UNARY
    {
        $$ = new lp::PreIncrementStmt($2, true);
    }
| DECREMENTO VARIABLE %prec UNARY
    {
        $$ = new lp::PreIncrementStmt($2, false);
    }
| VARIABLE INCREMENTO
    {
        $$ = new lp::PostIncrementStmt($1, true);
    }
| VARIABLE DECREMENTO
    {
        $$ = new lp::PostIncrementStmt($1, false);
    }
```

### Añadir regla en `exp` para división entera
```
| exp DIV_ENTERA exp
    {
        $$ = new lp::IntegerDivisionNode($1, $3);
    }
```

## Notas

- Los nombres de los tokens NO cambian. Solo cambia qué secuencia de caracteres los produce.
- `ASSIGNMENT` sigue siendo `ASSIGNMENT`, aunque ahora lo produzca `:=` en lugar de `=`.
- Los AST nodes (`PreIncrementStmt`, `PostIncrementStmt`, `IntegerDivisionNode`) ya existen.

## Verificación

```
make && ./interpreter.exe ejercicios/11-operadores-pseudocodigo/input.txt
```

Salida esperada:
```
print: 8
print: 1
print: 2
```
