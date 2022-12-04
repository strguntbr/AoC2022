:- include('lib/solve.prolog'). day(4). testResult(2).

oneCleansAll(assign{first: [Start1, End1], second: [Start2, End2]}) :- Start1 =< Start2, End1 >= End2, !.
oneCleansAll(assign{first: [Start1, End1], second: [Start2, End2]}) :- Start2 =< Start1, End2 >= End1.
reconsider(Assignments, Reconsider) :- member(Reconsider, Assignments), oneCleansAll(Reconsider).

result(Assignments, RecondiserationCount) :- bagof(R, reconsider(Assignments, R), Recondiserations), length(Recondiserations, RecondiserationCount).

/* required for loadData */
data_line(assign{first: First, second: Second}, Line) :- split_string(Line, ",", "", [T1, T2]), split_string(T1, "-", "", FirstStr), split_string(T2, "-","", SecondStr), maplist(number_string, First, FirstStr), maplist(number_string, Second, SecondStr).