# Rychlý start - Řešič matice 2×9

Funkcionální Prolog aplikace pro řešení constraint satisfaction problému.

## Rychlé spuštění (3 kroky)

### 1. Instalace SWI-Prolog

**Linux:**
```bash
sudo apt-get install swi-prolog
```

**macOS:**
```bash
brew install swi-prolog
```

**Windows:**
Stáhněte z https://www.swi-prolog.org/download/stable

---

### 2. Spuštění

**Nejjednodušší způsob:**
```bash
./run_solver.sh
```

**Nebo manuálně:**
```bash
swipl -s matrix_solver.pl -g "run" -t halt
```

---

### 3. Zadání vstupů

Program se vás zeptá na:

```
Zadejte součet prvního řádku: 85.
Zadejte součet druhého řádku: 86.
Zadejte součty 9 sloupců: [19,19,19,19,19,19,19,19,19].
```

**DŮLEŽITÉ**: Nezapomeňte tečku (`.`) na konci každého vstupu!

---

## Příklad výstupu

```
Nalezeno řešení:

[3, 5, 7, 9, 11, 13, 15, 17, 5]
[16, 14, 12, 10, 8, 6, 4, 2, 14]
```

---

## Co program dělá

✅ Umístí čísla 1-18 do matice 2×9 (každé jednou)
✅ Splní požadované součty řádků
✅ Splní požadované součty sloupců
✅ Zajistí, že sousední čísla se neliší přesně o 1

---

## Omezení

- Součet obou řádků **musí být 171** (součet čísel 1-18)
- Součet všech sloupců **musí být 171**
- Některé kombinace nemusí mít řešení

---

## Další možnosti

**Spustit testy:**
```bash
./run_solver.sh  # vyberte možnost 2
```

**Prolog konzole:**
```bash
swipl -s matrix_solver.pl
```

```prolog
?- run.                                              % interaktivní režim
?- solve_matrix(85, 86, [19,19,19,19,19,19,19,19,19], M).  % přímé volání
?- find_all_solutions(85, 86, [19,19,19,19,19,19,19,19,19]).  % všechna řešení
```

---

## Soubory

- `matrix_solver.pl` - hlavní solver s CLP(FD)
- `test_matrix.pl` - automatické testy
- `run_solver.sh` - spouštěcí skript
- `README_matrix_solver.md` - detailní dokumentace
- `EXAMPLES.md` - příklady vstupů k testování

---

## Pomoc

Více informací v:
- `README_matrix_solver.md` - kompletní dokumentace
- `EXAMPLES.md` - různé příklady vstupů

---

**Vytvořeno pomocí Prolog + CLP(FD) - funkcionální constraint programming**
