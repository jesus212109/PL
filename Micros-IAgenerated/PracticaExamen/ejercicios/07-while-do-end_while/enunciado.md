# Ejercicio 7: while-do-end_while

## Objetivo
Reemplazar la sintaxis `while (cond) stmt` por `while exp do stmtlist end_while`.

## Ficheros a modificar

1. **`parser/interpreter.y`**
2. **`table/init.hpp`**

## Cambios en `parser/interpreter.y`

### 1. Declarar token
```
%token END_WHILE
```
(`WHILE` y `DO` ya existen de ejercicios anteriores)

### 2. Reescribir la regla `while`

Reemplazar la regla `while` antigua por:

```
while:	WHILE controlSymbol exp DO stmtlist END_WHILE
	{
		// Create a new while node with implicit block
		$$ = new lp::WhileStmt($3, new lp::BlockStmt($5));

		// To control the interactive mode
		control--;
	}
;
```

### 3. Eliminar `cond`
Al igual que con `if`, elimina el uso de `cond` y usa `exp` directamente.

**Nota:** Si ya eliminaste `cond` en el ejercicio 6, este paso ya está hecho.

## Cambios en `table/init.hpp`
```
{"end_while", END_WHILE},
```

## Notas

- Al usar `stmtlist` en lugar de `stmt`, el cuerpo puede tener múltiples sentencias sin llaves.
- El `stmtlist` se envuelve en un `BlockStmt` para que quepa donde se espera un `Statement*`.
- La clase `WhileStmt` ya existe en el AST.

## Verificación

```
make && ./interpreter.exe ejercicios/07-while-do-end_while/input.txt
```

Salida esperada:
```
0
1
2
3
4
```
