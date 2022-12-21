 day(16).

:- use_module(lib/solve).

addPressure(OldPath, Pressure, path{pressure:NewPressure, valves:OldPath.valves}) :- NewPressure is OldPath.pressure + Pressure.

findAllPaths([], "AA", TimeLeft, Paths) :- !,
  findall(P, (
    to("AA", NextValve, Distance),
    NextTimeLeft is TimeLeft - Distance, NextTimeLeft > 0,
    findAllPaths([], NextValve, NextTimeLeft, P)
  ), ListOfPaths), append(ListOfPaths, Paths).
findAllPaths(OpenValves, Valve, TimeLeft, Paths) :-
  findall(P, (
    to(Valve, NextValve, Distance), \+ member(NextValve, [Valve|OpenValves]),
    NextTimeLeft = TimeLeft - Distance - 1, NextTimeLeft > 0,
    flow(Valve, Flow), T is max(0, TimeLeft - 1), Pressure is Flow * T,
    findAllPaths([Valve|OpenValves], NextValve, NextTimeLeft, NextPaths),
    maplist([OldPath,NewPath]>>addPressure(OldPath, Pressure, NewPath), NextPaths, P)
  ), ListOfPaths), append(ListOfPaths, Paths).
findAllPaths(OpenValves, Valve, TimeLeft, [path{pressure:Pressure,valves:[Valve|OpenValves]}]) :-
  flow(Valve, Flow), T is max(0, TimeLeft - 1), Pressure is Flow * T.

distinct(Set1, Set2) :- foreach(member(X, Set1), \+ member(X, Set2)).

normalizePath(Path, path{pressure:Path.pressure, valves:SortedValves}) :- sort(Path.valves, SortedValves).
normalizePaths(Paths, NormalizedPaths) :- maplist(normalizePath, Paths, NormalizedPaths).
removeDuplicates([],[]).
removeDuplicates([Path|T], [path{pressure:MaxPressure,valves:Path.valves}|UniquePaths]) :-
  aggregate(max(P), (member(path{pressure:P,valves:Path.valves}, [Path|T])), MaxPressure),
  findall(OtherPath, (member(OtherPath, T), OtherPath.valves\==Path.valves), OtherPaths),
  removeDuplicates(OtherPaths, UniquePaths).

/* calculate transitive hull */
maybeTo(From, To, Distance) :- to(From, To, Distance) ; Distance = infinity.

addDist(infinity, _, infinity) :- !.
addDist(_, infinity, infinity) :- !.
addDist(D1, D2, Sum) :- Sum is D1+D2.

ltDist(D1, D2) :- D1 \== infinity, ( D2 == infinity ; D1 < D2 ).

updateTo(Valve1, Valve2, Valve3) :-
  K = Valve1.name, I = Valve2.name, J = Valve3.name,
  maybeTo(I, J, IJDist), maybeTo(I, K, IKDist), maybeTo(K, J, KJDist),
  addDist(IKDist, KJDist, ViaDist),
  (
    ltDist(ViaDist, IJDist)
    -> (retractall(to(I, J, _)), assertTo(I, J, ViaDist))
    ; true
  ).

hull(Valves) :-
  assertTo(X, X, 0),
  foreach(member(Valve1, Valves), (
    foreach(member(Valve2, Valves), (
      foreach(member(Valve3, Valves), updateTo(Valve1, Valve2, Valve3))
    ))
  )),
  retractall(to(X, X, _)),
  foreach(flow(Name, 0), (
    retractall(to(_, Name, _))
  )).

/* required for loadData */
resetData :- retractall(to(_, _, _)), retractall(flow(_, _)).

data_line(valve{name: Name, flow: Flow, connections: Connections}, Line) :-
  split_string(Line, " =", ";,", [_,Name,_,_,_,FlowStr,_,_,_,_|Connections]), number_string(Flow, FlowStr),
  assert(flow(Name, Flow)), assertConnections(Name, Connections).

assertConnections(_, []).
assertConnections(Name, [Connection1|OtherConnections]) :- assertTo(Name, Connection1, 1), assertConnections(Name, OtherConnections).

assertTo(From, To, Distance) :- asserta(to(From, To, Distance)).