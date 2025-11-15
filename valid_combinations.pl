% Validní kombinace součtů pro matici 2×9
% Základní příklady - pro více kombinací spusťte discover_valid_combinations.pl

:- module(valid_combinations, [valid_combination/2]).

% valid_combination(RowSums, ColSums)
% RowSums = [RowSum1, RowSum2]
% ColSums = [C1, C2, C3, C4, C5, C6, C7, C8, C9]

% Příklady validních kombinací
valid_combination([85, 86], [19, 19, 19, 19, 19, 19, 19, 19, 19]).
valid_combination([86, 85], [19, 19, 19, 19, 19, 19, 19, 19, 19]).
valid_combination([90, 81], [19, 19, 19, 19, 19, 19, 19, 19, 19]).
valid_combination([81, 90], [19, 19, 19, 19, 19, 19, 19, 19, 19]).
valid_combination([88, 83], [19, 19, 19, 19, 19, 19, 19, 19, 19]).
valid_combination([83, 88], [19, 19, 19, 19, 19, 19, 19, 19, 19]).

% Poznámka: Toto je jen základní sada příkladů.
% Pro objevení všech validních kombinací spusťte:
%   swipl -s discover_valid_combinations.pl
