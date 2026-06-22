# Ejercicio 2: do-while

## Objetivo
Añadir el bucle `do-while` al intérprete.

Sintaxis:
```
do
    sentencias
while condicion;
```

Ejecuta el cuerpo **al menos una vez** y repite **mientras la condición sea verdadera**.

## Ficheros a modificar

1. **`parser/interpreter.y`**
2. **`table/init.hpp`**

## Cambios en `parser/interpreter.y`

### 1. Declarar token
```
%token DO
```
(`WHILE` ya existe)

### 2. Añadir `do_while` al `%type <st>`
```
%type <st> stmt asgn print read if while block repeat do_while
```

### 3. Añadir la regla gramatical
```
do_while: DO controlSymbol stmtlist WHILE controlSymbol exp SEMICOLON
 		{
			// Create a new do-while statement node
			$$ = new lp::DoWhileStmt($3, $6);

			// To control the interactive mode
			control--;
			control--;
		}
;
```

**¡Ojo con `$N`!** Aquí hay DOS `controlSymbol`, así que:
- `$1` = DO
- `$2` = controlSymbol (1º)
- `$3` = stmtlist
- `$4` = WHILE
- `$5` = controlSymbol (2º)
- `$6` = exp
- `$7` = SEMICOLON

Dos `controlSymbol` → dos `control++` → necesitas dos `control--`.

### 4. Añadir `do_while` a `stmt`
```
| do_while
 {
 }
```

## Cambios en `table/init.hpp`
```
{"do", DO},
```

## Diferencia clave con repeat-until

| Bucle | ¿Se ejecuta al menos una vez? | Condición de salida |
|-------|------------------------------|---------------------|
| `repeat-until` | Sí | Sale cuando es **verdadera** (se repite mientras falsa) |
| `do-while` | Sí | Se repite mientras es **verdadera** (sale cuando falsa) |

## Verificación

```
make && ./interpreter.exe ejercicios/02-do-while/input.txt
```

Salida esperada:
```
0
1
2
3
4
```
