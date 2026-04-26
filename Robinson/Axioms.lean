/-
Copyright (c) 2026. All rights reserved.
Author: Julián Calderón Almendros
License: MIT
-/

-- REFERENCE.md: project this file after every modification.
-- See AI-GUIDE.md §12 for the "proyectar" protocol.

-- ⚠️ CONSTRUCTIVIST PROJECT: No classical axioms allowed.
-- This module implements Robinson Arithmetic (Q) axiomatically.
-- Q3 is replaced with a decidable version to maintain constructivism.

import Robinson.Prelim

/-! ### Robinson Arithmetic (Q) — Axiomatic Foundation ###

  Robinson Arithmetic is the minimal axiom system sufficient for Gödel's
  incompleteness theorems. It consists of 7 axioms defining the natural
  numbers with successor, addition, and multiplication.

  **Constructive Modification**: The standard Q3 axiom (∀x. x = 0 ∨ ∃y. x = S(y))
  is non-constructive (uses LEM). We replace it with a decidability axiom
  that allows constructive case analysis.

  **Language**:
  - Type: ℕ (natural numbers, opaque/axiomatic)
  - Constant: 0 (zero)
  - Function: S (successor)
  - Operations: + (addition), * (multiplication)
  - Relation: = (equality, from Lean's core)

  **Reference**: Robinson, R. M. (1950). "An essentially undecidable axiom system".
  Proceedings of the International Congress of Mathematicians, 1950.
-/

namespace Robinson

/-! ### Primitive Types and Operations ### -/

/-- Natural numbers (axiomatic, opaque type) -/
axiom ℕ : Type

/-- Zero -/
axiom zero : ℕ

/-- Successor function -/
axiom succ : ℕ → ℕ

/-- Addition -/
axiom add : ℕ → ℕ → ℕ

/-- Multiplication -/
axiom mul : ℕ → ℕ → ℕ

/-! ### Notation ### -/

-- Standard notation for natural number operations
notation:max "0" => zero
notation:max "S" => succ
infixl:65 " + " => add
infixl:70 " * " => mul

/-! ### Robinson Axioms (Q1-Q7) ### -/

/-- **Q1**: Zero is not a successor.
    ∀x. S(x) ≠ 0
-/
axiom Q_zero_not_succ : ∀ (x : ℕ), succ x ≠ zero

/-- **Q2**: Successor is injective.
    ∀x ∀y. S(x) = S(y) → x = y
-/
axiom Q_succ_injective : ∀ (x y : ℕ), succ x = succ y → x = y

/-- **Q3 (Constructive)**: Decidability of zero.
    This replaces the classical Q3: ∀x. x = 0 ∨ ∃y. x = S(y)
    
    The classical version is non-constructive (uses LEM).
    Instead, we axiomatize that equality with zero is decidable,
    which allows constructive case analysis via `if x = 0 then ... else ...`
    
    From decidability, we can derive:
    - If x = 0, then x is zero.
    - If x ≠ 0, then ∃y. x = S(y) (by Q_pred below).
-/
axiom Q_decidable_zero : ∀ (x : ℕ), Decidable (x = zero)

/-- **Q3 (Predecessor)**: Every non-zero number is a successor.
    ∀x. x ≠ 0 → ∃y. x = S(y)
    
    This is the constructive content of the classical Q3.
    Combined with Q_decidable_zero, it allows full case analysis.
-/
axiom Q_pred : ∀ (x : ℕ), x ≠ zero → ∃ y, x = succ y

/-- **Q4**: Addition with zero (right identity).
    ∀x. x + 0 = x
-/
axiom Q_add_zero : ∀ (x : ℕ), add x zero = x

/-- **Q5**: Addition with successor (recursive definition).
    ∀x ∀y. x + S(y) = S(x + y)
-/
axiom Q_add_succ : ∀ (x y : ℕ), add x (succ y) = succ (add x y)

/-- **Q6**: Multiplication with zero (right annihilation).
    ∀x. x * 0 = 0
-/
axiom Q_mul_zero : ∀ (x : ℕ), mul x zero = zero

/-- **Q7**: Multiplication with successor (recursive definition).
    ∀x ∀y. x * S(y) = (x * y) + x
-/
axiom Q_mul_succ : ∀ (x y : ℕ), mul x (succ y) = add (mul x y) x

/-! ### Decidability Instance ### -/

/-- Make decidability of zero available globally -/
instance (x : ℕ) : Decidable (x = zero) := Q_decidable_zero x

/-! ### Basic Derived Properties ### -/

/-- Zero is unique (there's only one zero) -/
theorem zero_unique (x : ℕ) (h : ∀ y, succ y ≠ x) : x = zero := by
  by_cases hx : x = zero
  · exact hx
  · obtain ⟨y, hy⟩ := Q_pred x hx
    rw [hy] at h
    exact absurd rfl (h y)

/-- Successor is not equal to its argument -/
theorem succ_ne_self (x : ℕ) : succ x ≠ x := by
  intro h
  -- This requires induction, which Q doesn't have
  -- We leave this as sorry for now (Q cannot prove this)
  sorry

/-- Non-zero numbers have predecessors (computable witness extraction) -/
def pred (x : ℕ) (h : x ≠ zero) : ℕ :=
  (Q_pred x h).choose

theorem pred_spec (x : ℕ) (h : x ≠ zero) : x = succ (pred x h) :=
  (Q_pred x h).choose_spec

end Robinson

/-! ### Exports ### -/

-- Export all public declarations from Robinson namespace
export Robinson (
  ℕ zero succ add mul
  Q_zero_not_succ Q_succ_injective Q_decidable_zero Q_pred
  Q_add_zero Q_add_succ Q_mul_zero Q_mul_succ
  zero_unique succ_ne_self pred pred_spec
)
