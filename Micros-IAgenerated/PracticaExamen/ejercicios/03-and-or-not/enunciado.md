# Ejercicio 3: Case-insensitive + operadores lógicos `and`/`or`/`not`

## Objetivo
Hacer el intérprete **case-insensitive** y añadir las palabras clave `and`, `or`, `not` como operadores lógicos (reemplazando `&&`, `||`, `!`).

## Ficheros a modificar

1. **`parser/interpreter.l`**
2. **`parser/interpreter.y`** (solo si faltan tokens)
3. **`table/init.hpp`**

## Cambios en `parser/interpreter.l`

### 1. Añadir `%option case-insensitive` al principio del fichero
```
%option noyywrap
%option case-insensitive

DIGIT  [0-9]
```

### 2. Eliminar las reglas directas de operadores lógicos
Eliminar estas líneas:
```
"!"  { return NOT; }
"||" { return OR; }
"&&" { return AND; }
```

### 3. Añadir `!`, `||`, `&&` al estado ERROR (opcional, para no tragarlos sin más)
Si no se añaden al ERROR, el intérprete dará error léxico al encontrarlos.

## Cambios en `table/init.hpp`

Añadir al array `keyword[]`:
```
{"or",   OR},
{"and",  AND},
{"not",  NOT},
```

## Caso de prueba

```
x = true;
y = false;
if (x or y) then { print 1; } else { print 0; }
```

Con `%option case-insensitive`, `TRUE`, `True`, `true` son válidos.

## Notas importantes

- `%option case-insensitive` afecta a **todas las reglas del lexer** que contengan caracteres alfabéticos. Los operadores como `+`, `-`, `*` no se ven afectados.
- No es necesario modificar `interpreter.y` para esto — los tokens `OR`, `AND`, `NOT` ya existen en la gramática de ejemplo17.
- Al usar case-insensitive, `IF`, `If`, `iF` todas son válidas.

## Verificación

```
make && ./interpreter.exe ejercicios/03-and-or-not/input.txt
```

Salida esperada:
```
print: false
print: true
print: false
```
