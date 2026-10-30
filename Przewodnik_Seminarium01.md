# Lean 4 w ekonomii matematycznej: pierwsze seminarium

Materiał jest przeznaczony dla studentów i promotorów rozpoczynających formalizację matematyki w Leanie 4. Pierwsza część przedstawia zapis twierdzeń i konstrukcję dowodów. Druga stosuje te narzędzia do prostych modeli mikroekonomicznych. Wymagana jest umiejętność czytania dowodów matematycznych. Znajomość programowania funkcyjnego nie jest konieczna.

**Cele zajęć:** uczestnik potrafi odczytać stan dowodu, odróżnić definicję od założenia i twierdzenia, dobrać podstawową taktykę do postaci celu oraz wyjaśnić matematyczny sens przedstawionych formalizacji ekonomicznych.


## 1. Zawartość i uruchomienie

| Plik | Zastosowanie |
| --- | --- |
| `Wprowadzenie01.lean` | Samodzielne przykłady typów, liczb, zdań i konstrukcji `example` |
| `Seminarium01.lean` | Główny skrypt z przykładami matematycznymi, zastosowaniami ekonomicznymi i objaśnieniami dowodów |
| `Cwiczenia01.lean` | 12 zadań do samodzielnego rozwiązania |
| `Rozwiazania01.lean` | Kompletne rozwiązania zadań |
| `Przewodnik_Seminarium01.md` | Plan zajęć, objaśnienia, mapa taktyk i ścieżka dalszej nauki |
| `Prezentacja_Seminarium01.pdf` | Slajdy do prowadzenia zajęć |
| `Prezentacja_Seminarium01.typ` | Edytowalne źródło slajdów w formacie Typst |
| `lean-toolchain` | Przypięta wersja Leana |
| `lakefile.lean` | Przypięta wersja Mathlib i definicja projektu |
| `lake-manifest.json` | Dokładne wersje zależności projektu |
| `Weryfikacja.txt` | Wyniki kontroli kompilacji i zależności aksjomatycznych |

Otwórz cały folder w VS Code z oficjalnym rozszerzeniem Lean 4. W terminalu, w katalogu projektu, wykonaj:

```sh
lake exe cache get
lake env lean Seminarium01.lean
lake env lean Rozwiazania01.lean
lake env lean Cwiczenia01.lean
```

`lake exe cache get` pobiera gotowe artefakty kompilacji Mathlib. `lake env lean ...` sprawdza wskazany plik w środowisku projektu. Pierwsze uruchomienie może wymagać pobrania Leana i zależności. Deklaracja `import Mathlib` udostępnia bibliotekę w pliku źródłowym, ale jej nie instaluje.

Dołączony `lake-manifest.json` zachowaj razem z `lean-toolchain` i `lakefile.lean`. Jeżeli inicjalizujesz projekt bez manifestu, najpierw wykonaj `lake update`, a następnie zachowaj utworzony manifest. Wersja Mathlib jest przypięta do konkretnego commitu. Podczas przygotowania zajęć korzystaj z tych samych wersji, dla których sprawdzono materiały.

Prezentację skompilujesz poleceniem `typst compile Prezentacja_Seminarium01.typ`. Dokument korzysta z lokalnie dostępnych fontów i nie wymaga pakietów z Typst Universe.

Jeżeli VS Code zgłasza nieznany moduł `Mathlib`, sprawdź, czy otwarty folder zawiera `lakefile.lean`. Przy problemach z instalacją demonstrację można przeprowadzić w [edytorze internetowym Lean](https://live.lean-lang.org/). Dostępna tam wersja biblioteki może różnić się od wersji projektu.

### Wprowadzanie symboli matematycznych

W edytorze Leana wpisz sekwencję i zatwierdź spacją lub Tab:

| Symbol | Sekwencja |
| --- | --- |
| `ℝ`, `ℕ` | `\R`, `\N` |
| `ℤ`, `ℚ`, `ℂ` | `\Z`, `\Q`, `\C` |
| `≤`, `≠` | `\le`, `\ne` |
| `∀`, `∃` | `\forall`, `\exists` |
| `→`, `↔` | `\to`, `\iff` |
| `∧`, `∨`, `¬` | `\and`, `\or`, `\not` |
| `⟨`, `⟩` | `\langle`, `\rangle` |
| `←`, `·` | `\l`, `\.` |

## 2. Plan spotkania

| Czas | Temat i praca | Wynik kontrolny |
| --- | --- | --- |
| 0–35 min | Typy, symbole, `#check`, zdania i `example`; plik Wprowadzenie01.lean | Odróżniamy obiekt, zdanie i dowód; wyjaśniamy zapis `: P := by` |
| 35–55 min | Dostępne założenia, teza, `exact`, `intro`, `apply`, koniunkcja i istnienie | Przewidujemy, co pozostaje po każdym kroku; ćwiczenia 1 i 3 |
| 55–75 min | Podstawianie, upraszczanie i rachunki; części C–D skryptu | Dobieramy `rw`, `simp`, `ring` lub odpowiednią taktykę nierówności |
| 75–85 min | Przerwa | |
| 85–100 min | Użyteczność i preferencje; części E–F | Odczytujemy kierunek relacji i rolę znaku parametru |
| 100–125 min | Zbiór budżetowy; część G | Wyjaśniamy warunki dopuszczalności i dowód wypukłości |
| 125–150 min | Maksymalizacja i ćwiczenia; część H | Oddzielamy dopuszczalność od optymalności; rozwiązujemy zadania 7 i 10 |

Część I o indukcji jest dodatkiem. W wariancie 90-minutowym po podstawach wybierzcie monotoniczność użyteczności i optimum kwadratowe; wypukłość zbioru przełóżcie na drugie spotkanie.

**Praca w parze:** jedna osoba obsługuje edytor, a druga przewiduje stan dowodu po kolejnym kroku. Po około 20 minutach następuje zmiana ról. Interpretację definicji i kompletność założeń należy omawiać wspólnie. Przed zastosowaniem automatyzacji warto zapisać jednym zdaniem argument matematyczny, który uzasadnia wniosek.

## 3. Typy, zdania i pierwszy dowód

### 3.1. Teoria typów z perspektywy matematyka

Teoria typów jest formalnym językiem opisywania obiektów matematycznych i rozumowania o nich. Jej podstawowa zasada mówi, że każde poprawne wyrażenie ma typ. Typ określa, jakiego rodzaju obiekt opisujemy i jakie działania można na nim wykonywać [12].

Zapis `x : ℝ` czytamy „x jest liczbą rzeczywistą”, `f : ℝ → ℝ` oznacza funkcję rzeczywistą zmiennej rzeczywistej, a `v : ℝ × ℝ` parę liczb rzeczywistych. Początkowo można porównywać `x : ℝ` z matematycznym `x ∈ ℝ`. Jest to analogia ułatwiająca czytanie. W Lean typ i zbiór są odrębnymi pojęciami: dla typu X zapis `Set X` opisuje zbiory jego elementów, a `x ∈ A` jest zdaniem o przynależności.

Typy pomagają precyzować treść wyrażenia. Typ funkcji zawiera jej dziedzinę i przeciwdziedzinę, a typ `Matrix (Fin 2) (Fin 2) ℝ` określa macierz rzeczywistą o dwóch wierszach i dwóch kolumnach. W teorii typów zależnych typ może zależeć od parametru, np. `Matrix (Fin n) (Fin n) ℝ` zależy od wymiaru n. Szczegółów tej konstrukcji nie potrzeba do pierwszych dowodów.

### 3.2. Co robi #check i jak Lean rozumie liczby

`#check wyrażenie` odczytuje zapis, uzupełnia pominięte informacje i sprawdza jego poprawność typowania. Jeśli to się powiedzie, pokazuje wyrażenie wraz z typem. Polecenie może więc także zgłosić błąd, np. gdy brakuje odpowiedniej operacji albo typy argumentów nie pasują do siebie.

```lean
import Mathlib

#check (3 : ℕ)     -- 3 : ℕ
#check (3 : ℝ)     -- 3 : ℝ
#check (2 + 2)     -- 2 + 2 : ℕ
#eval (2 + 2)      -- 4
```

Dwukropek w `(3 : ℝ)` wskazuje oczekiwany typ całego wyrażenia. Zapis cyfr jest wieloznaczny: 3 może oznaczać liczbę naturalną, rzeczywistą lub element innej struktury wyposażonej w odpowiednią regułę interpretacji liczb. Lean korzysta w tym celu z klasy `OfNat`, np. z instancji `OfNat ℝ 3`. Instancja dostarcza element typu ℝ, który reprezentuje 3 [13].

W prostych przykładach, takich jak `#check 3` lub `#check (2 + 2)`, brak innych wskazówek powoduje domyślny wybór `Nat`. Inny typ może wynikać z dopisku `: ℝ`, typu argumentu funkcji albo pozostałych składników wyrażenia. Także znaczenie `+` zależy od wybranej struktury.

Należy odróżnić interpretację zapisu liczbowego od przekształcenia obiektu, który ma już ustalony typ:

```lean
#check (3 : ℝ)                -- interpretacja zapisu 3 w ℝ
example (n : ℕ) : ℝ := n      -- przekształcenie obiektu n z ℕ do ℝ
```

W drugim przykładzie Lean wstawia dostępne przekształcenie, zwane w dokumentacji *coercion*. Można je uwidocznić jako `(n : ℝ)` lub `↑n`, gdy typ docelowy jest znany. Typy `Nat` i `Real` nadal są odrębne. Nie działa tu relacja podtypów odpowiadająca zapisowi ℕ ⊆ ℝ, a hierarchia uniwersów `Type` nie jest hierarchią systemów liczbowych [14].

Te same mechanizmy obejmują inne struktury:

```lean
#check (3 : ℂ)
#check (3 : Quaternion ℝ)
#check (3 : Matrix (Fin 2) (Fin 2) ℝ)
```

Otrzymujemy odpowiednio 3+0i, kwaternion o części rzeczywistej 3 i zerowych częściach urojonych oraz macierz skalarną 3I. **Zapis 3 w standardowej strukturze macierzy kwadratowych oznacza macierz z trójkami na przekątnej i zerami poza nią.** Macierz samych trójek można zapisać jako `fun (_ _ : Fin 2) => (3 : ℝ)`.

Kwaterniony można też zapisać jako `ℍ[ℝ]` po włączeniu notacji poleceniem `open scoped Quaternion`. Samo wpisanie znaku ℍ nie ustanawia jego matematycznego znaczenia. Definicja i odpowiednia notacja muszą być dostępne w zaimportowanym środowisku.

Lean udostępnia ogólny mechanizm typów, klas i automatycznych przekształceń. `Nat` należy do jego podstawowej infrastruktury. Liczby rzeczywiste, zespolone, kwaterniony, macierze oraz ich struktury i twierdzenia udostępnia tutaj biblioteka Mathlib. Przypisanie obiektom struktur takich jak pierścień lub ciało określa dostępne działania i własności. Nie każdy typ interpretuje cyfry, a samo istnienie przekształcenia z ℕ nie zastępuje instancji `OfNat`.

### 3.3. Kiedy wyrażenie ma typ Prop

Należy rozróżniać trzy poziomy:

| Zapis | Znaczenie |
| --- | --- |
| `x : ℝ` | x jest obiektem matematycznym, tutaj liczbą rzeczywistą |
| `P : Prop` | P jest zdaniem |
| `h : P` | h jest dowodem tego konkretnego zdania |

`Prop` klasyfikuje **zdania**. Dowód konkretnego zdania P ma typ **P**. Stwierdzenie „dowody mają typ Prop” pomija więc istotny poziom i jest nieprecyzyjne [1, 15].

```lean
#check (2 + 2)                -- ℕ
#check (2 + 2 = 4)            -- Prop
#check ((2 : ℝ) + 2 = 4)     -- Prop
#check ((2 : ℝ) + 2 = 5)     -- Prop
```

W pierwszej równości liczby i dodawanie dotyczą ℕ, ponieważ nic nie wskazuje innego typu. W następnych równościach dopisek `: ℝ` wyznacza typ liczb. We wszystkich przypadkach operacja równości tworzy zdanie, dlatego całe wyrażenie ma typ `Prop`. W uproszczeniu jej sygnatura ma postać `Eq : α → α → Prop`: przyjmuje dwa obiekty wspólnego typu i tworzy zdanie o ich równości. Typ liczb i typ całego zdania odpowiadają więc różnym pytaniom.

Prawdziwość nie decyduje o tym, czy wyrażenie jest zdaniem. Równość 2+2=5 również jest zdaniem i ma typ `Prop`. `#check` nie dostarcza jej dowodu.

Podobnie predykat może mieć typ `ℝ → Prop`, np. `fun x : ℝ => x ≥ 0`, a funkcja liczbowa `fun x : ℝ => x + 1` ma typ `ℝ → ℝ`. O tym, czy wynik jest zdaniem, decyduje typ użytej operacji lub funkcji. Pomocniczo warto pamiętać, że `Nat : Type`, `Real : Type`, `P : Prop`, natomiast `h : P`.

Porównanie `2 == 2` jest odrębną operacją o wyniku typu `Bool`. `Bool` ma wartości `true` i `false`. Zdanie logiczne `True` ma typ `Prop`. W dowodach matematycznych zwykłą równość zapisujemy pojedynczym `=`.

### 3.4. Jak czytać example oraz : P := by

```lean
example (P : Prop) (hP : P) : P := by
  exact hP
```

Ten przykład czytamy: „Niech P będzie dowolnym zdaniem. Załóżmy, że dysponujemy dowodem P, nazwanym hP. Należy podać dowód P. Wskazujemy hP”. Zależność ma więc postać P → P. Nie udowadniamy dowolnego P bez założeń.

| Fragment | Znaczenie |
| --- | --- |
| `example` | Sprawdź anonimowy przykład; nie zachowuj wyniku pod nazwą do dalszego użycia |
| `(P : Prop)` | Parametrem jest dowolne zdanie P |
| `(hP : P)` | Kolejnym parametrem jest dowód P |
| `: P` | Wynikiem ma być dowód P |
| `:=` | Dalej podajemy ten wynik |
| `by` | Konstruujemy go za pomocą taktyk |
| `exact hP` | Wskazujemy dostępny dowód odpowiadający tezie |

Fragment `: P := by` składa się z trzech elementów składni; nie jest jednym poleceniem. Przed pierwszą taktyką Lean pokazuje:

```text
P : Prop
hP : P
⊢ P
```

Dwie pierwsze linie opisują dostępne obiekty i założenia. Po znaku `⊢` znajduje się bieżąca teza. Dokumentacja nazywa listę dostępnych obiektów i założeń *kontekstem lokalnym*. „Lokalny” oznacza, że informacje te obowiązują w tym miejscu dowodu, a nie we wszystkich plikach i twierdzeniach.

Ponieważ dowód jest już dany, ten sam przykład można zapisać bez taktyk:

```lean
example (P : Prop) (hP : P) : P := hP
```

`example` może sprawdzać także definicję zwykłego obiektu, np. `example : ℕ := 3`. W podanym przez użytkownika fragmencie oczekiwany typ jest zdaniem, więc sprawdzany obiekt jest jego dowodem. Jeśli wynik ma służyć w dalszych deklaracjach, nadajemy mu nazwę, np. `theorem identity_proof (P : Prop) (hP : P) : P := hP` [16].

### 3.5. Rola taktyk w dowodzie

Taktyki opisują kolejne kroki konstrukcji dowodu. Każdy krok powinien mieć czytelne uzasadnienie matematyczne i określać, co pozostaje do wykazania. Gotowy dowód Lean sprawdza jako wyrażenie odpowiedniego typu.

| Sytuacja | Krok | Co pozostaje |
| --- | --- | --- |
| Teza P, dostępny dowód `hP : P` | `exact hP` | Nic: wskazany dowód rozwiązuje zadanie |
| Teza P → Q | `intro hP` | Dowód Q przy dodatkowym założeniu `hP : P` |
| Teza ∀ x, P x | `intro x` | Dowód P x dla dowolnego x |
| Teza Q, twierdzenie `hPQ : P → Q` | `apply hPQ` | Dowód P |
| Teza P ∧ Q | `constructor` | Osobno dowód P i dowód Q |
| Założenie `h : P ∧ Q` | `obtain ⟨hP, hQ⟩ := h` | To samo zadanie, z dostępnymi osobno dowodami P i Q |
| Teza ∃ x, P x | `use a` | Dowód P a dla wskazanego świadka a |
| Dostępna równość x = y | `rw [h]` | Zadanie po podstawieniu zgodnie z równością; czasem dowód jest już zakończony |
| Wyrażenia wymagają uproszczenia | `simp [definicja]` | Uproszczone zadanie; czasem brak dalszych zadań |

Różnicę między `exact` i `apply` widać w przykładzie z przechodniością nierówności:

```lean
example (x y z : ℝ) (hxy : x ≤ y) (hyz : y ≤ z) : x ≤ z := by
  apply le_trans hxy
  exact hyz
```

`apply le_trans hxy` sprowadza tezę x≤z do brakującej przesłanki y≤z. `exact hyz` wskazuje dowód tej przesłanki. Alternatywny zapis `exact le_trans hxy hyz` podaje od razu cały dowód. Opisy `intro`, `exact`, `apply` i `rw` odpowiadają dokumentacji taktyk [17].

### 3.6. Składnia i nazwy deklaracji

| Konstrukcja | Rola |
| --- | --- |
| `def` | Nadaje nazwę definicji obiektu, funkcji lub predykatu |
| `theorem` | Nadaje nazwę zdaniu wraz z dowodem |
| `example` | Sprawdza przykład bez zachowywania go pod nazwą |
| `#check` | Pokazuje typ wyrażenia |
| `#print` | Pokazuje treść deklaracji |
| `#print axioms nazwa` | Pokazuje zależności aksjomatyczne wyniku |
| `sorry` | Zastępuje brakujący dowód przy użyciu `sorryAx`; oznacza nieukończoną formalizację |

Zapis `fun x => ...` tworzy funkcję przez podanie argumentu i wartości. Znak `·` rozpoczyna osobny poddowód. `(x : X)` deklaruje argument jawny, `{x : X}` argument zwykle wywnioskowywany, a `[Struktura X]` instancję odpowiedniej struktury. Zapis `_` pozostawia wyrażenie do wywnioskowania. Zapis `?_` tworzy lukę, którą w odpowiednim kontekście można rozwiązać jako osobne zadanie dowodowe [11].


## 4. Mapa taktyk według problemu

Przed wyborem narzędzia rozpoznaj główny spójnik lub strukturę celu: implikację, koniunkcję, kwantyfikator, równość albo nierówność.

| Narzędzie | Typowy problem | Co robi | Ograniczenie lub uwaga |
| --- | --- | --- | --- |
| `exact h` | Dowód tezy jest już dostępny | Dostarcza kompletny dowód bieżącego celu | Treść musi odpowiadać celowi, z uwzględnieniem równości definicyjnej |
| `intro x` / `intro h` | Cel `∀ x, ...` lub `P → Q` | Wprowadza dowolny obiekt lub zakładaną przesłankę | Nazwy są wybierane przez autora dowodu |
| `apply lemma` | Chcemy wykorzystać twierdzenie o odpowiednim wniosku | Zastępuje cel brakującymi przesłankami twierdzenia | Nie dowodzi tych przesłanek automatycznie |
| `constructor` | Cel `P ∧ Q` albo `P ↔ Q` | Tworzy dwa cele: składniki lub kierunki | Dla równoważności powstają implikacje |
| `obtain ⟨...⟩ := h` | Hipoteza jest koniunkcją lub zdaniem egzystencjalnym | Wyodrębnia dowody składników albo świadka i dowód jego własności | Korzysta ze świadka z hipotezy; nie wskazuje świadka dla celu egzystencjalnego |
| `rcases h with ...` | Analiza struktury hipotezy | Wyodrębnia składniki i może rozdzielać przypadki | W przykładach wystarcza wzorzec `⟨h1, h2⟩` |
| `use x` | Cel `∃ x, P x` | Wskazuje świadka | Pozostaje udowodnić jego własności |
| `left` / `right` | Cel `P ∨ Q` | Wybiera składnik do udowodnienia | Gdy alternatywa jest hipotezą, potrzebny jest podział na przypadki |
| `rfl` | Równość definicyjna | Zamyka cel po dozwolonej redukcji definicji i obliczeń | Nie jest ogólnym narzędziem algebry, np. przemienność z parametrami wymaga twierdzenia |
| `rw [h]` | Podstawienie według równości | Przepisuje cel; `at h1` przepisuje wskazaną hipotezę | `← h` odwraca kierunek; znaczenie ma dopasowanie wyrażenia |
| `simp [definicja, h]` | Upraszczanie wyrażeń i logiki | Stosuje reguły biblioteczne i wskazane informacje | Nie jest uniwersalnym dowodem; jawnie podawaj potrzebne hipotezy |
| `change ...` | Potrzebny jest inny zapis tej samej treści | Zastępuje cel definicyjnie równoważnym zapisem | Nie pozwala dowolnie zmieniać treści twierdzenia |
| `have h : P := ...` | Potrzebny lemat pomocniczy | Dodaje do kontekstu uprzednio uzasadniony fakt | Fakt trzeba rzeczywiście udowodnić |
| `calc` | Łańcuch równości lub nierówności | Organizuje kolejne kroki i ich uzasadnienia | Każde przejście wymaga własnego uzasadnienia |
| `ring` | Tożsamości wielomianowe | Normalizuje działania w odpowiednich strukturach algebraicznych | Nie rozwiązuje dowolnych równań i nie zastępuje podstawienia według założenia |
| `norm_num` | Konkretne rachunki i porównania liczbowe | Oblicza i uzasadnia wynik | Zmienne i struktura problemu mogą wymagać innych narzędzi |
| `linarith` | Liniowe równości i nierówności, szczególnie nad `ℚ`, `ℝ` | Wyprowadza konsekwencje przez kombinacje liniowe przesłanek | Iloczyny zmiennych i warunki ich znaków mogą wymagać odrębnego kroku |
| `nlinarith` | Wybrane nierówności wielomianowe | Poprzedza rozumowanie liniowe dodatkowymi przekształceniami nieliniowymi | Nie jest procedurą zupełną dla dowolnych nierówności wielomianowych; może wymagać przesłanki `sq_nonneg (...)` |
| `positivity` | Dodatniość, nieujemność i wybrane cele o niezerowości | Analizuje znaki składników wyrażenia | Potrzebuje odpowiednich informacji o składnikach |
| `omega` | Liniowa arytmetyka `ℕ` i `ℤ` | Uwzględnia dyskretność, obsługuje też szereg celów z dzieleniem i resztą | Nie służy do analizy nad `ℝ` ani ogólnych iloczynów zmiennych |
| `field_simp [hx]` | Równości z ułamkami | Usuwa mianowniki, korzystając z warunków takich jak `x ≠ 0` | Przy nierównościach trzeba kontrolować znak; nie stosować mechanicznie |
| `induction n with ...` | Twierdzenie o wszystkich liczbach naturalnych lub rekurencji | Tworzy bazę i krok z hipotezą indukcyjną | Nie uruchamiaj ponownie indukcji bez planu; wykorzystaj otrzymaną hipotezę |

### Zakres automatyzacji arytmetycznej

Wniosek `x ≤ 3` z `2*x + y ≤ 7` i `1 ≤ y` wynika z arytmetyki liniowej. Taktyka `linarith` konstruuje uzasadnienie na podstawie kombinacji liniowej przesłanek [6]. Natomiast przejście z `x ≤ y` do `a*x ≤ a*y` wymaga informacji o znaku `a`, a zawiera iloczyny zmiennych. W skrypcie ten krok wykonuje jawnie twierdzenie `mul_le_mul_of_nonneg_left`.

Dla `2*x*y ≤ x^2 + y^2` pomysłem jest `(x-y)^2 ≥ 0`. Polecenie `have` dodaje tę przesłankę, a `nlinarith` wykonuje pozostały rachunek. Zachowujemy w ten sposób matematyczne uzasadnienie w czytelnej postaci.

### Założenia lokalne i zależności aksjomatyczne

Taktyka jest metodą budowy dowodu; aksjomat jest przyjętym założeniem. Można zdefiniować abstrakcyjną relację R i założyć jej przechodniość, a następnie wyprowadzać konsekwencje za pomocą `intro`, `apply` i `exact`.

W części E przechodniość występuje jako lokalna hipoteza `hTrans`. W drugim przykładzie `[AddCommMonoid G]` oznacza instancję struktury przemiennego monoidu addytywnego. Udostępnia ona własności, z których korzysta twierdzenie `add_comm`. Nie konstruujemy liczb rzeczywistych ani ich działań.

Globalne `axiom nazwa : P` dodaje P bez dowodu. Założenia o preferencjach zapisuj jako parametry twierdzeń lub pola odpowiedniej struktury. Dzięki temu zależność wniosku od tych założeń pozostaje jawna. Wówczas wynik ma jasną postać: z tych założeń wynika ta teza. Sam Lean nie dowodzi niesprzeczności dowolnie dodanych aksjomatów ani trafności empirycznej modelu.

## 5. Omówienie zastosowań ekonomicznych

### 5.1. Monotoniczność użyteczności afinicznej

Rozważamy u(x) = ax + b i a ≥ 0. Dla x ≤ y mnożymy przez a, zachowując kierunek nierówności, po czym dodajemy b. Część F formalizuje dokładnie te dwa kroki.

`Monotone f` w Mathlib oznacza funkcję **niemalejącą**: x ≤ y implikuje f(x) ≤ f(y). Ścisłą rosnącość opisuje `StrictMono`. Przy a = 0 funkcja jest stała, więc z a ≥ 0 nie wynika ścisła rosnącość. Ćwiczenie 8 wymaga silniejszego założenia a > 0.

Założenie o znaku a wykorzystujemy przy mnożeniu nierówności. Dla a < 0 funkcja jest ściśle malejąca; dla a = 0 jest stała. Zatem nieujemność a jest warunkiem prawdziwości twierdzenia o niemalejącości. Definicje `Monotone` i `StrictMono` należy odczytywać z kierunkiem nierówności podanym w Mathlib [7].

### 5.2. Preferencje reprezentowane przez użyteczność

Przyjmujemy konwencję x ≽ y wtedy i tylko wtedy, gdy u(y) ≤ u(x). Funkcja u ma dowolną dziedzinę X i wartości w ℝ. Nie zakładamy wypukłości, topologii ani skończoności X.

Dowodzimy:

1. Zwrotności: x ≽ x.
2. Przechodniości: x ≽ y oraz y ≽ z implikują x ≽ z.
3. Zupełności: dla każdych x, y zachodzi x ≽ y lub y ≽ x.

Wszystkie trzy własności wynikają z własności porządku liczb rzeczywistych. W standardowej terminologii mikroekonomicznej relację zupełną i przechodnią nazywa się racjonalną relacją preferencji. Przy zupełności wymaganej także dla pary (x,x) zwrotność jest jej konsekwencją. W skrypcie pokazujemy ją osobno jako prosty przykład formalizacji [9, rozdział 1].

Relację definiujemy za pomocą danej funkcji u. Istnienie reprezentacji użytecznościowej dla niezależnie zadanej relacji preferencji wymaga osobnego twierdzenia i odpowiednich założeń. Sama zupełność i przechodniość na dowolnej dziedzinie nie gwarantują reprezentacji o wartościach rzeczywistych.

Nie dowiedliśmy też antysymetrii preferencji na X. Różne alternatywy mogą mieć tę samą użyteczność. Nie należy utożsamiać obojętności z równością alternatyw.

**Porządkowy charakter użyteczności.** Jeżeli φ : ℝ → ℝ jest ściśle rosnąca, funkcje u i φ ∘ u reprezentują tę samą relację preferencji, ponieważ u(y) ≤ u(x) wtedy i tylko wtedy, gdy φ(u(y)) ≤ φ(u(x)). Na przykład u i 3u + 7 porządkują alternatywy tak samo. Różnicom wartości użyteczności nie przypisujemy w tym modelu znaczenia intensywności preferencji. Jest to własność reprezentacji porządkowej; nie utożsamiamy jej z odrębnymi wynikami o użyteczności oczekiwanej [9, rozdział 1.4]. Ten wniosek omawia prezentacja, a jego formalny dowód pozostaje propozycją dalszej pracy.

### 5.3. Zbiór budżetowy dwóch dóbr

Koszyk to para x = (x₁, x₂). Przy zadanych cenach wydatki wynoszą p₁x₁ + p₂x₂. Definiujemy:

```text
B(p,w) = {x ∈ ℝ² : x₁ ≥ 0, x₂ ≥ 0, p₁x₁ + p₂x₂ ≤ w}.
```

Parametr w oznacza **dostępny budżet**. W uproszczonej interpretacji jednego okresu można utożsamiać go z dochodem przeznaczonym na konsumpcję. Osborne i Rubinstein opisują go jako zasoby pieniężne (*wealth*) [9, rozdział 5.1]. Określenie „dostępny budżet” zachowuje sens ograniczenia bez dodatkowych założeń o źródle środków. Identyfikator `budget_mono_income` zachowano, aby utrzymać zgodność kodu z dotychczasowymi odwołaniami.

Pierwszy wynik to B(p,w₁) ⊆ B(p,w₂), gdy w₁ ≤ w₂. `intro x hx` wybiera koszyk z pierwszego zbioru; `obtain` wyodrębnia warunki dopuszczalności; przechodniość daje nowy limit wydatków.

Drugi wynik to `Convex ℝ (budgetSet p₁ p₂ w)`, czyli wypukłość z użyciem standardowej definicji Mathlib. Nie wprowadzamy odrębnej, uproszczonej definicji wypukłości.

Dowód bierze x,y ∈ B oraz a,b ≥ 0 z a+b=1. Trzeba sprawdzić, że ax+by ma nieujemne obie składowe oraz spełnia budżet. `positivity` rozwiązuje dwa pierwsze cele. Dla wydatków zapisujemy łańcuch:

```text
spending(ax+by)
  = a*spending(x) + b*spending(y)
  ≤ a*w + b*w
  = (a+b)*w
  = w.
```

Przejście od pierwszego do drugiego wiersza opiera się na liniowości wydatków; `ring` sprawdza odpowiednią tożsamość. Nierówność wymaga nieujemności wag, a ostatni krok warunku a+b=1. Zapis `a • x` oznacza mnożenie wektora przez skalar; w składowych odpowiada zwykłemu mnożeniu liczb.

**Założenia:** formalny lemat o wypukłości zachodzi dla dowolnych p₁, p₂, w ∈ ℝ. W podręcznikowym modelu budżetowym autorzy przyjmują dodatnie ceny i dodatnie zasoby pieniężne [9, definicja 5.1]. Szerszy zakres naszego lematu wynika z jego algebraicznego dowodu. Przy parametrach spoza standardowego zakresu nie przypisujemy im automatycznie tej samej interpretacji ekonomicznej.

| Własność | Założenia wystarczające w rozważanym modelu |
| --- | --- |
| Inkluzja B(p,w₁) ⊆ B(p,w₂) | w₁ ≤ w₂, przy ustalonych cenach |
| Wypukłość B(p,w) | Dowolne rzeczywiste p₁, p₂, w |
| Niepustość B(p,w) | w ≥ 0; świadkiem jest koszyk (0,0) |
| Ograniczoność B(p,w) | p₁ > 0, p₂ > 0 i w ≥ 0 dają 0 ≤ xᵢ ≤ w/pᵢ |

Ostatnią własność podajemy jako obserwację matematyczną, bez formalnego dowodu w skrypcie. Wypukłość obejmuje również zbiór pusty. Przykładowo dla p₁ = p₂ = 1 i w = −1 zbiór jest pusty. Dla p₁ = 0, p₂ = 1 i w = 1 jest niepusty i nieograniczony w pierwszej współrzędnej. Te przykłady wyjaśniają, dlaczego wypukłość, niepustość i ograniczoność rozpatrujemy osobno.

### 5.4. Globalne optimum funkcji kwadratowej

Dla u_A(x) = Ax - x² kandydatem jest x* = A/2. Matematyczny certyfikat optymalności jest prosty:

```text
u_A(A/2) - u_A(x) = (x - A/2)² ≥ 0.
```

**Punkt maksymalizujący** to x* = A/2. **Wartość maksymalna** wynosi u_A(x*) = A²/4. Odróżniamy więc argument funkcji od wartości, którą funkcja w nim przyjmuje. Tożsamość pokazuje również jednoznaczność punktu maksymalizującego na ℝ, gdyż równość zachodzi tylko dla x = A/2. Skrypt formalizuje oszacowanie globalne oraz istnienie rozwiązania dopuszczalnego; nie zawiera osobnego twierdzenia o jednoznaczności.

W skrypcie `dsimp` rozwija definicję funkcji, `have` wprowadza dowód nieujemności kwadratu, a `nlinarith` uzasadnia pozostały rachunek. Pierwszy wynik obowiązuje na całym ℝ i nie wymaga A ≥ 0.

Drugi wynik dotyczy dziedziny x ≥ 0. Założenie A ≥ 0 pozwala sprawdzić, że kandydat A/2 jest dopuszczalny. `use` wskazuje kandydata, `constructor` oddziela dopuszczalność od optymalności, a udowodnione wcześniej oszacowanie globalne uzasadnia maksimum także na tej dziedzinie.

Dowód przez nieujemność kwadratu daje oszacowanie na całej dziedzinie. Gdy A < 0 i x ≥ 0, zachodzi Ax − x² ≤ 0, a w punkcie x = 0 funkcja przyjmuje wartość 0. Punkt maksymalizujący na półprostej ma zatem postać max{A/2, 0}. Skrypt formalizuje przypadek A ≥ 0. Przypadek A < 0 i łączny wzór są propozycją rozszerzenia.

## 6. Ćwiczenia i kryterium opanowania

W czasie seminarium wystarczą zadania 1, 3, 7 i 10. Pozostałe zadania są przeznaczone do pracy po spotkaniu. Zadania 8 i 11 są przejściem do samodzielnego używania założeń modelu.

| Zadania | Umiejętność | Jak sprawdzić zrozumienie |
| --- | --- | --- |
| 1-3 | Czytanie kontekstu i logiki | Potrafisz przewidzieć cel po zastosowaniu taktyki |
| 4-5 | Świadek i podstawienie | Wyjaśniasz, dlaczego wybrany świadek działa i gdzie wykorzystano h |
| 6-7 | Dobór automatyzacji | Wskazujesz liniową kombinację lub nieujemny kwadrat |
| 8-9 | Znaczenie założeń | Podajesz kontrprzykład po usunięciu założenia o znaku |
| 10-12 | Zastosowanie ekonomiczne | Rozdzielasz prawdziwość twierdzenia od interpretacji ekonomicznej |

Sprawdzeniem opanowania zadania jest samodzielne odtworzenie dowodu oraz wyjaśnienie roli każdego założenia.

## 7. Przygotowanie samodzielnej formalizacji

### Pierwsze cztery tygodnie: proponowana organizacja

| Okres | Główny cel | Konkretny rezultat |
| --- | --- | --- |
| Tydzień 1 | Infoview, `intro`, `exact`, `apply`, `rw`, `simp`; logika i równości | Odtworzone podstawy skryptu i rozwiązane zadania 1-7 |
| Tydzień 2 | Definicje modelu, relacje, porządki, funkcje | Własna relacja preferencji oraz 3-5 małych lematów o jej własnościach |
| Tydzień 3 | Zbiory, inkluzje, wypukłość i ograniczenia | Uogólnienie jednego wyniku budżetowego albo wariantu optimum |
| Tydzień 4 | Fragment rzeczywistego projektu | Sformalizowany mały lemat z własnego modelu wraz z jawną listą założeń |

Harmonogram ma charakter orientacyjny. Złożoność własnego wyniku zależy przede wszystkim od potrzebnych pojęć i dostępnego interfejsu bibliotecznego. Krótki dowód na papierze może wymagać wielu kroków formalnych.

**Proponowany tok pracy:**

1. Zapisz twierdzenie na papierze z dziedzinami i wszystkimi założeniami.
2. Oddziel obiekty modelu od własności: zbiór wyboru, relacja, funkcja celu, dopuszczalność.
3. Poszukaj odpowiadających im definicji Mathlib. Używaj `Monotone`, `Convex`, `Set` i innych istniejących interfejsów, gdy odpowiadają matematycznemu zamiarowi.
4. Rozpisz dowód na lematy o jednym zadaniu. Najpierw formalizuj najprostszy niebanalny lemat.
5. Używaj `#check` do sprawdzenia typów twierdzeń i narzędzi `exact?`, `apply?`, `rw?`, `simp?` do poszukiwania kroków. Odczytaj znalezione rozwiązanie przed jego przyjęciem.
6. Po zamknięciu dowodu sprawdź, czy twierdzenie ma właściwą treść: dziedziny, znaki, kierunek preferencji, brak przypadkowo sprzecznych lub nadmiernie silnych założeń.
7. Usuń wszystkie `sorry` z ukończonych wyników, przejrzyj zależności przez `#print axioms` i zapisz wersję projektu w Git.

Wyszukiwanie twierdzeń i odczytywanie ich parametrów wymaga odrębnej praktyki, także przy dobrej znajomości argumentu matematycznego. Definiując własny model, można korzystać z istniejącej konstrukcji ℝ i standardowych struktur algebraicznych Mathlib.

### Propozycje dalszych formalizacji

- Relacja obojętności indukowana przez u jest relacją równoważności.
- Ściśle rosnąca transformacja użyteczności zachowuje reprezentowaną relację preferencji.
- Uogólnienie wydatków i zbioru budżetowego do skończonej liczby dóbr, np. koszyków `Fin n → ℝ`.
- Optimum Ax-x² dla x ≥ 0 i dowolnego A, z rozbiciem na przypadki znaku A.
- Prosta własność zbioru dopuszczalnego lub relacji z własnego modelu badawczego.

Pełna równowaga ogólna wymaga większej infrastruktury: przestrzeni, ciągłości, zwartości, własności korespondencji i odpowiednich twierdzeń egzystencjalnych. Wybór małego lematu z takiego dowodu pozwala zacząć pracę badawczą wcześniej niż formalizowanie całego twierdzenia naraz.

AI może proponować kod i wyszukiwać kroki. Akceptacja przez Lean sprawdza dowód zapisanego twierdzenia, ale nie zastępuje kontroli, czy definicje i teza oddają zamierzoną treść matematyczną. Nowość naukowa także wymaga osobnej oceny literatury.

## 8. Literatura i dokumentacja

Terminologię formalizacji oparto na podręcznikach Leana i dokumentacji Mathlib. Definicje preferencji, reprezentacji użytecznościowej i zbioru budżetowego zestawiono z podręcznikiem Osborne’a i Rubinsteina. Przykłady kodu stanowią opracowanie seminaryjne. Objaśnienia oparte na literaturze nie oznaczają, że autorzy źródeł przedstawiają te same formalizacje w Leanie.

1. [*Theorem Proving in Lean 4*, „Propositions and Proofs”](https://lean-lang.org/theorem_proving_in_lean4/Propositions-and-Proofs/). Zdania jako typy, termy dowodowe i implikacja.
2. [*Mathematics in Lean*, rozdział 2, „Basics”](https://leanprover-community.github.io/mathematics_in_lean/C02_Basics.html). Równości, stosowanie twierdzeń, `rw`, `calc` i struktury algebraiczne.
3. [*Mathematics in Lean*, rozdział 3, „Logic”](https://leanprover-community.github.io/mathematics_in_lean/C03_Logic.html). Implikacje, koniunkcje, kwantyfikatory i analiza hipotez.
4. [Dokumentacja taktyk Mathlib](https://leanprover-community.github.io/mathlib4_docs/tactics.html). Zakres działania poszczególnych taktyk.
5. [*Lean Language Reference*, „Axioms”](https://lean-lang.org/doc/reference/latest/Axioms/). Aksjomaty, `sorryAx` i kontrola zależności przez `#print axioms`.
6. [Dokumentacja `linarith` i `nlinarith`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Tactic/Linarith/Frontend.html). Kombinacje liniowe przesłanek, certyfikaty i dodatkowe przekształcenia nieliniowe.
7. [Mathlib, `Order.Monotone.Defs`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Order/Monotone/Defs.html). Definicje `Monotone` i `StrictMono`.
8. [Mathlib, `Analysis.Convex.Basic`](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Convex/Basic.html). Definicja wypukłości i kombinacje wypukłe.
9. Martin J. Osborne, Ariel Rubinstein, [*Models in Microeconomic Theory*, Expanded Second Edition](https://www.openbookpublishers.com/books/10.11647/obp.0362), Open Book Publishers, 2023, DOI: [10.11647/OBP.0362](https://doi.org/10.11647/OBP.0362). Rozdział 1, „Preferences and utility”, s. 3–16, zwłaszcza §1.4; rozdział 5, „Consumer behavior”, s. 57–74, zwłaszcza §5.1 i definicja 5.1.
10. [Lean: praca z projektami](https://leanprover-community.github.io/install/project.html). Instalacja zależności i organizacja środowiska.

11. [*Lean Language Reference*, „Holes”](https://lean-lang.org/doc/reference/latest/Terms/Holes/). Zapis `_`, `?_` i nazwane luki w wyrażeniach.

12. [*Theorem Proving in Lean 4*, „Dependent Type Theory”](https://lean-lang.org/theorem_proving_in_lean4/Dependent-Type-Theory/). Typy obiektów, funkcji i parametryzowane rodziny typów.
13. [*Lean Language Reference*, „Numeric Literals”](https://lean-lang.org/doc/reference/latest/Terms/Numeric-Literals/). Interpretacja cyfr przez `OfNat`.
14. [*Lean Language Reference*, „Coercions”](https://lean-lang.org/doc/reference/latest/Coercions/). Przekształcenia między typami i odróżnienie ich od `OfNat`.
15. [*Lean Language Reference*, „Propositions”](https://lean-lang.org/doc/reference/latest/The-Type-System/Propositions/). Zdania i ich dowody.
16. [*Lean Language Reference*, „Example Declarations”](https://lean-lang.org/doc/reference/latest/Definitions/Example-Declarations/). Dokładna rola `example`.
17. [*Lean Language Reference*, „Tactic Reference”](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/). Znaczenie podstawowych taktyk.

Materiały wstępne i powyższe odsyłacze sprawdzono ponownie 30 października 2026 r. Pozostałą literaturę sprawdzono 29 października 2026 r. Ich wersje mogą różnić się od wersji projektu. Działanie przykładów sprawdzamy lokalnie na Leanie wskazanym przez `lean-toolchain` i Mathlib wskazanej przez manifest. Definicje monotoniczności i wypukłości porównano również z lokalnym kodem tej wersji Mathlib.

**Pierwsze zadanie po seminarium:** wybierz lemat z własnego modelu, którego dowód na papierze zajmuje najwyżej kilkanaście wierszy. Przygotuj jego treść, definicje obiektów, listę założeń i kontrprzykłady uzasadniające kluczowe założenia. Materiał ten będzie punktem wyjścia kolejnego spotkania.
