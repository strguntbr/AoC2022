 groupData. testResult(13).

:- include('13.common.prolog').

properSignalSum([], _, 0).
properSignalSum([[A,B]|T], I, Sum) :-
  NextI is I + 1, properSignalSum(T, NextI, NextSum),
  (
    comparesignal(A, B, lt)
    -> Sum is NextSum + I
    ; Sum is NextSum
  ).


result(Signals, ProperSignalSum) :- properSignalSum(Signals, 1, ProperSignalSum).
