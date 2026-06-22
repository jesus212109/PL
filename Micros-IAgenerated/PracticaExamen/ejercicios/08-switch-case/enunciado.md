# Ejercicio 8: switch-case-default

## Objetivo
Añadir la sentencia `switch-case-default` con la siguiente sintaxis:

```
switch (exp)
    case exp: stmtlist
    case exp: stmtlist
    default: stmtlist
end_switch
```

## Ficheros a modificar

1. **`parser/interpreter.y`**
2. **`table/init.hpp`**

## Cambios en `parser/interpreter.y`

### 1. Declarar tokens
```
%token SWITCH CASE DEFAULT END_SWITCH
```

### 2. Añadir al `%type <st>`
```
%type <st> ... switch_stmt case_list
```

### 3. Reglas gramaticales

```
case_list: case_list CASE exp ':' stmtlist
    {
        lp::SwitchStmt *sw = (lp::SwitchStmt *) $1;
        sw->addCase($3, new lp::BlockStmt($5));
        $$ = sw;
    }
    | CASE exp ':' stmtlist
    {
        lp::SwitchStmt *sw = new lp::SwitchStmt(NULL);
        sw->addCase($2, new lp::BlockStmt($4));
        $$ = (lp::Statement *) sw;
    }
;

switch_stmt: SWITCH LPAREN exp RPAREN case_list END_SWITCH
    {
        lp::SwitchStmt *sw = (lp::SwitchStmt *) $5;
        sw->setSwitchExp($3);
        $$ = sw;
    }
;
```

Para `DEFAULT`, añadir alternativa en `case_list`:
```
    | case_list DEFAULT ':' stmtlist
    {
        lp::SwitchStmt *sw = (lp::SwitchStmt *) $1;
        sw->setDefault(new lp::BlockStmt($4));
        $$ = sw;
    }
    | DEFAULT ':' stmtlist
    {
        lp::SwitchStmt *sw = new lp::SwitchStmt(NULL);
        sw->setDefault(new lp::BlockStmt($3));
        $$ = (lp::Statement *) sw;
    }
```

### 4. Añadir a `stmt`
```
| switch_stmt
 {
 }
```

## Cambios en `table/init.hpp`
```
{"switch",     SWITCH},
{"case",       CASE},
{"default",    DEFAULT},
{"end_switch", END_SWITCH},
```

## Notas importantes

- `case_list` es **recursivo por la izquierda**: va acumulando casos en el mismo `SwitchStmt`.
- Se usa `(lp::SwitchStmt *)` casteo porque el `%type` de `case_list` es `<st>`.
- Cada `stmtlist` se envuelve en un `BlockStmt` para convertirlo en `Statement*`.
- La clase `SwitchStmt` tiene métodos `addCase(val, body)` y `setDefault(body)`.

## Verificación

```
make && ./interpreter.exe ejercicios/08-switch-case/input.txt
```

Salida esperada:
```
print: dos
```
