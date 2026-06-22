# Ejercicio 5: Operador ternario `? :`

## Objetivo
Añadir el operador ternario `cond ? val_true : val_false`.

## Ficheros a modificar

1. **`parser/interpreter.l`**
2. **`parser/interpreter.y`**

## Cambios en `parser/interpreter.l`

### Añadir reglas para `?` y `:`
```
"?"		{ return '?'; }
":"		{ return ':'; }
```

### Excluir `?` y `:` del estado ERROR
Añadir `?` y `:` a la lista de exclusión en la regla `<ERROR>`:
```
<ERROR>[^0-9+\-*/()\^% \t\n\;a-zA-Z=<>!&?:]
```

## Cambios en `parser/interpreter.y`

### Precedencia
Añadir `%right '?' ':'` **ANTES** de `%left OR` (el ternario tiene la menor precedencia):
```
%right '?' ':'

%left OR CONCAT
```

### Regla de expresión
Dentro de `exp`, añadir:
```
| exp '?' exp ':' exp %prec '?'
	{
		// Create a new ternary node
		$$ = new lp::TernaryNode($1, $3, $5);
	}
```

**¡Ojo con `$N`!**
- `$1` = condición (exp)
- `$2` = `'?'` (token)
- `$3` = valor si verdadero (exp)
- `$4` = `':'` (token)
- `$5` = valor si falso (exp)

## Notas

- `%right '?' ':'`  da al ternario la precedencia más baja y asociatividad por la derecha.
- Si has añadido `%nonassoc THEN ELSE` (ejercicio 6) antes que OR, inserta `%right '?' ':'` entre ELSE y OR. La posición relativa dentro del bloque de precedencias es: justo encima de `%left OR CONCAT`.
- Sin `%prec '?'` en la regla, bison usaría la precedencia del token `'?'`, pero es más seguro ponerlo explícitamente.
- El `TernaryNode` ya existe en el AST. Su `evaluateNumber()` llama a `_cond->evaluateBool()` y devuelve el valor correspondiente.

## Verificación

```
make && ./interpreter.exe ejercicios/05-ternario/input.txt
```

Salida esperada:
```
print: 10
print: 20
```
