 testResult(1). testResult('test1', 36).

:- include('9.common.prolog').

result(Moves, TailVisits) :- result(Moves, 10, TailVisits).