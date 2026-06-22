# Ejercicio 1: repeat-until

## Objetivo
Añadir el bucle `repeat-until` al intérprete.

Sintaxis:
```
repeat
    sentencias
until condicion;
```

Ejecuta el cuerpo **al menos una vez** y repite **mientras la condición sea falsa** (sale cuando la condición es verdadera).

## Ficheros a modificar

1. **`parser/interpreter.y`**
2. **`table/init.hpp`**

## Cambios en `parser/interpreter.y`

### 1. Declarar tokens
Añadir en la sección de `%token`:
```
%token REPEAT UNTIL
```

### 2. Añadir `repeat` al `%type <st>`
Buscar la línea que contiene `%type <st> stmt asgn print read if while block` y añadir `repeat` al final:
```
%type <st> stmt asgn print read if while block repeat
```

### 3. Añadir la regla gramatical
Añadir tras la regla `while`:

```
repeat:	REPEAT controlSymbol stmtlist UNTIL exp SEMICOLON
		{
			// Create a new repeat statement node
			$$ = new lp::RepeatStmt($3, $5);

			// To control the interactive mode
			control--;
		}
;
```

**Pista sobre `$N`:** ¿Por qué `$3` es `stmtlist` y `$5` es `exp`?
- `$1` = REPEAT (token)
- `$2` = controlSymbol (epsilon, no value)
- `$3` = stmtlist
- `$4` = UNTIL (token)
- `$5` = exp
- `$6` = SEMICOLON (token)

### 4. Añadir `repeat` a la sección `stmt`
```
| repeat
 {
	// Default action: $$ = $1;
 }
```

## Cambios en `table/init.hpp`

Añadir al array `keyword[]`:
```
{"repeat", REPEAT},
{"until", UNTIL},
```

## Clase AST ya disponible

`RepeatStmt` ya está declarada en `ast.hpp` e implementada en `ast.cpp`. Su `evaluate()` ejecuta el cuerpo y comprueba la condición con `!this->_cond->evaluateBool()` (se repite mientras la condición sea falsa).

## Verificación

```bash
make
./interpreter.exe ejercicios/01-repeat-until/input.txt
```

Salida esperada:
```
1
2
3
4
5
```
