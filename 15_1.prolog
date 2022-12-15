:- include('lib/solve.prolog'). day(15). testResult(26).

merge([S1,E1], [S2,E2], [S1,E1]) :- S1 =< S2, E1 >= E2, !.
merge([S1,E1], [S2,E2], [S2,E2]) :- S2 =< S1, E2 >= E1, !.
merge([S1,E1], [S2,E2], [S1,E2]) :- S1 =< S2, E1 >= S2 - 1, !.
merge([S1,E1], [S2,E2], [S2,E1]) :- S2 =< S1, E2 >= S1 - 1, !.

mergeone(Ranges, [MergedRange|OtherRanges]) :-
  once((
    select(Range1, Ranges, T), select(Range2, T, OtherRanges),
    merge(Range1, Range2, MergedRange)
  )).

mergeall(Ranges, MergedRanges) :- mergeone(Ranges, NextRanges) -> mergeall(NextRanges, MergedRanges) ; MergedRanges = Ranges.

range(sensor{pos: [X,Y], size: Size}, Line, [StartX,EndX]) :-
  abs(Line - Y) =< Size, !,
  StartX is X - Size + abs(Line - Y),
  EndX is X + Size - abs(Line - Y).

range_size([S,E], Size) :- Size is E-S.

line_range(Sensors, Line, Merged) :-
  convlist([Sensor,Range]>>(range(Sensor, Line, Range)), Sensors, Ranges), mergeall(Ranges, Merged).

result([RequestedLine|Sensors], Count) :-
  line_range(Sensors, RequestedLine, Merged),
  maplist(range_size, Merged, Sizes), sumlist(Sizes, Count).

/* required for loadData */
data_line(RequestedLine, Line) :- string_concat("y=", T, Line), !, number_string(RequestedLine, T).
data_line(sensor{pos: [X,Y], size: Size}, Line) :-
  split_string(Line, ",:", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ=", Numbers),
  maplist(number_string, [X,Y,BeaconX,BeaconY], Numbers),
  Size is abs(X-BeaconX) + abs(Y-BeaconY).
