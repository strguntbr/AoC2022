:- include('9.common.prolog'). testResult(1). testResult('test1', 36).

result(Moves, TailVisits) :- result(Moves, 10, TailVisits).