 testResult(19). testResult('test1', 23). testResult('test2', 23). testResult('test3', 29). testResult('test4', 26).

:- use_module(lib/solve). day(6).

distinct([]).
distinct([H|T]) :- \+ member(H, T), distinct(T).

result([Characters], MarkerPos) :-
    length(Marker, 14),
    append(_, Marker, PreMessage),
    append(PreMessage, _, Characters),
    distinct(Marker),
    length(PreMessage, MarkerPos).

/* required for loadData */
data_line(Characters, Line) :- string_chars(Line, Characters).