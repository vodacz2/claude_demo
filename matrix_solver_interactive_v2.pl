:- use_module(library(clpfd)).

% Vylepšená interaktivní verze - NAČÍTÁ HOTOVÁ ŘEŠENÍ
% Žádné čekání na hledání - řešení jsou předpočítaná!

% Načíst validní řešení ze souboru (pokud existuje)
load_valid_solutions(Solutions) :-
    (exists_file('valid_combinations.pl') ->
        % Soubor existuje, načíst jej
        consult('valid_combinations'),
        findall(
            sol([R1, R2], Cols, Matrix),
            valid_combinations:valid_solution([R1, R2], Cols, Matrix),
            Solutions
        )
    ;
        % Soubor neexistuje, použít základní příklady
        writeln('Varování: Soubor valid_combinations.pl nenalezen.'),
        writeln('Spusťte nejdřív: swipl -s discover_valid_combinations_v2.pl'),
        writeln(''),
        Solutions = []
    ).

% Interaktivní menu s předpočítanými řešeními
run_interactive :-
    writeln(''),
    writeln('╔════════════════════════════════════════════════════════╗'),
    writeln('║  Řešič matice 2×9 - Okamžitý výběr                    ║'),
    writeln('╚════════════════════════════════════════════════════════╝'),
    writeln(''),
    writeln('Načítám předpočítaná řešení...'),
    writeln(''),

    % Načíst hotová řešení
    load_valid_solutions(Solutions),

    (Solutions = [] ->
        writeln('Žádná řešení v databázi. Spusťte discovery nástroj.'),
        halt
    ;
        true
    ),

    % Seskupit podle kombinací součtů
    group_solutions(Solutions, GroupedSolutions),
    length(GroupedSolutions, Count),

    format('Nalezeno ~w validních kombinací s ~w řešeními.~n', [Count, length(Solutions)]),
    writeln(''),
    writeln('═══════════════════════════════════════════════════════'),
    writeln('Vyberte kombinaci součtů:'),
    writeln('═══════════════════════════════════════════════════════'),
    writeln(''),

    % Zobrazit menu
    show_solutions_menu(GroupedSolutions, 1),

    writeln(''),
    write('Vaše volba (číslo): '),
    read(Choice),

    % Získat vybranou skupinu řešení
    (nth1(Choice, GroupedSolutions, group(R, C, Matrices)) ->
        writeln(''),
        writeln('Vybraná kombinace:'),
        format('  Řádky: ~w~n', [R]),
        format('  Sloupce: ~w~n', [C]),
        writeln(''),

        length(Matrices, SolCount),
        format('Pro tuto kombinaci existuje ~w řešení:~n~n', [SolCount]),

        % Zobrazit všechna řešení
        show_all_matrices(Matrices, 1)
    ;
        writeln('Neplatná volba!')
    ).

% Seskupit řešení podle kombinací součtů
group_solutions([], []).
group_solutions(Solutions, GroupedSolutions) :-
    % Získat unikátní kombinace součtů
    findall(
        comb(R, C),
        member(sol(R, C, _), Solutions),
        AllCombs
    ),
    sort(AllCombs, UniqueCombs),

    % Pro každou kombinaci shromáždit všechny matice
    findall(
        group(R, C, Matrices),
        (   member(comb(R, C), UniqueCombs),
            findall(M, member(sol(R, C, M), Solutions), Matrices)
        ),
        GroupedSolutions
    ).

% Zobrazit menu
show_solutions_menu([], _).
show_solutions_menu([group(R, C, Matrices)|Rest], N) :-
    length(Matrices, Count),
    format('  ~w) Řádky: ~w, Sloupce: ~w (~w řešení)~n', [N, R, C, Count]),
    N1 is N + 1,
    show_solutions_menu(Rest, N1).

% Zobrazit všechny matice
show_all_matrices([], _).
show_all_matrices([Matrix|Rest], N) :-
    format('Řešení #~w:~n', [N]),
    print_matrix(Matrix),
    writeln(''),
    N1 is N + 1,
    show_all_matrices(Rest, N1).

% Pomocný predikát pro výpis matice
print_matrix([]).
print_matrix([Row|Rest]) :-
    format('  ~w~n', [Row]),
    print_matrix(Rest).

% Hlavní menu
main :-
    run_interactive.
