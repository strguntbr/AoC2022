:- include('lib/solve.prolog'). day(14).

assertSand(X, Y) :- \+ filled(X, Y, _), assert(filled(X, Y, sand)).

dropSand(_, X, _, Y, _, VoidY, FinalX, FinalY) :- \+ filled(X, Y, _), !, dropSand(X, Y, VoidY, FinalX, FinalY).
dropSand(X, _, _, Y, _, VoidY, FinalX, FinalY) :- \+ filled(X, Y, _), !, dropSand(X, Y, VoidY, FinalX, FinalY).
dropSand(_, _, X, Y, _, VoidY, FinalX, FinalY) :- \+ filled(X, Y, _), !, dropSand(X, Y, VoidY, FinalX, FinalY).
dropSand(_, X, _, _, Y, _, X, Y) :- assertSand(X, Y).

dropSand(X, Y, VoidY, FinalX, FinalY) :- Y < VoidY, YBelow is Y + 1, XLeft is X - 1, XRight is X + 1, dropSand(XLeft, X, XRight, YBelow, Y, VoidY, FinalX, FinalY).

fillWithSand(VoidY, SandCount) :- dropSand(500, 0, VoidY, _, _), !, fillWithSand(VoidY, NextSandCount), SandCount is NextSandCount + 1.
fillWithSand(_, 0).

/* required for loadData */
resetData :- retractall(filled(_, _, _)).

data_line(MaxY, Line) :- split_string(Line, ">", " -", Points), maplist(point_string, Rocks, Points), assertRocks(Rocks, MaxY).
point_string(Point, String) :- split_string(String, ",", "", [XStr, YStr]), maplist(number_string, Point, [XStr, YStr]).

assertRocks([[_,Y]], Y).
assertRocks([Rock1,Rock2|OtherRocks], MaxY) :- assertRocks_(Rock1, Rock2, MaxY1), assertRocks([Rock2|OtherRocks], MaxY2), MaxY is max(MaxY1, MaxY2).

assertRocks_([X,Y], [X,Y], Y) :- !, assertRock(X, Y).
assertRocks_([X1,Y1], [X1,Y2], MaxY) :- !, assertRock(X1, Y1), YN is Y1 + sign(Y2 - Y1), assertRocks_([X1, YN], [X1, Y2], _), MaxY is max(Y1, Y2).
assertRocks_([X1,Y1], [X2,Y1], Y1) :- !, assertRock(X1, Y1), XN is X1 + sign(X2 - X1), assertRocks_([XN, Y1], [X2, Y1], _).

assertRock(X, Y) :- filled(X, Y, rock), ! ; retractall(filled(X, Y, _)), assert(filled(X, Y, rock)).
