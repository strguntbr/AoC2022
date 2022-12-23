day(22). groupData. testResult(5031).

:- use_module(lib/solve).
:- use_module(library(clpq)).

mod1(X, Y, R) :- R is mod(X-1, Y)+1.

border(X, _, down) :- size(CubeSize), 0 is mod(X, CubeSize).
border(X, _, up) :- size(CubeSize), 1 is mod(X, CubeSize).
border(_, Y, right) :- size(CubeSize), 0 is mod(Y, CubeSize).
border(_, Y, left) :- size(CubeSize), 1 is mod(Y, CubeSize).

rev(up, down). rev(down, up). rev(left, right). rev(right, left).


wrapCube(X, Y, left, left, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  member(Shift, [0,-2,2]),
  { NextX = X + Shift*Size },
  { NextY = Y + 4*Size },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).
wrapCube(X, Y, right, right, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  member(Shift, [0,-2,2]),
  { NextX = X + Shift*Size },
  { NextY = Y - 4*Size },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).
wrapCube(X, Y, up, up, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  member(Shift, [0,-2,2]),
  { NextX = X + 4*Size },
  { NextY = Y + Shift*Size },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).
wrapCube(X, Y, down, down, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  member(Shift, [0,-2,2]),
  { NextX = X - 4*Size },
  { NextY = Y + Shift*Size },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).

/*===========================*/

wrapCube(X, Y, left, up, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X - Dist + 1},
  { NextY = Y - Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).
wrapCube(X, Y, down, right, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + Size - Dist + 1 },
  { NextY = Y + Size - Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).

wrapCube(X, Y, left, down, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X + Size - Dist },
  { NextY = Y - Size + Dist - 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).
wrapCube(X, Y, up, right, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X - Size + Dist - 1 },
  { NextY = Y + Size - Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).

wrapCube(X, Y, right, up, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X - Dist + 1 },
  { NextY = Y + Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).
wrapCube(X, Y, down, left, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + Dist },
  { NextY = Y - Dist + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).

wrapCube(X, Y, right, down, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X + Size - Dist },
  { NextY = Y + Size - Dist + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).
wrapCube(X, Y, up, left, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X - Dist },
  { NextY = Y - Dist + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).

/*===========================*/

wrapCube(X, Y, left, right, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X - Size - 2*Dist + 1 },
  { NextY = Y - Size - 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).
wrapCube(X, Y, left, right, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X + 3*Size - 2*Dist + 1 },
  { NextY = Y - Size - 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).

wrapCube(X, Y, right, left, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X - Size - 2*Dist + 1 },
  { NextY = Y + Size + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).
wrapCube(X, Y, right, left, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X + 3*Size - 2*Dist + 1 },
  { NextY = Y + Size + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).

wrapCube(X, Y, up, down, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X - Size - 1 },
  { NextY = Y - Size - 2*Dist + 1},
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).
wrapCube(X, Y, up, down, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X - Size - 1 },
  { NextY = Y + 3*Size - 2*Dist + 1},
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).

wrapCube(X, Y, down, up, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + Size + 1 },
  { NextY = Y - Size - 2*Dist + 1},
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).
wrapCube(X, Y, down, up, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + Size + 1 },
  { NextY = Y + 3*Size - 2*Dist + 1},
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).

/*===========================*/

wrapCube(X, Y, left, down, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X - 3*Size - Dist },
  { NextY = Y + Size + Dist - 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).
wrapCube(X, Y, down, left, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X - 2*Size + Dist },
  { NextY = Y + 4*Size - Dist + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).

wrapCube(X, Y, left, up, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X + 4*Size - Dist + 1 },
  { NextY = Y + 2*Size - Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).
wrapCube(X, Y, up, left, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X + 2*Size - Dist },
  { NextY = Y + 4*Size - Dist + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).

wrapCube(X, Y, right, down, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X - 3*Size - Dist },
  { NextY = Y - Size - Dist + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).
wrapCube(X, Y, down, right, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X - Size - Dist },
  { NextY = Y - 3*Size - Dist + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).

wrapCube(X, Y, right, up, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X + 4*Size - Dist + 1 },
  { NextY = Y - 2*Size + Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).
wrapCube(X, Y, up, right, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + 3*Size + Dist - 1 },
  { NextY = Y - Size - Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).

wrapCube(X, Y, up, right, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + Size + Dist - 1 },
  { NextY = Y - 3*Size - Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).
wrapCube(X, Y, right, up, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + 2*Size - Dist + 1},
  { NextY = Y - 4*Size + Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).

wrapCube(X, Y, up, left, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + 2*Size - Dist },
  { NextY = Y + 4*Size - Dist + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).
wrapCube(X, Y, left, up, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + 2*Size - Dist + 1 },
  { NextY = Y + 4*Size - Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).

wrapCube(X, Y, down, right, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X - Size - Dist + 1 },
  { NextY = Y - 3*Size - Dist },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).
wrapCube(X, Y, right, down, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X - Size - Dist },
  { NextY = Y - 3*Size - Dist + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).

wrapCube(X, Y, down, left, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X - 2*Size + Dist },
  { NextY = Y + 4*Size - Dist + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).
wrapCube(X, Y, left, down, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X - Size - Dist },
  { NextY = Y + 3*Size + Dist - 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).

/*===========================*/

wrapCube(X, Y, left, right, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X - Size - 2*Dist + 1 },
  { NextY = Y + Size - 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).
wrapCube(X, Y, left, right, NextX, NextY) :-
  border(X, Y, left),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X + 3*Size - 2*Dist + 1 },
  { NextY = Y + Size - 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, right).

wrapCube(X, Y, right, left, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X - Size - 2*Dist + 1 },
  { NextY = Y - Size + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).
wrapCube(X, Y, right, left, NextX, NextY) :-
  border(X, Y, right),
  size(Size),
  mod1(X, Size, Dist),
  { NextX = X + 3*Size - 2*Dist + 1 },
  { NextY = Y - Size + 1 },
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, left).

wrapCube(X, Y, up, down, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + Size - 1 },
  { NextY = Y - Size - 2*Dist + 1},
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).
wrapCube(X, Y, up, down, NextX, NextY) :-
  border(X, Y, up),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X + Size - 1 },
  { NextY = Y + 3*Size - 2*Dist + 1},
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, down).

wrapCube(X, Y, down, up, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X - Size + 1 },
  { NextY = Y - Size - 2*Dist + 1},
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).
wrapCube(X, Y, down, up, NextX, NextY) :-
  border(X, Y, down),
  size(Size),
  mod1(Y, Size, Dist),
  { NextX = X - Size + 1 },
  { NextY = Y + 3*Size - 2*Dist + 1},
  \+ tile(NextX, NextY, _),
  border(NextX, NextY, up).

/* Just a logging in case the definitions above are not 100% correct */
wrapCube(X, Y, Dir, _, _, _) :- format("Wrapping failed at ~w,~w with direction ~w\n", [X, Y, Dir]), fail.

wrapAroundEdge(X, Y, Direction, WrappedDirection, TileX, TileY, Tile) :-
  wrapCube(X, Y, Direction, WrappedDirection, WrappedX, WrappedY),
  neighborTile(WrappedX, WrappedY, WrappedDirection, TileX, TileY),
  tile(TileX, TileY, Tile).


/* navigate map */
neighborTile(X, Y, right, X, NextY) :- NextY is Y + 1, tile(X, NextY, _), !.
neighborTile(X, Y, left, X, NextY) :- NextY is Y - 1, tile(X, NextY, _), !.
neighborTile(X, Y, up, NextX, Y) :- NextX is X - 1, tile(NextX, Y, _), !.
neighborTile(X, Y, down, NextX, Y) :- NextX is X + 1, tile(NextX, Y, _), !.

nextTile(X, Y, Direction, Direction, NextX, NextY) :-
  neighborTile(X, Y, Direction, TileX, TileY),
  tile(TileX, TileY, Tile), !,
  (
    Tile = open
    -> (NextX = TileX, NextY = TileY)
    ; (NextX = X, NextY = Y)
  ).
nextTile(X, Y, Direction, NextDirection, NextX, NextY) :-
  wrapAroundEdge(X, Y, Direction, WrappedDirection, TileX, TileY, Tile), !,
  (
    Tile = open
    -> (NextDirection = WrappedDirection, NextX = TileX, NextY = TileY)
    ; (NextDirection = Direction, NextX = X, NextY = Y)
  ).
/* Just a logging in case something goes wrong */
nextTile(X, Y, Direction, _, _, _) :- format("Fail at ~w,~w with dir ~w\n", [X,Y,Direction]), fail.

nextDir(right, 'R', down).
nextDir(down, 'R', left).
nextDir(left, 'R', up).
nextDir(up, 'R', right).
nextDir(PrevDir, 'L', NextDir) :- nextDir(NextDir, 'R', PrevDir).

move(X, Y, Dir, [], X, Y, Dir).
move(X, Y, Dir, [Turn|Path], FinalX, FinalY, FinalDir) :-
  nextDir(Dir, Turn, NextDir), !,
  move(X, Y, NextDir, Path, FinalX, FinalY, FinalDir).
move(X, Y, Dir, [0|Path], FinalX, FinalY, FinalDir) :- !,
  move(X, Y, Dir, Path, FinalX, FinalY, FinalDir).
move(X, Y, Dir, [Steps|Path], FinalX, FinalY, FinalDir) :-
  NextSteps is Steps - 1,
  nextTile(X, Y, Dir, NextDir, NextX, NextY),
  move(NextX, NextY, NextDir, [NextSteps|Path], FinalX, FinalY, FinalDir).

/* create map */
assertTile(' ', _, _).
assertTile(., X, Y) :- assert(tile(X, Y, open)).
assertTile(#, X, Y) :- assert(tile(X, Y, wall)).

assertRow([], _, _).
assertRow([FirstTile|OtherTiles], X, Y) :-
  assertTile(FirstTile, X, Y),
  NextY is Y + 1,
  assertRow(OtherTiles, X, NextY).

assertMap([], _).
assertMap([FirstRow|OtherRows], X) :-
  assertRow(FirstRow, X, 1),
  NextX is X + 1,
  assertMap(OtherRows, NextX).

assertMap(Map) :-
  retractall(tile(_, _, _)),
  retractall(size(_)),
  assertMap(Map, 1),
  aggregate_all(count, tile(_, _, _), TileCount),
  Size is floor(sqrt(TileCount / 6)),
  assert(size(Size)).

/* calculate result */
value(right, 0).
value(down, 1).
value(left, 2).
value(up, 3).

result([Map,[Path]], Result) :-
  assertMap(Map),
  aggregate_all(min(Y), tile(1, Y, open), StartY),
  move(1, StartY, right, Path, FinalX, FinalY, FinalDir),
  value(FinalDir, DirValue),
  Result is 1000 * FinalX + 4 * FinalY + DirValue.

/* required for loadData */
data_line(Path, Line) :- path_line(Path, Line), !.
data_line(MapRow, Line) :- maprow_line(MapRow, Line).

path_line([Steps], Line) :- number_string(Steps, Line), !.
path_line([Steps,Turn|NextPath], Line) :-
  re_matchsub("^(?<steps>\\d+)(?<turn>[LR])(?<rest>.*)$", Line, Match, []),
  number_string(Steps, Match.steps),
  atom_string(Turn, Match.turn),
  path_line(NextPath, Match.rest).

maprow_line(MapRow, Line) :- string_chars(Line, MapRow).