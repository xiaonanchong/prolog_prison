%% prison
% May be helpful for testing

% generate_integer(+Min, +Max, -I)
%   I is an integer in the range Min <= I <= Max

generate_integer(Min,Max,Min):-
  Min =< Max.
generate_integer(Min,Max,I) :-
  Min < Max,
  NewMin is Min + 1,
  generate_integer(NewMin,Max,I).
  
  
% Uncomment this line to use the provided database for Problem 2.
% You MUST recomment or remove it from your submitted solution.
%:- include(prisonDb).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Problem 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% prison_game(+Cells, +Warders, -Escaped)
%   Escaped is a list of cell numbers for prisoners who will escape
%   once all warders have completed their runs.

prison_game(Cells, Warders, Escaped) :-
  integer(Cells), Cells > 0,
  integer(Warders), Warders > 0,
  make_list(Cells, unlocked, Initial),
  run_warders(2, Warders, Initial, Final),
  extract_indices(Final, unlocked, Escaped).

%% t 1.1
make_list(N, I, L):-
  make(N, I, 0, [], L).
make(N, _I, N, A, A).
make(N, I, C, A, L):-
  C < N, !,
  C1 is C + 1,
  make(N ,I, C1, [I | A], L).

%% t 1.2
extract_indices(L, I, R):-
  extract(L, I, 1, [], R1),
  sort(R1, R).
extract([], _, _, A, A).
extract([H|T], H, C, A, R):-
  C1 is C + 1,
  extract(T, H, C1, [C|A], R).
extract([H|T], I, C, A, R):-
  C1 is C + 1,
  extract(T, I, C1, A, R).

%% t 1.3
run_warders(N, M, Final, Final):-
  N > M, !.
run_warders(N, M, Initial, Final):-
  run(N, 1, Initial, F),
  N1 is N + 1,
  run_warders(N1, M, F, Final).

run(N, C, [], []).
run(N, C, [H|Rest], [E|T]):-
  process_one(N, C, H, E),
  C1 is C + 1,
  run(N, C1, Rest, T).

process_one(N, C, H, E):-
  C mod N =:= 0, !,
  turn_key(H, E).
process_one(N, C, H, H).  

turn_key(locked, unlocked).
turn_key(unlocked, locked).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     Problem 2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ^^^^^^^^^^^^^^^^^^^^^^^ test ^^^^^^^^^^^^^^^^^^^^^^^^^^
:- use_module(library(plunit)).

% test 1.1
:- begin_tests(make_list).
test(1):-
  make_list(2, a, [a, a]),
  make_list(1, c, [c]).
test(2, [fail]):-
  make_list(-1, _, _).
:- end_tests(make_list).
?- run_tests(make_list).

% test 1.2
:- begin_tests(extract_indices).
test(1, true(Indices == [4,9])):-
  extract_indices([p,r,i,s,o,n,e,r,s],s,Indices).
test(2, true(Indices == [])):-
  extract_indices([p,r,i,s,o,n,e,r,s],a,Indices).
:- end_tests(extract_indices).
?- run_tests(extract_indices).

% test 1.3
:- begin_tests(run_warders).
test(1, true(F = [unlocked, locked])):-
  run_warders(2,2, [unlocked, unlocked], F).
test(2, true(F = [locked, unlocked, unlocked])):-
  run_warders(2,3, [locked, locked, locked], F).
:- end_tests(run_warders).
?- run_tests(run_warders).
