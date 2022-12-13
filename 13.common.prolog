:- include('lib/solve.prolog'). day(13).

comparesignal(A, A, eq) :- !.

comparesignal(A, B, Result) :-
  number(A), number(B), !,
  (
    A < B
    -> Result = lt
    ; Result = gt
  ).

comparesignal([A1|AN], [B1|BN], Result) :- !,
  comparesignal(A1, B1, FirstResult),
  (
    FirstResult == eq
    -> comparesignal(AN, BN, Result)
    ; Result = FirstResult
  ).

comparesignal([], [_|_], lt) :- !.
comparesignal([_|_], [], gt) :- !.

comparesignal(A, B, Result) :- number(A), is_list(B), !, comparesignal([A], B, Result).
comparesignal(A, B, Result) :- number(B), is_list(A), !, comparesignal(A, [B], Result).

/* required for loadData */
data_line(ignore, "").
data_line(List, Line) :- term_string(List, Line).
