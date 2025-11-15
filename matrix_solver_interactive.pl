:- use_module(library(clpfd)).

% Vylepšená interaktivní verze - nabízí pouze validní kombinace
% Načítá předem objevené validní kombinace z valid_combinations.pl

% Hlavní predikát pro řešení matice 2x9
solve_matrix(RowSum1, RowSum2, ColSums, Matrix) :-
    % Validace vstupů
    validate_inputs(RowSum1, RowSum2, ColSums),

    % Vytvoření matice 2x9
    Matrix = [Row1, Row2],
    length(Row1, 9),
    length(Row2, 9),

    % Sloučení všech proměnných do jednoho seznamu
    append(Row1, Row2, AllVars),

    % Doména: každá buňka obsahuje číslo 1-18
    AllVars ins 1..18,

    % Každé číslo použito právě jednou
    all_distinct(AllVars),

    % Součet prvního řádku
    sum(Row1, #=, RowSum1),

    % Součet druhého řádku
    sum(Row2, #=, RowSum2),

    % Součty sloupců
    constrain_column_sums(Row1, Row2, ColSums),

    % Sousední čísla se nesmí lišit o 1
    no_adjacent_consecutive(Matrix),

    % Hledání řešení
    label(AllVars).

% Validace vstupů
validate_inputs(RowSum1, RowSum2, ColSums) :-
    TotalSum is (1 + 18) * 18 // 2,
    RowSum1 + RowSum2 =:= TotalSum,
    sum_list(ColSums, ColSumsTotal),
    ColSumsTotal =:= TotalSum,
    length(ColSums, 9).

% Omezení pro součty sloupců
constrain_column_sums(_, _, []).
constrain_column_sums([H1|T1], [H2|T2], [ColSum|RestColSums]) :-
    H1 + H2 #= ColSum,
    constrain_column_sums(T1, T2, RestColSums).

% Omezení: sousední čísla se nesmí lišit o 1
no_adjacent_consecutive(Matrix) :-
    Matrix = [Row1, Row2],
    no_consecutive_in_row(Row1),
    no_consecutive_in_row(Row2),
    no_consecutive_vertical_diagonal(Row1, Row2).

no_consecutive_in_row([]).
no_consecutive_in_row([_]).
no_consecutive_in_row([A, B|Rest]) :-
    abs(A - B) #\= 1,
    no_consecutive_in_row([B|Rest]).

no_consecutive_vertical_diagonal([], []).
no_consecutive_vertical_diagonal([_], [_]).
no_consecutive_vertical_diagonal([A1, A2|RestRow1], [B1, B2|RestRow2]) :-
    abs(A1 - B1) #\= 1,
    abs(A1 - B2) #\= 1,
    abs(A2 - B1) #\= 1,
    no_consecutive_vertical_diagonal([A2|RestRow1], [B2|RestRow2]).

no_consecutive_vertical_diagonal([A], [B]) :-
    abs(A - B) #\= 1.

% Pomocný predikát pro výpis matice
print_matrix([]).
print_matrix([Row|Rest]) :-
    format('  ~w~n', [Row]),
    print_matrix(Rest).

% Načíst validní kombinace ze souboru (pokud existuje)
load_valid_combinations(Combinations) :-
    (exists_file('valid_combinations.pl') ->
        % Soubor existuje, načíst jej
        consult('valid_combinations'),
        findall(
            comb([R1, R2], Cols),
            valid_combinations:valid_combination([R1, R2], Cols),
            Combinations
        )
    ;
        % Soubor neexistuje, použít základní příklady
        writeln('Varování: Soubor valid_combinations.pl nenalezen.'),
        writeln('Používám základní příklady. Pro více možností spusťte:'),
        writeln('  swipl -s discover_valid_combinations.pl'),
        writeln(''),
        % Základní příklady
        Combinations = [
            comb([85, 86], [19, 19, 19, 19, 19, 19, 19, 19, 19]),
            comb([86, 85], [19, 19, 19, 19, 19, 19, 19, 19, 19]),
            comb([90, 81], [19, 19, 19, 19, 19, 19, 19, 19, 19]),
            comb([81, 90], [19, 19, 19, 19, 19, 19, 19, 19, 19])
        ]
    ).

% Interaktivní menu s validními kombinacemi
run_interactive :-
    writeln(''),
    writeln('╔════════════════════════════════════════════════════════╗'),
    writeln('║  Řešič matice 2×9 - Interaktivní režim                ║'),
    writeln('╚════════════════════════════════════════════════════════╝'),
    writeln(''),
    writeln('Načítám validní kombinace...'),
    writeln(''),

    % Načíst validní kombinace
    load_valid_combinations(Combinations),

    length(Combinations, Count),
    format('Nalezeno ~w validních kombinací součtů.~n', [Count]),
    writeln(''),
    writeln('═══════════════════════════════════════════════════════'),
    writeln('Vyberte kombinaci součtů:'),
    writeln('═══════════════════════════════════════════════════════'),
    writeln(''),

    % Zobrazit menu s kombinacemi
    show_combinations_menu(Combinations, 1),

    writeln(''),
    write('Vaše volba (číslo): '),
    read(Choice),

    % Získat vybranou kombinaci
    (nth1(Choice, Combinations, comb([R1, R2], Cols)) ->
        writeln(''),
        writeln('Vybraná kombinace:'),
        format('  Řádky: [~w, ~w]~n', [R1, R2]),
        format('  Sloupce: ~w~n', [Cols]),
        writeln(''),
        writeln('Hledám řešení...'),
        writeln(''),

        % Najít všechna řešení pro tuto kombinaci
        findall(
            Matrix,
            solve_matrix(R1, R2, Cols, Matrix),
            Solutions
        ),

        % Zobrazit výsledky
        length(Solutions, SolCount),
        (SolCount > 0 ->
            format('Nalezeno ~w řešení pro tuto kombinaci.~n~n', [SolCount]),

            % Zobrazit první řešení
            writeln('Řešení #1:'),
            nth1(1, Solutions, FirstMatrix),
            print_matrix(FirstMatrix),
            writeln(''),

            % Nabídnout zobrazení dalších řešení
            (SolCount > 1 ->
                format('Chcete vidět dalších ~w řešení? (ano/ne): ', [SolCount - 1]),
                read(ShowMore),
                (ShowMore = ano ->
                    show_remaining_solutions(Solutions, 2)
                ;
                    true
                )
            ;
                true
            )
        ;
            writeln('Žádné řešení nenalezeno (toto by se nemělo stát!).')
        )
    ;
        writeln('Neplatná volba!')
    ).

% Zobrazit menu s kombinacemi
show_combinations_menu([], _).
show_combinations_menu([comb([R1, R2], Cols)|Rest], N) :-
    format('  ~w) Řádky: [~w, ~w], Sloupce: ~w~n', [N, R1, R2, Cols]),
    N1 is N + 1,
    show_combinations_menu(Rest, N1).

% Zobrazit zbývající řešení
show_remaining_solutions([], _).
show_remaining_solutions([_], _) :- !.  % První už bylo zobrazeno
show_remaining_solutions([_|Rest], N) :-
    show_solutions_from(Rest, N).

show_solutions_from([], _).
show_solutions_from([Matrix|Rest], N) :-
    writeln(''),
    format('Řešení #~w:~n', [N]),
    print_matrix(Matrix),
    N1 is N + 1,
    show_solutions_from(Rest, N1).

% Původní jednoduché rozhraní (pro zpětnou kompatibilitu)
run :-
    writeln('=== Řešič matice 2x9 ==='),
    writeln('Čísla 1-18 budou umístěna do matice 2x9.'),
    writeln('Celkový součet všech čísel je 171.'),
    writeln(''),

    % Vstup součtů řádků
    write('Zadejte součet prvního řádku: '),
    read(RowSum1),
    write('Zadejte součet druhého řádku: '),
    read(RowSum2),

    % Kontrola součtu řádků
    (RowSum1 + RowSum2 =:= 171 ->
        true
    ;
        writeln('CHYBA: Součet řádků musí být 171!'),
        fail
    ),

    % Vstup součtů sloupců
    writeln('Zadejte součty 9 sloupců jako seznam [S1,S2,S3,S4,S5,S6,S7,S8,S9]:'),
    read(ColSums),

    % Řešení
    writeln(''),
    writeln('Hledám řešení...'),
    (solve_matrix(RowSum1, RowSum2, ColSums, Matrix) ->
        writeln(''),
        writeln('Nalezeno řešení:'),
        writeln(''),
        print_matrix(Matrix),
        writeln('')
    ;
        writeln('Řešení neexistuje pro zadané vstupy.')
    ).

% Hlavní menu
main :-
    writeln(''),
    writeln('╔════════════════════════════════════════════════════════╗'),
    writeln('║  Řešič matice 2×9 s omezujícími podmínkami            ║'),
    writeln('╚════════════════════════════════════════════════════════╝'),
    writeln(''),
    writeln('Vyberte režim:'),
    writeln('  1) Interaktivní menu (doporučeno) - vyberte z validních kombinací'),
    writeln('  2) Manuální vstup - zadejte vlastní součty'),
    writeln('  3) Objevit nové validní kombinace'),
    writeln(''),
    write('Vaše volba [1-3]: '),
    read(Choice),
    (   Choice = 1 -> run_interactive
    ;   Choice = 2 -> run
    ;   Choice = 3 ->
            writeln(''),
            writeln('Spusťte: swipl -s discover_valid_combinations.pl'),
            writeln('')
    ;   writeln('Neplatná volba!')
    ).
