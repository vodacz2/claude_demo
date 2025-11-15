:- use_module(library(clpfd)).

% Skript pro objevení všech validních kombinací součtů
% Tento skript najde všechna možná řešení matice 2x9 a extrahuje
% unikátní kombinace součtů řádků a sloupců

% Řešení matice bez předem daných součtů - jen s omezením sousedů
solve_matrix_unrestricted(Matrix, RowSums, ColSums) :-
    % Vytvoření matice 2x9
    Matrix = [Row1, Row2],
    length(Row1, 9),
    length(Row2, 9),

    % Sloučení všech proměnných
    append(Row1, Row2, AllVars),

    % Doména: každá buňka obsahuje číslo 1-18
    AllVars ins 1..18,

    % Každé číslo použito právě jednou
    all_distinct(AllVars),

    % Sousední čísla se nesmí lišit o 1
    no_adjacent_consecutive(Matrix),

    % Labeling pro hledání řešení
    label(AllVars),

    % Vypočítat součty
    sum(Row1, #=, RowSum1),
    sum(Row2, #=, RowSum2),
    RowSums = [RowSum1, RowSum2],

    % Vypočítat součty sloupců
    compute_column_sums(Row1, Row2, ColSums).

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

% Vypočítat součty sloupců
compute_column_sums([], [], []).
compute_column_sums([H1|T1], [H2|T2], [Sum|RestSums]) :-
    Sum #= H1 + H2,
    compute_column_sums(T1, T2, RestSums).

% Najít všechna řešení a extrahovat kombinace s maticemi
discover_all_combinations :-
    writeln('╔════════════════════════════════════════════════════════╗'),
    writeln('║  Objevování validních kombinací součtů pro matici 2×9  ║'),
    writeln('╚════════════════════════════════════════════════════════╝'),
    writeln(''),
    writeln('Hledám všechna možná řešení...'),
    writeln('(Toto může trvat několik minut)'),
    writeln(''),

    % Najít všechna řešení S MATICEMI
    findall(
        solution(RowSums, ColSums, Matrix),
        solve_matrix_unrestricted(Matrix, RowSums, ColSums),
        AllSolutions
    ),

    % Seskupit podle kombinací součtů (jedna kombinace může mít více řešení)
    group_solutions_by_sums(AllSolutions, GroupedSolutions),
    length(GroupedSolutions, UniqueCount),

    % Zobrazit výsledky
    length(AllSolutions, TotalCount),

    writeln(''),
    writeln('═══════════════════════════════════════════════════════'),
    format('Celkem nalezeno řešení: ~w~n', [TotalCount]),
    format('Unikátních kombinací součtů: ~w~n', [UniqueCount]),
    writeln('═══════════════════════════════════════════════════════'),
    writeln(''),

    % Uložit do souboru
    open('valid_combinations.pl', write, Stream),
    write_solutions_to_file(Stream, GroupedSolutions),
    close(Stream),

    writeln(''),
    writeln('Výsledky uloženy do: valid_combinations.pl'),
    writeln(''),

    % Zobrazit prvních 10 kombinací
    writeln('Prvních 10 validních kombinací:'),
    writeln(''),
    show_first_n_solutions(GroupedSolutions, 10).

% Zapsat kombinace do souboru
write_combinations_to_file(Stream, Combinations) :-
    format(Stream, '% Validní kombinace součtů pro matici 2×9~n', []),
    format(Stream, '% Automaticky generováno discover_valid_combinations.pl~n~n', []),
    format(Stream, ':- module(valid_combinations, [valid_combination/2]).~n~n', []),
    format(Stream, '% valid_combination(RowSums, ColSums)~n', []),
    format(Stream, '% RowSums = [RowSum1, RowSum2]~n', []),
    format(Stream, '% ColSums = [C1, C2, C3, C4, C5, C6, C7, C8, C9]~n~n', []),
    write_each_combination(Stream, Combinations, 1).

write_each_combination(_, [], _).
write_each_combination(Stream, [combination(RowSums, ColSums)|Rest], N) :-
    format(Stream, 'valid_combination(~w, ~w).~n', [RowSums, ColSums]),
    N1 is N + 1,
    write_each_combination(Stream, Rest, N1).

% Zobrazit prvních N kombinací
show_first_n_combinations(_, 0) :- !.
show_first_n_combinations([], _) :- !.
show_first_n_combinations([combination(RowSums, ColSums)|Rest], N) :-
    N > 0,
    format('  Řádky: ~w, Sloupce: ~w~n', [RowSums, ColSums]),
    N1 is N - 1,
    show_first_n_combinations(Rest, N1).

% Rychlá verze - najde jen vzorky řešení (rychlejší)
discover_sample_combinations(MaxSolutions) :-
    writeln('╔════════════════════════════════════════════════════════╗'),
    writeln('║  Objevování validních kombinací (vzorkování)           ║'),
    writeln('╚════════════════════════════════════════════════════════╝'),
    writeln(''),
    format('Hledám až ~w řešení...~n', [MaxSolutions]),
    writeln(''),

    % Najít omezený počet řešení
    State = state(0, MaxSolutions, []),
    (   solve_matrix_unrestricted(_, RowSums, ColSums),
        arg(1, State, Count),
        Count < MaxSolutions,
        arg(3, State, Acc),
        NewCount is Count + 1,
        nb_setarg(1, State, NewCount),
        nb_setarg(3, State, [combination(RowSums, ColSums)|Acc]),
        fail
    ;   true
    ),

    arg(3, State, AllCombinations),

    % Odstranit duplikáty
    sort(AllCombinations, UniqueCombinations),

    % Zobrazit výsledky
    length(AllCombinations, TotalCount),
    length(UniqueCombinations, UniqueCount),

    writeln(''),
    writeln('═══════════════════════════════════════════════════════'),
    format('Nalezeno řešení: ~w~n', [TotalCount]),
    format('Unikátních kombinací: ~w~n', [UniqueCount]),
    writeln('═══════════════════════════════════════════════════════'),
    writeln(''),

    % Zobrazit všechny kombinace
    writeln('Nalezené validní kombinace:'),
    writeln(''),
    show_first_n_combinations(UniqueCombinations, UniqueCount).

% Spuštění
:- initialization(main).

main :-
    writeln(''),
    writeln('Vyberte režim:'),
    writeln('  1) Rychlý vzorek (100 řešení) - ~30 sekund'),
    writeln('  2) Střední vzorek (500 řešení) - ~2 minuty'),
    writeln('  3) Velký vzorek (2000 řešení) - ~5-10 minut'),
    writeln('  4) Všechna řešení (varování: může trvat hodiny!)'),
    writeln(''),
    write('Vaše volba [1-4]: '),
    read(Choice),
    writeln(''),
    (   Choice = 1 -> discover_sample_combinations(100)
    ;   Choice = 2 -> discover_sample_combinations(500)
    ;   Choice = 3 -> discover_sample_combinations(2000)
    ;   Choice = 4 -> discover_all_combinations
    ;   writeln('Neplatná volba!')
    ),
    halt.
