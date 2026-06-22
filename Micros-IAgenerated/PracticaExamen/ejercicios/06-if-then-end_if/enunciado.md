# Ejercicio 6: if-then-else-end_if

## Objetivo
Reemplazar el `if (cond) stmt` por `if exp then stmtlist end_if` con `else` opcional.
Se elimina el no terminal `cond` (ya no necesitan paréntesis obligatorios) y se usa `exp` directamente.

Nueva sintaxis:
```
if exp then
    sentencias
end_if

if exp then
    sentencias
else
    sentencias
end_if
```

## Ficheros a modificar

1. **`parser/interpreter.y`**
2. **`table/init.hpp`**

## Cambios en `parser/interpreter.y`

### 1. Declarar tokens
```
%token THEN ELSE END_IF
```

### 2. Añadir `%nonassoc THEN` y `%nonassoc ELSE`
Antes de `%left OR CONCAT`, añadir:
```
%nonassoc THEN
%nonassoc ELSE
```

**Esto resuelve el dangling-else**: `ELSE` tiene más precedencia que `THEN`, por lo que se asocia al `if` más cercano.

### 3. Reescribir la regla `if`

Reemplazar la regla `if` antigua por:

```
if:	IF controlSymbol exp THEN stmtlist END_IF
	{
		// Simple conditional without else
		$$ = new lp::IfStmt($3, new lp::BlockStmt($5));

		// To control the interactive mode
		control--;
	}

	| IF controlSymbol exp THEN stmtlist ELSE stmtlist END_IF
	{
		// Compound conditional with else
		$$ = new lp::IfStmt($3, new lp::BlockStmt($5), new lp::BlockStmt($7));

		// To control the interactive mode
		control--;
	}
;
```

### 4. Eliminar el no terminal `cond`
Se elimina la regla `cond: LPAREN exp RPAREN`. Ahora las condiciones son expresiones directamente.

**Nota:** Al eliminar `cond`, asegúrate de que:
- `%type <expNode> exp` ya no incluye `cond`
- La regla `if` ya no usa `cond` sino `exp`

## Cambios en `table/init.hpp`
```
{"then",   THEN},
{"else",   ELSE},    // si no está ya
{"end_if", END_IF},
```

## Dangling-else explicado

El conflicto clásico:
```
if x then if y then stmtlist else stmtlist end_if end_if
```

¿A qué `if` pertenece el `else`? Con `%nonassoc THEN` / `%nonassoc ELSE`, el `else` se asocia al `if` más cercano (el `y`).

## Verificación

```
make && ./interpreter.exe ejercicios/06-if-then-end_if/input.txt
```

Salida esperada:
```
print: 10
```
