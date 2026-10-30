// Kompilacja: typst compile Prezentacja_Seminarium01.typ
// Edytowalne źródło prezentacji. Bez pakietów Typst Universe.
// Pełne dowody: Seminarium01.lean. Ćwiczenia i rozwiązania: osobne pliki.
// Literatura i zakres wykorzystania źródeł: końcowe slajdy i przewodnik.

#set document(title: "Lean 4 w ekonomii matematycznej. Seminarium 1", author: "Materiały seminaryjne")
#set page(width: 320mm, height: 180mm,
  margin: (left: 19mm, right: 19mm, top: 18mm, bottom: 17mm), fill: white)
#set text(font: "Avenir Next", size: 21pt, lang: "pl", fill: rgb("#202B38"))
#set par(justify: false, leading: 0.45em, spacing: 0.65em)
#set math.equation(numbering: none)
#show math.equation: set text(font: "New Computer Modern Math")
#show raw: set text(font: ("DejaVu Sans Mono", "New Computer Modern"))
#set list(indent: 17pt, body-indent: 9pt, spacing: 11pt)
#set enum(indent: 17pt, body-indent: 9pt, spacing: 11pt)

#let navy = rgb("#193B6B")
#let pale = rgb("#F0F4FA")
#let gray = rgb("#566475")
#let note(body) = block(above: 9pt)[#text(size: 16pt, fill: gray, body)]
#let small(body) = text(size: 18pt, body)
#let source(url, label) = block(above: 10pt)[#text(size: 13pt, fill: gray)[Źródło: #link(url)[#label]]]
#let lean(s, size: 18pt) = block(width: 100%, fill: rgb("#F5F7FA"), inset: 12pt,
  above: 9pt, below: 11pt)[
  #set text(size: size)
  #set par(leading: 0.3em)
  #raw(s, lang: "lean", block: true)
]
#let state(s) = lean(s, size: 19pt)
#let twocol(a, b, ratio: (1fr, 1fr)) = grid(columns: ratio, gutter: 26pt, a, b)
#let statement(title, body, color: navy) = block(width: 100%, above: 8pt, below: 13pt)[
  #text(fill: color, size: 19pt, weight: "bold", title)
  #v(7pt)
  #body
]
#let data-table(..cells, columns: (1fr, 2fr), size: 19pt) = {
  set text(size: size)
  table(columns: columns, inset: (x: 10pt, y: 9pt),
    stroke: (bottom: 0.4pt + rgb("#CAD2DD")),
    fill: (x, y) => if y == 0 { pale } else { none }, ..cells)
}
#let slide(title, section, body) = page(
  header: text(size: 11pt, fill: gray)[#section],
  footer: context [
    #line(length: 100%, stroke: 0.5pt + rgb("#CAD2DD"))
    #v(3pt)
    #grid(columns: (1fr, auto),
      text(size: 10pt, fill: gray)[Lean 4 w ekonomii matematycznej · Seminarium 1],
      text(size: 10pt, fill: gray)[#counter(page).display("1") / #counter(page).final().first()])
  ],
)[
  #metadata(title) <slide-title>
  #text(size: 30pt, fill: navy, weight: "bold", title)
  #v(18pt)
  #body
]

// Slajd 1
#slide("Lean 4 w ekonomii matematycznej", "Seminarium 1")[
  #v(26pt)
  #text(size: 37pt, weight: "medium")[Formalizacja twierdzeń\
  i konstrukcja dowodów]
  #v(23pt)
  #text(size: 24pt, fill: navy)[Logika, preferencje i optymalizacja]
  #v(24pt)
  #note[Materiał wprowadzający dla studentów i promotorów]
]

// Slajd 2
#slide("Teoria typów: obiekty i ich rodzaje", "Wprowadzenie")[
Każde poprawne wyrażenie w Lean ma określony typ.
  Typ wskazuje, jakiego rodzaju obiekt zapisujemy.
  #data-table(columns: (1.2fr, 2fr), size: 21pt,
    [*Zapis*], [*Znaczenie*],
    [`x : ℝ`], [Liczba rzeczywista],
    [`v : ℝ × ℝ`], [Para liczb rzeczywistych],
    [`f : ℝ → ℝ`], [Funkcja o zadanej dziedzinie i przeciwdziedzinie])
  #note[Zapis `x : ℝ` można na początku czytać podobnie do „x należy do ℝ”. Typ i zbiór są jednak odrębnymi pojęciami w Lean.]
  #source("https://lean-lang.org/theorem_proving_in_lean4/Dependent-Type-Theory/", [Theorem Proving in Lean 4, §2.1])
]

// Slajd 3
#slide("Plan seminarium", "Organizacja")[
#data-table(columns: (0.8fr, 2.6fr),
    [*Czas*], [*Temat*],
    [0–35 min], [Typy, zapis liczb, zdania i pierwszy dowód],
    [35–55 min], [Założenia, teza i podstawowe kroki dowodu],
    [55–75 min], [Podstawianie, upraszczanie i rachunki],
    [75–85 min], [Przerwa],
    [85–125 min], [Użyteczność, preferencje i zbiór budżetowy],
    [125–150 min], [Maksymalizacja i ćwiczenia])
  #note[Praca w parze: przed wpisaniem kolejnej taktyki wyjaśniamy, jakie zadanie dowodowe powinno po niej pozostać.]
]

// Slajd 4
#slide("Wprowadzanie symboli matematycznych", "Wprowadzenie")[
W edytorze VS Code z rozszerzeniem Lean 4 wpisz sekwencję i zatwierdź ją spacją lub Tab.
  #data-table(columns: (0.6fr, 0.8fr, 1.2fr), size: 21pt,
    [*Symbol*], [*Wpisz*], [*Nazwa w Lean*],
    [`ℕ`], [`\N`], [`Nat`],
    [`ℤ`], [`\Z`], [`Int`],
    [`ℚ`], [`\Q`], [`Rat`],
    [`ℝ`], [`\R`], [`Real`],
    [`ℂ`], [`\C`], [`Complex`])
  #note[To znaki Unicode używane w kodzie. Na przykład `ℝ` jest notacją typu `Real`. Przykłady z liczbami rzeczywistymi wymagają odpowiedniego importu, tutaj `import Mathlib`.]
]

// Slajd 5
#slide("Polecenie #check: jaki typ ma wyrażenie?", "Wprowadzenie")[
#lean("#check (3 : ℕ)        -- wynik: 3 : ℕ\n#check (3 : ℝ)        -- wynik: 3 : ℝ\n#check (2 + 2)        -- wynik: 2 + 2 : ℕ", size: 20pt)
  `#check` odczytuje zapis, uzupełnia informacje o typach i sprawdza, czy wyrażenie jest poprawnie zbudowane.

  Następnie pokazuje wyrażenie wraz z jego typem.
  #note[Polecenie `#check (2 + 2)` informuje o typie. Do obliczenia wartości wyrażenia służy m.in. `#eval (2 + 2)`, którego wynikiem jest 4.]
]

// Slajd 6
#slide("Zapis 3 w różnych typach liczbowych", "Wprowadzenie")[
#lean("#check (3 : ℕ)\n#check (3 : ℝ)\n#check (3 : ℂ)", size: 21pt)
  Dopisek po dwukropku wskazuje oczekiwany typ liczby.
  Lean korzysta z reguły interpretowania zapisu liczbowego w tym typie, opisanej przez `OfNat`.

  Gdy w prostym wyrażeniu nie ma innych wskazówek, Lean domyślnie wybiera `ℕ`.
  #note[Ten sam zapis cyfr może oznaczać obiekty różnych typów. Samo to nie ustanawia relacji zawierania pomiędzy tymi typami.]
  #source("https://lean-lang.org/doc/reference/latest/Terms/Numeric-Literals/", [Lean Language Reference, Numeric Literals])
]

// Slajd 7
#slide("Obiekt, zdanie i dowód zdania", "Wprowadzenie")[
#data-table(columns: (1.2fr, 1.8fr), size: 21pt,
    [*Zapis*], [*Jak go czytać*],
    [`x : ℝ`], [x jest liczbą rzeczywistą],
    [`P : Prop`], [P jest zdaniem],
    [`h : P`], [h jest dowodem zdania P])
  #v(10pt)
  Równość `2 + 2 = 4` ma typ `Prop`, ponieważ operacja równości tworzy zdanie o dwóch obiektach tego samego typu.

  Również `2 + 2 = 5` ma typ `Prop`. Prawdziwość zdania sprawdzamy przez podanie dowodu.
  #note[`Prop` klasyfikuje zdania. Dowód konkretnego zdania P ma typ P. Same liczby w `2 + 2 = 4` Lean interpretuje tutaj jako naturalne.]
  #source("https://lean-lang.org/doc/reference/latest/The-Type-System/Propositions/", [Lean Language Reference, Propositions])
]

// Slajd 8
#slide("Odczytywanie deklaracji example", "Wprowadzenie")[
#lean("example (P : Prop) (hP : P) : P := by\n  exact hP", size: 21pt)
  #data-table(columns: (1fr, 2fr), size: 20pt,
    [*Fragment*], [*Znaczenie*],
    [`example`], [Sprawdź przykład bez nadawania mu nazwy],
    [`(P : Prop)`], [Niech P będzie dowolnym zdaniem],
    [`(hP : P)`], [Załóżmy, że mamy już dowód P],
    [`: P`], [Wymagany wynik: dowód P])
  #note[To zapis argumentu „jeżeli P, to P”. Nie wynika z niego prawdziwość dowolnego zdania bez założenia jego dowodu.]
]

// Slajd 9
#slide("Zapis := by oraz pierwszy krok dowodu", "Wprowadzenie")[
#lean("example (P : Prop) (hP : P) : P := by\n  exact hP", size: 21pt)
  #statement("Trzy elementy składni")[
    `: P` określa, co należy dostarczyć.

    `:=` rozpoczyna zapis tego, co dostarczamy.

    `by` pozwala skonstruować dowód za pomocą taktyk.
  ]
  Ten sam przykład można zapisać bez taktyk:
  #lean("example (P : Prop) (hP : P) : P := hP", size: 20pt)
  #note[Dowód jest już w założeniach. Wystarczy go wskazać.]
]

// Slajd 10
#slide("Dostępne założenia i bieżąca teza", "Wprowadzenie")[
W panelu Infoview przykład ma początkowo postać:
  #state("P : Prop\nhP : P\n⊢ P")
  Nad znakiem `⊢` widzimy obiekty i założenia dostępne w danym miejscu dowodu.

  Za znakiem `⊢` widzimy zdanie, którego dowodu Lean teraz oczekuje.
  #note[Dokumentacja nazywa listę dostępnych obiektów i założeń „kontekstem lokalnym”. W prezentacji posługujemy się opisem „dostępne założenia”.]
]

// Slajd 11
#slide("exact: wskazanie kompletnego dowodu", "Podstawowe kroki dowodu")[
#twocol([
    *Przed krokiem*
    #state("P : Prop\nhP : P\n⊢ P")
  ],[
    *Krok dowodowy*
    #lean("exact hP", size: 22pt)
    Dowód `hP` ma typ `P`, czyli odpowiada bieżącej tezie.
  ])
  #v(14pt)
  Po tym kroku nie pozostaje żadne zadanie dowodowe.
  #note[`exact` może wskazać także dowód złożony z kilku dostępnych faktów, np. `exact hPQ hP` stosuje dowód implikacji do dowodu jej przesłanki.]
]

// Slajd 12
#slide("intro: przyjęcie przesłanki implikacji", "Podstawowe kroki dowodu")[
#lean("example (P Q : Prop) (hPQ : P → Q) : P → Q := by\n  intro hP\n  exact hPQ hP", size: 18pt)
  #twocol([
    *Przed `intro hP`*
    #state("P Q : Prop\nhPQ : P → Q\n⊢ P → Q")
  ],[
    *Po `intro hP`*
    #state("P Q : Prop\nhPQ : P → Q\nhP : P\n⊢ Q")
  ])
  #note[Aby dowieść implikacji, przyjmujemy jej przesłankę i dowodzimy wniosku. Przy tezie `∀ x, ...` taktyka `intro x` wprowadza dowolny obiekt x.]
]

// Slajd 13
#slide("apply: sprowadzenie tezy do przesłanek", "Podstawowe kroki dowodu")[
Dysponujemy twierdzeniem o przechodniości: z $x≤y$ i $y≤z$ wynika $x≤z$.
  #lean("example (x y z : ℝ)\n    (hxy : x ≤ y) (hyz : y ≤ z) : x ≤ z := by\n  apply le_trans hxy\n  exact hyz", size: 18pt)
  #data-table(columns: (1.1fr, 1.6fr), size: 21pt,
    [*Etap*], [*Pozostaje udowodnić*],
    [Przed `apply`], [$x≤z$],
    [Po `apply le_trans hxy`], [$y≤z$],
    [Po `exact hyz`], [Brak dalszych zadań])
  #note[`apply` dobiera twierdzenie do bieżącej tezy. Nieuzupełnione przesłanki stają się nowymi zadaniami dowodowymi.]
]

// Slajd 14
#slide("Koniunkcja: dowód i analiza hipotezy", "Logika")[
  #twocol([
    *Teza `P ∧ Q`*
    #lean("example (P Q : Prop)\n    (hP : P) (hQ : Q) :\n    P ∧ Q := by\n  constructor\n  · exact hP\n  · exact hQ", size: 17pt)
    Aby dowieść koniunkcji, dowodzimy obu zdań. `constructor` rozdziela te zadania.
  ], [
    *Hipoteza `h : P ∧ Q`*
    #lean("example (P Q : Prop)\n    (h : P ∧ Q) : P := by\n  obtain ⟨hP, hQ⟩ := h\n  exact hP", size: 17pt)
    Z założenia otrzymujemy osobno dowód P i dowód Q.
  ])
  #v(10pt)
  #note[Zapis `rcases h with ⟨hP, hQ⟩` również wyodrębnia oba dowody. Kropka `·` otwiera osobny poddowód.]
]

// Slajd 15
#slide("Istnienie: świadek i jego własność", "Logika")[
  #twocol([
    *Dowód istnienia*
    #lean("example : ∃ x : ℝ,\n    x > 0 := by\n  use 1\n  norm_num", size: 18pt)
    `use 1` wybiera świadka. Taktyka `norm_num` uzasadnia nierówność $1>0$.
  ], [
    *Użycie faktu o istnieniu*
    #lean("example (P : ℝ → Prop)\n    (h : ∃ x, P x) :\n    ∃ y, P y := by\n  obtain ⟨x, hx⟩ := h\n  use x", size: 17pt)
    Świadek: $x$. Jego własność: `hx : P x`.
  ])
  #v(10pt)
  #note[W pierwszym przypadku wybieramy świadka tezy. W drugim korzystamy ze świadka dostępnego w założeniu.]
]

// Slajd 16
#slide("Ćwiczenia 1 i 3: założenia i koniunkcja", "Ćwiczenia")[
  #statement("Zadanie 1")[
    #lean("example (P : Prop) (hP : P) : P := by\n  sorry", size: 18pt)
  ]
  #statement("Zadanie 3")[
    #lean("example (P Q : Prop) (h : P ∧ Q) : Q ∧ P := by\n  sorry", size: 18pt)
  ]
  #note[Przed wpisaniem kodu: jakie dowody są już dostępne i jakie cele powinien utworzyć pierwszy krok?]
]

// Slajd 17
#slide("rw: podstawienie zgodnie z równością", "Równości i nierówności")[
#lean("example (x y : ℝ) (h : x = y) : x + 1 = y + 1 := by\n  rw [h]", size: 20pt)
  Założenie `h : x = y` pozwala zastąpić x przez y.
  W tym przykładzie otrzymujemy identyczne wyrażenia po obu stronach, więc `rw` kończy dowód.
  #data-table(columns: (1fr, 1.8fr), size: 20pt,
    [*Zapis*], [*Miejsce i kierunek podstawienia*],
    [`rw [h]`], [W tezie: x zastępujemy przez y],
    [`rw [← h]`], [W tezie: y zastępujemy przez x],
    [`rw [h] at hx`], [W założeniu hx: x zastępujemy przez y])
]

// Slajd 18
#slide("simp: uproszczenie do znanej postaci", "Równości i nierówności")[
#lean("def twice (x : ℝ) : ℝ := 2 * x\n\nexample (x : ℝ) : twice x + 0 = 2 * x := by\n  simp [twice]", size: 20pt)
  `simp [twice]` rozwija podaną definicję i stosuje reguły upraszczania, np. $a+0=a$.

  W tym przykładzie obie strony upraszczają się do $2x$, co kończy dowód.
  #note[Reguły upraszczania są uzasadnionymi twierdzeniami bibliotecznymi. Taktyka `simp` może uprościć zadanie bez jego pełnego rozwiązania.]
]

// Slajd 19
#slide("rfl: równość wynikająca z definicji", "Równości i nierówności")[
#lean("def twice (x : ℝ) : ℝ := 2 * x\n\nexample (x : ℝ) : twice x = 2 * x := by\n  rfl", size: 20pt)
  Po rozwinięciu definicji `twice` obie strony są tym samym wyrażeniem.

  `rfl` wystarcza, gdy Lean rozpoznaje taką zgodność przez dozwolone obliczenia i redukcję definicji.
  #note[Przemienność `x + y = y + x` dla dowolnych x i y wymaga twierdzenia o dodawaniu. Sama redukcja definicji jej tutaj nie uzasadnia.]
]

// Slajd 20
#slide("Tożsamości wielomianowe", "Równości i nierówności")[
  #lean("example (x y : ℝ) (h : x = y + 1) :\n    x ^ 2 = y ^ 2 + 2 * y + 1 := by\n  rw [h]\n  ring", size: 19pt)
  #statement("Podstawienie i normalizacja")[
    `rw [h]` zastępuje x przez y+1 zgodnie z założeniem.

    `ring` sprowadza obie strony do tej samej postaci wielomianowej.
  ]
  #note[Normalizacja wielomianów nie zastępuje świadomego doboru podstawienia.]
]

// Slajd 21
#slide("Nierówności liniowe", "Równości i nierówności")[
  #lean("example (x y : ℝ)\n    (hx : 2 * x + y ≤ 7) (hy : 1 ≤ y) :\n    x ≤ 3 := by\n  linarith", size: 19pt)
  #statement("Rozumowanie matematyczne")[
    $ 2x+1 ≤ 2x+y ≤ 7 quad ==> quad x ≤ 3. $
  ]
  `linarith` uzasadnia wniosek przez połączenie dostępnych równości i nierówności liniowych.

  #note[Przy mnożeniu przez parametr trzeba uwzględnić jego znak, np. przez `mul_le_mul_of_nonneg_left`.]
]

// Slajd 22
#slide("Nieujemność kwadratu w dowodzie nierówności", "Równości i nierówności")[
  #statement("Teza")[
    $ forall x,y in RR: quad 2 x y ≤ x^2+y^2. $
  ]
  #lean("example (x y : ℝ) : 2 * x * y ≤ x ^ 2 + y ^ 2 := by\n  have hsq : 0 ≤ (x - y) ^ 2 := sq_nonneg (x - y)\n  nlinarith [hsq]", size: 17pt)
  `have` dodaje dowód nieujemności kwadratu.
  `nlinarith` wyprowadza z tego faktu żądaną nierówność.

  Uzasadnienie przesłanki `hsq`:
  $ (x-y)^2 = x^2 - 2 x y + y^2 ≥ 0. $
  #note[Ćwiczenie 7: dobierz kwadrat uzasadniający $2x ≤ x^2+1$. Taktyka `nlinarith` może wymagać takiej dodatkowej przesłanki.]
]

// Slajd 23
#slide("Jawne założenia modelu", "Założenia modelu")[
  #lean("example {X : Type*} (R : X → X → Prop)\n    (hTrans : ∀ a b c, R a b → R b c → R a c)\n    (x y z : X) (hxy : R x y) (hyz : R y z) :\n    R x z := by\n  exact hTrans x y z hxy hyz", size: 17pt)
  - `X` jest typem alternatyw, a `R` relacją na `X`.
  - `hTrans` jest jawnym założeniem o tej relacji.
  - Wynik wyprowadza konsekwencję przyjętej własności.
  #note[Globalne `axiom` przyjmuje deklarację bez dowodu. Założenia ekonomiczne zachowujemy jawnie w treści modelu i twierdzeń.]
]

// Slajd 24
#slide("Monotoniczność użyteczności afinicznej", "Użyteczność")[
  #statement("Twierdzenie")[
    Niech $u(x)=a x+b$ oraz $a ≥ 0$. Wówczas
    $ x ≤ y quad ==> quad u(x) ≤ u(y). $
  ]
  Dowód na papierze:
  $ x ≤ y quad ==> quad a x ≤ a y quad ==> quad a x+b ≤ a y+b. $
  #v(8pt)
  - Pierwsze przejście wykorzystuje nieujemność $a$.
  - Drugie wykorzystuje zgodność porządku z dodawaniem.
  #note[`Monotone` oznacza niemalejącość. Ścisłą rosnącość zapisujemy jako `StrictMono`.]
]

// Slajd 25
#slide("Dowód monotoniczności w Lean", "Użyteczność")[
  #lean("theorem affine_monotone (a b : ℝ) (ha : 0 ≤ a) :\n    Monotone (fun x : ℝ => a * x + b) := by\n  intro x y hxy\n  change a * x + b ≤ a * y + b\n  have hmul : a * x ≤ a * y :=\n    mul_le_mul_of_nonneg_left hxy ha\n  exact add_le_add hmul (le_refl b)", size: 18pt)
  #v(8pt)
  `intro` wprowadza argumenty i przesłankę nierówności. `change` pokazuje wartości funkcji. `have` zapisuje krok mnożenia, a `exact` zamyka dowód.
]

// Slajd 26
#slide("Znak parametru a monotoniczność", "Użyteczność")[
  $ u(x)=a x+b, quad x in RR. $
  #v(12pt)
  #data-table(columns: (0.8fr, 1.6fr, 1.3fr),
    [*Parametr*], [*Własność funkcji*], [*Zapis w Mathlib*],
    [$a>0$], [Ściśle rosnąca], [`StrictMono u`],
    [$a=0$], [Stała, niemalejąca], [`Monotone u`],
    [$a<0$], [Ściśle malejąca], [`StrictAnti u`])
  #v(13pt)
  *Ćwiczenie 8.* Udowodnij właśność ściśle rosnącą dla $a>0$.

  *Ćwiczenie 9.* Dla $u(x)=-x$ wskaż kontrprzykład do niemalejącości.
  #note[Dodatniość współczynnika pozwala zachować ścisłą nierówność przy mnożeniu.]
]

// Slajd 27
#slide("Preferencje reprezentowane przez użyteczność", "Preferencje")[
  #statement("Definicja")[
    Dla $u: X arrow RR$ przyjmujemy
    $ x succ.eq y quad <==> quad u(y) ≤ u(x). $
  ]
  #lean("def weakPref {X : Type*} (u : X → ℝ)\n    (x y : X) : Prop := u y ≤ u x", size: 18pt)
  `weakPref u x y` czytamy: $x$ jest co najmniej tak samo pożądany jak $y$.

  #source("https://doi.org/10.11647/OBP.0362.01", [Osborne i Rubinstein (2023), rozdz. 1])
]

// Slajd 28
#slide("Przechodniość preferencji", "Preferencje")[
  $ u(z) ≤ u(y) ≤ u(x) quad ==> quad x succ.eq z. $
  #lean("theorem weakPref_trans {X : Type*} (u : X → ℝ)\n    (x y z : X) (hxy : weakPref u x y)\n    (hyz : weakPref u y z) : weakPref u x z := by\n  change u y ≤ u x at hxy\n  change u z ≤ u y at hyz\n  change u z ≤ u x\n  exact le_trans hyz hxy", size: 17pt)
  #note[Po rozwinięciu definicji korzystamy z przechodniości porządku w ℝ. Kolejność argumentów `hyz`, `hxy` wynika z kierunku nierówności.]
]

// Slajd 29
#slide("Zwrotność, zupełność i zakres wyniku", "Preferencje")[
  #data-table(columns: (1fr, 1.6fr, 1.3fr),
    [*Własność*], [*Po rozwinięciu definicji*], [*Uzasadnienie*],
    [Zwrotność], [$u(x) ≤ u(x)$], [`le_refl (u x)`],
    [Zupełność], [$u(y) ≤ u(x) or u(x) ≤ u(y)$], [`le_total (u y) (u x)`])
  #v(14pt)
  #statement("Znaczenie założonej reprezentacji")[
    Relacja zdefiniowana za pomocą użyteczności jest zupełna i przechodnia. Istnienie reprezentacji dla niezależnie zadanej relacji wymaga osobnego twierdzenia.
  ]
  #note[Obojętność nie implikuje równości alternatyw. Różne obiekty mogą mieć tę samą użyteczność.]
]

// Slajd 30
#slide("Porządkowy charakter użyteczności", "Preferencje")[
  Jeżeli $phi: RR arrow RR$ jest ściśle rosnąca, to
  $ u(y) ≤ u(x) quad <==> quad phi(u(y)) ≤ phi(u(x)). $
  #v(15pt)
  Funkcje $u$ i $phi compose u$ reprezentują tę samą relację preferencji.
  #v(14pt)
  #statement("Przykład")[
    $ v(x)=3u(x)+7. $
    Zmiana skali zachowuje uporządkowanie alternatyw.
  ]
  #note[Różnice wartości użyteczności nie opisują tutaj intensywności preferencji. Formalny dowód niezmienniczości jest propozycją dalszej pracy.]
  #source("https://doi.org/10.11647/OBP.0362.01", [Osborne i Rubinstein (2023), §1.4])
]

// Slajd 31
#slide("Zbiór budżetowy dwóch dóbr", "Zbiory budżetowe")[
  $ B(p,w) = {x in RR^2 : x_1 ≥ 0, x_2 ≥ 0, p_1 x_1+p_2 x_2 ≤ w}. $
  #lean("abbrev Bundle := ℝ × ℝ\n\ndef spending (p₁ p₂ : ℝ) (x : Bundle) : ℝ :=\n  p₁ * x.1 + p₂ * x.2\n\ndef budgetSet (p₁ p₂ w : ℝ) : Set Bundle :=\n  {x | 0 ≤ x.1 ∧ 0 ≤ x.2 ∧ spending p₁ p₂ x ≤ w}", size: 17pt)
  #note[Parametr w oznacza dostępny budżet. Składowe koszyka zapisujemy jako `x.1` i `x.2`.]
]

// Slajd 32
#slide("Zwiększenie budżetu i inkluzja zbiorów", "Zbiory budżetowe")[
  #statement("Twierdzenie")[
    $ w_1 ≤ w_2 quad ==> quad B(p,w_1) subset.eq B(p,w_2). $
  ]
  #lean("theorem budget_mono_income (p₁ p₂ w₁ w₂ : ℝ)\n    (hw : w₁ ≤ w₂) :\n    budgetSet p₁ p₂ w₁ ⊆ budgetSet p₁ p₂ w₂ := by\n  intro x hx\n  obtain ⟨hx1, hx2, hxw⟩ := hx\n  exact ⟨hx1, hx2, le_trans hxw hw⟩", size: 17pt)
  #note[Ilości dóbr pozostają nieujemne. Nowy limit wydatków wynika z przechodniości: wydatek ≤ w₁ ≤ w₂.]
]

// Slajd 33
#slide("Wypukłość zbioru budżetowego", "Zbiory budżetowe")[
  #statement("Definicja wypukłości")[
    Dla $x,y in B$ oraz $a,b ≥ 0$ takich, że $a+b=1$,
    $ a x+b y in B. $
  ]
  Nieujemność składowych kombinacji wynika z nieujemności wag i składowych koszyków.

  Dla wydatków:
  $ p dot (a x+b y) = a (p dot x)+b (p dot y)
      ≤ a w+b w = (a+b)w = w. $
  #note[W Lean korzystamy ze standardowej definicji `Convex ℝ`, zgodnej z tą kombinacją wypukłą.]
]

// Slajd 34
#slide("Wypukłość: warunki dopuszczalności", "Zbiory budżetowe")[
  Niech $x,y in B(p,w)$, $a,b≥0$ oraz $a+b=1$.
  Dla $z=a x+b y$ dowodzimy:
  #v(10pt)
  #data-table(columns: (1.5fr, 1.6fr), size: 20pt,
    [*Warunek*], [*Uzasadnienie w Lean*],
    [$z_1=a x_1+b y_1≥0$], [`positivity`],
    [$z_2=a x_2+b y_2≥0$], [`positivity`],
    [$p dot z≤w$], [`calc` i twierdzenia o porządku])
  #v(14pt)
  Kluczowe przejście dla wydatków:
  $ a(p dot x)+b(p dot y) ≤ a w+b w = w. $
  #note[Oszacowanie wykorzystuje nieujemność wag. Ostatnia równość korzysta z warunku a+b=1. Pełny dowód: część G skryptu.]
]

// Slajd 35
#slide("Założenia a własności zbioru budżetowego", "Zbiory budżetowe")[
  #data-table(columns: (1fr, 2fr), size: 20pt,
    [*Własność*], [*Założenia wystarczające*],
    [Wypukłość], [Dowolne $p_1,p_2,w in RR$],
    [Niepustość], [$w≥0$, świadek $(0,0)$],
    [Ograniczoność], [$p_1>0$, $p_2>0$ oraz $w≥0$])
  #v(14pt)
  *Ćwiczenie 11.* Uzasadnij niepustość przez wskazanie koszyka zerowego.

  Przy dodatnich cenach każdy dopuszczalny koszyk spełnia
  $ 0≤x_i≤w/p_i quad (i=1,2). $
  #note[Ograniczoność omawiamy matematycznie. Skrypt formalizuje wypukłość, a ćwiczenie 11 dotyczy niepustości.]
  #source("https://doi.org/10.11647/OBP.0362.05", [Osborne i Rubinstein (2023), §5.1; zakres formalnego lematu jest szerszy])
]

// Slajd 36
#slide("Globalne maksimum funkcji kwadratowej", "Optymalizacja")[
  #statement("Twierdzenie")[
    Dla $u_A (x)=A x-x^2$, gdzie $A,x in RR$,
    $ u_A (x) ≤ u_A (A/2). $
  ]
  *Certyfikat optymalności:*
  $ u_A (A/2)-u_A (x) = (x-A/2)^2 ≥ 0. $
  #v(8pt)
  Oszacowanie obowiązuje na całym $RR$, dla każdego parametru $A$.
]

// Slajd 37
#slide("Dowód optymalności w Lean", "Optymalizacja")[
  #lean("def quadraticUtility (A x : ℝ) : ℝ := A * x - x ^ 2\n\ntheorem quadratic_global_max (A x : ℝ) :\n    quadraticUtility A x ≤ quadraticUtility A (A / 2) := by\n  dsimp [quadraticUtility]\n  have hsq : 0 ≤ (x - A / 2) ^ 2 := sq_nonneg (x - A / 2)\n  nlinarith [hsq]", size: 17pt)
  #v(8pt)
  - `dsimp` rozwija definicję funkcji celu.
  - `have` dodaje uzasadniony fakt pomocniczy.
  - `nlinarith` weryfikuje rachunek wielomianowy.
]

// Slajd 38
#slide("Maksymalizacja na półprostej x ≥ 0", "Optymalizacja")[
  #lean("theorem quadratic_nonneg_optimum (A : ℝ) (hA : 0 ≤ A) :\n    ∃ x : ℝ, 0 ≤ x ∧ ∀ y : ℝ, 0 ≤ y →\n      quadraticUtility A y ≤ quadraticUtility A x := by\n  use A / 2\n  constructor\n  · positivity\n  · intro y _hy\n    exact quadratic_global_max A y", size: 17pt)
  #statement("Rola założenia A ≥ 0")[
    Zapewnia dopuszczalność kandydata $A/2$. Optymalność wynika z wcześniejszego oszacowania na całym $RR$.
  ]
]

// Slajd 39
#slide("Ćwiczenie 10: górne oszacowanie funkcji", "Ćwiczenia")[
  #statement("Zadanie 10")[
    #lean("example (x : ℝ) : 6 * x - x ^ 2 ≤ 9 := by\n  sorry", size: 20pt)
  ]
  + Wskaż punkt osiągania wartości $9$.
  + Zapisz różnicę między $9$ a wartością funkcji jako kwadrat.
  + Zastosuj `sq_nonneg` i odpowiednią taktykę arytmetyczną.
  #v(8pt)
  #note[Dalszy projekt: maksimum Ax − x² na x ≥ 0 dla dowolnego A. Wymaga rozpatrzenia znaku parametru.]
]

// Slajd 40
#slide("Punkt maksymalizujący i wartość maksymalna", "Optymalizacja")[
  Dla $u_A (x)=A x-x^2$ na całym $RR$:
  #v(14pt)
  #data-table(columns: (1.6fr, 1fr), size: 23pt,
    [*Wielkość*], [*Wynik*],
    [Punkt maksymalizujący], [$x^*=A/2$],
    [Wartość maksymalna], [$u_A (x^*)=A^2/4$])
  #v(17pt)
  Na dziedzinie $x≥0$ punkt maksymalizujący wynosi
  $ x^*=max{A/2,0}. $
  #note[Skrypt dowodzi istnienia rozwiązania dla $A≥0$. Przypadek $A<0$, w którym rozwiązaniem jest $x=0$, pozostaje zadaniem rozszerzającym.]
]

// Slajd 41
#slide("Kontrola treści formalnego wyniku", "Samodzielna formalizacja")[
  - Czy dziedziny i kierunki relacji odpowiadają modelowi?
  - Gdzie wykorzystujemy dodatniość, niezerowość i dopuszczalność?
  - Czy założenia nie czynią tezy niezamierzenie trywialną?
  - Czy wynik korzysta wyłącznie z zaakceptowanych aksjomatów?
  #lean("#print axioms quadratic_nonneg_optimum", size: 19pt)
  #note[W tym przykładzie otrzymujemy standardowe zależności `propext`, `Classical.choice`, `Quot.sound`. Obecność `sorryAx` wskazywałaby na lukę.]
]

// Slajd 42
#slide("Samodzielna formalizacja lematu", "Samodzielna formalizacja")[
  #statement("Punkt wyjścia kolejnego spotkania")[
    Twierdzenie z własnego modelu, którego dowód na papierze zajmuje kilkanaście wierszy, wraz z definicjami i pełną listą założeń.
  ]
  + Dobór definicji odpowiadających interfejsom Mathlib.
  + Podział dowodu na małe lematy.
  + Wyszukanie twierdzeń i kontrola ich typów przez `#check`.
  + Formalny dowód oraz ponowna kontrola jego interpretacji.
  #note[Możliwy temat: zachowanie preferencji przez ściśle rosnącą transformację użyteczności.]
]

// Slajd 43
#slide("Liczby w innych strukturach", "Uzupełnienie techniczne")[
#lean("#check (3 : ℂ)\n#check (3 : Quaternion ℝ)\n#check (3 : Matrix (Fin 2) (Fin 2) ℝ)", size: 20pt)
  W tych strukturach 3 oznacza odpowiednio liczbę zespoloną, kwaternion i macierz skalarną.

  W standardowej strukturze macierzy kwadratowych zapis 3 oznacza $3I$, z zerami poza przekątną.
  #note[Macierz samych trójek to inny obiekt: `fun (_ _ : Fin 2) => (3 : ℝ)`. Dla kwaternionów zapis `ℍ[ℝ]` wymaga `open scoped Quaternion`. Przykłady zakładają `import Mathlib`.]
]

// Slajd 44
#slide("Zapis liczbowy i przekształcenie typu", "Uzupełnienie techniczne")[
#twocol([
    *Interpretacja zapisu 3*
    #lean("#check (3 : ℝ)", size: 20pt)
    `OfNat` określa, jaki obiekt typu ℝ oznacza ten zapis cyfr.
  ],[
    *Przekształcenie zmiennej*
    #lean("example (n : ℕ) : ℝ := n", size: 18pt)
    Lean wstawia dostępne przekształcenie z ℕ do ℝ.
  ])
  #v(14pt)
  Typy ℕ i ℝ pozostają odrębne. Biblioteka opisuje przekształcenia między nimi oraz struktury algebraiczne.
  #source("https://lean-lang.org/doc/reference/latest/Coercions/", [Lean Language Reference, Coercions])
]

// Slajd 45
#slide("Literatura: formalizacja w Lean", "Źródła")[
  #set text(size: 20pt)
  #statement("Theorem Proving in Lean 4")[
    #link("https://lean-lang.org/theorem_proving_in_lean4/Propositions-and-Proofs/")[Rozdział 3, Propositions and Proofs] \
    Zdania jako typy i konstrukcja termów dowodowych.
  ]
  #statement("Mathematics in Lean")[
    #link("https://leanprover-community.github.io/mathematics_in_lean/C02_Basics.html")[Rozdział 2, Basics] i
    #link("https://leanprover-community.github.io/mathematics_in_lean/C03_Logic.html")[rozdział 3, Logic] \
    Równości, struktury algebraiczne i logika.
  ]
  #statement("Dokumentacja Mathlib i Lean Language Reference")[
    #link("https://leanprover-community.github.io/mathlib4_docs/tactics.html")[Taktyki Mathlib] oraz
    #link("https://lean-lang.org/doc/reference/latest/Axioms/")[zależności aksjomatyczne].
  ]
  #note[Działanie kodu zależy od wersji projektu. Pełna bibliografia i odsyłacze do definicji znajdują się w przewodniku.]
]

// Slajd 46
#slide("Literatura: podstawy mikroekonomiczne", "Źródła")[
  #text(size: 23pt, weight: "bold")[Martin J. Osborne, Ariel Rubinstein]

  #emph[Models in Microeconomic Theory] \
  Expanded Second Edition, Open Book Publishers, 2023
  #v(16pt)
  #data-table(columns: (1fr, 2fr), size: 20pt,
    [*Fragment*], [*Temat w seminarium*],
    [Rozdział 1, s. 3–16], [Preferencje i reprezentacja użytecznościowa],
    [§1.4], [Porządkowy charakter użyteczności],
    [§5.1, s. 57–58], [Zbiór budżetowy i jego wypukłość])
  #v(12pt)
  #link("https://doi.org/10.11647/OBP.0362")[doi.org/10.11647/OBP.0362]
  #note[Przykłady w Lean stanowią opracowanie seminaryjne. Lemat o wypukłości ma słabsze założenia niż podręcznikowy model konsumenta.]
]
