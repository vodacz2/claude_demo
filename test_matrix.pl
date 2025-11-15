% Testovací příklady pro matrix_solver.pl
% Načtení: swipl -s test_matrix.pl

:- [matrix_solver].

% Test 1: Rovnoměrné rozdělení - všechny sloupce stejné
test1 :-
    writeln('=== Test 1: Rovnoměrné sloupce (všechny po 19) ==='),
    RowSum1 = 85,
    RowSum2 = 86,
    ColSums = [19, 19, 19, 19, 19, 19, 19, 19, 19],
    writeln('Vstupy:'),
    format('  Řádky: ~w, ~w~n', [RowSum1, RowSum2]),
    format('  Sloupce: ~w~n', [ColSums]),
    writeln(''),
    (solve_matrix(RowSum1, RowSum2, ColSums, Matrix) ->
        writeln('Řešení nalezeno:'),
        print_matrix(Matrix),
        writeln('✓ Test 1 úspěšný')
    ;
        writeln('✗ Test 1 selhal - řešení nenalezeno')
    ),
    writeln('').

% Test 2: Nerovnoměrné sloupce
test2 :-
    writeln('=== Test 2: Nerovnoměrné sloupce ==='),
    RowSum1 = 90,
    RowSum2 = 81,
    ColSums = [20, 20, 20, 19, 19, 19, 18, 18, 18],
    writeln('Vstupy:'),
    format('  Řádky: ~w, ~w~n', [RowSum1, RowSum2]),
    format('  Sloupce: ~w~n', [ColSums]),
    writeln(''),
    (solve_matrix(RowSum1, RowSum2, ColSums, Matrix) ->
        writeln('Řešení nalezeno:'),
        print_matrix(Matrix),
        writeln('✓ Test 2 úspěšný')
    ;
        writeln('✗ Test 2 selhal - řešení nenalezeno')
    ),
    writeln('').

% Test 3: Extrémnější rozdělení
test3 :-
    writeln('=== Test 3: Extrémní rozdělení řádků ==='),
    RowSum1 = 100,
    RowSum2 = 71,
    ColSums = [19, 19, 19, 19, 19, 19, 19, 19, 19],
    writeln('Vstupy:'),
    format('  Řádky: ~w, ~w~n', [RowSum1, RowSum2]),
    format('  Sloupce: ~w~n', [ColSums]),
    writeln(''),
    (solve_matrix(RowSum1, RowSum2, ColSums, Matrix) ->
        writeln('Řešení nalezeno:'),
        print_matrix(Matrix),
        writeln('✓ Test 3 úspěšný')
    ;
        writeln('✗ Test 3 selhal - řešení nenalezeno')
    ),
    writeln('').

% Test 4: Nevalidní vstup - špatný součet řádků
test4 :-
    writeln('=== Test 4: Nevalidní vstup (špatný součet řádků) ==='),
    RowSum1 = 80,
    RowSum2 = 80,  % Součet = 160, ne 171
    ColSums = [19, 19, 19, 19, 19, 19, 19, 19, 19],
    writeln('Vstupy:'),
    format('  Řádky: ~w, ~w (součet = ~w, mělo by být 171)~n', [RowSum1, RowSum2, 160]),
    format('  Sloupce: ~w~n', [ColSums]),
    writeln(''),
    (solve_matrix(RowSum1, RowSum2, ColSums, Matrix) ->
        writeln('✗ Test 4 selhal - měl zamítnout nevalidní vstup'),
        print_matrix(Matrix)
    ;
        writeln('✓ Test 4 úspěšný - správně zamítl nevalidní vstup')
    ),
    writeln('').

% Test 5: Nevalidní vstup - špatný součet sloupců
test5 :-
    writeln('=== Test 5: Nevalidní vstup (špatný součet sloupců) ==='),
    RowSum1 = 85,
    RowSum2 = 86,
    ColSums = [20, 20, 20, 20, 20, 20, 20, 20, 20],  % Součet = 180, ne 171
    writeln('Vstupy:'),
    format('  Řádky: ~w, ~w~n', [RowSum1, RowSum2]),
    format('  Sloupce: ~w (součet = 180, mělo by být 171)~n', [ColSums]),
    writeln(''),
    (solve_matrix(RowSum1, RowSum2, ColSums, Matrix) ->
        writeln('✗ Test 5 selhal - měl zamítnout nevalidní vstup'),
        print_matrix(Matrix)
    ;
        writeln('✓ Test 5 úspěšný - správně zamítl nevalidní vstup')
    ),
    writeln('').

% Spuštění všech testů
run_all_tests :-
    writeln(''),
    writeln('╔════════════════════════════════════════════╗'),
    writeln('║  Testování řešiče matice 2×9              ║'),
    writeln('╚════════════════════════════════════════════╝'),
    writeln(''),
    test1,
    test2,
    test3,
    test4,
    test5,
    writeln('╔════════════════════════════════════════════╗'),
    writeln('║  Testy dokončeny                           ║'),
    writeln('╚════════════════════════════════════════════╝'),
    writeln('').

% Automatické spuštění testů při načtení
:- initialization(run_all_tests).
