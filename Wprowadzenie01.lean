import Mathlib

namespace Wprowadzenie01

/-!
# Typy, zapis liczb, zdania i pierwszy dowód

Plik towarzyszy nowemu wstępowi prezentacji i części 3 przewodnika.
Uruchomienie: lake env lean Wprowadzenie01.lean
Wszystkie przykłady są kompletne. Polecenia #check wyświetlają informacje.
-/

-- W VS Code: wpisz \N, \R, \C i zatwierdź spacją lub Tab.
-- Symbole są znakami Unicode, a nie poleceniami LaTeX wykonywanymi przez Lean.
#check ℕ
#check Nat
#check ℝ
#check Real
#check ℂ
#check Complex

-- Typ wskazuje rodzaj obiektu: liczbę, parę albo funkcję.
#check (3 : ℝ)
#check ((1, 2) : ℝ × ℝ)
#check (fun x : ℝ => x + 1)

-- #check pokazuje typ. #eval w tym przykładzie oblicza wartość.
#check (2 + 2)
#eval (2 + 2)

-- Zapis cyfr interpretuje się w typie wynikającym z otoczenia.
-- Dopisek po dwukropku wskazuje oczekiwany typ.
#check (3 : ℕ)
#check (3 : ℝ)
#check (3 : ℂ)
#check OfNat

-- To inny mechanizm: n ma już typ ℕ, a Lean przekształca je do ℝ.
-- Wyświetlany wynik funkcji zawiera ↑n.
#check (fun (n : ℕ) => (n : ℝ))
example (n : ℕ) : ℝ := n

-- Inne struktury matematyczne udostępnia Mathlib.
#check (3 : Quaternion ℝ)

section QuaternionNotation
open scoped Quaternion
#check ℍ[ℝ]
#check (3 : ℍ[ℝ])
end QuaternionNotation

-- Kwadratowa macierz 3 to macierz skalarna 3I.
#check (3 : Matrix (Fin 2) (Fin 2) ℝ)

example : (3 : Matrix (Fin 2) (Fin 2) ℝ) 0 1 = 0 := by
  simp only [Matrix.ofNat_apply]
  norm_num

example : (3 : Matrix (Fin 2) (Fin 2) ℝ) 0 0 = 3 := by
  simp only [Matrix.ofNat_apply]
  norm_num

-- Macierz samych trójek wymaga innego zapisu.
#check (fun (_ _ : Fin 2) => (3 : ℝ))

-- Typ liczb i typ całego zdania to różne informacje.
#check (2 + 2)                 -- ℕ
#check (2 + 2 = 4)             -- Prop; liczby są tu naturalne
#check ((2 : ℝ) + 2 = 4)      -- Prop; liczby są rzeczywiste
#check ((2 : ℝ) + 2 = 5)      -- Prop; fałszywa równość też jest zdaniem
#check Eq                     -- równość przyjmuje dwa obiekty i tworzy zdanie
#check (fun x : ℝ => x ≥ 0)   -- ℝ → Prop

-- Prop klasyfikuje zdania. Dowód konkretnego zdania P ma typ P.
#check Prop
#check True
#check (2 == 2)                -- Bool, odrębna operacja od równości =

-- Czytamy: niech P będzie zdaniem i niech hP będzie dowodem P.
-- Po ostatnim dwukropku podajemy oczekiwany wynik: dowód P.
-- := rozpoczyna zapis wyniku; by pozwala skonstruować go za pomocą taktyk.
example (P : Prop) (hP : P) : P := by
  -- Dostępne: P : Prop, hP : P. Teza po znaku ⊢: P.
  exact hP
  -- Wskazany dowód odpowiada tezie, więc nie pozostaje żadne zadanie.

-- Ten sam wynik można dostarczyć bez bloku taktyk.
example (P : Prop) (hP : P) : P := hP

-- Pełny zapis zależności: dla każdego zdania P, jeżeli P, to P.
example : ∀ P : Prop, P → P := by
  intro P hP
  exact hP

-- example sprawdza anonimową definicję, także zwykłego obiektu.
example : ℕ := 3

-- Nazwany wynik można wykorzystać dalej w tym pliku.
theorem identity_proof (P : Prop) (hP : P) : P := hP

end Wprowadzenie01
