 day(12).

:- use_module(lib/solve).

heightDiff("S", Neighbor, HeightDiff) :- !, HeightDiff is Neighbor - "a".
heightDiff(Node, "E", HeightDiff) :- !, HeightDiff is "z" - Node.
heightDiff(Node, "S", HeightDiff) :- !, HeightDiff is "a" - Node.
heightDiff("E", Neighbor, HeightDiff) :- !, HeightDiff is Neighbor - "z".
heightDiff(Node, Neighbor, HeightDiff) :- HeightDiff is Neighbor - Node.

initEdge(Height1, Pos1, Height2, Pos2) :- heightDiff(Height1, Height2, HeightDiff), HeightDiff =< 1, !, assert(edge(Pos1, Pos2)).
initEdge(_, _, _, _).

initEdgeRows([Node], [Neighbor], RowNr, ColNr) :-
  NextRowNr is RowNr + 1,
  initNode(Node, [RowNr, ColNr]),
  initEdge(Node, [RowNr, ColNr], Neighbor, [NextRowNr, ColNr]),
  initEdge(Neighbor, [NextRowNr, ColNr], Node, [RowNr, ColNr]).
initEdgeRows([Node,NeighborHorizontal|OtherCols], [NeighborVertical|OtherColsNextRow], RowNr, ColNr) :- 
  NextColNr is ColNr + 1, NextRowNr is RowNr + 1,
  initNode(Node, [RowNr, ColNr]),
  initEdge(Node, [RowNr, ColNr], NeighborHorizontal, [RowNr, NextColNr]),
  initEdge(Node, [RowNr, ColNr], NeighborVertical, [NextRowNr, ColNr]),
  initEdge(NeighborHorizontal, [RowNr, NextColNr], Node, [RowNr, ColNr]),
  initEdge(NeighborVertical, [NextRowNr, ColNr], Node, [RowNr, ColNr]),
  initEdgeRows([NeighborHorizontal|OtherCols], OtherColsNextRow, RowNr, NextColNr).

initEdgeCols([Node], RowNr, ColNr) :- initNode(Node, [RowNr, ColNr]).
initEdgeCols([Node,Neighbor|OtherCols], RowNr, ColNr) :-
  NextColNr is ColNr + 1,
  initNode(Node, [RowNr, ColNr]),
  initEdge(Node, [RowNr, ColNr], Neighbor, [RowNr, NextColNr]),
  initEdge(Neighbor, [RowNr, NextColNr], Node, [RowNr, ColNr]),
  initEdgeCols([Neighbor|OtherCols], RowNr, NextColNr).

initEdges([Row], RowNr) :- initEdgeCols(Row, RowNr, 0).
initEdges([Row,NextRow|OtherRows], RowNr) :-
  initEdgeRows(Row, NextRow, RowNr, 0),
  NextRowNr is RowNr + 1,
  initEdges([NextRow|OtherRows], NextRowNr).

nodeWithDistance(Node, Distance, Height) :- node(Height, Node), distance(Node, Distance).
nextNode(Node, Height) :- aggregate_all(min(Distance, [N, H]), nodeWithDistance(N, Distance, H), min(_, [Node, Height])), retractall(node(_, Node)).

maybeDistance(Node, Distance) :- distance(Node, Distance), !. maybeDistance(_, infinite).
updateDistance(Node, infinite, Via, ViaDistance) :- !,
  retractall(distance(Node, _)), retractall(pre(Node, _)), 
  assert(distance(Node, ViaDistance)), assert(pre(Node, Via)).
updateDistance(Node, Distance, Via, ViaDistance) :- ViaDistance < Distance, !,
  retractall(distance(Node, _)), retractall(pre(Node, _)),
  assert(distance(Node, ViaDistance)), assert(pre(Node, Via)).
updateDistance(_, _, _, _).
updateDistance(Node, Neighbor) :-
  maybeDistance(Neighbor, NeighborDistance),
  distance(Node, NodeDistance), AlternativeDistance is NodeDistance + 1,
  updateDistance(Neighbor, NeighborDistance, Node, AlternativeDistance).

updateNeighbors(Node) :- foreach(edge(Node, Neighbor), updateDistance(Node, Neighbor)).

calculatePath(ShortestPath) :- nextNode(Node, Height), !,
  (
    Height =:= "E"
    -> distance(Node, ShortestPath)
    ; updateNeighbors(Node), calculatePath(ShortestPath)
  ).

result(Map, ShortestPath) :- initEdges(Map, 0), calculatePath(ShortestPath).

/* required for loadData */
data_line(Heights, Line) :- string_chars(Line, T), maplist(atom_string, T, Heights).
