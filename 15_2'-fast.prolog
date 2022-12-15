:- include('lib/solve.prolog'). day(15). testResult(56000011).

merge([S1,E1], [S2,E2], [S1,E1]) :- S1 =< S2, E1 >= E2, !.
merge([S1,E1], [S2,E2], [S2,E2]) :- S2 =< S1, E2 >= E1, !.
merge([S1,E1], [S2,E2], [S1,E2]) :- S1 =< S2, E1 >= S2 - 1, !.
merge([S1,E1], [S2,E2], [S2,E1]) :- S2 =< S1, E2 >= S1 - 1, !.

mergeone(Ranges, [MergedRange|OtherRanges]) :-
  once((
    select(Range1, Ranges, T), select(Range2, T, OtherRanges),
    merge(Range1, Range2, MergedRange)
  )).

mergeall(Ranges, MergedRanges) :- mergeone(Ranges, NextRanges), !, mergeall(NextRanges, MergedRanges).
mergeall(Ranges, Ranges).

sensor_range(sensor{pos: [X,Y], size: Size}, Line, Scale, [StartX,EndX]) :-
  ScaledSize is Size - Scale,
  abs(Line - Y) =< ScaledSize, !,
  StartX is X - ScaledSize + abs(Line - Y),
  EndX is X + ScaledSize - abs(Line - Y).

line_range(Sensors, Line, Scale, Ranges) :-
  convlist([Sensor,Range]>>(sensor_range(Sensor, Line, Scale, Range)), Sensors, SensorRanges), mergeall(SensorRanges, Ranges).

beaconpos(Sensors, Line, Max, BeaconPos) :-
  Line >= 0, Line =< Max,
  line_range(Sensors, Line, 0, Ranges),
  \+ mergeall([[0,Max]|Ranges], Ranges), !,
  convlist([[_,E],P]>>(P is E+1, P>=0, P=<Max), Ranges, [BeaconPos|_]).

beaconfrequency(Sensors, Line, Max, Frequency) :- beaconpos(Sensors, Line, Max, Pos), Frequency is Line + Pos * 4000000.

between(Start, End, Step, Value) :- Steps is div(End-Start, Step), between(0, Steps, V), Value is Start + V * Step + div(Step, 2).

distances([_], [_], [], _).
distances([_,S2|SO], [E1|EO], [Distance|OtherDistances], Scale) :-
  Distance is Scale - div(S2 - E1 - 1, 2), distances([S2|SO], EO, OtherDistances, Scale).

distances(Ranges, Distances, Scale) :-
  maplist([[S,_],S]>>true, Ranges, Starts),
  maplist([[_,E],E]>>true, Ranges, Ends),
  sort(Starts, SortedStarts), sort(Ends, SortedEnds),
  distances(SortedStarts, SortedEnds, Distances, Scale).

possibleBeaconDistances(Sensors, Line, Scale, Max, Distances) :-
  line_range(Sensors, Line, Scale, Ranges),
  \+ mergeall([[0,Max]|Ranges], Ranges), !,
  distances(Ranges, Distances, Scale).

findBeaconPos(0, From, To, Max, Sensors, Frequency) :- !,
  between(From, To, Line),
  beaconfrequency(Sensors, Line, Max, Frequency).
findBeaconPos(Scale, From, To, Max, Sensors, Frequency) :-
    between(From, To, Scale, Line),
    possibleBeaconDistances(Sensors, Line, Scale, Max, Distances),
    member(Distance, Distances),
    checkWithDistance(Line, Distance, Max, Sensors, Frequency).

checkWithDistance(Line, Distance, Max, Sensors, Frequency) :-
  PrevLine is Line - Distance, NextLine is Line + Distance,
  (beaconfrequency(Sensors, PrevLine, Max, Frequency) ; beaconfrequency(Sensors, NextLine, Max, Frequency)).

getScale(Sensors, Scale) :- maplist([sensor{pos:_,size:S},S]>>true, Sensors, Sizes), min_list(Sizes, MinSize), Scale is MinSize - 1.

getMax(Size, Max) :- Max is Size * 2.

result([Size|Sensors], Frequency) :-
  getScale(Sensors, Scale), getMax(Size, Max),
  findBeaconPos(Scale, 0, Max, Max, Sensors, Frequency).

/* required for loadData */
data_line(RequestedLine, Line) :- string_concat("y=", LineStr, Line), !, number_string(RequestedLine, LineStr).
data_line(sensor{pos: [X,Y], size: Size}, Line) :-
  split_string(Line, ",:", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ=", Numbers),
  maplist(number_string, [X,Y,BeaconX,BeaconY], Numbers),
  Size is abs(X-BeaconX) + abs(Y-BeaconY).

