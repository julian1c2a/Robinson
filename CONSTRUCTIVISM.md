# Constructivismo en Robinson

**Última actualización:** 2026-04-26 00:00  
**Autor**: Julián Calderón Almendros

---

## Filosofía

Este proyecto es **estrictamente constructivo e intuicionista**. Cada prueba debe ser
computacional, cada afirmación de existencia debe proporcionar un testigo explícito,
y no se permiten axiomas clásicos.

---

## ¿Qué es el Constructivismo?

**Las matemáticas constructivas** requieren que:

1. **La existencia es constructiva**: Para probar `∃ x, P x`, debes proporcionar un `x` específico y probar `P x`.
2. **Las funciones son computables**: Toda función debe ser implementable como un algoritmo.
3. **La lógica es intuicionista**: `¬¬P` no implica `P`. La prueba por contradicción solo funciona para negaciones.
4. **Sin axiomas de elección**: No Axioma de Elección, no Ley del Tercero Excluido.

---

## Axiomas Clásicos Prohibidos

### ❌ Ley del Tercero Excluido (LEM)

```lean
-- PROHIBIDO en este proyecto
axiom lem (p : Prop) : p ∨ ¬p
```

**Por qué está prohibido**: LEM permite divisiones de casos no constructivas. En lógica constructiva,
no puedes asumir `p ∨ ¬p` sin una prueba.

**Alternativa constructiva**: Usa predicados decidibles cuando sea posible:

```lean
-- PERMITIDO: decidibilidad explícita
instance : Decidable (n = 0) := ...
if n = 0 then ... else ...
```

### ❌ Axioma de Elección (AC)

```lean
-- PROHIBIDO en este proyecto
axiom choice {α : Sort u} {β : α → Sort v} :
  (∀ x, Nonempty (β x)) → Nonempty (∀ x, β x)
```

**Por qué está prohibido**: AC permite extraer testigos sin proporcionarlos explícitamente.

**Alternativa constructiva**: Proporciona testigos explícitamente en la prueba:

```lean
-- PERMITIDO: testigo explícito
def myFunction (h : ∀ x, ∃ y, P x y) (x : α) : β :=
  (h x).choose  -- testigo de ∃ constructivo
```

### ❌ Classical.choose

```lean
-- PROHIBIDO en este proyecto
noncomputable def Classical.choose {α : Sort u} {p : α → Prop}
  (h : ∃ x, p x) : α
```

**Por qué está prohibido**: Usa AC internamente. No computable.

**Alternativa constructiva**: Extrae el testigo de la estructura de la prueba:

```lean
-- PERMITIDO: extracción computable de testigo
def ExistsUnique.choose {α : Sort u} {p : α → Prop}
  (h : ExistsUnique p) : α := h.1
```

### ❌ Eliminación de Doble Negación

```lean
-- PROHIBIDO en este proyecto
axiom dne (p : Prop) : ¬¬p → p
```

**Por qué está prohibido**: No es válido en lógica intuicionista.

**Alternativa constructiva**: Prueba `p` directamente, o trabaja con `¬¬p` tal cual.

### ❌ Prueba por Contradicción (para afirmaciones positivas)

```lean
-- PROHIBIDO para afirmaciones positivas
theorem foo : P := by
  by_contra h
  -- derivar contradicción de ¬P
  -- concluir P
```

**Por qué está prohibido**: Solo válido para probar negaciones en lógica intuicionista.

**Alternativa constructiva**: Prueba `P` directamente, o prueba `¬¬P` si eso es suficiente.

---

## Técnicas Constructivas Permitidas

### ✅ Pattern Matching y Recursión

```lean
def factorial : ℕ → ℕ
  | 0 => 1
  | n + 1 => (n + 1) * factorial n
```

### ✅ Inducción

```lean
theorem add_comm (n m : ℕ) : n + m = m + n := by
  induction n with
  | zero => simp
  | succ n ih => simp [ih]
```

### ✅ Predicados Decidibles

```lean
instance : Decidable (n < m) := ...

def min (n m : ℕ) : ℕ :=
  if n < m then n else m
```

### ✅ Testigos Explícitos

```lean
theorem exists_succ (n : ℕ) : ∃ m, m = n + 1 :=
  ⟨n + 1, rfl⟩
```

### ✅ Funciones Computables

```lean
def gcd : ℕ → ℕ → ℕ
  | 0, m => m
  | n + 1, m => gcd (m % (n + 1)) (n + 1)
```

---

## Constructivo vs Clásico: Ejemplos

### Ejemplo 1: Existencia

**Clásico (prohibido)**:

```lean
-- Usa LEM para probar existencia sin testigo
theorem exists_or_not (p : α → Prop) : (∃ x, p x) ∨ (∀ x, ¬p x) := by
  by_cases h : ∃ x, p x
  · left; exact h
  · right; intro x; intro hpx; exact h ⟨x, hpx⟩
```

**Constructivo (requerido)**:

```lean
-- Proporciona testigo explícito o prueba negación universal
theorem exists_zero : ∃ n : ℕ, n = 0 :=
  ⟨0, rfl⟩

theorem forall_succ_ne_zero : ∀ n : ℕ, n + 1 ≠ 0 :=
  fun n h => Nat.succ_ne_zero n h
```

### Ejemplo 2: Decidibilidad

**Clásico (prohibido)**:

```lean
-- Usa LEM implícitamente
def isEven (n : ℕ) : Bool :=
  if n % 2 = 0 then true else false  -- requiere Decidable (n % 2 = 0)
```

**Constructivo (requerido)**:

```lean
-- Proporciona instancia de decidibilidad explícita
instance : Decidable (n % 2 = 0) := Nat.decEq (n % 2) 0

def isEven (n : ℕ) : Bool :=
  n % 2 = 0  -- usa la instancia de decidibilidad
```

### Ejemplo 3: Existencia Única

**Clásico (prohibido)**:

```lean
noncomputable def ExistsUnique.choose (h : ∃! x, p x) : α :=
  Classical.choose (ExistsUnique.exists h)
```

**Constructivo (requerido)**:

```lean
def ExistsUnique.choose (h : ∃! x, p x) : α :=
  h.1  -- extrae testigo de la estructura de la prueba
```

---

## Beneficios del Constructivismo

1. **Contenido computacional**: Cada prueba produce un algoritmo.
2. **Testigos explícitos**: No hay pasos no constructivos ocultos.
3. **Teoremas más fuertes**: Las pruebas constructivas son más informativas.
4. **Extracción de programas**: Las pruebas se pueden extraer a código ejecutable.
5. **Claridad filosófica**: Las matemáticas son sobre construcciones, no existencia abstracta.

---

## Recursos

### Libros y Artículos

- **Intuitionistic Type Theory** — Per Martin-Löf (1984)
- **Constructive Analysis** — Errett Bishop (1967)
- **Homotopy Type Theory: Univalent Foundations of Mathematics** — The Univalent Foundations Program (2013)
- **Constructivism in Mathematics** — A.S. Troelstra & D. van Dalen (1988)

### Asistentes de Prueba Constructivos

- **Coq** — Asistente de prueba constructivo
- **Agda** — Lenguaje de programación dependiente constructivo
- **Lean 4** — Soporta tanto lógica clásica como constructiva (este proyecto usa solo constructiva)

### Recursos en Línea

- [Constructive Mathematics (Stanford Encyclopedia of Philosophy)](https://plato.stanford.edu/entries/mathematics-constructive/)
- [Intuitionistic Logic (Stanford Encyclopedia of Philosophy)](https://plato.stanford.edu/entries/logic-intuitionistic/)

---

## Lista de Verificación de Cumplimiento

Antes de hacer commit de cualquier archivo `.lean`, verificar:

- [ ] No hay `import Init.Classical` ni módulos similares
- [ ] No hay `open Classical`
- [ ] No hay `Classical.choose`, `Classical.some`, `Classical.choice`
- [ ] No hay `by_contra` para afirmaciones positivas
- [ ] No hay `em` (tercero excluido)
- [ ] No hay `noncomputable` (excepto para predicados `Prop`)
- [ ] Todas las pruebas de existencia proporcionan testigos explícitos
- [ ] Todas las funciones son computables
- [ ] Todos los predicados decidibles tienen instancias `Decidable` explícitas
- [ ] No se usa `by_cases` sin una instancia `Decidable` explícita
- [ ] No se asume `p ∨ ¬p` sin prueba

---

## Preguntas Frecuentes

### ¿Por qué constructivismo?

El constructivismo ofrece una base más sólida para las matemáticas computacionales.
Cada teorema es un algoritmo, cada prueba es ejecutable. Esto hace que las matemáticas
sean más transparentes y útiles para la ciencia de la computación.

### ¿Es el constructivismo más débil que las matemáticas clásicas?

No necesariamente. Muchos teoremas clásicos tienen versiones constructivas igualmente
potentes. Las pruebas constructivas son a menudo más informativas porque proporcionan
algoritmos explícitos.

### ¿Qué pasa con los teoremas que requieren LEM?

Algunos teoremas clásicos no tienen versiones constructivas directas. En esos casos,
podemos:
1. Probar una versión más débil pero constructiva
2. Probar la doble negación del teorema (`¬¬P` en lugar de `P`)
3. Trabajar con predicados decidibles cuando sea posible

### ¿Puedo usar `by_contra`?

Solo para probar **negaciones**. `by_contra` es válido constructivamente para probar `¬P`,
pero no para probar afirmaciones positivas `P`.

```lean
-- PERMITIDO: probar negación
theorem not_exists_max : ¬∃ n : ℕ, ∀ m : ℕ, m ≤ n := by
  by_contra h
  -- derivar contradicción

-- PROHIBIDO: probar afirmación positiva
theorem exists_something : ∃ n : ℕ, P n := by
  by_contra h  -- ❌ NO CONSTRUCTIVO
```

---

**Esta es una restricción estricta para todo el proyecto Robinson.**

**Última actualización**: 2026-04-26 00:00  
**Autor**: Julián Calderón Almendros
