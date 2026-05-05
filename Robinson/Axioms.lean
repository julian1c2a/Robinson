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

  **Constructive Implementation**: Instead of axioms, we define ℕ as an
  inductive type. This makes all of Robinson's axioms (Q1-Q7) provable as
  theorems, and everything is fully computable and constructive.

  **Language**:
  - Type: ℕ (natural numbers, inductive type)
  - Constructors: zero (𝟘), succ (𝐒)
  - Operations: + (addition), * (multiplication)
  - Relation: = (equality, from Lean's core)

  **Notation**: We use Unicode symbols 𝟘 and 𝐒 to avoid conflicts with
  Lean's built-in natural numbers. In mathematical notation, these correspond
  to the standard 0 and S.

  **Note**: This implementation is STRONGER than axiomatic Robinson Arithmetic
  because we have the induction principle available from the inductive type.
  However, it is completely constructive and allows us to prove Gödel's
  incompleteness theorems.

  **Reference**: Robinson, R. M. (1950). "An essentially undecidable axiom system".
  Proceedings of the International Congress of Mathematicians, 1950.
-/

namespace Robinson

/-! ### Primitive Types and Operations ### -/

/-- Natural numbers (inductive type, fully constructive) -/
inductive ℕ : Type where
  | zero : ℕ
  | succ : ℕ → ℕ

/-- Zero (pattern for the zero constructor) -/
def zero : ℕ := ℕ.zero

/-- Successor function -/
def succ : ℕ → ℕ := ℕ.succ

/-- Addition (defined recursively) -/
def add : ℕ → ℕ → ℕ
  | x, ℕ.zero => x
  | x, ℕ.succ y => ℕ.succ (add x y)

/-- Multiplication (defined recursively) -/
def mul : ℕ → ℕ → ℕ
  | _, ℕ.zero => ℕ.zero
  | x, ℕ.succ y => add (mul x y) x

/-! ### Notation ### -/

-- Standard notation for natural number operations
-- Note: We use prefix notation for zero and succ to avoid conflicts
prefix:max "𝟘" => zero
prefix:max "𝐒" => succ
infixl:65 " + " => add
infixl:70 " * " => mul

/-! ### Robinson Axioms (Q1-Q7) — Now Theorems ### -/

/-- **Q1**: Zero is not a successor.
    ∀x. 𝐒(x) ≠ 𝟘

    This is now a theorem, proven by the inductive definition.
-/
theorem Q_zero_not_succ : ∀ (x : ℕ), succ x ≠ zero := by
  intro _ h
  cases h

/-- **Q2**: Successor is injective.
    ∀x ∀y. 𝐒(x) = 𝐒(y) → x = y

    This is now a theorem, proven by the inductive definition.
-/
theorem Q_succ_injective : ∀ (x y : ℕ), succ x = succ y → x = y := by
  intro x y h
  injection h

/-- **Q3 (Constructive)**: Decision function for zero.

    This is now computable, defined by pattern matching on the inductive type.
-/
def isZero : ℕ → Bool
  | ℕ.zero => true
  | ℕ.succ _ => false

/-- Specification: if isZero returns true, then x is zero -/
theorem isZero_spec_true : ∀ (x : ℕ), isZero x = true → x = zero := by
  intro x h
  cases x with
  | zero => rfl
  | succ n => contradiction

/-- Specification: if isZero returns false, then x is not zero -/
theorem isZero_spec_false : ∀ (x : ℕ), isZero x = false → x ≠ zero := by
  intro x h
  cases x with
  | zero => contradiction
  | succ n => intro h'; cases h'

/-- **Q3 (Predecessor)**: Every non-zero number is a successor.
    ∀x. x ≠ 𝟘 → ∃y. x = 𝐒(y)

    This is now a theorem with explicit witness extraction.
-/
theorem Q_pred : ∀ (x : ℕ), x ≠ zero → ∃ y, x = succ y := by
  intro x h
  cases x with
  | zero => contradiction
  | succ n => exact ⟨n, rfl⟩

/-- **Q4**: Addition with zero (right identity).
    ∀x. x + 𝟘 = x

    This is now a theorem, proven by the definition of add.
-/
theorem Q_add_zero : ∀ (x : ℕ), add x zero = x := by
  intro x
  rfl

/-- **Q5**: Addition with successor (recursive definition).
    ∀x ∀y. x + 𝐒(y) = 𝐒(x + y)

    This is now a theorem, proven by the definition of add.
-/
theorem Q_add_succ : ∀ (x y : ℕ), add x (succ y) = succ (add x y) := by
  intro x y
  rfl

/-- **Q6**: Multiplication with zero (right annihilation).
    ∀x. x * 𝟘 = 𝟘

    This is now a theorem, proven by the definition of mul.
-/
theorem Q_mul_zero : ∀ (x : ℕ), mul x zero = zero := by
  intro x
  rfl

/-- **Q7**: Multiplication with successor (recursive definition).
    ∀x ∀y. x * 𝐒(y) = (x * y) + x

    This is now a theorem, proven by the definition of mul.
-/
theorem Q_mul_succ : ∀ (x y : ℕ), mul x (succ y) = add (mul x y) x := by
  intro x y
  rfl

/-! ### Decidability Instance ### -/

/-- Decidability instance derived from isZero.

    This instance is computable because it's based on pattern matching.
-/
instance (x : ℕ) : Decidable (x = zero) :=
  match x with
  | ℕ.zero => isTrue rfl
  | ℕ.succ _ => isFalse (fun h => ℕ.noConfusion h)

/-! ### Basic Derived Properties ### -/

/-- Zero is unique (there's only one zero) -/
theorem zero_unique (x : ℕ) (h : ∀ y, succ y ≠ x) : x = zero := by
  by_cases hx : x = zero
  · exact hx
  · obtain ⟨y, hy⟩ := Q_pred x hx
    rw [hy] at h
    exact absurd rfl (h y)

/-- Successor is not equal to its argument.

    This is now provable by induction on the inductive type.
-/
theorem succ_ne_self : ∀ (x : ℕ), succ x ≠ x := by
  intro x h
  induction x with
  | zero => cases h
  | succ n ih =>
    injection h with h'
    exact ih h'

/-- Non-zero numbers have predecessors (computable witness extraction).

    This is now computable because we can pattern match on the inductive type.
-/
def pred (x : ℕ) (h : x ≠ zero) : ℕ :=
  match x with
  | ℕ.zero => absurd rfl h
  | ℕ.succ n => n

theorem pred_spec (x : ℕ) (h : x ≠ zero) : x = succ (pred x h) := by
  cases x with
  | zero => contradiction
  | succ n => rfl

end Robinson

/-! ### Exports ### -/

-- Export all public declarations from Robinson namespace
export Robinson (
  ℕ
  zero
  succ
  add
  mul
  Q_zero_not_succ
  Q_succ_injective
  isZero
  isZero_spec_true
  isZero_spec_false
  Q_pred
  Q_add_zero
  Q_add_succ
  Q_mul_zero
  Q_mul_succ
  zero_unique
  succ_ne_self
  pred
  pred_spec
)
