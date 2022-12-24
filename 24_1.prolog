testResult(18).

:- include('24.common.prolog').

result(Map, Time) :- goTo([[-1,0]], Map.target, Map.height, Map.width, 0, Time).
