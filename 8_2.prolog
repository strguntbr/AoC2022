 day(8). testResult(8).

:- use_module(lib/solve).
:- use_module(lib/matrix).

allSmaller([], _).
allSmaller([H|T], X) :- H < X, allSmaller(T, X).

viewingDistanceBefore(_, _, 1, Score, Score) :- !.
viewingDistanceBefore([H|T], Tree, Pos, _, Score) :- H >= Tree, !, NextPos is Pos - 1, viewingDistanceBefore(T, Tree, NextPos, 1, Score).
viewingDistanceBefore([_|T], Tree, Pos, ScoreIn, Score) :- NextPos is Pos - 1, NextScoreIn is ScoreIn + 1, viewingDistanceBefore(T, Tree, NextPos, NextScoreIn, Score).
viewingDistanceBefore(Trees, Tree, Pos, Score) :- viewingDistanceBefore(Trees, Tree, Pos, 0, Score).
viewingDistanceAfter(Trees, Tree, Pos, Score) :-
  reverse(Trees, ReverseTrees), length(Trees, L), ReversePos is L - Pos + 1,
  viewingDistanceBefore(ReverseTrees, Tree, ReversePos, 0, Score).

viewingScore(TreeMap, X, Y, Score) :-
  nthCol1(Y, TreeMap, Col), nth1(X, Col, Tree), viewingDistanceBefore(Col, Tree, X, ScoreUp), viewingDistanceAfter(Col, Tree, X, ScoreDown),
  nthRow1(X, TreeMap, Row), nth1(Y, Row, Tree), viewingDistanceBefore(Row, Tree, Y, ScoreLeft), viewingDistanceAfter(Row, Tree, Y, ScoreRight),
  Score is ScoreUp * ScoreDown * ScoreLeft * ScoreRight.

result(TreeMap, MaxScore) :- aggregate_all(max(Score), viewingScore(TreeMap, _, _, Score), MaxScore).

/* required for loadData */
data_line(Trees, Line) :- string_chars(Line, Chars), maplist(atom_number, Chars, Trees).