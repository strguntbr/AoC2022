:- include('18.common.prolog'). testResult(58).

cube([X,Y,Z]) :- cube(X, Y, Z).
outside([MinX,MaxX], [MinY,MaxY], [MinZ, MaxZ], [X,Y,Z]) :- X =< MinX ; X >= MaxX ; Y =< MinY ; Y >= MaxY ; Z =< MinZ ; Z >= MaxZ.

filledWithSteam(_, _, _, Pos) :- cube(Pos), !, fail.
filledWithSteam(XRange, YRange, ZRange, Pos) :- outside(XRange, YRange, ZRange, Pos), !.
filledWithSteam(_, _, _, [X, Y, Z]) :- visited(X, Y, Z), !, fail.
filledWithSteam(XRange, YRange, ZRange, [X, Y, Z]) :- assert(visited(X, Y, Z)), neighbor([X,Y,Z], Neighbor), filledWithSteam(XRange, YRange, ZRange, Neighbor).

fillHoles :-
  aggregate_all(max(T), cube(T, _, _), MaxX), aggregate_all(min(T), cube(T, _, _), MinX),
  aggregate_all(max(T), cube(_, T, _), MaxY), aggregate_all(min(T), cube(_, T, _), MinY),
  aggregate_all(max(T), cube(_, _, T), MaxZ), aggregate_all(min(T), cube(_, _, T), MinZ),
  foreach(between(MinX, MaxX, X), (
    foreach(between(MinY, MaxY, Y), (
        foreach(between(MinZ, MaxZ, Z), (
          retractall(visited(_, _, _)),  
          filledWithSteam([MinX, MaxX], [MinY, MaxY], [MinZ, MaxZ], [X, Y, Z]) ; foreach(visited(Xv, Yv, Zv), (cube(Xv, Yv, Zv) ; assert(cube(Xv, Yv, Zv))))
      ))
    ))
  )).
  
result(_, ExposedSides) :- fillHoles, countExposedSides(ExposedSides).
