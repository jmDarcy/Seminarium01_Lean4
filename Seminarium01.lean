import Mathlib
-- Importujemy definicje, twierdzenia i taktyki biblioteki Mathlib.
-- Plik wymaga środowiska projektu z zależnością Mathlib.

namespace Seminarium01
-- Oddzielamy nazwy z seminarium od nazw istniejących w bibliotece.

/-!
# Seminarium 1: od stanu dowodu do prostych modeli ekonomicznych

Praca z plikiem: ustawiaj kursor po kolejnych taktykach i obserwuj Infoview.
Nad znakiem ⊢ znajdują się dostępne obiekty i założenia, za nim bieżąca teza.
Dowody w tym pliku są kompletne: nie korzystają z `sorry` ani z dodatkowych aksjomatów.

Materiał można omawiać etapami.
A–D: podstawy formalizacji; E–H: zastosowania; I: materiał uzupełniający.
Terminologia: Theorem Proving in Lean 4, rozdz. 3; Mathematics in Lean, rozdz. 2–3.
Kontekst ekonomiczny: Osborne i Rubinstein, Models in Microeconomic Theory,
wyd. 2 rozszerzone, 2023, rozdz. 1 i 5, https://doi.org/10.11647/OBP.0362.
Dokładne odsyłacze i zakres wykorzystania źródeł podaje przewodnik.
-/

/-! ## A. Typ, zdanie, dowód -/

#check (3 : ℕ)
-- System sprawdza typ liczby naturalnej, a nie prawdziwość twierdzenia.

#check (4 : ℕ)

#check (3 : ℝ)
-- Ten sam zapis liczbowy interpretujemy teraz jako liczbę rzeczywistą.

#check ((3.1 + 1) : ℚ)


#eval (3+3 : ℕ)
#eval (3+3 : ℝ)


#check (3 : ℂ)
#check (3 : Quaternion ℝ)
#check (3 : Matrix (Fin 2) (Fin 2) ℝ)

#check ((2 : ℝ) + 2 = 5)


#check ((3+(3 : ℝ) = 6) : Prop)

#check ((5+(3 : ℕ) = 6) : Prop)

#check ((2 + 2 = 4))
-- Wyrażenie ma typ Prop. Poprawne typowanie zdania nie jest dowodem jego prawdziwości.

#eval (3 + 3 : ℕ)  -- 6

example : ((4 : ℝ) + 3 : ℝ) = 7 := by
  norm_num

example (n : ℕ) : ℝ := n   -- przekształcenie istniejącego obiektu

example (P : Prop) (hP : P) : P := hP
example (P : Prop) (hP : P) : P := by
  -- P jest dowolnym zdaniem; hP to dostępny dowód P; celem jest P.
  exact hP
  -- Dostarczamy dowód odpowiadający dokładnie bieżącej tezie.

example (n : ℕ) : n = n := by
  rfl
  -- Obie strony są definicyjnie tym samym wyrażeniem.

example : (2 : ℕ) + 2 = 4 := by
  rfl
  -- W tym przypadku obliczenie na liczbach naturalnych redukuje lewą stronę.

/-! ## B. Logika: intro, exact, apply, constructor, obtain, use -/


example (P Q : Prop) (hPQ : P → Q) : P → Q := hPQ

example (P Q : Prop) (hPQ : P → Q) : P → Q := by
  intro hP
  -- Z tezy P → Q przechodzimy do Q, dopisując hP : P do kontekstu.
  exact hPQ hP
  -- Stosujemy dowód implikacji hPQ do dowodu jej przesłanki hP.

example : ∀ x : ℝ, x ≤ x := by
  intro x
  -- Wybieramy dowolne x; odtąd celem jest x ≤ x.
  exact le_refl x
  -- Korzystamy z bibliotecznego twierdzenia o zwrotności nierówności.

example (P Q : Prop) (hP : P) (hQ : Q) : P ∧ Q := by
  constructor
  -- Powstają dwa cele: P oraz Q. Każda kropka · otwiera osobny poddowód.
  · exact hP
    -- Zamykamy pierwszy cel.
  · exact hQ
    -- Zamykamy drugi cel.

example (P Q : Prop) (h : P ∧ Q) : Q ∧ P := by
  obtain ⟨hP, hQ⟩ := h
  -- Wyodrębniamy z h dowody obu składników: hP : P i hQ : Q.
  constructor
  -- Budujemy żądaną koniunkcję w odwrotnej kolejności.
  · exact hQ
  · exact hP

example (P Q : Prop) (h : P ∧ Q) : P := by
  rcases h with ⟨hP, hQ⟩
  -- Alternatywny sposób wyodrębnienia składników; hQ nie jest tu potrzebne.
  exact hP

example (P Q : Prop) (hP : P) : P ∨ Q := by
  left
  -- Do dowodu alternatywy wystarczy wybrać i udowodnić lewą stronę.
  exact hP

example (P Q : Prop) : (P ∧ Q) ↔ (Q ∧ P) := by
  constructor
  -- Równoważność rozbijamy na dwie implikacje.
  · intro h
    obtain ⟨hP, hQ⟩ := h
    exact ⟨hQ, hP⟩
    -- Nawiasy ⟨...⟩ tutaj bezpośrednio konstruują dowód koniunkcji.
  · intro h
    obtain ⟨hQ, hP⟩ := h
    exact ⟨hP, hQ⟩

example : ∃ x : ℝ, x > 0 := by
  use 1
  -- Podajemy świadka kwantyfikatora egzystencjalnego; pozostaje 1 > 0.
  norm_num
  -- Uzasadniamy nierówność liczbową 1 > 0.

example (P : Prop) (hNot : ¬ P) : P → False := by
  intro hP
  -- Negacja ¬ P oznacza P → False.
  exact hNot hP
  -- Z dowodu P i jego negacji uzyskujemy sprzeczność.

example (x y z : ℝ) (hxy : x ≤ y) (hyz : y ≤ z) : x ≤ z := by
  apply le_trans hxy
  -- Dopasowujemy wniosek twierdzenia o przechodniości; nowy cel to y ≤ z.
  exact hyz

  example (x y z : ℝ) (hxy : x ≤ y) (hyz : y ≤ z) : x ≤ z := by
    apply le_trans hxy hyz
  -- Dopasowujemy wniosek twierdzenia o przechodniości; nowy cel to y ≤ z.

  example (x y z : ℝ) (hxy : x ≤ y) (hyz : y ≤ z) : x ≤ z := by
    exact le_trans hxy hyz

/-! ## C. Równości: rw, simp, ring, calc -/

example (x y : ℝ) (h : x = y) : x + 1 = y + 1 := by
  rw [h]
  -- Podstawiamy y za x. Pozostaje równość identycznych wyrażeń; rw ją zamyka.

example (x y : ℝ) (h : x = y) : y + 1 = x + 1 := by
  rw [← h]
  -- Odwracamy kierunek podstawienia: zamieniamy y na x.

example (x y : ℝ) (hxy : x = y) (hx : x + 1 = 3) : y + 1 = 3 := by
  rw [hxy] at hx
  -- Przepisujemy x na y we wskazanej hipotezie hx, zamiast w celu.
  exact hx
  -- Po podstawieniu hx ma dokładnie treść bieżącego celu.

def twice (x : ℝ) : ℝ := 2 * x
-- Definicja nadaje nazwę funkcji; nie stwierdza nowego faktu matematycznego.

example (x : ℝ) : twice x = 2 * x := by
  rfl
  -- Rozwinięcie definicji twice wystarcza do identyczności stron.

example (x : ℝ) : twice x + 0 = 2 * x := by
  simp [twice]
  -- Rozwijamy wskazaną definicję i stosujemy reguły upraszczania, m.in. + 0.

example (x y : ℝ) : (x + y) ^ 2 = x ^ 2 + 2 * x * y + y ^ 2 := by
  ring
  -- Normalizujemy wielomiany. Nie korzystamy tutaj z założeń o x ani y.

example (x y : ℝ) (h : x = y + 1) : x ^ 2 = y ^ 2 + 2 * y + 1 := by
  rw [h]
  -- Najpierw podstawiamy zgodnie z h, aby otrzymać tożsamość wielomianową.
  ring
  -- Teraz cel jest tożsamością wielomianową.

example (a b c : ℝ) : a + b + c = c + (b + a) := by
  calc
    a + b + c = c + (a + b) := by rw [add_comm (a + b) c]
    -- Pierwszy krok: zamiana kolejności dwóch składników zewnętrznej sumy.
    _ = c + (b + a) := by rw [add_comm a b]
    -- Podkreślenie powtarza prawą stronę poprzedniego kroku jako lewą.

/-! ## D. Nierówności: twierdzenia o porządku -/

example (x y : ℝ) (hxy : x ≤ y) : x + 3 ≤ y + 3 := by
  exact add_le_add hxy (le_refl 3)
  -- Dodajemy tę samą liczbę do obu stron, używając konkretnego twierdzenia.

example (x y : ℝ) (hxy : x ≤ y) : x + 3 ≤ y + 3 := by
  linarith
  -- Ten sam wniosek wyprowadzamy automatycznie z arytmetyki liniowej.

example (x y : ℝ) (hx : 2 * x + y ≤ 7) (hy : 1 ≤ y) : x ≤ 3 := by
  linarith
  -- Z y ≥ 1 wynika 2x + 1 ≤ 7, a następnie x ≤ 3.

example (x y : ℝ) : 2 * x * y ≤ x ^ 2 + y ^ 2 := by
  have hsq : 0 ≤ (x - y) ^ 2 := sq_nonneg (x - y)
  -- Dodajemy do kontekstu uzasadniony fakt o nieujemności kwadratu.
  nlinarith [hsq]
  -- Taktyka wyprowadza wniosek z hsq. Nie rozstrzyga wszystkich nierówności wielomianowych.

example (x y : ℝ) (hx : 0 ≤ x) (hy : 0 ≤ y) : 0 ≤ x * y + 1 := by
  positivity
  -- Rozpoznajemy znak iloczynu, a następnie sumy.

example : (4 : ℝ) ^ 3 < 5 ^ 3 := by
  norm_num
  -- Konkretny rachunek liczbowy, bez zmiennych wymagających rozumowania.

example (n : ℕ) (hn : n < 5) : n ≤ 4 := by
  omega
  -- Arytmetyka liniowa liczb naturalnych uwzględniająca ich dyskretność.

example (x : ℝ) (hx : x ≠ 0) : (x + 1) / x = 1 + 1 / x := by
  field_simp [hx]
  -- Usuwamy mianownik dzięki hx; tutaj taktyka zamyka również powstałą równość.
  -- W trudniejszych przykładach po usunięciu mianowników może być potrzebne ring.

/-! ## E. Aksjomatyka: dowód z jawnych założeń, bez nowych aksjomatów -/

example {X : Type*} (R : X → X → Prop)
    (hTrans : ∀ a b c, R a b → R b c → R a c)
    (x y z : X) (hxy : R x y) (hyz : R y z) : R x z := by
  -- X jest typem alternatyw, a R relacją dwuargumentową na X.
  -- hTrans jest lokalnym założeniem o R, a nie dowodem jego przechodniości.
  exact hTrans x y z hxy hyz
  -- Stosujemy zadeklarowaną własność relacji do konkretnych argumentów.

example {X : Type*} (R : (X × X) → Prop)
    (hTrans : ∀ a b c, R (a, b) → R (b, c) → R (a, c))
    (x y z : X) (hxy : R (x, y)) (hyz : R (y, z)) : R (x, z) := by
  exact hTrans x y z hxy hyz
  -- W tym przypadku relacja jest zadeklarowana na parach elementów typu X.


example {G : Type*} [AddCommMonoid G] (a b : G) : a + b = b + a := by
  -- Klasa AddCommMonoid udostępnia założenia o dodawaniu, w tym przemienność.
  exact add_comm a b
  -- Korzystamy z interfejsu struktury. Nie dowodzimy aksjomatów od początku.

/-! ## F. Użyteczność i preferencje -/

theorem affine_monotone (a b : ℝ) (ha : 0 ≤ a) :
    Monotone (fun x : ℝ => a * x + b) := by
  -- Monotone f oznacza: dla każdych x ≤ y zachodzi f x ≤ f y.
  intro x y hxy
  -- W kontekście mamy teraz x, y oraz hxy : x ≤ y.
  change a * x + b ≤ a * y + b
  -- Jawnie zapisujemy postać celu wynikającą z podstawienia argumentów funkcji.
  have hmul : a * x ≤ a * y := mul_le_mul_of_nonneg_left hxy ha
  -- Mnożenie nierówności przez a wymaga ha. To istotny krok matematyczny.
  exact add_le_add hmul (le_refl b)
  -- Dodajemy b do obu stron i zamykamy cel.

def weakPref {X : Type*} (u : X → ℝ) (x y : X) : Prop := u y ≤ u x
-- weakPref u x y czytamy: x jest co najmniej tak samo pożądany jak y.
-- Kierunek nierówności wynika z przyjętej interpretacji preferencji.

theorem weakPref_refl {X : Type*} (u : X → ℝ) (x : X) : weakPref u x x := by
  change u x ≤ u x
  -- Rozwijamy definicję relacji do zwykłej nierówności.
  exact le_refl (u x)

theorem weakPref_trans {X : Type*} (u : X → ℝ) (x y z : X)
    (hxy : weakPref u x y) (hyz : weakPref u y z) : weakPref u x z := by
  change u y ≤ u x at hxy
  -- Odczytujemy pierwszą hipotezę jako nierówność użyteczności.
  change u z ≤ u y at hyz
  -- Analogicznie odczytujemy drugą hipotezę.
  change u z ≤ u x
  -- Celem jest przechodniość tych nierówności.
  exact le_trans hyz hxy
  -- Najpierw u z ≤ u y, potem u y ≤ u x; kolejność argumentów ma znaczenie.

theorem weakPref_complete {X : Type*} (u : X → ℝ) (x y : X) :
    weakPref u x y ∨ weakPref u y x := by
  change u y ≤ u x ∨ u x ≤ u y
  -- Zupełność preferencji sprowadzamy do porównywalności liczb rzeczywistych.
  exact le_total (u y) (u x)

/-!
Wyniki dotyczą relacji zdefiniowanej za pomocą danej funkcji użyteczności.
Istnienie reprezentacji użytecznościowej dla niezależnie zadanej relacji
preferencji stanowi osobne zagadnienie (Osborne i Rubinstein, rozdz. 1).
Wartości użyteczności opisują uporządkowanie alternatyw. Ich różnicom
nie przypisujemy tutaj interpretacji intensywności preferencji.
-/

/-! ## G. Zbiór budżetowy: inkluzja i wypukłość -/

abbrev Bundle := ℝ × ℝ
-- Koszyk dwóch dóbr to para liczb rzeczywistych; x.1 i x.2 to jego składowe.

def spending (p₁ p₂ : ℝ) (x : Bundle) : ℝ := p₁ * x.1 + p₂ * x.2
-- Przy ustalonych cenach funkcja wydatków jest liniowa względem koszyka.

def budgetSet (p₁ p₂ w : ℝ) : Set Bundle :=
  {x | 0 ≤ x.1 ∧ 0 ≤ x.2 ∧ spending p₁ p₂ x ≤ w}
-- Element zbioru spełnia trzy warunki: nieujemność obu ilości i ograniczenie wydatków.

theorem budget_mono_income (p₁ p₂ w₁ w₂ : ℝ) (hw : w₁ ≤ w₂) :
    budgetSet p₁ p₂ w₁ ⊆ budgetSet p₁ p₂ w₂ := by
  intro x hx
  -- Inkluzję dowodzimy, biorąc dowolny koszyk x z pierwszego zbioru.
  obtain ⟨hx1, hx2, hxw⟩ := hx
  -- Wyodrębniamy trzy warunki przynależności do zbioru budżetowego.
  exact ⟨hx1, hx2, le_trans hxw hw⟩
  -- Ilości się nie zmieniają; nowy limit wydatków wynika z przechodniości.

theorem budget_convex (p₁ p₂ w : ℝ) : Convex ℝ (budgetSet p₁ p₂ w) := by
  intro x hx y hy a b ha hb hab
  -- Definicja Convex daje x,y ze zbioru oraz a,b ≥ 0 i a + b = 1.
  -- Celem jest przynależność a • x + b • y do tego samego zbioru.
  obtain ⟨hx1, hx2, hxw⟩ := hx
  -- Wyodrębniamy warunki dopuszczalności koszyka x.
  obtain ⟨hy1, hy2, hyw⟩ := hy
  -- Wyodrębniamy warunki dopuszczalności koszyka y.
  change 0 ≤ a * x.1 + b * y.1 ∧
    0 ≤ a * x.2 + b * y.2 ∧
    p₁ * (a * x.1 + b * y.1) + p₂ * (a * x.2 + b * y.2) ≤ w
  -- Odsłaniamy składowe kombinacji i definicję zbioru budżetowego.
  constructor
  -- Oddzielamy nieujemność pierwszej ilości od pozostałych warunków.
  · positivity
    -- a,b oraz odpowiednie ilości są nieujemne.
  · constructor
    -- Oddzielamy nieujemność drugiej ilości od ograniczenia wydatków.
    · positivity
    · calc
        p₁ * (a * x.1 + b * y.1) + p₂ * (a * x.2 + b * y.2)
            = a * spending p₁ p₂ x + b * spending p₁ p₂ y := by
              dsimp [spending]
              -- Rozwijamy wydatki obu koszyków.
              ring
              -- Sprawdzamy liniowość wydatków przez rachunek wielomianowy.
        _ ≤ a * w + b * w :=
          add_le_add (mul_le_mul_of_nonneg_left hxw ha)
            (mul_le_mul_of_nonneg_left hyw hb)
        -- Każdy wydatek jest ≤ w; mnożniki są nieujemne.
        _ = (a + b) * w := by ring
        -- Wyłączamy w przed nawias.
        _ = w := by rw [hab, one_mul]
        -- Korzystamy z a + b = 1, a następnie z 1 * w = w.

/-!
Lemat o wypukłości zachodzi dla dowolnych rzeczywistych parametrów p₁, p₂, w.
W standardowym modelu konsumenta przyjmuje się dodatnie ceny i dodatnie
zasoby pieniężne (Osborne i Rubinstein, rozdz. 5.1). Tutaj w interpretujemy
jako dostępny budżet. Szerszy zakres formalnego lematu wynika z tego,
że sam dowód wypukłości nie wymaga założeń o znakach tych parametrów.
Niepustość i ograniczoność zbioru wymagają odrębnych uzasadnień.
-/

/-! ## H. Optymalizacja bez rachunku różniczkowego -/

def quadraticUtility (A x : ℝ) : ℝ := A * x - x ^ 2
-- Parametr A jest rzeczywisty; na razie dziedziną wyboru jest całe ℝ.

theorem quadratic_global_max (A x : ℝ) :
    quadraticUtility A x ≤ quadraticUtility A (A / 2) := by
  dsimp [quadraticUtility]
  -- Po rozwinięciu definicji cel to Ax - x² ≤ A(A/2) - (A/2)².
  have hsq : 0 ≤ (x - A / 2) ^ 2 := sq_nonneg (x - A / 2)
  -- Matematyczny pomysł dowodu: nieujemność kwadratu odchylenia od A/2.
  nlinarith [hsq]
  -- Rachunek wielomianowy przekształca ten fakt w żądane oszacowanie.

theorem quadratic_nonneg_optimum (A : ℝ) (hA : 0 ≤ A) :
    ∃ x : ℝ, 0 ≤ x ∧ ∀ y : ℝ, 0 ≤ y →
      quadraticUtility A y ≤ quadraticUtility A x := by
  use A / 2
  -- Wskazujemy punkt maksymalizujący A/2; jego wartość wynosi A²/4.
  constructor
  -- Osobno sprawdzamy dopuszczalność i optymalność kandydata.
  · positivity
    -- A/2 ≥ 0 dzięki hA.
  · intro y _hy
    -- Bierzemy dowolny dopuszczalny y; _hy to dowód jego nieujemności.
    exact quadratic_global_max A y
    -- Oszacowanie na całym ℝ obowiązuje także na podzbiorze {y | 0 ≤ y}.

#print axioms quadratic_nonneg_optimum
-- Wyświetlamy aksjomaty, od których zależy wynik. Nie powinno być sorryAx.

/-! ## I. Dodatek: indukcja i szukanie twierdzeń -/

def doubleNat : ℕ → ℕ
  | 0 => 0
  | n + 1 => doubleNat n + 2
-- Definicja rekurencyjna: wartość początkowa i krok zależny od poprzedniej wartości.

theorem doubleNat_eq (n : ℕ) : doubleNat n = 2 * n := by
  induction n with
  -- System tworzy bazę oraz krok z hipotezą indukcyjną.
  | zero =>
    rfl
    -- Obie strony dla n = 0 redukują się do 0.
  | succ n ih =>
    rw [doubleNat, ih]
    -- Rozwijamy jeden krok rekurencji i korzystamy z ih : doubleNat n = 2 * n.
    ring
    -- Pozostaje elementarna tożsamość 2n + 2 = 2(n + 1).

#check mul_le_mul_of_nonneg_left
#check add_le_add
#check Convex
-- #check pozwala sprawdzić dokładny typ twierdzenia lub definicji.
-- W edytorze warto też sprawdzić `exact?`, `apply?`, `rw?`, `simp?`.
-- Są to narzędzia pomocy w znalezieniu dowodu, a nie nowe założenia.

end Seminarium01
-- Koniec przestrzeni nazw; pełne nazwy wyników zaczynają się od Seminarium01.
