:- include('lib/solve.prolog'). day(5). groupData.
:- use_module(library(clpfd)).

concatAll([], "").
concatAll([H|T], Result) :- concatAll(T, TResult), string_concat(H, TResult, Result).

first([H|_], H).
stackTops([], "").
stackTops(Stacks, Tops) :- maplist(first, Stacks, TopCrates), concatAll(TopCrates, Tops).

push([FirstStack|OtherStacks], Crates, 1, [ResultingFirstStack|OtherStacks]) :- !, reorderForPush(Crates, ReorderedCrates), append(ReorderedCrates, FirstStack, ResultingFirstStack).
push([FirstStack|OtherStacks], Crates, To, [FirstStack|ResultingOtherStacks]) :- NextTo is To - 1, push(OtherStacks, Crates, NextTo, ResultingOtherStacks).

pop([FirstStack|OtherStacks], Amount, 1, Crates, [RemainingFirstStack|OtherStacks]) :- !, length(Crates, Amount), append(Crates, RemainingFirstStack, FirstStack).
pop([FirstStack|OtherStacks], Amount, From, Crates, [FirstStack|ResultingOtherStacks]) :- NextFrom is From - 1, pop(OtherStacks, Amount, NextFrom, Crates, ResultingOtherStacks).

rearrange(Stacks, [], Stacks).
rearrange(Stacks, [move{amount: Amount, from: From, to: To}|Rearrangements], ResultingStacks) :-
     pop(Stacks, Amount, From, Picked, PoppedStacks),
     push(PoppedStacks, Picked, To, PushedStacks),
     rearrange(PushedStacks, Rearrangements, ResultingStacks).

result([Stacks, Rearrangements], StackTops) :- rearrange(Stacks, Rearrangements, FinalStacks), stackTops(FinalStacks, StackTops).

/* required for loadData */
data_line(Rearrangement, Line) :- line_rearrangement(Line, Rearrangement), !.
data_headers(Stacks, Line) :- maplist(data_header, Data, Line), append(DataWoIndices, [_], Data), transpose(DataWoIndices, RawStacks), maplist(normalizeStack, RawStacks, Stacks).

data_header(Indices, Line) :- line_indices(Line, Indices), !.
data_header(Crates, Line) :- line_crates(Line, Crates).

normalizeStack([[]|Stack], NormalizedStack) :- !, normalizeStack(Stack, NormalizedStack).
normalizeStack(Stack, Stack).

line_rearrangement(Line, move{amount: Amount, from: From, to: To}) :- string_concat("move ", T, Line), split_string(T, "o", "frmt ", Split), maplist(number_string, [Amount, From, To], Split).
line_indices(Line, Indices) :- split_string(Line, " ", " ", IndexStrings), maplist(number_string, Indices, IndexStrings).
line_crates(Line, Crates) :- split_string(Line, " ", "[]", RawCrates), removeEmptyCrates(RawCrates, Crates).

removeEmptyCrates([], []).
removeEmptyCrates([""|[""|[""|[""|RawT]]]], [[]|T]) :- !, removeEmptyCrates(RawT, T).
removeEmptyCrates([H|RawT], [H|T]) :- removeEmptyCrates(RawT, T).