# Rychlý start - Řešič matice 2×9

Funkcionální Prolog aplikace pro řešení constraint satisfaction problému.

## Rychlé spuštění (3 kroky)

### 1. Instalace SWI-Prolog

**Linux:**
```bash
sudo apt-get install swi-prolog
```

**macOS (s Homebrew):**
```bash
brew install swi-prolog
```

**macOS (bez Homebrew):**
Stáhněte DMG installer z https://www.swi-prolog.org/download/stable

**Windows:**
Stáhněte z https://www.swi-prolog.org/download/stable

---

### 2. Spuštění

**Nejjednodušší způsob (doporučeno):**
```bash
./run_solver.sh
# Vyberte možnost 1 - Interaktivní menu
```

**Nebo přímo:**
```bash
swipl -s matrix_solver_interactive.pl -g "main" -t halt
```

---

### 3. Výběr z validních kombinací

Program nabídne **pouze validní kombinace** součtů:

```
Vyberte kombinaci součtů:
═══════════════════════════════════════════════════════
  1) Řádky: [85, 86], Sloupce: [19,19,19,19,19,19,19,19,19]
  2) Řádky: [86, 85], Sloupce: [19,19,19,19,19,19,19,19,19]
  3) Řádky: [90, 81], Sloupce: [19,19,19,19,19,19,19,19,19]
  ...

Vaše volba (číslo): 1.
```

**Žádné nevalidní vstupy!** Program už ví, které kombinace mají řešení.

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

**Objevit nové validní kombinace:**
```bash
./run_solver.sh  # vyberte možnost 3
# Doporučuji: Rychlý vzorek (100 řešení) - ~30 sekund
```

**Spustit testy:**
```bash
./run_solver.sh  # vyberte možnost 4
```

**Prolog konzole:**
```bash
swipl -s matrix_solver_interactive.pl
```

```prolog
?- main.                                             % hlavní menu
?- run_interactive.                                  % interaktivní menu
?- solve_matrix(85, 86, [19,19,19,19,19,19,19,19,19], M).  % přímé volání
```

---

## ⏱️ Časová náročnost

**Interaktivní výběr**: Okamžitý (používá předem objevené kombinace)

**Objevování nových kombinací** (jednorázově):
- Rychlý vzorek (100): ~30 sekund
- Střední vzorek (500): ~2 minuty
- Velký vzorek (2000): ~10 minut
- Všechna řešení: hodiny (obvykle není potřeba)

💡 **Tip**: Začněte s rychlým vzorkem. Ten najde většinu běžných kombinací.

---

## Soubory

**Hlavní soubory:**
- `matrix_solver_interactive.pl` - interaktivní solver s menu (doporučeno)
- `matrix_solver.pl` - původní solver s manuálním vstupem
- `discover_valid_combinations.pl` - nástroj pro objevování validních kombinací
- `valid_combinations.pl` - databáze validních kombinací
- `run_solver.sh` - spouštěcí skript

**Dokumentace a testy:**
- `test_matrix.pl` - automatické testy
- `QUICKSTART.md` - tento soubor
- `README_matrix_solver.md` - detailní dokumentace
- `EXAMPLES.md` - příklady vstupů k testování

---

## Pomoc

Více informací v:
- `README_matrix_solver.md` - kompletní dokumentace
- `EXAMPLES.md` - různé příklady vstupů

---

**Vytvořeno pomocí Prolog + CLP(FD) - funkcionální constraint programming**
