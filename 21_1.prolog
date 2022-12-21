:- include('lib/solve.prolog'). day(21). testResult(152).

result(_, Result) :- monkey("root", Result).

/* required for loadData */
resetData :- retractall(monkey(_, _)).
data_line(monkey{n: Name, def: Definition}, Line) :- split_string(Line, ":", " ", [Name, Definition]), assertMonkey(Name, Definition).

assertMonkey(Name, Definition) :- number_string(Monkey, Definition), assert(monkey(Name, Monkey)).
assertMonkey(Name, Definition) :- split_string(Definition, " ", "", [Monkey1, Op, Monkey2]), assert(monkey(Name, Result) :- (monkey(Monkey1, R1), monkey(Monkey2, R2), calc(R1, Op, R2, Result))).

calc(A, "+", B, R) :- R is A+B.
calc(A, "-", B, R) :- R is A-B.
calc(A, "*", B, R) :- R is A*B.
calc(A, "/", B, R) :- R is A/B.
