import Mathlib

namespace Cwiczenia01

/-!
Ćwiczenia do seminarium 1. Każde `sorry` zastąp kompletnym dowodem.
Ostrzeżenia o `sorry` w tym pliku oznaczają zadania do rozwiązania.
Rozwiązania znajdują się w osobnym pliku Rozwiazania01.lean.
Plik nie importuje skryptu seminaryjnego; wymaga jedynie biblioteki Mathlib.
Terminologię i literaturę podaje Przewodnik_Seminarium01.md, części 3, 5 i 8.
-/

-- 1. Dostarcz istniejący dowód. Narzędzie: exact.
example (P : Prop) (hP : P) : P := by
  sorry
-- 2. Wprowadź zmienne i przesłankę implikacji. Narzędzia: intro, add_le_add lub linarith.
example : ∀ x y : ℝ, x ≤ y → x + 2 ≤ y + 2 := by
  sorry


-- 3. Wyodrębnij składniki założenia i udowodnij koniunkcję w odwrotnej kolejności.
-- Narzędzia: obtain, constructor, exact.
example (P Q : Prop) (h : P ∧ Q) : Q ∧ P := by
  sorry

-- 4. Wskaż konkretną liczbę rzeczywistą. Narzędzia: use, norm_num.
example : ∃ x : ℝ, x ^ 2 = 4 := by
  sorry

-- 5. Najpierw użyj założenia, potem rachunku. Narzędzia: rw, ring.
example (x y : ℝ) (h : x = y + 2) : x ^ 2 = y ^ 2 + 4 * y + 4 := by
  sorry

-- 6. Nierówność liniowa. Narzędzie: linarith.
example (x : ℝ) (hx : 3 * x + 2 ≤ 11) : x ≤ 3 := by
  sorry

-- 7. Nieujemność kwadratu. Narzędzia: have, sq_nonneg, nlinarith.
example (x : ℝ) : 2 * x ≤ x ^ 2 + 1 := by
  sorry

-- 8. Udowodnij ścisłą rosnącość funkcji afinicznej przy dodatnim współczynniku kierunkowym.
-- Narzędzia: intro, change, mul_lt_mul_of_pos_left.
example (a b : ℝ) (ha : 0 < a) : StrictMono (fun x : ℝ => a * x + b) := by
  sorry

-- 9. Kontrprzykład do monotoniczności bez założenia o znaku nachylenia.
example : ∃ x y : ℝ, x ≤ y ∧ (-1) * x > (-1) * y := by
  sorry

-- 10. Udowodnij górne oszacowanie funkcji kwadratowej. Wskazówka: (x - 3)^2 ≥ 0.
-- Wartość maksymalna wynosi 9, a punkt maksymalizujący to x = 3.
example (x : ℝ) : 6 * x - x ^ 2 ≤ 9 := by
  sorry

-- 11. Niepustość prostego zbioru budżetowego: wybierz koszyk zerowy.
example (p₁ p₂ w : ℝ) (hw : 0 ≤ w) :
    ∃ x : ℝ × ℝ, 0 ≤ x.1 ∧ 0 ≤ x.2 ∧ p₁ * x.1 + p₂ * x.2 ≤ w := by
  sorry

-- 12. Zastosuj przechodniość nierówności do wartości funkcji użyteczności.
-- Przy konwencji x ≽ y ↔ u y ≤ u x jest to przechodniość słabej preferencji.
example {X : Type*} (u : X → ℝ) (x y z : X)
    (hxy : u y ≤ u x) (hyz : u z ≤ u y) : u z ≤ u x := by
  sorry

end Cwiczenia01
