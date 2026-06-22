# Ejercicio 9: Strings con escapes

## Objetivo
Añadir literales de cadena (string) con comillas simples y secuencias de escape.

Sintaxis:
```
print 'Hola mundo';
print 'Linea 1\nLinea 2';
```

## Ficheros a modificar

1. **`parser/interpreter.l`**
2. **`parser/interpreter.y`**

## Cambios en `parser/interpreter.l`

### 1. Añadir la regla para strings
```
STRING_LIT  \'([^'\\]|\\.)*\'

{STRING_LIT} {
    std::string raw(yytext);
    std::string val = raw.substr(1, raw.length()-2);
    // Procesar escapes: \n → newline, \t → tab, \\ → \, \' → '
    for (size_t i = 0; i < val.length(); i++) {
        if (val[i] == '\\' && i+1 < val.length()) {
            switch (val[i+1]) {
                case 'n': val.replace(i, 2, "\n"); break;
                case 't': val.replace(i, 2, "\t"); break;
                case '\\': val.replace(i, 2, "\\"); break;
                case '\'': val.replace(i, 2, "'"); break;
                case '0': val.replace(i, 2, "\0"); break;
            }
        }
    }
    yylval.string = strdup(val.c_str());
    return STRING;
}
```

### 2. Añadir STRING_LIT a las regexp
Poner STRING_LIT ANTES de la regla `{IDENTIFIER}` para que `'...'` no se confunda con un identificador.

## Cambios en `parser/interpreter.y`

### Añadir `STRING` a los tokens
Ya está declarado en la base: `%token <string> ... STRING`

### Añadir regla en `exp`
```
| STRING
	{
		$$ = new lp::StringNode($1);
	}
```

## Notas

- El procesamiento de escapes se hace **en el lexer**, no en el AST.
- `yylval.string` debe ser un `char*` (strdup) porque el `%union` tiene `char *string`.
- Excluir `'` del estado ERROR para que los strings no provoquen error léxico.
- El `StringNode` ya existe en el AST.

## Verificación

```
make && ./interpreter.exe ejercicios/09-string-escapes/input.txt
```
