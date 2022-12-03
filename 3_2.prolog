:- include('lib/solve.prolog'). day(3). testResult(70).

priority(Item, Priority) :- Item >= "a", Item =< "z", Priority is Item - "a" + 1.
priority(Item, Priority) :- Item >= "A", Item =< "Z", Priority is Item - "A" + 27.
inAllRucksacks([First, Second, Third], Item) :- member(Item, First), member(Item, Second), member(Item, Third), !.
groupRucksacks([],[]).
groupRucksacks([First|[Second|[Third|Rest]]], [[First,Second,Third]|RestGrouped]) :- groupRucksacks(Rest, RestGrouped).

result(Rucksacks, PrioritySum) :- groupRucksacks(Rucksacks, GroupedRucksacks), maplist(inAllRucksacks, GroupedRucksacks, Items), maplist(priority, Items, Priorities), sum_list(Priorities, PrioritySum).

/* required for loadData */
data_line(Items, Line) :- string_chars(Line, Chars), maplist(atom_string, Chars, Items).