day(24).

:- use_module(lib/solve).

openSpace(-1, 0, _, _, _, _) :- !.
openSpace(Height, Y, _, _, Height, Width) :- !, Y is Width - 1.
openSpace(X, Y, left, Time, _, Width) :- YP is mod(Y + Time, Width), \+ blizzard(left, X, YP).
openSpace(X, Y, right, Time, _, Width) :- YP is mod(Y - Time, Width), \+ blizzard(right, X, YP).
openSpace(X, Y, up, Time, Height, _) :- XP is mod(X + Time, Height), \+ blizzard(up, XP, Y).
openSpace(X, Y, down, Time, Height, _) :- XP is mod(X - Time, Height), \+ blizzard(down, XP, Y).

openSpace(X, Y, Time, Height, Width) :-
  openSpace(X, Y, left, Time, Height, Width),
  openSpace(X, Y, right, Time, Height, Width),
  openSpace(X, Y, up, Time, Height, Width),
  openSpace(X, Y, down, Time, Height, Width).

neighbor(X, Y, X, Y).
neighbor(X, Y, XN, Y) :- (XN is X - 1 ; XN is X + 1).
neighbor(X, Y, X, YN) :- (YN is Y - 1 ; YN is Y + 1).

validPos(-1, 0, _, _).
validPos(Height, Y, Height, Width) :- Y is Width - 1.
validPos(X, Y, Height, Width) :- X >= 0, X < Height, Y >= 0, Y < Width.

neighbors([X, Y], Neighbors) :-
  findall([XN,YN], neighbor(X, Y, XN, YN), Neighbors).

goTo(Positions, TargetPos, Height, Width, Time, FinalTime) :-
  maplist([P,N]>>neighbors(P, N), Positions, ListOfNeighbors), append(ListOfNeighbors, AllNeighbors), sort(AllNeighbors, Neighbors),
  findall([X,Y], (member([X,Y], Neighbors), validPos(X, Y, Height, Width), openSpace(X, Y, Time, Height, Width)), NewPositions),
  (
    member(TargetPos, NewPositions)
    -> FinalTime is Time
    ; (
      NextTime is Time + 1,
      goTo(NewPositions, TargetPos, Height, Width, NextTime, FinalTime)
    )
  ).

assertBlizzard(^, X, Y) :- assert(blizzard(up, X, Y)).
assertBlizzard(v, X, Y) :- assert(blizzard(down, X, Y)).
assertBlizzard(<, X, Y) :- assert(blizzard(left, X, Y)).
assertBlizzard(>, X, Y) :- assert(blizzard(right, X, Y)).
assertBlizzard(., _, _).

assertBlizzardsRow([], _, _).
assertBlizzardsRow([FirstBliizzard|OtherBlizzards], X, Y) :-
  assertBlizzard(FirstBliizzard, X, Y),
  NextY is Y + 1,
  assertBlizzardsRow(OtherBlizzards, X, NextY).

assertBlizzards([], _).
assertBlizzards([FirstRow|OtherRows], X) :-
  assertBlizzardsRow(FirstRow, X, 0),
  NextX is X + 1,
  assertBlizzards(OtherRows, NextX).

assertMap([First|Data], Height, Width) :-
  retractall(blizzard(_,_,_)),
  append(Map, [_], Data),
  length(Map, Height),
  length(First, Width),
  assertBlizzards(Map, 0).

/* required for loadData */
data_line(Blizzards, Line) :- string_chars(Line, [#|Chars]), append(Blizzards, [#], Chars).
postProcessData(Map, map{width: Width, height: Height, target: [Height,EndY]}) :-
  assertMap(Map, Height, Width),
  EndY is Width - 1.
