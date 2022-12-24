testResult(54).

:- include('24.common.prolog').

result(Map, Time) :-
  goTo([[-1,0]], Map.target, Map.height, Map.width, 0, T1),
  goTo([Map.target], [-1, 0], Map.height, Map.width, T1, T2),
  goTo([[-1,0]],  Map.target, Map.height, Map.width, T2, Time).
