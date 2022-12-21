 day(15). testResult(56000011).

:- use_module(lib/solve).

pick2([H|T], X1, X2) :- (member(X2,T), X1 = H) ; pick2(T, X1, X2).

gapLine(sensor{pos: [X1,Y1], size: S1}, sensor{pos: [X2,Y2], size: S2}, [[XS,Y1],[XE,Y2]]) :-
  XS is X1 + S1 + 1, XE is X2 - S2 - 1,
  0 is abs(XE - XS) - abs(Y1 - Y2).
gapLine(sensor{pos: [X1,Y1], size: S1}, sensor{pos: [X2,Y2], size: S2}, [[X1,YS],[X2,YE]]) :-
  YS is Y1 + S1 + 1, YE is Y2 - S2 - 1,
  0 is abs(YE - YS) - abs(X1 - X2).

allGapLines(Sensors, Lines) :- findall(L, (pick2(Sensors,S1,S2), gapLine(S1,S2,L)), Lines).

intersect([[X1,Y1],[X2,Y2]], [[X3,Y3],[X4,Y4]], [X,Y]) :-
  Denom is (X1-X2) * (Y3-Y4) - (Y1-Y2) * (X3-X4),
  Denom \== 0,
  XT is (X1*Y2 - Y1*X2) * (X3-X4) - (X1-X2) * (X3*Y4 - Y3*X4),
  YT is (X1*Y2 - Y1*X2) * (Y3-Y4) - (Y1-Y2) * (X3*Y4 - Y3*X4),
  X is div(XT, Denom), Y is div(YT, Denom).

intersection(Lines, Intersection) :- pick2(Lines, Line1, Line2), intersect(Line1, Line2, Intersection).

result([_|Sensors], Frequency) :-
  allGapLines(Sensors, Lines),
  intersection(Lines, [X,Y]),
  \+ inrange(X, Y),
  Frequency is X * 4000000 + Y.

/* required for loadData */
data_line(RequestedLine, Line) :- string_concat("y=", LineStr, Line), !, number_string(RequestedLine, LineStr).
data_line(sensor{pos: [X,Y], size: Size}, Line) :-
  split_string(Line, ",:", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ=", Numbers),
  maplist(number_string, [X,Y,BeaconX,BeaconY], Numbers),
  Size is abs(X-BeaconX) + abs(Y-BeaconY),
  assert(inrange(PX, PY) :- (abs(PX-X) + abs(PY-Y) =< Size, !)).

