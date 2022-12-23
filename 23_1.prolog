testResult(110).

:- include('23.common.prolog').

result(Map, Result) :-
    assertMap(Map),
    aggregate_all(count, elf(_,_), Elves),
    simulate(10),
    boundingBox(MinX, MaxX, MinY, MaxY),
    Result is (MaxX - MinX + 1) * (MaxY - MinY + 1) - Elves.
