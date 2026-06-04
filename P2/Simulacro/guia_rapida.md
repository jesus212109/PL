# Guía Rápida — Simulacro de Examen PL

## Flujo de trabajo

```bash
./simulacro.sh setup a      # 1. Guarda backup + borra feature A
# ... edita los 4 archivos ... #
./simulacro.sh test a       # 2. Compila + ejecuta tests
./simulacro.sh restore      # 3. Restaura original
# repetir con b, c, d
```

## ⚠️ Requisitos CRÍTICOS del Profesor

### 1. 0 shift/reduce conflicts — ¡OBLIGATORIO!

```bash
bison -d parser/interpreter.y  # Debe dar: 0 warnings, 0 conflicts
```

Los 9 conflictos están en `while`/`do_while`. **Solución fija ya aplicada:**
```yacc
// ANTES (9 conflictos):
do_while: DO controlSymbol stmtlist WHILE exp SEMICOLON
// DESPUÉS (0 conflictos):
do_while: DO controlSymbol stmtlist WHILE controlSymbol exp SEMICOLON
```
Además del `%right INCREMENTO DECREMENTO`, el `%right '?' ':'` debe ir **ANTES** de `%left OR` (precedencia baja).

### 2. Keywords: también en `init.hpp`, no solo en `%token`

El array `keyword[]` está en **`table/init.hpp:72-104`**. Cualquier keyword (como `repeat`, `until`) debe estar ahí:

```cpp
static struct {
    std::string name;
    int token;
} keyword[] = {
    {"print",        PRINT},
    {"repeat",       REPEAT},   // ← ¡OBLIGATORIO registrar!
    {"until",        UNTIL},    // ← ¡OBLIGATORIO registrar!
    ...
    {"",             0}         // ← centinela
};
```

Si solo pones `%token REPEAT UNTIL` en `.y` pero no en `init.hpp`, **falla en ejecución**.

## Patrón de 4 Capas (TODA pregunta sigue esto)

| Capa | Archivo | Qué se añade |
|------|---------|-------------|
| **Flex** | `interpreter.l` | Reconocer operador/palabra → devolver token |
| **Bison** | `interpreter.y` | ① Declarar token `%token` ② Precedencia `%left/%right` ③ Regla gramatical |
| **AST (hpp)** | `ast/ast.hpp` | Clase del nodo (inline) con constructor, getType, printAST, evaluate* |
| **AST (cpp)** | `ast/ast.cpp` | Implementación de evaluate() (solo si es compleja) |

---

## Pregunta A — División Entera `//` (10 pts)

### Flex (`interpreter.l:14x`)
```
"//"    { return DIV_ENTERA; }      /* NEW */
```

### Bison (`interpreter.y`)
```
%token DIV_ENTERA CONCAT          /* línea ~191 en %token */
%left MULTIPLICATION DIVISION MODULO DIV_ENTERA   /* ~220 */
```
Regla:
```
/* NEW: integer division */
| exp DIV_ENTERA exp
    { $$ = new lp::IntegerDivisionNode($1, $3); }
```

### AST (`ast/ast.hpp`) — inline
```cpp
class IntegerDivisionNode : public NumericOperatorNode {
 public:
  IntegerDivisionNode(ExpNode *L, ExpNode *R) : NumericOperatorNode(L,R) {}
  void printAST() { std::cout << "IntegerDivisionNode" << std::endl; }
  double evaluateNumber();
};
```

### AST (`ast/ast.cpp`)
```cpp
double lp::IntegerDivisionNode::evaluateNumber() {
    double left  = this->_left->evaluateNumber();
    double right = this->_right->evaluateNumber();
    if (std::abs(right) < 1.0e-6)
        execerror("Runtime error: division by zero", "");
    return (double)((long)left / (long)right);
}
```

### Tests
```
print 7 // 3;         → 2
print 10 // 4;        → 2
print 3 // 7;         → 0
```

---

## Pregunta B — Operador Ternario `?:` (10 pts) ✅ Hecho

### Flex (`interpreter.l:160-161`)
```
"?"     { return '?'; }
":"     { return ':'; }
```

### Bison (`interpreter.y`)
```
/* NO declarar %token '?' ':' — los literales son implícitos */
/* Precedencia: BAJA (justo encima de OR) */
/*******************************************************/
/* NEW in example 15 */

%right '?' ':'            /* NEW: ternary operator */

%left OR
...
```
Regla:
```
/* NEW: ternary operator ?: */
| exp '?' exp ':' exp %prec '?'
    { $$ = new lp::TernaryNode($1, $3, $5); }
```

### AST (`ast/ast.hpp`) — inline TODO
```cpp
class TernaryNode : public ExpNode {
 private:
   ExpNode *_cond;
   ExpNode *_true;
   ExpNode *_false;
 public:
   TernaryNode(ExpNode *c, ExpNode *t, ExpNode *f) : _cond(c), _true(t), _false(f) {}
   int getType() { return _true->getType(); }
   void printAST() { std::cout << "TernaryNode" << std::endl; }
   double evaluateNumber() { return _cond->evaluateBool() ? _true->evaluateNumber() : _false->evaluateNumber(); }
   bool evaluateBool() { return _cond->evaluateBool() ? _true->evaluateBool() : _false->evaluateBool(); }
   std::string evaluateString() { return _cond->evaluateBool() ? _true->evaluateString() : _false->evaluateString(); }
};
```

### Clave: `getType()` automático
```
getType() → _true->getType()
```
`_true` es la rama verdadera. Si es `NumberNode(10)` → `NumberNode::getType()` = NUMBER.  
PrintStmt ve NUMBER → llama a `evaluateNumber()`. **Automágico.**

### Tests
```
print (1<2 ? 10 : 20);       → 10
print (1>2 ? 'a' : 'b');     → b
x:=1; print (x=1 ? 'si' : 'no');  → si
```

### Errores típicos ❌
| Error | Por qué | Solución |
|-------|---------|----------|
| `&prec` en vez de `%prec` | Bison no entiende | Usar `%prec '?'` |
| `%token '?' ':'` declarado | Conflictos | **No declarar**, son implícitos |
| Constructor con `double` | Ternario necesita 3 ExpNode* | `TernaryNode(ExpNode *c, ExpNode *t, ExpNode *f)` |
| `evaluatebool` vs `evaluateBool` | No sobreescribe virtual | Usar `evaluateBool` (B mayúscula) |
| `getType()` devuelve BOOL fijo | No refleja la rama | `return _true->getType()` |
| `evaluateNumber()` devuelve `_cond` (puntero) | Dirección de memoria | `_cond->evaluateBool() ? ...` |
| `%right '?' ':'` después de relacionales | `1<2?10:20` se parsea como `1<(2?10:20)` | Ponerlo **antes** de `%left OR` |

---

## Pregunta C — Incremento/Decremento/Compuestos (15 pts)

### Operadores
| Símbolo | Token | 
|---------|-------|
| `++` (pre/post) | `INCREMENTO` |
| `--` (pre/post) | `DECREMENTO` |
| `+:=` | `MAS_IGUAL` |
| `-:=` | `MENOS_IGUAL` |

### Flex (`interpreter.l`)
```
"++"    { return INCREMENTO; }      /* NEW */
"--"    { return DECREMENTO; }      /* NEW */
"+:="   { return MAS_IGUAL; }       /* NEW */
"-:="   { return MENOS_IGUAL; }     /* NEW */
```

### Bison (`interpreter.y`)
```
%token ASSIGNMENT MAS_IGUAL MENOS_IGUAL INCREMENTO DECREMENTO
...
%right INCREMENTO DECREMENTO /* NEW: pre/post increment/decrement */
```
Reglas (DENTRO de `asgn`, son sentencias, no expresiones):
```yacc
/* NEW for practice: increment/decrement */
| INCREMENTO VARIABLE
    { $$ = new lp::PreIncrementStmt($2, true); }
| DECREMENTO VARIABLE
    { $$ = new lp::PreIncrementStmt($2, false); }
| VARIABLE INCREMENTO
    { $$ = new lp::PostIncrementStmt($1, true); }
| VARIABLE DECREMENTO
    { $$ = new lp::PostIncrementStmt($1, false); }

/* NEW: compound assignment +:= and -:= */
| VARIABLE MAS_IGUAL exp
    { $$ = new lp::CompoundAssignmentStmt($1, $3, PLUS); }
| VARIABLE MENOS_IGUAL exp
    { $$ = new lp::CompoundAssignmentStmt($1, $3, MINUS); }
```

### AST (`ast/ast.hpp`)
```cpp
class PreIncrementStmt : public Statement {
 private:
  std::string _var;
  bool _inc;      // true=++, false=--
 public:
  PreIncrementStmt(std::string id, bool inc = true) : _var(id), _inc(inc) {}
  void printAST() { std::cout << "PreIncrementStmt" << std::endl; }
  void evaluate();
};

class PostIncrementStmt : public Statement {
 private:
  std::string _var;
  bool _inc;
 public:
  PostIncrementStmt(std::string id, bool inc = true) : _var(id), _inc(inc) {}
  void printAST() { std::cout << "PostIncrementStmt" << std::endl; }
  void evaluate();
};

class CompoundAssignmentStmt : public Statement {
 private:
  std::string _var;
  ExpNode *_exp;
  int _op;       // PLUS o MINUS
 public:
  CompoundAssignmentStmt(std::string id, ExpNode *e, int op)
      : _var(id), _exp(e), _op(op) {}
  void printAST() { std::cout << "CompoundAssignmentStmt" << std::endl; }
  void evaluate();
};
```

### AST (`ast/ast.cpp`)
```cpp
void lp::PreIncrementStmt::evaluate() {
    lp::Variable *var = (lp::Variable *) table.getSymbol(this->_var);
    if (!var) {
        var = new lp::NumericVariable(this->_var, VARIABLE, NUMBER, 0.0);
        table.installSymbol(var);
    } else if (var->getType() != NUMBER) {
        var->setType(NUMBER);
    }
    double delta = this->_inc ? 1.0 : -1.0;
    double newVal = ((lp::NumericVariable*)var)->getValue() + delta;
    ((lp::NumericVariable*)var)->setValue(newVal);
}

// PostIncrementStmt es IDÉNTICO a PreIncrementStmt
// La diferencia es semántica (valor de retorno), pero como es
// sentencia y no expresión, el efecto es el mismo.

void lp::CompoundAssignmentStmt::evaluate() {
    lp::Variable *var = (lp::Variable *) table.getSymbol(this->_var);
    if (!var) {
        var = new lp::NumericVariable(this->_var, VARIABLE, NUMBER, 0.0);
        table.installSymbol(var);
    } else if (var->getType() != NUMBER) {
        var->setType(NUMBER);
    }
    double cur = ((lp::NumericVariable*)var)->getValue();
    double rhs = this->_exp->evaluateNumber();
    double result = (this->_op == PLUS) ? (cur + rhs) : (cur - rhs);
    ((lp::NumericVariable*)var)->setValue(result);
}
```

### ⚠️ Regla de oro — Casteo a `NumericVariable*`
```cpp
// Para leer/escribir el valor numérico de una variable:
lp::Variable *var = (lp::Variable *) table.getSymbol(this->_var);
...
double valor = ((lp::NumericVariable*)var)->getValue();   // ← casteo necesario
((lp::NumericVariable*)var)->setValue(nuevo_valor);        // ← casteo necesario
```
`Variable` base NO tiene `getValue()` — solo `NumericVariable` lo tiene.

### Tests
```
++x  (x=5) → 6
x--  (x=6) → 5
x+:=3 (x=5) → 8
x-:=2 (x=8) → 6
```

---

## Pregunta D — Bucle `repeat-until` (15 pts)

### Flex
Los tokens `REPEAT` y `UNTIL` se registran en `table/init.cpp` como keywords.  
**No hace falta tocar `interpreter.l`.**

### Bison (`interpreter.y`)
```
%token WHILE DO END_WHILE REPEAT UNTIL   /* REPEAT UNTIL ya en %token */
%type <st> for_stmt repeat do_while ...  /* repeat ya en %type */

/* En stmt: */
| repeat                                  /* ~330 */

/* NEW for practice: repeat-until */
repeat: REPEAT controlSymbol stmtlist UNTIL exp SEMICOLON
    {
        $$ = new lp::RepeatStmt(new lp::BlockStmt($3), $5);
        control--;
    }
```

### AST (`ast/ast.hpp`)
```cpp
class RepeatStmt : public Statement {
 private:
  Statement *_body;
  ExpNode *_cond;
 public:
  RepeatStmt(Statement *b, ExpNode *c) : _body(b), _cond(c) {}
  void printAST() { std::cout << "RepeatStmt" << std::endl; }
  void evaluate();
};
```

### AST (`ast/ast.cpp`)
```cpp
void lp::RepeatStmt::evaluate() {
    int maxIter = 100000;
    int iter = 0;
    do {
        if (++iter > maxIter) {
            execerror("Runtime error", "Infinite loop detected in repeat");
            break;
        }
        this->_body->evaluate();
    } while (!this->_cond->evaluateBool());
}
```

### Clave: lógica invertida
```
repeat → do { ... } while(!cond)
```
- `repeat cuerpo until cond;` → ejecuta cuerpo MIENTRAS cond sea **false**
- Se ejecuta **siempre al menos una vez** (do-while)
- `maxIter = 100000` + contador para detectar bucles infinitos

### Tests
```
x:=1; repeat print x; x:=x+1; until x>3;   → 1 2 3
x:=5; repeat x:=x-1; until x=0; print x;    → 0
```

---

## Resumen Visual: Jerarquía de `getType()`

```
ExpNode (clase base abstracta)
├── NumberNode              → getType() = NUMBER
├── StringNode              → getType() = STRING
├── BoolNode                → getType() = BOOL
├── NumericOperatorNode     → getType() = NUMBER   ← (//, +, -, *, /, mod, ^)
├── NumericUnaryOperatorNode → getType() = NUMBER  ← (-expr, +expr)
├── ComparisonNode          → getType() = BOOL     ← (<, >, <=, >=, =, <>)
├── LogicalNode             → getType() = BOOL     ← (and, or, not)
└── TernaryNode             → getType() = _true->getType()  ← DELEGA
```

## Resumen Visual: Jerarquía de Statements

```
Statement (clase base abstracta)
├── AsgnStmt                → x:=5
├── PreIncrementStmt        → ++x, --x
├── PostIncrementStmt       → x++, x--
├── CompoundAssignmentStmt  → x+:=3, x-:=2
├── PrintStmt
├── ReadStmt
├── IfStmt
├── WhileStmt
├── DoWhileStmt
├── RepeatStmt              → repeat..until
├── ForStmt
├── SwitchStmt
├── BlockStmt               → grupo de statements
└── ClearScreenStmt / PlaceStmt
```

## PrintStmt: Cómo disp

```
PrintStmt::evaluate()
  switch (_exp->getType())
    case NUMBER:  _exp->evaluateNumber() → print número
    case STRING:  _exp->evaluateString() → print string
    case BOOL:    _exp->evaluateBool()   → print "true"/"false"
```

## Plan de Ataque para el Examen

```bash
# 1. Pregunta A: implementar // desde cero
./simulacro.sh setup a
# Editar: .l (token) → .y (%token + precedencia + regla) → ast.hpp (clase inline) → ast.cpp (evaluateNumber)
./simulacro.sh test a
./simulacro.sh restore

# 2. Pregunta B: implementar ?: (tokens ya dados, falta arreglar)
./simulacro.sh setup b
# .l: ya tiene "?" y ":" (solo verificar)
# .y: añadir %right '?' ':' ANTES de OR + regla con %prec '?'
# ast.hpp: TernaryNode con { en misma línea al FINAL del namespace
# ast.cpp: nada (inline)
./simulacro.sh test b
./simulacro.sh restore

# 3. Pregunta C: implementar ++/--/+:=-:=
./simulacro.sh setup c
# Editar: .l (4 tokens) → .y (6 reglas en asgn) → ast.hpp (3 clases) → ast.cpp (3 evaluate)
./simulacro.sh test c
./simulacro.sh restore

# 4. Pregunta D: implementar repeat-until
./simulacro.sh setup d
# Flex: NO tocar (keywords en init.hpp ya)
# .y: %token REPEAT UNTIL + regla repeat
# ast.hpp: RepeatStmt al final del namespace
# ast.cpp: evaluate() con do{body}while(!cond)
./simulacro.sh test d
./simulacro.sh restore
```

## Checklist antes de `./simulacro.sh test X`

1. ❓ **Flex** — ¿Existe el token? ¿Está en el orden correcto?
2. ❓ **Bison** — ¿Token declarado? ¿Precedencia en posición correcta? ¿Regla con %prec si hace falta?
3. ❓ **init.hpp** — ¿Keyword registrada en el array? (si es D)
4. ❓ **AST hpp** — ¿Clase con herencia correcta? ¿Constructor con tipos correctos? ¿Métodos inline? ¿`{` en misma línea?
5. ❓ **AST cpp** — ¿Implementación de evaluate()? (solo si no es inline)
6. ❓ **Bison** — `bison -d parser/interpreter.y` → **0 warnings, 0 conflicts**
7. ❓ **make** — ¿Compila? (0 errores)
8. ❓ **test** — ¿Pasan todos los tests de la pregunta?
