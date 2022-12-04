:- include('lib/solve.prolog'). day(4). testResult(4).

between(X, [Start, End]) :- X >= Start, X =< End.
overlap(assign{first: [Start1, _], second: Second}) :- between(Start1, Second), !.
oneCleansAll(assign{first: [_, End1], second: Second}) :- between(End1, Second), !.
oneCleansAll(assign{first: First, second: [Start2, _]}) :- between(Start2, First), !.
oneCleansAll(assign{first: First, second: [_, End2]}) :- between(End2, First), !.
reconsider(Assignments, Reconsider) :- member(Reconsider, Assignments), oneCleansAll(Reconsider).

result(Assignments, RecondiserationCount) :- bagof(R, reconsider(Assignments, R), Recondiserations), length(Recondiserations, RecondiserationCount).

/* required for loadData */
data_line(assign{first: First, second: Second}, Line) :- split_string(Line, ",", "", [T1, T2]), split_string(T1, "-", "", FirstStr), split_string(T2, "-","", SecondStr), maplist(number_string, First, FirstStr), maplist(number_string, Second, SecondStr).