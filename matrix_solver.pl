:- use_module(library(clpfd)).

% Hlavní predikát pro řešení matice 2x9
% solve_matrix(RowSum1, RowSum2, ColSums, Matrix)
% RowSum1, RowSum2 - požadované součty řádků
% ColSums - seznam 9 součtů sloupců [S1, S2, ..., S9]
% Matrix - výsledná matice [[R1C1, R1C2, ..., R1C9], [R2C1, R2C2, ..., R2C9]]
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
    % Kontrola, že součet všech čísel 1-18 je 171
    TotalSum is (1 + 18) * 18 // 2,
    RowSum1 + RowSum2 =:= TotalSum,

    % Kontrola, že součet sloupců = 171
    sum_list(ColSums, ColSumsTotal),
    ColSumsTotal =:= TotalSum,

    % Kontrola, že máme 9 součtů sloupců
    length(ColSums, 9).

% Omezení pro součty sloupců
constrain_column_sums(_, _, []).
constrain_column_sums([H1|T1], [H2|T2], [ColSum|RestColSums]) :-
    H1 + H2 #= ColSum,
    constrain_column_sums(T1, T2, RestColSums).

% Omezení: sousední čísla se nesmí lišit o 1
no_adjacent_consecutive(Matrix) :-
    Matrix = [Row1, Row2],

    % Horizontální sousedé v řádku 1
    no_consecutive_in_row(Row1),

    % Horizontální sousedé v řádku 2
    no_consecutive_in_row(Row2),

    % Vertikální a diagonální sousedé
    no_consecutive_vertical_diagonal(Row1, Row2).

% Žádné dva sousední prvky v řádku se nesmí lišit o 1
no_consecutive_in_row([]).
no_consecutive_in_row([_]).
no_consecutive_in_row([A, B|Rest]) :-
    abs(A - B) #\= 1,
    no_consecutive_in_row([B|Rest]).

% Kontrola vertikálních a diagonálních sousedů
no_consecutive_vertical_diagonal([], []).
no_consecutive_vertical_diagonal([_], [_]).
no_consecutive_vertical_diagonal([A1, A2|RestRow1], [B1, B2|RestRow2]) :-
    % Vertikální soused
    abs(A1 - B1) #\= 1,

    % Diagonální sousedé
    abs(A1 - B2) #\= 1,
    abs(A2 - B1) #\= 1,

    no_consecutive_vertical_diagonal([A2|RestRow1], [B2|RestRow2]).

% Kontrola posledního sloupce (pouze vertikální)
no_consecutive_vertical_diagonal([A], [B]) :-
    abs(A - B) #\= 1.

% Pomocný predikát pro výpis matice
print_matrix([]).
print_matrix([Row|Rest]) :-
    format('~w~n', [Row]),
    print_matrix(Rest).

% Interaktivní rozhraní
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

% Příklad použití s konkrétními hodnotami
example1 :-
    writeln('Příklad: Řádky [85, 86], všechny sloupce po 19'),
    ColSums = [19, 19, 19, 19, 19, 19, 19, 19, 19],
    solve_matrix(85, 86, ColSums, Matrix),
    print_matrix(Matrix).

% Hledání všech řešení
find_all_solutions(RowSum1, RowSum2, ColSums) :-
    writeln('Hledám všechna řešení...'),
    findall(Matrix, solve_matrix(RowSum1, RowSum2, ColSums, Matrix), Solutions),
    length(Solutions, Count),
    format('Nalezeno ~w řešení.~n', [Count]),
    print_all_solutions(Solutions, 1).

print_all_solutions([], _).
print_all_solutions([Matrix|Rest], N) :-
    format('~nŘešení #~w:~n', [N]),
    print_matrix(Matrix),
    N1 is N + 1,
    print_all_solutions(Rest, N1).
