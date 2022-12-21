 day(9).

:- use_module(lib/solve).

visit(X, Y) :- retractall(visited(X, Y)), assert(visited(X, Y)).
init(Knots, Rope) :- retractall(visited(_, _)), visit(0, 0), length(Rope, Knots), maplist(=([0,0]), Rope).

/* adjacent(+Knot1, ?Knot2) where */
/*   Knot1 is the X and Y position (a list of 2 numbers) of this knot */
/*   Knot2 is the X and Y position of this knot such that X and Y positons of this knot do not differ by more than 1 from Knot1 */
/*adjacent([HX, HY], [TX, TY]) :- abs(HX - TX) =< 1, abs(HY - TY) =< 1.*/
adjacent([X1, Y1], [X2, Y2]) :- between(-1, 1, XD), between(-1, 1, YD), X2 is X1 + XD, Y2 is Y1 + YD.

/* moveTail(+OldTail, +Head, -NewTail) where */
/*   OldTail is the X and Y position of the tail knot */
/*   Head is the X and Y position of the old head knot */
/*   NewTail is the X and Y positions to which the tail knots moves following the head knot */
moveTail(Head, Tail, Tail) :- adjacent(Tail, Head), !.
moveTail([HX, HY], [TX, TY], [TXn, TYn]) :- TXn is TX + sign(HX - TX), TYn is TY + sign(HY - TY).

/* moveTails(+Head, +OldTails, -NewTails) where */
/*   Head is the X and Y position of the old head knot */
/*   OldTails is a list of X and Y positions of each tail knots */
/*   NewTail is a list of X and Y positions to which each tail knot moves following the head knot */
moveTails([X, Y], [], []) :- visit(X, Y).
moveTails(Head, [FirstTail|OtherTails], [NextFirstTail|NextOtherTails]) :- moveTail(Head, FirstTail, NextFirstTail), moveTails(NextFirstTail, OtherTails, NextOtherTails).

/* step(+OldKnot, ?Direction, ?NewKnot) where */
/*   OldKnot is the X and Y position of a knot before the step */
/*   Direction is the direction into which this know moves (either up, down, left or right) */
/*   NewKnot is the X and Y position of the knot before the step */
step([X, Y], up, [Xn, Y]) :- Xn is X - 1.
step([X, Y], down, [Xn, Y]) :- Xn is X + 1.
step([X, Y], left, [X, Yn]) :- Yn is Y - 1.
step([X, Y], right, [X, Yn]) :- Yn is Y + 1.

/* move(OldKnots, Moves, NewKnots) where */
/*   OldKnots is a list of knots before moving */
/*   Moves is a list of move directions in which the head knot is moved */
/*   NewKnots is a list of the knots after moving the head knot */
move(Knots, [], Knots).
move([Head|Tails], [FirstMove|OtherMoves], FinalRope) :-
  step(Head, FirstMove, NextHead), 
  moveTails(NextHead, Tails, NextTails),
  move([NextHead|NextTails], OtherMoves, FinalRope).

result(Data, Length, TailVisits) :- append(Data, Moves), init(Length, Rope), move(Rope, Moves, _), aggregate_all(count, visited(_, _), TailVisits).

/* required for loadData */
data_line(Moves, Line) :-
  split_string(Line, " ", "", [DirStr, Width]), 
  dir_string(Direction, DirStr), number_string(Repeat, Width),
  length(Moves, Repeat), maplist(=(Direction), Moves).
dir_string(up, "U"). dir_string(down, "D"). dir_string(left, "L"). dir_string(right, "R").
