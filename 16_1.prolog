:- include('16.common.prolog'). testResult(1651).

result(Valves, ReleasedPressure) :- hull(Valves), 
  findAllPaths([], "AA", 30, Paths),
  aggregate_all(max(Pressure), member(path{pressure: Pressure, valves: _}, Paths), ReleasedPressure).
 