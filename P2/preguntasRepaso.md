# Preguntas de Repaso — Examen PL (Ejemplo 17 → main/)

## Pregunta 1: controlSymbol

**¿Por qué es necesario el `controlSymbol`? ¿Qué problema resuelve y cómo funciona exactamente?**

**Respuesta:**
`controlSymbol` es una regla epsilon (vacía) que se coloca justo después del token que inicia un bloque (`IF`, `WHILE`, `FOR`, `REPEAT`, `DO`). Su función es evitar la **ejecución prematura** en modo interactivo: cuando escribes línea por línea, el parser va ejecutando cada sentencia conforme la completa. Si tienes un `if` anidado, puede que la rama interior se ejecute antes de terminar el exterior.

El contador `control` se incrementa al reducir `controlSymbol` y se decrementa al finalizar el bloque. Si `control > 0`, la evaluación se pospone.

**Ejemplo con `if`:**
```
if: IF controlSymbol exp THEN stmtlist END_IF
```
`controlSymbol` va tras `IF`, no tras `THEN` ni `END_IF`, porque es justo al entrar al `if` cuando hay que "protegerse" de la ejecución prematura.

---

## Pregunta 2: Cambiar `&&`, `||`, `!` por `and`, `or`, `not`

**Explica paso a paso qué archivos hay que tocar.**

**Respuesta:**

| Paso | Archivo | Acción |
|------|---------|--------|
| 1 | `interpreter.l` | Eliminar reglas `"&&" { return AND; }`, `"||" { return OR; }`, `"!" { return NOT; }` |
| 2 | `interpreter.l` | Añadir `{"and", AND}`, `{"or", OR}`, `{"not", NOT}` (se hace en `init.hpp`, no en el lexer) |
| 3 | `init.hpp` | Añadir al array `keyword[]`: `{"and", AND}`, `{"or", OR}`, `{"not", NOT}` |
| 4 | `interpreter.y` | Verificar que los tokens `AND`, `OR`, `NOT` ya existen o añadirlos a `%token` |
| 5 | `ast.hpp` / `ast.cpp` | **No hay que tocar nada**: las clases `AndNode`, `OrNode`, `NotNode` ya existen |

**Nota sobre el error típico:** No hay que tocar el AST. El cambio es solo léxico: antes `&&` se tokenizaba como AND, ahora `and` se tokeniza como AND. El parser y las clases AST son exactamente las mismas. El error más común es pensar que hay que crear nuevas clases AST, cuando en realidad el árbol sintáctico es idéntico.

---

## Pregunta 3: Añadir `repeat-until`

**a) ¿Qué pones en `init.hpp`?**
```cpp
{"repeat", REPEAT},
{"until", UNTIL},
```

**b) ¿Qué reglas léxicas en `interpreter.l`?**
Ninguna directa. El identificador `"repeat"` es capturado por la regla `{IDENTIFIER}`, que hace `table.lookupSymbol()` y devuelve `s->getToken()`. Como está registrado en `init.hpp`, la tabla lo reconoce como `REPEAT`.

**c) Regla gramatical en `interpreter.y`:**
```bison
repeat: REPEAT controlSymbol stmtlist UNTIL exp SEMICOLON
```
- `controlSymbol` va tras `REPEAT` (como en todos los bucles)
- `stmtlist` son las sentencias del cuerpo
- `UNTIL exp SEMICOLON` es la condición con punto y coma

**d) Clase AST:**
```cpp
// En ast.hpp (declaración, ya viene hecha en el examen)
class RepeatStmt : public Statement { ... };

// En ast.cpp (implementación)
void lp::RepeatStmt::evaluate() {
    do {
        this->_body->evaluate();
    } while (!this->_cond->evaluateBool());  // ← negada respecto a do-while
}
```

**Diferencia clave con `do-while`:**
- `do-while`: se repite **mientras** la condición sea `true`
- `repeat-until`: se repite **hasta** que la condición sea `true` (es decir, mientras sea `false`)

En código: `while (!cond)` en lugar de `while (cond)`.

---

## Pregunta 4: Conflictos SR en el `for`

**¿Qué problema de conflictos SR puede aparecer con `for`? ¿Dónde pones el `controlSymbol`?**

**Respuesta correcta:**
El `for` tiene dos alternativas (con STEP opcional):
```
for_stmt: FOR controlSymbol VARIABLE FROM exp TO exp DO stmtlist END_FOR
        | FOR controlSymbol VARIABLE FROM exp TO exp STEP exp DO stmtlist END_FOR
```

**Aquí NO hay conflicto SR** porque después de `TO exp`, los dos tokens siguientes posibles son `DO` y `STEP`. Son tokens distintos, bison elige con 1 token de lookahead.

El `controlSymbol` va tras `FOR` por consistencia con los demás constructos (siempre al principio del bloque), y para que la regla epsilon se reduzca justo al entrar, sin ambigüedad.

**¿Y si `TO` fuera opcional?**
```
for_stmt: FOR VAR FROM exp TO exp DO ...     // con TO
        | FOR VAR FROM exp DO ...             // sin TO (hipotético)
```
Tampoco habría conflicto: tras `exp`, los tokens `TO` y `DO` son distintos.

**¿Y si `FROM` fuera opcional?**
```
for_stmt: FOR VAR FROM exp TO exp DO ...
        | FOR VAR TO exp DO ...               // sin FROM (hipotético)
**
**Aquí SÍ habría conflicto:** Tras `FOR VAR`, el parser vería `exp` (un número, variable, etc.). La expresión `exp` puede empezar por varios tokens. El parser no sabría si está viendo el `exp` que va tras `FROM` o el `exp` que va tras `TO`. Necesitaría más lookahead.

---

## Pregunta 5: Precedencia de `^` (POWER)

**¿Cómo declarar `^` para que sea asociativo a derechas y de máxima precedencia?**

```bison
%right POWER
```

Colocada al **final** de la sección de precedencia (lo último declarado tiene máxima prioridad):

```bison
%right '?' ':'
%left OR
%left AND
%nonassoc EQUAL NOT_EQUAL GREATER_OR_EQUAL LESS_OR_EQUAL GREATER_THAN LESS_THAN
%left NOT
%left PLUS MINUS
%left CONCAT
%left MULTIPLICATION DIVISION MODULO DIV_ENTERA
%left LPAREN RPAREN
%right INCREMENTO DECREMENTO
%nonassoc UNARY
%right POWER              ← máxima precedencia, asociativo a derechas
%nonassoc THEN
%nonassoc ELSE
```

**Error típico:** Decir que `^` va "por debajo de la multiplicación". Es al revés. `2*3^4 = 2*(3^4) = 162`, no `(2*3)^4 = 1296`. La potencia es el operador de máxima precedencia.

**Asociatividad a derechas:** `2^3^2` = `2^(3^2)` = 512. Con `%left` sería `(2^3)^2` = 64, que no es lo usual en matemáticas.

---

## Pregunta 6: Métodos a implementar en el AST

**¿Qué dos métodos tienes que implementar SÍ o SÍ para cada Statement y para cada ExpNode?**

**Para un `Statement`** (ej: `RepeatStmt`, `ForStmt`, `CompoundAssignmentStmt`):
1. `evaluate()` — lógica de ejecución
2. `printAST()` — representación del árbol (puede ir inline en `.hpp`)

**Para un `ExpNode`** (ej: `PowerNode`, `TernaryNode`, `IntegerDivisionNode`):
1. `evaluateNumber()` — devuelve el valor numérico
2. `printAST()` — representación del árbol

Además, según el tipo:
- Si es booleano: `evaluateBool()`
- Si es string: `evaluateString()`  
- `getType()` — suele ser trivial (devuelve NUMBER, BOOL o STRING)

**Regla de oro del examen:** El profesor da `ast.hpp` completo. Tú solo tocas `ast.cpp` para implementar los métodos `evaluate()` de las nuevas sentencias. A veces también `printAST()` si no va inline.

---

## Pregunta 7: Diferencia `DoWhileStmt` vs `RepeatStmt`

```cpp
// DoWhileStmt: se repite MIENTRAS cond == true
void lp::DoWhileStmt::evaluate() {
    do {
        this->_body->evaluate();
    } while (this->_cond->evaluateBool());
}

// RepeatStmt: se repite HASTA que cond == true (mientras sea false)
void lp::RepeatStmt::evaluate() {
    do {
        this->_body->evaluate();
    } while (!this->_cond->evaluateBool());
}
```

**Error típico:** Pensar que hay que cambiar la estructura del bucle. Es exactamente el mismo `do-while`, solo que la condición está negada. `repeat-until` es un `do-while` con la condición invertida.

---

## Pregunta 8: Regla gramatical del ternario `? :`

```bison
| exp '?' exp ':' exp %prec '?'
    {
        $$ = new lp::TernaryNode($1, $3, $5);
    }
```

**Explicación de `$N`:**
- `$1` = `exp` (condición)
- `$2` = `'?'` (token literal)
- `$3` = `exp` (valor si true)
- `$4` = `':'` (token literal)
- `$5` = `exp` (valor si false)

**El `%prec '?'` es obligatorio.** Sin él, bison usa la precedencia del último terminal de la regla (`':'`). Como `':'` se declaró como `%right '?' ':'`, la precedencia sería correcta pero puede haber conflictos sutiles. Con `%prec '?'` nos aseguramos.

**Precedencia crítica:**
```bison
%right '?' ':'       ← baja precedencia (antes que OR)
%left OR
...
```
Si pones `%right '?' ':'` entre los operadores relacionales, entonces:
```c
1 < 2 ? 10 : 20   → se parsea como   1 < (2 ? 10 : 20)   ← MAL
```
Con la precedencia baja:
```c
1 < 2 ? 10 : 20   → se parsea como   (1 < 2) ? 10 : 20   ← BIEN
```

**Error típico:** `$N` no correlaciona con lo que esperas intuitivamente. El `'?'` y `':'` ocupan posiciones `$2` y `$4`, no te los saltes.

---

## Pregunta 9: `TO` opcional en el `for`

**¿Habría conflicto si `TO` fuera opcional? Es decir:**
```
for_stmt: FOR VAR FROM exp TO exp DO stmtlist END_FOR
        | FOR VAR FROM exp DO stmtlist END_FOR
```

**Respuesta:** No. `TO` y `DO` son tokens distintos. Tras `FROM exp`, el parser ve `TO` o `DO` y elige sin ambigüedad con 1 token de lookahead.

**¿Y si `FROM` fuera opcional?**
```
for_stmt: FOR VAR FROM exp TO exp DO ...
        | FOR VAR TO exp DO ...     // sin FROM (hipotético)
```

**Aquí SÍ hay conflicto:** Tras `FOR VAR`, el parser ve una expresión (`exp`). Pero tanto la primera alternativa (que espera `FROM exp`) como la segunda (que espera `exp` directamente) empiezan con `exp`. El parser no sabe qué ruta tomar hasta que ve `FROM` o no. Pero como `exp` empieza con `NUMBER`, `VARIABLE`, etc., y `FROM` también es un token, el parser no puede decidir hasta después de la expresión, lo que requiere más de 1 token de lookahead.

---

## Pregunta 10: Registro de palabras reservadas

**¿Qué hace que `table.lookupSymbol("repeat")` devuelva un símbolo cuyo `getToken()` sea `REPEAT`?**

**Respuesta:**
El mecanismo es:

1. **Archivo**: `table/init.hpp`
2. **Array**: `keyword[]`
3. **Función**: `init()` en `table/init.cpp`

```cpp
// table/init.hpp
static struct {
    std::string keyword;
    int token;
} keyword[] = {
    {"print", PRINT},
    {"read", READ},
    {"if", IF},
    {"then", THEN},
    {"else", ELSE},
    {"end_if", END_IF},
    {"while", WHILE},
    {"do", DO},
    {"end_while", END_WHILE},
    {"repeat", REPEAT},     // ← aquí se registra
    {"until", UNTIL},       // ← aquí se registra
    // ...
    {"", 0}  // ← centinela
};
```

**`init()` en `init.cpp`:**
```cpp
void lp::init() {
    for (int i = 0; keyword[i].keyword != ""; i++) {
        lp::Keyword *k = new lp::Keyword(keyword[i].keyword, keyword[i].token);
        table.installSymbol(k);
    }
    // También registra constantes numéricas, lógicas y funciones
}
```

**El flujo completo:**
1. `main()` llama a `lp::init()` al arrancar
2. `init()` recorre `keyword[]` y para cada entrada crea un `Keyword` y lo mete en la tabla
3. Cuando el lexer encuentra `"repeat"`, hace `table.lookupSymbol("repeat")`
4. La tabla devuelve el puntero al `Keyword` que se instaló en init
5. El lexer llama a `s->getToken()` que devuelve `REPEAT`

**Error típico:** Añadir la palabra reservada en `interpreter.l` como regla directa (`"repeat" { return REPEAT; }`) en lugar de en `init.hpp`. Eso funciona, pero el profesor espera que uses el mecanismo de la tabla de símbolos. Además, si haces regla directa en el lexer, `"repeat"` no se podría usar como nombre de variable (cosa que el diseño permite en otros contextos).

---

## Pregunta 11: `%type` y `%union`

**¿Qué significan `<st>`, `<stmts>` y `<expNode>`? ¿Dónde se declaran esos tipos? ¿Qué pasa si usas `$$ = new lp::RepeatStmt(...)` en una regla cuyo `%type` es `<st>` pero `RepeatStmt` hereda de `Statement`?**

**Respuesta:**
`<st>`, `<stmts>` y `<expNode>` son etiquetas que referencian campos del `%union`:

```bison
%union {
    std::string *string;
    double number;
    bool logic;
    lp::ExpNode *expNode;
    lp::Statement *st;
    std::list<lp::Statement*> *stmts;
    std::list<lp::ExpNode*> *parameters;
}
```

Luego `%type <st> stmt` indica que `$$` de las reglas `stmt` es del tipo `st` (o sea, `lp::Statement*`).

Funciona por herencia C++: `RepeatStmt` es un `Statement`, así que `new lp::RepeatStmt(...)` es válido como `$$` en una regla `<st>`. El puntero se convierte implícitamente.

---

## Pregunta 12: `%union` explicado desde cero

**¿Qué es `%union` en bison y por qué es necesaria?**

**Respuesta:**
Sin `%union`, bison solo maneja `int` como tipo de `$$`, `$1`, etc. Como el intérprete necesita pasar punteros a nodos del AST (`Statement*`, `ExpNode*`), strings, listas, doubles y bools, el `%union` declara todos esos tipos en un union C.

Cada campo del union tiene un nombre (`st`, `expNode`, `stmts`, etc.) que luego se usa en `%type` para asociar símbolos gramaticales a tipos concretos.

En el examen NO sueles tocar el `%union`. Ya viene hecho. Solo añades líneas a `%type` si creas un nuevo símbolo no terminal (ej: `repeat`).

---

## Pregunta 13: Strings con escapes

**¿Qué token nuevo necesitas en `interpreter.y`? ¿Qué regla en `interpreter.l` captura `'...'` con escapes? ¿Qué clase AST nueva? ¿Qué método virtual hay que añadir a `ExpNode`?**

**Respuesta:**

**Lexer** (`interpreter.l`):
```c
STRING_LIT  \'([^'\\]|\\.)*\'

{STRING_LIT} {
    std::string raw(yytext);
    std::string val = raw.substr(1, raw.length()-2);
    // Procesar escapes: \n → newline, \t → tab, \\ → \, \' → '
    for (size_t i=0; i<val.length(); i++) {
        if (val[i] == '\\' && i+1 < val.length()) {
            switch (val[i+1]) {
                case 'n': val.replace(i,2,"\n"); break;
                case 't': val.replace(i,2,"\t"); break;
                case '\\':val.replace(i,2,"\\"); break;
                case '\'':val.replace(i,2,"'"); break;
            }
        }
    }
    yylval.string = new std::string(val);
    return STRING;
}
```

**Grammar** (`interpreter.y`): `%token <string> STRING`

**AST:** Nueva clase `StringNode` (hereda de `ExpNode`). Declaración en `ast.hpp` (ya viene hecha), implementación de `printAST()`, `getType()` y `evaluateString()` en `ast.cpp`.

**Método virtual añadido a `ExpNode`:**
```cpp
virtual std::string evaluateString() { return ""; }
```

---

## Pregunta 14: `%option case-insensitive`

**¿Qué implicaciones tiene? ¿Afecta también a los operadores?**

**Respuesta:**
Sí. `If`, `IF`, `iF` se reconocen todos como `IF`. Solo afecta a caracteres alfabéticos en reglas del lexer. Los operadores como `"+"`, `"^"`, `":="` no se ven afectados porque no contienen letras.

**Ojo:** no afecta a cómo se busca en la tabla de símbolos (que es case-sensitive internamente), pero como todas las palabras se registran en minúscula y el lexer recibe el texto en minúscula por el `case-insensitive`, funciona.

---

## Pregunta 15: ciclo de vida de `control`

**`controlSymbol` hace `control++`. ¿Dónde se hace `control--`? ¿Por qué no basta solo con incrementar?**

**Respuesta:**
`control--` va en `evaluate()` de **todos** los constructos que usan `controlSymbol`: `IfStmt`, `WhileStmt`, `ForStmt`, `RepeatStmt`, `DoWhileStmt`, `SwitchStmt`.

El patrón es: `control++` al entrar (vía `controlSymbol`), `control--` al salir (en `evaluate()`). Esto permite anidar estructuras sin límite: cada bloque anidado incrementa el contador, y al cerrar lo decrementa. Si se te olvida el `control--`, el contador nunca baja y el intérprete se bloquea en modo interactivo.

---

## Pregunta 16: Acción por defecto `{}` en bison

**¿Qué significan las llaves vacías `{}` en reglas de `stmt`?**

```
stmt: ...
    | for_stmt
     {
     }
    | while
     {
     }
```

**Respuesta:**
Es la **acción por defecto** de bison: `$$ = $1;`. El `Statement*` que devuelve la regla del `for_stmt` o `while` se pasa directamente al `stmt` que lo contiene.

**Propagación:** El `$$` del `stmt` recibe el `$1` del `for_stmt`, así que el nodo `ForStmt` sube un nivel en el árbol. Esto permite que `stmtlist` reciba cualquier tipo de sentencia sin importar su tipo concreto.

**Diferencia entre los tipos:**
| Símbolo | Contiene | Ejemplo |
|---------|----------|---------|
| `exp` | Un nodo `ExpNode*` que devuelve un valor | `2 + 3`, `x`, `true` |
| `stmt` | Un nodo `Statement*` (una sentencia) | `x := 5;`, `print x;` |
| `stmtlist` | Una lista `std::list<Statement*>*` | `x:=1; print x;` |

---

## Pregunta 17: Jerarquía de `Symbol` en la tabla

**¿Qué diferencia hay entre `NumericVariable` y `NumericConstant`? ¿Y entre `Variable` y `Keyword`?**

**Respuesta:**

Árbol de herencia desde `Symbol`:
```
Symbol
├── Variable        → puede cambiar de tipo y valor
│   ├── NumericVariable  → guarda un double
│   ├── LogicalVariable  → guarda un bool
│   └── StringVariable   → guarda un std::string
├── Constant        → inmutable, valor fijo
│   ├── NumericConstant  → PI, E, GAMMA, tau...
│   └── LogicalConstant  → true, false, yes...
├── Keyword         → palabra reservada (if, while, repeat...)
└── Builtin         → función predefinida
    ├── BuiltinParameter0  → rand()
    ├── BuiltinParameter1  → sin(x), cos(x)
    └── BuiltinParameter2  → pow(x,y)
```

**Diferencia clave Variable vs Constant:** Las variables se crean al asignar y pueden cambiar de tipo. Las constantes se registran en `init()` y no se pueden modificar (intentarlo da error semántico).

**Diferencia Variable vs Keyword:** `Keyword` solo almacena el token asociado y se usa en el lexer para identificar palabras reservadas. `Variable` almacena datos y se modifica en tiempo de ejecución.

---

## Pregunta 18: `%union` en reglas concretas

**¿Qué campo del `%union` usarías para `$$` de la regla `case_list`? ¿Y para `listOfExp`?**

**Respuesta:**

- `case_list`: `<st>` (`Statement*`). Es recursiva por la izquierda y va acumulando casos en un `SwitchStmt`, pasándolo hacia arriba como `Statement*`.
- `listOfExp`: `<parameters>` (`std::list<ExpNode*>*`). Construye una lista de expresiones para los parámetros de funciones.

```bison
case_list: case_list CASE exp ':' stmtlist
    {
        lp::SwitchStmt *sw = (lp::SwitchStmt *) $1;  // ← casteo necesario
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
```

Cada iteración recibe el `SwitchStmt` acumulado en `$1`, añade un caso, y lo devuelve en `$$`. La primera alternativa crea un nuevo `SwitchStmt`.

---

## Pregunta 19: Creación automática de variables

**Cuando haces `x := 5;` y `x` no existe aún, ¿dónde se crea y de qué tipo?**

**Respuesta:**
En `AssignmentStmt::evaluate()`:

```cpp
lp::Variable *var = (lp::Variable *) table.getSymbol(this->_id);
if (!var) {
    // No existe → crear según el tipo del valor asignado
    var = new lp::NumericVariable(this->_id, VARIABLE, NUMBER, value);
    table.installSymbol(var);
}
```

Si el valor asignado es `NUMBER` → se crea `NumericVariable`.
Si es `BOOL` → se crea `LogicalVariable`.
Si la variable ya existe pero con otro tipo, se borra la vieja y se crea una nueva del tipo correcto.

---

## Pregunta 20: `PrintStmt` y switch por tipo

**¿Por qué `PrintStmt::evaluate()` necesita un `switch` por tipo?**

**Respuesta:**
Porque cada tipo se evalúa con un método distinto:
```cpp
switch(this->_exp->getType()) {
    case NUMBER: std::cout << this->_exp->evaluateNumber(); break;
    case BOOL:   std::cout << (this->_exp->evaluateBool() ? "true" : "false"); break;
    case STRING: std::cout << this->_exp->evaluateString(); break;
}
```
Si llamaras a `evaluateNumber()` en un string, sería error de tipo. El switch selecciona el método correcto según el tipo dinámico de la expresión.

---

## Pregunta 21: `control--` en todos los evaluate()

**¿En qué evaluate() aparece `control--` además de `IfStmt`?**

**Respuesta:**
En TODOS los que usan `controlSymbol` en la gramática:
- `IfStmt::evaluate()`
- `WhileStmt::evaluate()`
- `ForStmt::evaluate()`
- `RepeatStmt::evaluate()`
- `DoWhileStmt::evaluate()`
- `SwitchStmt::evaluate()`

Sin `control--`, el contador nunca decrece y el modo interactivo se bloquea para siempre después del primer bloque.

---

## Pregunta 22: De `if cond stmt` (Ejemplo 17) a `if exp then stmtlist end_if` (main/)

**¿Qué cambios hay que hacer en `interpreter.y` partiendo de Ejemplo 17?**

**Respuesta:**
| Cambio | Detalle |
|--------|---------|
| Añadir tokens | `THEN`, `END_IF` al `%token` |
| Añadir a `init.hpp` | `{"then", THEN}`, `{"end_if", END_IF}` en `keyword[]` |
| Cambiar regla `if:` | `IF controlSymbol exp THEN stmtlist END_IF` (dos alternativas: con/sin ELSE) |
| `stmtlist` | Ya debe existir (regla recursiva `stmtlist: stmt \| stmtlist stmt`) |
| `%type` | Añadir `if` a `%type <st> ...` si no está |
| Precedencia | `%nonassoc THEN` y `%nonassoc ELSE` para dangling-else |

El `controlSymbol` va tras `IF` para incrementar el contador al entrar.

---

## Pregunta 23: `stmtlist` vs `{ stmt }`

**Ejemplo 17 usa `{ stmt }` para bloques. main/ los elimina y usa `stmtlist`. ¿Ventajas y conflictos?**

**Respuesta:**
**Ventaja:** Sintaxis más limpia, no necesitas llaves para múltiples sentencias. `if cond then x:=1; print x; end_if` es más natural.

**Conflicto potencial:** `stmtlist` puede contener un solo `stmt`, y `stmt` puede ser un `if`. Eso permite `if` anidados: `if (a) then if (b) then ... end_if end_if`. El `end_if` delimita cada nivel. Sin `end_if` (si usáramos el estilo C sin llaves), habría ambigüedad (dangling else). Precisamente el `%nonassoc THEN`/`ELSE` combinado con `END_IF` elimina el problema.

---

## Pregunta 24: `init.hpp` — todos los arrays

**¿Qué arrays contiene `init.hpp` además de `keyword[]`?**

**Respuesta:**
| Array | Contenido | Ejemplo |
|-------|-----------|---------|
| `keyword[]` | Palabras reservadas → token | `{"repeat", REPEAT}` |
| `numericConstant[]` | Constantes numéricas → valor | `{"PI", 3.141592}` |
| `logicalConstant[]` | Constantes booleanas → valor | `{"true", true}` |
| `function_0[]` | Funciones 0 parámetros | `{"rand", rand}` |
| `function_1[]` | Funciones 1 parámetro | `{"sin", sin}` |
| `function_2[]` | Funciones 2 parámetros | `{"pow", pow}` |

Todos terminan con `{"", 0}` como centinela. La función `init()` en `init.cpp` los recorre y los instala en la tabla.

---

## Pregunta 25: Lexer directo vs lookup en tabla

**Ejemplo 17 usa reglas directas (`"if" { return IF; }`). main/ usa `table.lookupSymbol()`. ¿Por qué el cambio?**

**Respuesta:**
**Ventajas del lookup:**
1. Añadir una palabra nueva solo requiere tocar `init.hpp` (el `keyword[]`). No tocas el lexer.
2. El lexer queda más limpio: una sola regla `{IDENTIFIER}` para todos los identificadores.
3. Consistencia: las keywords, constantes y funciones se registran igual en `init()`.
4. Escalabilidad: puedes añadir 20 keywords sin tocar el lexer.

**Cómo migrar:** Añadir la regla `{IDENTIFIER}` con lookup en el lexer, eliminar las reglas directas de palabras reservadas, y registrar todo en `init.hpp`.

**Importante para el examen:** El profesor espera que uses `init.hpp`. Poner reglas directas funciona pero penalizan.

---

## Pregunta 26: Campos del `%union`

**¿Qué campos lleva el `%union` y para qué sirve cada uno?**

**Respuesta:**
| Campo | Tipo | Uso |
|-------|------|-----|
| `string` | `std::string*` | Tokens STRING, VARIABLE, CONSTANT |
| `number` | `double` | Token NUMBER |
| `logic` | `bool` | Token BOOL |
| `expNode` | `lp::ExpNode*` | `$$` de reglas `exp` |
| `st` | `lp::Statement*` | `$$` de `stmt`, `asgn`, `if`, `while`, etc. |
| `stmts` | `std::list<lp::Statement*>*` | `$$` de `stmtlist` |
| `parameters` | `std::list<lp::ExpNode*>*` | `$$` de `listOfExp` |

---

## Pregunta 27: `controlSymbol` en modo interactivo

**¿Por qué en main/ es necesario `controlSymbol` si en Ejemplo 17 no existe?**

**Respuesta:**
En Ejemplo 17 el intérprete es más simple y se usa con archivos. En `main/`, al añadir modo interactivo, escribir línea por línea causa que bloques incompletos se intenten evaluar antes de tiempo.

`controlSymbol` incrementa `control` al entrar a un bloque. Cuando `control > 0`, la evaluación se pospone. Al cerrar el bloque (`evaluate()` hace `control--`), si `control` vuelve a 0, se evalúa.

Sin esto, escribir `if (x>0) then` y pulsar Enter evaluaría el `if` sin cuerpo, dando resultados incorrectos o errores.

---

## Pregunta 28: Memoria en el AST — ¿quién borra los nodos?

**El AST se construye con `new`. ¿Quién hace `delete`? ¿Hay memory leaks?**

**Respuesta:**
En el código de Ejemplo 17 y `main/` **no se libera memoria explícitamente**. Los nodos creados con `new` no tienen `delete`. Para un intérprete que se ejecuta una vez y termina, esto es aceptable (el SO reclama la memoria al salir).

En el examen no suelen preguntar por gestión de memoria del AST. Lo importante es saber que cada regla gramatical crea sus nodos con `new` y los pasa hacia arriba vía `$$`.

---

## Pregunta 29: Recuperación de errores — el token `error`

**¿Qué hace esta regla en bison?**
```bison
stmt: error SEMICOLON { $$ = new lp::EmptyStmt(); }
```

**Respuesta:**
El token especial `error` de bison se activa cuando ocurre un error de sintaxis. El parser descarta tokens hasta encontrar uno que permita continuar. La regla:

1. Encuentra un error de sintaxis
2. Descarta tokens hasta ver `SEMICOLON`
3. Reduce la regla creando un `EmptyStmt`
4. Continúa parseando el resto del programa

Esto permite que el intérprete muestre varios errores en una ejecución en lugar de parar en el primero. Sin esta regla, bison llamaría a `yyerror()` y abortaría.

**En el examen:** Esta regla suele venir hecha. No la tienes que escribir, pero debes saber qué hace.

---

## Pregunta 30: `read_string` — lectura de strings

**¿En qué se diferencia `read_string` de `read`? ¿Qué tocarías para implementarlo partiendo de Ejemplo 17?**

**Respuesta:**
`read` lee un **número** y lo asigna a una variable. `read_string` lee un **string** (hasta el final de línea) y lo asigna.

**Cambios necesarios:**
1. `init.hpp`: añadir `{"read_string", READ_STRING}` a `keyword[]`
2. `interpreter.y`: añadir `READ_STRING` al `%token`
3. `interpreter.y`: añadir regla `read: READ_STRING LPAREN VARIABLE RPAREN`
4. `ast.hpp`/`ast.cpp`: clase `ReadStringStmt` con `evaluate()` que lee una línea con `std::getline()`
5. `ast.cpp`: `ReadStringStmt::evaluate()` crea/actualiza una `StringVariable` en la tabla

---

## Pregunta 31: `BuiltinFunctionNode` — ¿cómo funcionan?

**¿Qué diferencia hay entre `BuiltinFunctionNode_0`, `BuiltinFunctionNode_1` y `BuiltinFunctionNode_2`?**

**Respuesta:**
Se diferencian en el **número de parámetros** que recibe la función:

| Clase | Parámetros | Ejemplo | evaluateNumber() |
|-------|-----------|---------|------------------|
| `_0` | 0 | `rand()` | `f->getFunction()()` |
| `_1` | 1 | `sin(x)` | `f->getFunction()(this->_exp->evaluateNumber())` |
| `_2` | 2 | `pow(x,y)` | `f->getFunction()(e1->evaluateNumber(), e2->evaluateNumber())` |

Cada una se crea en `interpreter.y` según `f->getNParameters()`:
```bison
exp: BUILTIN LPAREN listOfExp RPAREN {
    switch(f->getNParameters()) {
        case 0: $$ = new lp::BuiltinFunctionNode_0($1); break;
        case 1: $$ = new lp::BuiltinFunctionNode_1($1, e); break;
        case 2: $$ = new lp::BuiltinFunctionNode_2($1, e1, e2); break;
    }
}
```

---

## Pregunta 32: `listOfExp` y recursión

**¿Cómo construye `listOfExp` una lista de expresiones?**

**Respuesta:**
Dos reglas recursivas por la derecha:

```bison
listOfExp: exp restOfListOfExp
restOfListOfExp: COMMA exp restOfListOfExp
               | /* epsilon */
;
```

Cada `exp` se añade al principio de la lista. La recursión va consumiendo `COMMA exp` y construyendo `std::list<ExpNode*>`. Al final, `listOfExp` contiene todas las expresiones separadas por comas.

**Tipo:** `%type <parameters> listOfExp restOfListOfExp`

---

## Pregunta 33: Cambio de operadores — `=` → `:=`

**En Ejemplo 17 la asignación es `x = 5`. En `main/` es `x := 5`. ¿Qué hay que cambiar?**

**Respuesta:**
1. `interpreter.l`: eliminar `"=" { return ASSIGNMENT; }`, añadir `":=" { return ASSIGNMENT; }`
2. `interpreter.l`: añadir `"= " { return EQUAL; }` (la comparación de igualdad pasa a ser `=` simple)
3. `interpreter.l`: eliminar `"==" { return EQUAL; }` (ya no se usa)
4. `interpreter.l`: añadir `"<>" { return NOT_EQUAL; }`, eliminar `"!=" { return NOT_EQUAL; }`
5. `interpreter.y`: no cambia — los tokens `ASSIGNMENT`, `EQUAL`, `NOT_EQUAL` siguen llamándose igual

**Lo importante:** Los nombres de los tokens NO cambian. Solo cambia qué secuencia de caracteres los produce en el lexer.

---

## Pregunta 34: `BlockStmt` — ¿dónde se usa?

**¿En qué partes del código se crea un `BlockStmt`?**

**Respuesta:**
Aparece en **dos contextos distintos**:

1. **Explícito en la gramática** (cuando escribes `{ stmtlist }`):
```bison
block: LETFCURLYBRACKET stmtlist RIGHTCURLYBRACKET
    { $$ = new lp::BlockStmt($2); }
```

2. **Implícito en `switch-case`**: cada caso envuelve su `stmtlist` en un `BlockStmt`:
```bison
case_list: ... CASE exp ':' stmtlist
    { sw->addCase($2, new lp::BlockStmt($4)); }
```

**¿Por qué el switch necesita BlockStmt?** Porque `addCase` espera un `Statement*`, y `stmtlist` es una lista. El `BlockStmt` envuelve la lista en un solo `Statement`.

---

## Pregunta 35: Prioridad de `%type` — ¿cuándo añadir un nuevo símbolo?

**Si creas una regla nueva `repeat: REPEAT controlSymbol stmtlist UNTIL exp SEMICOLON`, ¿qué `%type` necesitas añadir?**

**Respuesta:**
Añadir `repeat` a la línea:
```bison
%type <st> for_stmt repeat do_while clear_screen place switch_stmt case_list block
```
`<st>` porque `repeat` produce un `Statement*` (un `RepeatStmt`). También añadir `| repeat` en la sección `stmt`:
```bison
stmt: ...
    | repeat
     {
     }
```

Y declarar los tokens: `REPEAT` y `UNTIL` en `%token`.
