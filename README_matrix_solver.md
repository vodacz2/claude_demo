# Řešič matice 2×9 s omezujícími podmínkami

Prolog aplikace pro řešení constraint satisfaction problému umístění čísel 1-18 do matice 2×9.

## Požadavky

- SWI-Prolog (https://www.swi-prolog.org/)
- Knihovna CLP(FD) (součást SWI-Prolog)

## Instalace SWI-Prolog

### Linux (Debian/Ubuntu)
```bash
sudo apt-get install swi-prolog
```

### macOS
```bash
brew install swi-prolog
```

### Windows
Stáhněte installer z https://www.swi-prolog.org/download/stable

## Použití

### Spuštění interaktivního režimu

```bash
swipl -s matrix_solver.pl
```

Poté v Prolog konzoli:

```prolog
?- run.
```

Program vás vyzve k zadání:
1. Součet prvního řádku
2. Součet druhého řádku (součet obou musí být 171)
3. Seznam součtů 9 sloupců jako `[S1,S2,S3,S4,S5,S6,S7,S8,S9]`

### Příklad interaktivního použití

```prolog
?- run.
=== Řešič matice 2x9 ===
Čísla 1-18 budou umístěna do matice 2x9.
Celkový součet všech čísel je 171.

Zadejte součet prvního řádku: 85.
Zadejte součet druhého řádku: 86.
Zadejte součty 9 sloupců jako seznam [S1,S2,S3,S4,S5,S6,S7,S8,S9]:
[19,19,19,19,19,19,19,19,19].

Hledám řešení...

Nalezeno řešení:
[3,5,7,9,11,13,15,17,5]
[16,14,12,10,8,6,4,2,14]
```

### Programové použití

```prolog
% Základní řešení
?- solve_matrix(85, 86, [19,19,19,19,19,19,19,19,19], Matrix).

% Spuštění příkladu
?- example1.

% Hledání všech řešení
?- find_all_solutions(85, 86, [19,19,19,19,19,19,19,19,19]).
```

## Omezující podmínky

Program řeší následující omezení:

1. **Čísla 1-18**: Každé číslo použito právě jednou
2. **Součty řádků**: Uživatelem definované (musí dát celkem 171)
3. **Součty sloupců**: Uživatelem definované pro každý z 9 sloupců (musí dát celkem 171)
4. **Zakázané sousedy**: Čísla, která se dotýkají horizontálně, vertikálně nebo diagonálně, se nesmí lišit přesně o 1

## Struktura kódu

- `solve_matrix/4` - hlavní řešící predikát
- `validate_inputs/3` - validace vstupních součtů
- `constrain_column_sums/3` - aplikace omezení na součty sloupců
- `no_adjacent_consecutive/1` - omezení pro sousední čísla
- `run/0` - interaktivní rozhraní
- `find_all_solutions/3` - hledání všech možných řešení

## Příklady vstupů

### Rovnoměrné rozdělení
```prolog
Řádky: 85, 86
Sloupce: [19,19,19,19,19,19,19,19,19]
```

### Nerovnoměrné rozdělení
```prolog
Řádky: 90, 81
Sloupce: [20,20,20,19,19,19,18,18,18]
```

## Výstup

Program vypíše matici 2×9, kde:
- První řádek je seznam 9 čísel
- Druhý řádek je seznam 9 čísel
- Všechna omezení jsou splněna

## Časová složitost

Hledání řešení může trvat od zlomků sekundy do několika minut v závislosti na:
- Složitosti vstupních omezení
- Existenci řešení
- Výkonu počítače

## Řešení problémů

### Program nenalezne řešení
- Zkontrolujte, že součet řádků = 171
- Zkontrolujte, že součet sloupců = 171
- Některé kombinace vstupů nemají řešení kvůli omezení sousedních čísel

### Chyba syntaxe při zadávání
- Seznam sloupců musí být ve formátu: `[19,19,19,19,19,19,19,19,19].`
- Nezapomeňte tečku na konci vstupu
- Čísla oddělujte čárkami bez mezer
