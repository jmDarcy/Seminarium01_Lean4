import Mathlib

namespace Rozwiazania01

/-!
Rozwiązania 12 ćwiczeń. Numeracja odpowiada plikowi Cwiczenia01.lean.
Każdy przykład zawiera kompletny dowód. Objaśnienia pojęć i źródła
znajdują się w Przewodnik_Seminarium01.md.
-/

-- 1. Dowód znajduje się już w kontekście.
example (P : Prop) (hP : P) : P := by
  exact hP

-- 2. Najpierw wprowadzamy zmienne i przesłankę, następnie uzasadniamy nierówność.
example : ∀ x y : ℝ, x ≤ y → x + 2 ≤ y + 2 := by
  intro x y hxy
  exact add_le_add hxy (le_refl 2)

-- 3. Z dowodów P i Q konstruujemy dowód Q ∧ P.
example (P Q : Prop) (h : P ∧ Q) : Q ∧ P := by
  obtain ⟨hP, hQ⟩ := h
  constructor
  · exact hQ
  · exact hP

-- 4. Istnienie dowodzimy, dostarczając świadka i sprawdzając jego własność.
example : ∃ x : ℝ, x ^ 2 = 4 := by
  use 2
  norm_num

-- 5. Podstawienie zgodnie z h sprowadza cel do tożsamości wielomianowej.
example (x y : ℝ) (h : x = y + 2) : x ^ 2 = y ^ 2 + 4 * y + 4 := by
  rw [h]
  ring

-- 6. Przenosimy 2 na drugą stronę i dzielimy przez dodatnie 3.
example (x : ℝ) (hx : 3 * x + 2 ≤ 11) : x ≤ 3 := by
  linarith

-- 7. Matematycznym uzasadnieniem jest (x - 1)^2 ≥ 0.
example (x : ℝ) : 2 * x ≤ x ^ 2 + 1 := by
  have hsq : 0 ≤ (x - 1) ^ 2 := sq_nonneg (x - 1)
  nlinarith [hsq]

-- 8. Dodatniość a zapewnia zachowanie ścisłej nierówności przy mnożeniu.
example (a b : ℝ) (ha : 0 < a) : StrictMono (fun x : ℝ => a * x + b) := by
  intro x y hxy
  change a * x + b < a * y + b
  have hmul : a * x < a * y := mul_lt_mul_of_pos_left hxy ha
  exact add_lt_add_of_lt_of_le hmul (le_refl b)

-- 9. Wystarczają x = 0 i y = 1. norm_num sprawdza wszystkie trzy porównania.
example : ∃ x y : ℝ, x ≤ y ∧ (-1) * x > (-1) * y := by
  use 0, 1
  norm_num

-- 10. Tożsamość 9 - (6x - x²) = (x - 3)² daje górne oszacowanie.
-- Podstawienie x = 3 potwierdza osiąganie wartości maksymalnej 9.
example (x : ℝ) : 6 * x - x ^ 2 ≤ 9 := by
  nlinarith [sq_nonneg (x - 3)]

-- 11. Zerowe wydatki są dopuszczalne, gdy dochód jest nieujemny.
example (p₁ p₂ w : ℝ) (hw : 0 ≤ w) :
    ∃ x : ℝ × ℝ, 0 ≤ x.1 ∧ 0 ≤ x.2 ∧ p₁ * x.1 + p₂ * x.2 ≤ w := by
  use (0, 0)
  simpa using hw

-- 12. Uwaga na kierunek: u z ≤ u y ≤ u x.
example {X : Type*} (u : X → ℝ) (x y z : X)
    (hxy : u y ≤ u x) (hyz : u z ≤ u y) : u z ≤ u x := by
  exact le_trans hyz hxy

end Rozwiazania01
