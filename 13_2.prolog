:- include('13.common.prolog'). testResult(140).

smaller(Signals, X, Y) :-
  (nonvar(Y) ; member(Y, Signals)),
  (nonvar(X) ; member(X, Signals)),
  comparesignal(X, Y, lt).

result(Signals, C) :- 
  aggregate_all(count, smaller(Signals, _, [[2]]), C1),
  aggregate_all(count, smaller(Signals, _, [[6]]), C2),
  C is (C1+1) * (C2+2).
