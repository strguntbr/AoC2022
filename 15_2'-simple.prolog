 day(15). testResult(56000011).

:- use_module(lib/solve).

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

end([_,E], E).

beacon_pos(Line, Ranges, Max, Poses) :-
  mergeall([[0,Max]|Ranges], Merged), Ranges \== Merged,
  convlist([R, [Row,Line]]>>(end(R, E), Row is E+1, Row =< Max, Row >= 0), Ranges, Poses).

line_range(Sensors, Line, Merged) :-
  convlist([Sensor,Range]>>(range(Sensor, Line, Range)), Sensors, Ranges), mergeall(Ranges, Merged).

line_beaconpos(Sensors, Line, Max, Pos) :-
  line_range(Sensors, Line, Ranges),
  beacon_pos(Line, Ranges, Max, Pos).

result([Size|Sensors], Frequency) :-
  Max is Size * 2, numlist(0, Max, Lines),
  convlist([L,P]>>(line_beaconpos(Sensors, L, Max, P)), Lines, [[[X,Y]]]),
  Frequency is X * 4000000 + Y.

/* required for loadData */
data_line(Size, Line) :- string_concat("y=", T, Line), !, number_string(Size, T).
data_line(sensor{pos: [X,Y], size: Size}, Line) :-
  split_string(Line, ",:", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ=", Numbers),
  maplist(number_string, [X,Y,BeaconX,BeaconY], Numbers),
  Size is abs(X-BeaconX) + abs(Y-BeaconY).
