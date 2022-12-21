 day(10). testResult(13140).

:- use_module(lib/solve).

process([], _, _, []).
process([noop|Instructions], Cycle, X, [Signal|OtherSignals]) :-
  NextCycle is Cycle + 1,
  process(Instructions, NextCycle, X, OtherSignals),
  Signal is Cycle * X.
process([add{v: V}|Instructions], Cycle, X, [Signal1,Signal2|OtherSignals]) :-
  NextCycle is Cycle + 2, NextX is X + V,
  process(Instructions, NextCycle, NextX, OtherSignals),
  Signal1 is Cycle * X,
  Signal2 is (Cycle + 1) * X.

signalStrength([], _, 0).
signalStrength([H|T], Cycle, Sum) :- mod(Cycle, 40) =:= 20, !, NextCycle is Cycle + 1, signalStrength(T, NextCycle, NextSum), Sum is H + NextSum.
signalStrength([_|T], Cycle, Sum) :- NextCycle is Cycle + 1, signalStrength(T, NextCycle, Sum).

result(Instructions, SignalStrength) :- process(Instructions, 1, 1, Signals), signalStrength(Signals, 1, SignalStrength).

/* required for loadData */
data_line(noop, "noop").
data_line(add{v: V}, Line) :- split_string(Line, " ", "", ["addx", Value]), number_string(V, Value).