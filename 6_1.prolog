 day(6). testResult(7). testResult('test1', 5). testResult('test2', 6). testResult('test3', 10). testResult('test4', 11).

:- use_module(lib/solve).

result([Characters], Marker) :- append(X, [A,B,C,D|_], Characters), A \== B, A \== C, A \== D, B \== C, B \== D, C \== D, length([_,_,_,_|X], Marker).

/* required for loadData */
data_line(Characters, Line) :- string_chars(Line, Characters).