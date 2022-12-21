 testResult(1651).

:- include('16.common.prolog').

result(Valves, ReleasedPressure) :- hull(Valves), 
  findAllPaths([], "AA", 30, Paths),
  aggregate_all(max(Pressure), member(path{pressure: Pressure, valves: _}, Paths), ReleasedPressure).
 