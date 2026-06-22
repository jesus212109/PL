# AGENTS.md - Proyecto Intérprete de Pseudocódigo

## Estructura del Proyecto

- **P1/** - Ejercicios de flex (ejercicios 1-5): ejemplos de analizadores léxicos
- **P2/** - Núcleo del proyecto
  - `*.p` - Ficheros de ejemplo del profesor (if.p, for.p, menu.p, etc.)
  - **main/** - Intérprete de referencia completo (funciona 100%)
  - **ejemplo17/** - Base limpia Ejemplo 17 (estudiante), compila con 1 SR conflict (dangling else)
  - **Simulacro/** - Simulacro de examen (base = Ejemplo 17, con scripts para practicar)
    - `parser/interpreter.l` - Lexer
    - `parser/interpreter.y` - Grammar (0 sr conflicts)
    - `ast/ast.hpp` + `ast.cpp` - AST completo
    - `table/init.hpp` - Registro de palabras reservadas
    - `simulacro.sh` - Script setup/test/restore/fulltest
    - `tests/` - Tests para preguntas A/B/C/D
    - `backups/` - Copias limpias para restaurar
    - `guia_rapida.md` - Chuleta rápida de examen
    - `fase0_completa.md` / `.pdf` - Guía completa (todos los ficheros explicados)

## Compilación

```bash
cd P2/Simulacro && make        # Compila -> interpreter.exe
cd P2/Simulacro && make clean   # Limpia generados
```

## Ejecución

```bash
./interpreter.exe                   # Modo interactivo (Ctrl+D)
./interpreter.exe script.p          # Modo archivo
```

## Simulacro de Examen

```bash
cd P2/Simulacro
bash simulacro.sh setup_a    # Implementa pregunta A (//)
bash simulacro.sh test       # Ejecuta todos los tests
bash simulacro.sh restore    # Restaura a base limpia
bash simulacro.sh fulltest   # setup -> test cada pregunta A/B/C/D
```

## PreparaciónExMoodle

- **`enunciado.md`** - Especificación completa del pseudocódigo en español (keywords, diseño, ejemplos)
- **`tests/`** - 36 tests en inglés, verificados contra `main/interpreter.exe`
  - `runner.sh` - Ejecuta todos los tests y compara con `.expected`
  - Soporta ficheros `.input` para test con entrada stdin
- **`tests-es/`** - 36 tests equivalentes en español (requieren intérprete traducido)
  - `runner-es.sh` - Mismo sistema que `runner.sh`
  - `generate-es.sh` - Genera `.expected` tras implementar el español (ejecutar con `bash generate-es.sh`)
- **`guia_rapida_examen.md`** - Chuleta de examen: comandos, patrones, errores, soluciones

## Reglas Críticas

1. **Código en ESPAÑOL**: variables, clases, funciones, comentarios, tokens
2. **0 sr conflicts**: ni uno. Usar `controlSymbol` si es necesario
3. **%option case-insensitive** en flex
4. **Case-insensitive REAL en keywords**: añadir `tolower()` en `{IDENTIFIER}` rule de `interpreter.l`
5. **Keywords compuestos**: `si_no` (else), `hasta_que` (until), `fin_si`, etc. con guión bajo
6. **Makefiles con -ansi** (C++98) para coincidir con Ejemplo 17

## Escenario de Examen

- Profesor da `ast.hpp` y `ast.cpp` pre-hechos → normalmente solo se tocan:
  - `parser/interpreter.l`
  - `parser/interpreter.y`
  - `table/init.hpp`
- **Pero** hay que saber modificar el AST también por si acaso

## Errores Comunes en Examen

1. **Falta init.hpp**: si añades keywords (`repeat`/`until`), deben estar en `keyword[]` de init.hpp
2. **`?:` precedencia**: `%right '?' ':'` antes de `%left OR`, no entre relacionales
3. **`$N` cambia**: al añadir `controlSymbol` en `do_while`, los números `$N` se desplazan
4. **El AST necesita casteo**: `Variable*` → `NumericVariable*` para acceder a `getValue()`
5. **`hasta` vs `hasta_que`**: No confundir. `hasta` = TO (para), `hasta_que` = UNTIL (repetir)
6. **`si_no` es un solo token**: Con guión bajo, registrado como keyword → token ELSE

## Documentación

Usar estándar Doxygen en español para toda clase y función pública.
