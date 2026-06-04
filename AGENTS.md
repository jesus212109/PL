# AGENTS.md - Proyecto Intérprete de Pseudocódigo

## Estructura del Proyecto

- **P1/** - Ejercicios de flex (ejercicios 1-5): ejemplos de analizadores léxicos
- **P2/** - Ficheros `.p` de ejemplo proporcionados por el profesor (if.p, for.p, menu.p, etc.)
- **Raíz**: Donde se creará el intérprete (`interpreter.l`, `interpreter.y`, `.hpp`, `.cpp`, Makefile)

## Requisitos del Sistema

```bash
# Instalar herramientas necesarias (ejemplo para Fedora/CentOS)
sudo dnf install flex bison gcc-c++ make

# En Ubuntu/Debian:
# sudo apt-get install flex bison g++ make
```

## Reglas Críticas

1. **TODO el código en ESPAÑOL**: variables, clases, funciones, comentarios, nombres de tokens
2. **Grammar SIN conflictos**: 0 shift/reduce, 0 reduce/reduce (usar `%nonassoc` y precedencia explícita si es necesario)
3. **Case insensitive**: keywords e identificadores (usar `%option case-insensitive` en flex)

## Compilación

```bash
make        # Compila todo -> interpreter.exe
make clean  # Limpia generados
```

## Ejecución

```bash
./interpreter.exe              # Modo interactivo (Ctrl+D para salir)
./interpreter.exe script.p    # Modo archivo (debe tener extensión .p)
```

## Especificaciones del Lenguaje (.p)

### Palabras Reservadas
`read`, `read_string`, `print`, `if`, `then`, `else`, `end_if`, `while`, `do`, `end_while`, `repeat`, `until`, `for`, `from`, `step`, `to`, `end_for`, `switch`, `case`, `default`, `end_switch`, `clear_screen`, `place`

### Funciones Predefinidas
`sin`, `cos`, `sqrt`, `log`, `log10`, `exp`, `integer`, `abs`

### Constantes Predefinidas
`pi`, `e`, `gamma`, `phi`, `deg`

### Operadores
- Aritméticos: `+`, `-`, `*`, `/`, `//` (división entera), `mod`, `^` (potencia)
- Relacionales: `<`, `<=`, `>`, `>=`, `=`, `<>`
- Lógicos: `true`, `false`, `or`, `and`, `not`
- String: `||` (concatenación)
- Asignación: `:=`
- Unarios extra: `++`, `--`, `+:=`, `-:=`

### Comentarios
- Bloque: `(* ... *)` (NO anidados)
- Línea: `# ...` (desde `#` hasta fin de línea; `#` al inicio de línea NO termina el programa)

### Tipos
- Números: enteros, reales, notación científica (todos como `double` internamente)
- Strings: comillas simples `'...'`, con secuencias de escape `\n`, `\t`, `\\`, `\'`
- Booleanos: `true`/`false`

## Extensiones Requeridas (para máxima puntuación)

- `do { ... } while` loops
- Operador ternario `? :`
- Operadores unarios: `++`, `--`, `+:=`, `-:=`

## Errores a Capturar

- Léxicos: símbolos desconocidos, identificadores mal formados, comentarios sin cerrar
- Sintácticos: estructura de sentencias inválida
- Semánticos: tipos incompatibles en operaciones
- Ejecución: bucles infinitos, archivo no encontrado

## Patrón de Arquitectura Recomendado

- **Flex**: `interpreter.l` con tokens para Bison
- **Bison**: `interpreter.y` genera AST o ejecuta directamente
- **C++**: Clase `Nodo` abstracta con `evaluar()` polimórfico, o Visitor pattern
- **Tabla de Símbolos**: dinámico (tipado dinámico), almacenar valor + tipo actual

## Documentación

Usar estándar Doxygen en español para toda clase y función pública.