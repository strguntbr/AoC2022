day(23).

:- use_module(lib/solve).

/* debug */
printPos(X, Y) :- elf(X, Y) -> write("#") ; write(".").

print :-
    boundingBox(MinX, MaxX, MinY, MaxY),
    writeln(""),
    forall(between(MinX, MaxX, X), (
        forall(between(MinY, MaxY, Y), (
            printPos(X, Y)
        )),
        writeln("")
    )).

/* simulate */
empty([X, Y]) :- empty(X, Y).
empty(X, Y) :-
    \+ elf(X, Y),
    \+ proposedElf(_, _, X, Y).

collision(X, Y, OldX, OldY) :-
    proposedElf(X, Y, AnotherOldX, AnotherOldY),
    (OldX =\= AnotherOldX ; OldY =\= AnotherOldY).

moveIfNoCollision(X, Y, OldX, OldY, NewX, NewY) :-
    collision(X, Y, OldX, OldY)
    -> (
        NewX = OldX,
        NewY = OldY,
        assert(elf(OldX, OldY))
    )
    ; (
        NewX = X,
        NewY = Y,
        assert(elf(X, Y))
    ).

move(Moves) :-
    aggregate_all(count, proposedElf(_,_,_,_), Moves),
    forall(proposedElf(X, Y, OldX, OldY), moveIfNoCollision(X, Y, OldX, OldY, _, _)),
    retractall(proposedElf(_, _, _, _)).

neighbors(X, Y, n, [UpX, Y], [UpX, LeftY], [UpX, RightY]) :-
    UpX is X - 1,
    LeftY is Y - 1,
    RightY is Y +1.
neighbors(X, Y, s, [DownX, Y], [DownX, LeftY], [DownX, RightY]) :-
    DownX is X + 1,
    LeftY is Y - 1,
    RightY is Y +1.
neighbors(X, Y, w, [X, LeftY], [UpX, LeftY], [DownX, LeftY]) :-
    LeftY is Y - 1,
    UpX is X - 1,
    DownX is X + 1.
neighbors(X, Y, e, [X, RightY], [UpX, RightY], [DownX, RightY]) :-
    RightY is Y + 1,
    UpX is X - 1,
    DownX is X + 1.

proposeMove(X, Y, _, X, Y) :-
    XUp is X - 1,
    XDown is X + 1,
    YLeft is Y - 1,
    YRight is Y + 1,
    foreach((between(XUp, XDown, XC), between(YLeft, YRight, YC)), (
        (XC = X, YC = Y) ; (empty(XC, YC))
    )), !.
proposeMove(X, Y, [Direction|_], MovedX, MovedY) :-
    neighbors(X, Y, Direction, [MovedX, MovedY], N1, N2),
    empty([MovedX, MovedY]), empty(N1), empty(N2), !,
    assert(proposedElf(MovedX, MovedY, X, Y)),
    retractall(elf(X, Y)).
proposeMove(X, Y, [_|Directions], MovedX, MovedY) :- proposeMove(X, Y, Directions, MovedX, MovedY).
proposeMove(X, Y, [], X, Y).

propose([FirstDirection|OtherDirections], NextDirections) :-
    append(OtherDirections, [FirstDirection], NextDirections),
    forall(elf(X, Y), proposeMove(X, Y, [FirstDirection|OtherDirections], _, _)).

simulate(Rounds, _, MaxRounds) :- number(MaxRounds), Rounds = MaxRounds, !.
simulate(Rounds, Directions, MaxRounds) :-
    propose(Directions, NextDirections),
    move(Moves),
    (
        Moves = 0
        -> (
            MaxRounds is Rounds + 1
        )
        ; (
            NextRounds is Rounds + 1,
            simulate(NextRounds, NextDirections, MaxRounds)
        )
    ).
simulate(MaxRounds) :- simulate(0, [n, s, w, e], MaxRounds).

/* create map */
assertElf(., _, _).
assertElf(#, X, Y) :- assert(elf(X, Y)).

assertRow([], _, _).
assertRow([FirstElf|OtherElves], X, Y) :-
    assertElf(FirstElf, X, Y),
    NextY is Y + 1,
    assertRow(OtherElves, X, NextY).

assertMap([], _).
assertMap([FirstRow|OtherRows], X) :-
    assertRow(FirstRow, X, 0),
    NextX is X + 1,
    assertMap(OtherRows, NextX).

assertMap(Map) :-
    retractall(elf(_, _)),
    retractall(proposedElf(_, _, _, _)),
    assertMap(Map, 0).

boundingBox(MinX, MaxX, MinY, MaxY) :-
    aggregate_all(min(X), elf(X, _), MinX),
    aggregate_all(max(X), elf(X, _), MaxX),
    aggregate_all(min(Y), elf(_, Y), MinY),
    aggregate_all(max(Y), elf(_, Y), MaxY).

/* required for loadData */
data_line(MapRow, Line) :- string_chars(Line, MapRow).
