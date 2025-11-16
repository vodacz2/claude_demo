:- use_module(library(clpfd)).

% Load the main solver
:- ['matrix_solver_interactive.pl'].

% Test 1: Valid input (list)
test_valid_input :-
    writeln('Test 1: Valid input with square brackets'),
    ColSums = [15,16,17,18,19,20,21,22,23],
    (validate_inputs(57, 114, ColSums) ->
        writeln('✓ PASSED: Valid input accepted')
    ;
        writeln('✗ FAILED: Valid input rejected')
    ),
    nl.

% Test 2: Invalid input (tuple without brackets)
test_invalid_input :-
    writeln('Test 2: Invalid input without square brackets (tuple)'),
    % Simulate what happens when user types: 15,16,17,18,19,20,21,22,23
    % This creates a tuple, not a list
    ColSums = (15,16,17,18,19,20,21,22,23),
    (validate_inputs(57, 114, ColSums) ->
        writeln('✗ FAILED: Invalid input accepted (should have been rejected)')
    ;
        writeln('✓ PASSED: Invalid input rejected with error message')
    ),
    nl.

% Test 3: Check that is_list works correctly
test_is_list :-
    writeln('Test 3: Verify is_list predicate'),
    List = [1,2,3],
    Tuple = (1,2,3),
    format('  is_list([1,2,3]): ~w~n', [is_list(List)]),
    format('  is_list((1,2,3)): ~w~n', [\+ is_list(Tuple)]),
    (is_list(List), \+ is_list(Tuple) ->
        writeln('✓ PASSED: is_list correctly distinguishes lists from tuples')
    ;
        writeln('✗ FAILED: is_list does not work as expected')
    ),
    nl.

% Run all tests
run_tests :-
    writeln(''),
    writeln('═══════════════════════════════════════════════════════'),
    writeln('Testing Input Validation Fix'),
    writeln('═══════════════════════════════════════════════════════'),
    nl,
    test_is_list,
    test_valid_input,
    test_invalid_input,
    writeln('═══════════════════════════════════════════════════════'),
    writeln('Tests completed'),
    writeln('═══════════════════════════════════════════════════════'),
    nl.

:- initialization(run_tests, main).
