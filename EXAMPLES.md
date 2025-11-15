# Příklady vstupů pro řešič matice 2×9

Tento dokument obsahuje různé příklady vstupů, které můžete použít pro testování řešiče.

## Základní informace

- **Celkový součet všech čísel 1-18**: 171
- **Povinné**: Součet obou řádků = 171
- **Povinné**: Součet všech sloupců = 171
- **Omezení**: Sousední čísla (horizontálně, vertikálně, diagonálně) se nesmí lišit o 1

## Platné příklady

### Příklad 1: Rovnoměrné rozdělení
```
Součet prvního řádku: 85
Součet druhého řádku: 86
Součty sloupců: [19,19,19,19,19,19,19,19,19]
```
**Poznámka**: Nejjednodušší příklad s téměř rovnoměrným rozdělením.

---

### Příklad 2: Mírně nerovnoměrné sloupce
```
Součet prvního řádku: 85
Součet druhého řádku: 86
Součty sloupců: [20,20,19,19,19,19,19,18,18]
```
**Poznámka**: Lehce nerovnoměrné sloupce, stále relativně snadné.

---

### Příklad 3: Nerovnoměrné řádky
```
Součet prvního řádku: 90
Součet druhého řádku: 81
Součty sloupců: [19,19,19,19,19,19,19,19,19]
```
**Poznámka**: Větší rozdíl mezi řádky.

---

### Příklad 4: Extrémní rozdíl řádků
```
Součet prvního řádku: 100
Součet druhého řádku: 71
Součty sloupců: [19,19,19,19,19,19,19,19,19]
```
**Poznámka**: Velmi nerovnoměrné řádky - může být složitější najít řešení.

---

### Příklad 5: Nerovnoměrné všechno
```
Součet prvního řádku: 92
Součet druhého řádku: 79
Součty sloupců: [21,20,20,19,19,19,18,18,17]
```
**Poznámka**: Nerovnoměrné jak řádky, tak sloupce.

---

### Příklad 6: Maximální rozdíly ve sloupcích
```
Součet prvního řádku: 85
Součet druhého řádku: 86
Součty sloupců: [25,24,23,20,19,18,15,14,13]
```
**Poznámka**: Velké rozdíly mezi sloupci - komplikovanější řešení.

---

## Neplatné příklady (měly by selhat)

### Neplatný příklad 1: Špatný součet řádků
```
Součet prvního řádku: 80
Součet druhého řádku: 80
Součty sloupců: [19,19,19,19,19,19,19,19,19]
```
**Chyba**: Součet řádků = 160, ne 171 ❌

---

### Neplatný příklad 2: Špatný součet sloupců
```
Součet prvního řádku: 85
Součet druhého řádku: 86
Součty sloupců: [20,20,20,20,20,20,20,20,20]
```
**Chyba**: Součet sloupců = 180, ne 171 ❌

---

### Neplatný příklad 3: Nekonzistentní součty
```
Součet prvního řádku: 90
Součet druhého řádku: 81
Součty sloupců: [20,20,20,19,19,19,18,18,18]
```
**Chyba**: Součet sloupců = 171, ale součet řádků také = 171, takže je to OK!
**Poznámka**: Toto je vlastně platný příklad - řešitel by ho měl akceptovat.

---

## Případy, které mohou nemít řešení

I když jsou matematicky validní (součty = 171), některé kombinace **nemusí mít řešení** kvůli omezení sousedních čísel:

### Příklad těžkého vstupu
```
Součet prvního řádku: 135
Součet druhého řádku: 36
Součty sloupců: [19,19,19,19,19,19,19,19,19]
```
**Poznámka**: Extrémně nerovnoměrné řádky - omezení sousedů může zabránit nalezení řešení.

---

## Jak testovat

### V interaktivním režimu
```bash
./run_solver.sh
# Vyberte možnost 1
# Zadejte hodnoty z příkladů výše
```

### V Prolog konzoli
```bash
swipl -s matrix_solver.pl
```

```prolog
?- solve_matrix(85, 86, [19,19,19,19,19,19,19,19,19], Matrix).
?- solve_matrix(90, 81, [19,19,19,19,19,19,19,19,19], Matrix).
```

### Hledání všech řešení
```prolog
?- find_all_solutions(85, 86, [19,19,19,19,19,19,19,19,19]).
```

---

## Tipy pro experimentování

1. **Začněte jednoduše**: Zkuste Příklad 1 s rovnoměrným rozdělením
2. **Postupně zvyšujte složitost**: Přidávejte nerovnoměrnost postupně
3. **Sledujte čas řešení**: Složitější vstupy trvají déle
4. **Hledejte více řešení**: Některé vstupy mohou mít více řešení
5. **Testujte hranice**: Zkuste extrémní hodnoty a sledujte, kdy řešení přestane existovat

---

## Očekávané časy řešení

| Složitost | Čas | Příklad |
|-----------|-----|---------|
| Nízká | < 1s | Příklad 1, 2 |
| Střední | 1-10s | Příklad 3, 4 |
| Vysoká | 10s-2min | Příklad 5, 6 |
| Velmi vysoká | > 2min nebo žádné řešení | Extrémní případy |

**Poznámka**: Časy závisí na výkonu počítače a implementaci SWI-Prolog.
