# Ejercicio 10: read_string y concatenación `||`

## Objetivo
Añadir la sentencia `read_string` para leer cadenas y la concatenación `||` entre strings.

## Ficheros a modificar

1. **`parser/interpreter.l`**
2. **`parser/interpreter.y`**
3. **`table/init.hpp`**

## Cambios en `parser/interpreter.l`

### Añadir regla para `"||"` como CONCAT
```
"||"	{ return CONCAT; }
```

Si ya existe una regla `"||"` que devuelve `OR`, reemplazarla (OR ahora se obtiene vía keyword `or`).

## Cambios en `parser/interpreter.y`

### 1. Declarar token
```
%token READ_STRING
```

### 2. Añadir a `%type <st>`
```
%type <st> ... read_string
```

### 3. Añadir regla para `read_string`
```
read_string: READ_STRING LPAREN VARIABLE RPAREN
    {
        $$ = new lp::ReadStmt($3);
    }
;
```

### 4. Añadir regla de concatenación en `exp`
```
| exp CONCAT exp
    {
        $$ = new lp::ConcatenationNode($1, $3);
    }
;
```

### 5. Añadir `read_string` a `stmt`
```
| read_string SEMICOLON
 {
 }
```

### 6. Declarar `CONCAT` en precedencia
`CONCAT` debe tener la misma precedencia que `OR` (nivel más bajo de todas):
```
%left OR CONCAT
```

## Cambios en `table/init.hpp`
```
{"read_string", READ_STRING},
```

## Notas

### Dependencia del ejercicio 3
La regla `"||"` se reasigna de `OR` a `CONCAT`. Si no has hecho el ejercicio 3, `||` aún devuelve `OR` y tendrás que eliminar esa regla antes de añadir la nueva.

### `read_string` no es totalmente funcional
La regla gramatical usa `ReadStmt`, pero `ReadStmt::evaluate()` solo lee números (`std::cin >> double`). Para leer strings correctamente se necesita una clase `ReadStringStmt` que no está en el AST proporcionado. La regla compila, pero en ejecución leerá un número en lugar de un string.

### Concatenación
`ConcatenationNode` ya existe en el AST. La concatenación solo funciona si ambos operandos son strings (o se convierten).

## Verificación

```
make && ./interpreter.exe ejercicios/10-read-string/input.txt
```
