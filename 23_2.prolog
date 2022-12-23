testResult(20).

:- include('23.common.prolog').

result(Map, RequiredRounds) :- assertMap(Map), simulate(RequiredRounds).
