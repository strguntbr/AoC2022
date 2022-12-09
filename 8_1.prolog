:- include('lib/solve.prolog'). day(8). testResult(21).
:- include('lib/matrix.prolog').

allSmaller([], _).
allSmaller([H|T], X) :- H < X, allSmaller(T, X).

treeVisibleInLine(BeforeTrees, Tree, _) :- allSmaller(BeforeTrees, Tree), !.
treeVisibleInLine(_, Tree, AfterTrees) :- allSmaller(AfterTrees, Tree), !.
treeVisibleInLine(Trees, Pos) :-
  append(BeforeTrees, [Tree|AfterTrees], Trees), length([_|BeforeTrees], Pos),
  treeVisibleInLine(BeforeTrees, Tree, AfterTrees).

treeVisible(_, Y, Row, _) :- treeVisibleInLine(Row, Y), !.
treeVisible(X, _, _, Col) :- treeVisibleInLine(Col, X), !.
treeVisible(TreeMap, X, Y) :- nthCol1(Y, TreeMap, Col), nthRow1(X, TreeMap, Row), treeVisible(X, Y, Row, Col).

result(TreeMap, Visible) :- aggregate_all(count, treeVisible(TreeMap, _, _), Visible).

/* required for loadData */
data_line(Trees, Line) :- string_chars(Line, Chars), maplist(atom_number, Chars, Trees).