/-
Copyright (c) 2026. All rights reserved.
Author: Julián Calderón Almendros
License: MIT
-/

-- REFERENCE.md: project this file after every modification.
-- See AI-GUIDE.md §12 for the "proyectar" protocol.
-- This is the foundational module. All other modules import it.

-- ⚠️ CONSTRUCTIVIST PROJECT: No classical axioms allowed.
-- This project is strictly constructive and intuitionistic.
-- All proofs must be computational. No LEM, no AC, no Classical.choose.

universe u

/-! ### ExistsUnique — Unique Existence (Constructive) ###

  Custom implementation of ∃! independent of Lean's standard library.
  Provides a complete API via dot-notation and Peano-compatible aliases.

  Definition: p has a unique witness iff ∃ x, p x ∧ ∀ y, p y → y = x

  ⚠️ CONSTRUCTIVE: Defined as Prop with explicit witness extraction.
  The witness is accessible via pattern matching. No classical axioms used.
-/

def ExistsUnique {α : Sort u} (p : α → Prop) : Prop :=
  ∃ x, p x ∧ ∀ y, p y → y = x

/-! ### Notation ###
  ∃! x, p   — standard-looking notation (overrides Lean built-in ∃!)
  ∃¹ x, p   — safe notation (no clash risk, Peano-style, 4 variants) -/

syntax "∃! " ident ", " term : term
macro_rules
  | `(∃! $x, $p) => `(ExistsUnique fun $x => $p)

syntax "∃¹ " ident ", " term : term
syntax "∃¹ " "(" ident ")" ", " term : term
syntax "∃¹ " "(" ident " : " term ")" ", " term : term
syntax "∃¹ " ident " : " term ", " term : term
macro_rules
  | `(∃¹ $x:ident, $p:term)                     => `(ExistsUnique (fun $x => $p))
  | `(∃¹ ($x:ident), $p:term)                   => `(ExistsUnique (fun $x => $p))
  | `(∃¹ ($x:ident : $t:term), $p:term)         => `(ExistsUnique (fun ($x : $t) => $p))
  | `(∃¹ $x:ident : $t:term, $p:term)           => `(ExistsUnique (fun ($x : $t) => $p))

/-! ### API — dot-notation style ### -/

/-- Constructor: witness + property + uniqueness proof → ExistsUnique -/
theorem ExistsUnique.intro {α : Sort u} {p : α → Prop} (w : α)
    (hw : p w) (h : ∀ y, p y → y = w) : ExistsUnique p :=
  ⟨w, hw, h⟩

/-- Extract ∃ x, p x from ExistsUnique p -/
theorem ExistsUnique.exists {α : Sort u} {p : α → Prop} (h : ExistsUnique p) :
    ∃ x, p x := by
  obtain ⟨w, hw, _⟩ := h
  exact ⟨w, hw⟩

/-- Uniqueness: any two witnesses are equal -/
theorem ExistsUnique.unique {α : Sort u} {p : α → Prop} (h : ExistsUnique p) :
    ∀ x y, p x → p y → x = y := by
  intro x y hx hy
  obtain ⟨w, hw, huniq⟩ := h
  calc x = w := huniq x hx
       _ = y := (huniq y hy).symm

/-! ### API — Peano-compatible aliases ###

  Mirror the Peano.PeanoNatLib naming convention for cross-project compatibility.
  These are thin wrappers; no new logic. -/

/-- Alias for ExistsUnique.unique (Peano style) -/
theorem unique_of_existsUnique {α : Sort u} {p : α → Prop} (h : ExistsUnique p) :
    ∀ x y, p x → p y → x = y :=
  h.unique

/-! ### User definitions go below this line ###
  Add preliminary definitions, notations, and helper lemmas specific
  to your project here. -/
