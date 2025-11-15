:- use_module(library(clpfd)).

% Vylepšená verze - ukládá i řešení (matice), ne jen součty!
% Tím eliminuje potřebu opětovného hledání při výběru

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

% Najít řešení a uložit včetně matic - S PRŮBĚŽNÝM HLÁŠENÍM
discover_sample_solutions(MaxSolutions) :-
    writeln('╔════════════════════════════════════════════════════════╗'),
    writeln('║  Objevování validních kombinací (vzorkování)           ║'),
    writeln('╚════════════════════════════════════════════════════════╝'),
    writeln(''),
    format('Hledám až ~w řešení (včetně matic)...~n', [MaxSolutions]),
    writeln('Průběh bude zobrazován každých 10 řešení.'),
    writeln(''),

    % Najít řešení s průběžným hlášením
    nb_setval(solutions_found, []),
    nb_setval(solution_count, 0),

    (   solve_matrix_unrestricted(Matrix, RowSums, ColSums),
        nb_getval(solution_count, Count),
        Count < MaxSolutions,

        % Přidat řešení do seznamu
        nb_getval(solutions_found, CurrentSolutions),
        nb_setval(solutions_found, [sol(RowSums, ColSums, Matrix)|CurrentSolutions]),

        % Aktualizovat počítadlo
        NewCount is Count + 1,
        nb_setval(solution_count, NewCount),

        % Zobrazit průběh každých 10 řešení
        (NewCount mod 10 =:= 0 ->
            % Spočítat unikátní kombinace
            nb_getval(solutions_found, AllSols),
            count_unique_combinations(AllSols, UniqueCount),
            format('\rNalezeno: ~w řešení (~w unikátních kombinací)...', [NewCount, UniqueCount]),
            flush_output
        ;
            true
        ),

        fail
    ;
        true
    ),

    % Získat finální seznam řešení
    nb_getval(solutions_found, AllSolutions),
    length(AllSolutions, FinalCount),

    writeln(''),
    writeln(''),
    writeln('═══════════════════════════════════════════════════════'),
    format('Celkem nalezeno: ~w řešení~n', [FinalCount]),
    writeln('═══════════════════════════════════════════════════════'),
    writeln(''),

    % Uložit do souboru
    open('valid_combinations.pl', write, Stream),
    write_solutions_to_file(Stream, AllSolutions),
    close(Stream),

    writeln('Řešení uložena do: valid_combinations.pl'),
    writeln(''),

    % Zobrazit přehled
    show_summary(AllSolutions).

% Spočítat počet unikátních kombinací
count_unique_combinations(Solutions, Count) :-
    findall(
        comb(R, C),
        member(sol(R, C, _), Solutions),
        AllCombs
    ),
    sort(AllCombs, UniqueCombs),
    length(UniqueCombs, Count).

% Zapsat řešení do souboru
write_solutions_to_file(Stream, Solutions) :-
    format(Stream, '% Validní kombinace s předpočítanými řešeními pro matici 2×9~n', []),
    format(Stream, '% Automaticky generováno - řešení jsou již hotová!~n~n', []),
    format(Stream, ':- module(valid_combinations, [valid_solution/3]).~n~n', []),
    format(Stream, '% valid_solution(RowSums, ColSums, Matrix)~n', []),
    format(Stream, '% RowSums = [RowSum1, RowSum2]~n', []),
    format(Stream, '% ColSums = [C1, C2, C3, C4, C5, C6, C7, C8, C9]~n', []),
    format(Stream, '% Matrix = [[R1], [R2]] - řešení~n~n', []),
    write_each_solution(Stream, Solutions).

write_each_solution(_, []).
write_each_solution(Stream, [sol(RowSums, ColSums, Matrix)|Rest]) :-
    format(Stream, 'valid_solution(~w, ~w, ~w).~n', [RowSums, ColSums, Matrix]),
    write_each_solution(Stream, Rest).

% Zobrazit shrnutí
show_summary(Solutions) :-
    % Extrahovat unikátní kombinace součtů
    findall(
        comb(R, C),
        (member(sol(R, C, _), Solutions)),
        AllCombs
    ),
    sort(AllCombs, UniqueCombs),
    length(UniqueCombs, UniqueCount),

    format('Unikátních kombinací součtů: ~w~n', [UniqueCount]),
    writeln(''),
    writeln('Validní kombinace:'),
    show_unique_combs(UniqueCombs).

show_unique_combs([]).
show_unique_combs([comb(R, C)|Rest]) :-
    format('  Řádky: ~w, Sloupce: ~w~n', [R, C]),
    show_unique_combs(Rest).

% Spuštění
:- initialization(main).

main :-
    writeln(''),
    writeln('Objevování validních kombinací (s uložením řešení)'),
    writeln(''),
    writeln('Vyberte režim:'),
    writeln('  1) Rychlý vzorek (100 řešení) - ~30 sekund'),
    writeln('  2) Střední vzorek (500 řešení) - ~2 minuty'),
    writeln('  3) Velký vzorek (2000 řešení) - ~5-10 minut'),
    writeln(''),
    write('Vaše volba [1-3]: '),
    read(Choice),
    writeln(''),
    (   Choice = 1 -> discover_sample_solutions(100)
    ;   Choice = 2 -> discover_sample_solutions(500)
    ;   Choice = 3 -> discover_sample_solutions(2000)
    ;   writeln('Neplatná volba!')
    ),
    halt.
