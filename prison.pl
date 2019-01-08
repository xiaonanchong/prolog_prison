%% prison

%% t 1.1
make_list(N, I, L):-
  make(N, I, 0, [], L).
make(N, _I, N, A, A).
make(N, I, C, A, L):-
  C < N, !,
  C1 is C + 1,
  make(N ,I, C1, [I | A], L).

:- use_module(library(plunit)).

:- begin_tests(make_list).
test(1):-
  make_list(2, a, [a, a]),
  make_list(1, c, [c]).
test(2, [fail]):-
  make_list(-1, _, _).
:- end_tests(make_list).

?- run_tests(make_list).
