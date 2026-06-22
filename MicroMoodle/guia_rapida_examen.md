# Guía Rápida — Examen PL (Español + Case-Insensitive)

## 1. Los 3 comandos de verificación (IMPESCINDIBLES)

```bash
# 1. Compilar — si sale "conflicts:" → PARAR, resolver antes
make

# 2. Ver conflictos detallados
make interpreter.output
grep -i conflict parser/interpreter.output
# Si no hay conflictos, grep no devuelve nada

# 3. Ejemplo concreto del conflicto (el más útil)
bison -Wcounterexamples parser/interpreter.y
# Te dice EXACTAMENTE qué código es ambiguo
```

---

## 2. Patrón: añadir keyword nuevo (3 ficheros)

| Paso | Fichero | Qué hacer |
|------|---------|-----------|
| 1 | `table/init.hpp` | Añadir `{"nombre", TOKEN},` en `keyword[]` |
| 2 | `parser/interpreter.l` | Solo si no es keyword simple (ej: `"+:=" { return MAS_IGUAL; }`) |
| 3 | `parser/interpreter.y` | `%token TOKEN` + `%left`/`%right` precedencia + regla gramatical |

**Error más común:** Pones `%token REPEAT UNTIL` en `.y` pero **olvidas** `init.hpp` → falla en ejecución.

---

## 3. Keywords español — alias pattern

```cpp
static struct {
    std::string name;
    int token;
} keyword[] = {
    // Inglés
    {"print",        PRINT},
    {"if",           IF},
    {"else",         ELSE},
    // ... etc ...
    // Español (alias — mismo token)
    {"escribir",     PRINT},
    {"si",           IF},
    {"si_no",        ELSE},
    // ...
    {"", 0}  // ← centinela SIEMPRE
};
```

**Tokens compuestos con guión bajo:** `si_no`, `fin_si`, `hasta_que`, `borrar_pantalla`, `leer_cadena`, `fin_mientras`, etc. — el lexer los ve como un único `{IDENTIFIER}`.

---

## 4. Case-insensitive REAL — `tolower()` en `interpreter.l`

`%option case-insensitive` **NO basta** (está en `main/` y no funciona). Necesitas:

```c
{IDENTIFIER}    {
    // ... validaciones guiones bajos ...

    std::string identifier(yytext);

    // ★ CONVERTIR a minusculas ANTES de buscar en tabla
    for (size_t i = 0; i < identifier.length(); i++) {
        identifier[i] = tolower(identifier[i]);
    }
    yylval.string = strdup(identifier.c_str());

    if (table.lookupSymbol(identifier) == false) {
        // crear variable
        lp::NumericVariable *n = new lp::NumericVariable(identifier, VARIABLE, UNDEFINED, 0.0);
        table.installSymbol(n);
        return VARIABLE;
    } else {
        lp::Symbol *s = table.getSymbol(identifier);
        return s->getToken();
    }
}
```

**Efectos:** `ESCRIBIR` = `Escribir` = `escribir`. Variables `X` y `x` son la misma.

---

## 5. `controlSymbol` — regla de oro

```yacc
controlSymbol: /* epsilon */ { control++; }
```

**Todo** `stmt` que contenga un `stmtlist` necesita `controlSymbol`:

| Regla | Entra | Sale |
|-------|-------|------|
| `if` | `IF controlSymbol exp THEN stmtlist ELSE stmtlist END_IF` | `control--` 1 vez |
| `while` | `WHILE controlSymbol exp DO stmtlist END_WHILE` | `control--` 1 vez |
| `for_stmt` | `FOR controlSymbol VARIABLE FROM exp TO exp DO stmtlist END_FOR` | `control--` 1 vez |
| `repeat` | `REPEAT controlSymbol stmtlist UNTIL exp SEMICOLON` | `control--` 1 vez |
| `do_while` | `DO controlSymbol stmtlist WHILE controlSymbol exp SEMICOLON` | `control--` **2 veces** |

**⚠️ `$N` cambia** al añadir `controlSymbol`. Si había `$3` y pones `controlSymbol` delante, pasa a ser `$4`.

---

## 6. `?:` precedencia — error típico

```yacc
// BIEN (antes de OR, precedencia baja):
%right '?' ':'
%left OR
%left AND
%nonassoc ...

// MAL (después de relacionales):
%nonassoc ...
%right '?' ':'    // ← 1<2?10:20 se parsea como 1<(2?10:20)
```

---

## 7. Dangling else — resolución

```yacc
%nonassoc THEN      // ← necesario
%nonassoc ELSE      // ← necesario
// (THEN y ELSE no se declaran como %token — ya existen)
```

---

## 8. Precedencia completa (de menor a mayor)

```yacc
%right '?' ':'            // ternario — MÍNIMA precedencia
%left OR                  // o
%left AND                 // y
%nonassoc EQUAL NOT_EQUAL GREATER_OR_EQUAL LESS_OR_EQUAL GREATER_THAN LESS_THAN
%left NOT                 // no
%left PLUS MINUS          // + -
%left CONCAT              // || concatenacion
%left MULTIPLICATION DIVISION MODULO DIV_ENTERA
%right INCREMENTO DECREMENTO
%nonassoc UNARY
%right POWER              // ^ — MÁXIMA precedencia
%nonassoc THEN
%nonassoc ELSE
```

---

## 9. Errores mortales y cómo evitarlos

| Error | Síntoma | Solución |
|-------|---------|----------|
| Falta `init.hpp` | Keyword no reconocida en runtime | Revisar `keyword[]` en `table/init.hpp` |
| `$N` desplazado | Valor incorrecto en acción semántica | Contar desde 1, `controlSymbol` suma +1 |
| Sin casteo numérico | `getValue()` no existe en `Variable` | `((NumericVariable*)var)->getValue()` |
| `%option case-insensitive` solo | Keywords mayúsculas no funcionan | Añadir `tolower()` en `{IDENTIFIER}` |
| `hasta` para TO y UNTIL | Conflicto léxico | Usar `hasta_que` para UNTIL |
| `control--` de menos | Interactive mode se cuelga | Cada `controlSymbol` → un `control--` al salir |

---

## 10. Casteo a `NumericVariable*` — patrón

```cpp
// Para leer/escribir valor numérico de variable:
lp::Variable *var = (lp::Variable *) table.getSymbol(this->_var);
if (!var) {
    var = new lp::NumericVariable(this->_var, VARIABLE, NUMBER, 0.0);
    table.installSymbol(var);
}
double valor = ((lp::NumericVariable*)var)->getValue();    // ← casteo
((lp::NumericVariable*)var)->setValue(nuevo_valor);         // ← casteo
```

`Variable` base NO tiene `getValue()` — solo `NumericVariable`.

---

## 11. Resumen visual: tipos de nodos

```
ExpNode
├── NumberNode → NUMBER
├── StringNode → STRING
├── VariableNode → type dinámico
├── ConstantNode → NUMBER o BOOL
├── NumericOperatorNode (+, -, *, /, //, mod, ^) → NUMBER
├── NumericUnaryOperatorNode (-x, +x) → NUMBER
├── RelationalOperatorNode (<, >, =, <>, <=, >=) → BOOL
├── LogicalOperatorNode (and, or) → BOOL
├── NotNode → BOOL
├── ConcatenationNode → STRING
├── BuiltinFunctionNode → NUMBER
└── TernaryNode → _true->getType() (delega)

Statement
├── AssignmentStmt / MultipleAssignmentStmt
├── PreIncrementStmt / PostIncrementStmt
├── CompoundAssignmentStmt
├── PrintStmt / ReadStmt
├── IfStmt / WhileStmt / ForStmt / RepeatStmt / DoWhileStmt
├── SwitchStmt
├── ClearScreenStmt / PlaceStmt
├── BlockStmt / EmptyStmt
└── AST (raíz)
```

---

## 12. PrintStmt — cómo muestra

```
PrintStmt::evaluate()
  switch (_exp->getType())
    case NUMBER:  _exp->evaluateNumber()  → "print: 3.14"
    case STRING:  _exp->evaluateString()  → "print: hola"
    case BOOL:    _exp->evaluateBool()    → "print: true"/"print: false"
```

---

## 13. Plan de ataque recomendado

```bash
# FASE 1: init.hpp — añadir keywords español como alias (30 min)
# FASE 2: interpreter.l — tolower() en {IDENTIFIER} (5 min)
# FASE 3: Compilar y probar
make
# Si 0 conflicts:
cd PreparaciónExMoodle/tests-es && bash generate-es.sh && bash runner-es.sh
# Si FALLAN: depurar cada uno
# Si PASAN: ¡listo!
```

---

## 14. Orden de dificultad de las preguntas típicas

| Tipo | Dificultad | Tiempo |
|------|-----------|--------|
| Añadir operador nuevo (//, ^, mod) | ★☆☆ | 10 min |
| Añadir keyword (repeat/until, for) | ★★☆ | 15 min |
| Operador ternario `?:` | ★★☆ | 15 min |
| Incremento/decremento/compuestos | ★★★ | 20 min |
| Traducción a español completa | ★★★ | 30 min |
| Añadir sentencia compleja (switch) | ★★★ | 25 min |
| Case-insensitive real | ★☆☆ | 5 min (si sabes el tolower) |
