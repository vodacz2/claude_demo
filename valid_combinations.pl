% Validní kombinace s předpočítanými řešeními pro matici 2×9
% Základní sada pro okamžité použití

:- module(valid_combinations, [valid_solution/3]).

% valid_solution(RowSums, ColSums, Matrix)
% RowSums = [RowSum1, RowSum2]
% ColSums = [C1, C2, C3, C4, C5, C6, C7, C8, C9]
% Matrix = [[R1], [R2]] - kompletní řešení

% Řešení jsou PŘEDPOČÍTANÁ - žádné čekání!

valid_solution([85, 86], [19, 19, 19, 19, 19, 19, 19, 19, 19], [[3, 5, 7, 9, 11, 13, 15, 17, 5], [16, 14, 12, 10, 8, 6, 4, 2, 14]]).
valid_solution([86, 85], [19, 19, 19, 19, 19, 19, 19, 19, 19], [[16, 14, 12, 10, 8, 6, 4, 2, 14], [3, 5, 7, 9, 11, 13, 15, 17, 5]]).
valid_solution([90, 81], [19, 19, 19, 19, 19, 19, 19, 19, 19], [[3, 5, 7, 9, 11, 13, 15, 18, 9], [16, 14, 12, 10, 8, 6, 4, 1, 10]]).
valid_solution([81, 90], [19, 19, 19, 19, 19, 19, 19, 19, 19], [[16, 14, 12, 10, 8, 6, 4, 1, 10], [3, 5, 7, 9, 11, 13, 15, 18, 9]]).
valid_solution([88, 83], [19, 19, 19, 19, 19, 19, 19, 19, 19], [[3, 5, 7, 9, 11, 13, 16, 18, 6], [16, 14, 12, 10, 8, 6, 3, 1, 13]]).
valid_solution([83, 88], [19, 19, 19, 19, 19, 19, 19, 19, 19], [[16, 14, 12, 10, 8, 6, 3, 1, 13], [3, 5, 7, 9, 11, 13, 16, 18, 6]]).

% Pro více kombinací spusťte discovery tool:
%   swipl -s discover_valid_combinations_v2.pl
