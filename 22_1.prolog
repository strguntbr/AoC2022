day(22). groupData. testResult(6032).

:- use_module(lib/solve).

/* navigate map */
neighborTile(X, Y, right, X, NextY) :- NextY is Y + 1, tile(X, NextY, _), !.
neighborTile(X, _, right, X, NextY) :- aggregate_all(min(Y), tile(X, Y, _), NextY).
neighborTile(X, Y, left, X, NextY) :- NextY is Y - 1, tile(X, NextY, _), !.
neighborTile(X, _, left, X, NextY) :- aggregate_all(max(Y), tile(X, Y, _), NextY).
neighborTile(X, Y, up, NextX, Y) :- NextX is X - 1, tile(NextX, Y, _), !.
neighborTile(_, Y, up, NextX, Y) :- aggregate_all(max(X), tile(X, Y, _), NextX).
neighborTile(X, Y, down, NextX, Y) :- NextX is X + 1, tile(NextX, Y, _), !.
neighborTile(_, Y, down, NextX, Y) :- aggregate_all(min(X), tile(X, Y, _), NextX).

nextTile(X, Y, Direction, NextX, NextY) :- neighborTile(X, Y, Direction, NextX, NextY), tile(NextX, NextY, open), !.
nextTile(X, Y, _, X, Y).

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
  nextTile(X, Y, Dir, NextX, NextY),
  move(NextX, NextY, Dir, [NextSteps|Path], FinalX, FinalY, FinalDir).

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
  assertMap(Map, 1).

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