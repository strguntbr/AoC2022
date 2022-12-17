:- include('16.common.prolog'). testResult(1707).

result(Valves, ReleasedPressure) :- hull(Valves), 
  findAllPaths([], "AA", 26, Paths),
  normalizePaths(Paths, NormalizedPaths),
  removeDuplicates(NormalizedPaths, UniquePaths),
  aggregate_all(max(Pressure), (
    select(path{pressure:MyPressure,valves:MyValves}, UniquePaths, ElephantPaths),
    member(path{pressure:ElephantPressure,valves:ElephantValves}, ElephantPaths),
    distinct(MyValves, ElephantValves), Pressure is MyPressure + ElephantPressure
  ), ReleasedPressure).
