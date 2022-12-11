:- include('lib/solve.prolog'). day(11). groupData.

incCounter(Id) :- counter(Id, C), NextC is C + 1, retract(counter(Id, _)), assert(counter(Id, NextC)).

operate(OldWorryLevel, mul{v: self}, NewWorryLevel) :- !, NewWorryLevel is OldWorryLevel * OldWorryLevel.
operate(OldWorryLevel, mul{v: V}, NewWorryLevel) :- !, NewWorryLevel is OldWorryLevel * V.
operate(OldWorryLevel, add{v: self}, NewWorryLevel) :- !, NewWorryLevel is OldWorryLevel + OldWorryLevel.
operate(OldWorryLevel, add{v: V}, NewWorryLevel) :- !, NewWorryLevel is OldWorryLevel + V.

throwto(Monkey, WorryLevel) :- assert(monkey_item(Monkey, WorryLevel)).
throw(WorryLevel, Divisible, Then, Else) :-
  mod(WorryLevel, Divisible) =:= 0
    -> throwto(Then, WorryLevel)
    ; throwto(Else, WorryLevel).

inspect(Monkey, WorryLevel, [Op, Divisible, Then, Else]) :-
  incCounter(Monkey),
  operate(WorryLevel, Op, NewWorryLevel),
  relief(NewWorryLevel, ReliefedWorryLevel),
  throw(ReliefedWorryLevel, Divisible, Then, Else).
inspectall(Monkey, Inspection) :- foreach(monkey_item(Monkey, Item), inspect(Monkey, Item, Inspection)).

round([]) :- !.
round([[Id, Op, Divisible, Then, Else]|OtherMonkeySpecs]) :-
  inspectall(Id, [Op, Divisible, Then, Else]),
  retractall(monkey_item(Id, _)),
  round(OtherMonkeySpecs).
rounds(MonkeySpecs, Rounds) :- foreach(between(1, Rounds, _), round(MonkeySpecs)).

largest([X], X, []) :- !.
largest([H|T], H, T) :- largest(T, L, _), H >= L, !.
largest([H|T], L, [H|TL]) :- largest(T, L, TL).
business(Business) :- findall(C, counter(_, C), C1), largest(C1, L1, C2), largest(C2, L2, _), Business is L1 * L2.

rawdata_monkeyspec([Monkey, Items, Op, Divisible, Then, Else], [Monkey, Op, Divisible, Then, Else]) :- foreach(member(Item, Items), assert(monkey_item(Monkey, Item))), assert(counter(Monkey, 0)).
init(RawData, MonkeySpecs) :- retractall(monkey_item(_, _)), retractall(counter(_, _)), maplist(rawdata_monkeyspec, RawData, MonkeySpecs).

/* required for loadData */
data_line(Monkey, Line) :- string_concat("Monkey ", T, Line), !, string_concat(N, ":", T), !, number_string(Monkey, N).
data_line(Items, Line) :- string_concat("  Starting items: ", I, Line), !, split_string(I, ",", " ", Is), maplist(number_string, Items, Is).
data_line(Operation, Line) :- string_concat("  Operation: ", T, Line), !, operation_string(Operation, T).
data_line(Divisible, Line) :- string_concat("  Test: divisible by ", T, Line), !, number_string(Divisible, T).
data_line(Then, Line) :- string_concat("    If true: throw to monkey ", T, Line), !, number_string(Then, T).
data_line(Else, Line) :- string_concat("    If false: throw to monkey ", T, Line), !, number_string(Else, T).

operation_string(add{v: V}, Op) :- string_concat("new = old + ", T, Op), !, value_string(V, T).
operation_string(mul{v: V}, Op) :- string_concat("new = old * ", T, Op), !, value_string(V, T).

value_string(self, "old") :- !.
value_string(V, S) :- number_string(V, S).
