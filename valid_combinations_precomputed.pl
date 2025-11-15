% Validní kombinace s předpočítanými řešeními pro matici 2×9
% Ručně připravená základní sada - pro více spusťte discovery tool

:- module(valid_combinations, [valid_solution/3]).

% valid_solution(RowSums, ColSums, Matrix)
% RowSums = [RowSum1, RowSum2]
% ColSums = [C1, C2, C3, C4, C5, C6, C7, C8, C9]
% Matrix = [[R1], [R2]] - kompletní řešení

% Příklad 1: Řádky [85, 86], rovnoměrné sloupce
valid_solution([85, 86], [19, 19, 19, 19, 19, 19, 19, 19, 19], [[3, 5, 7, 9, 11, 13, 15, 17, 5], [16, 14, 12, 10, 8, 6, 4, 2, 14]]).

% Poznámka: Toto je jen základní příklad.
% Pro kompletní databázi řešení spusťte:
%   swipl -s discover_valid_combinations_v2.pl
% To vygeneruje všechna řešení během ~30 sekund
