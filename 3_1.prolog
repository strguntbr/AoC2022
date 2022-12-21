 day(3). testResult(157).
 
:- use_module(lib/solve).

priority(Item, Priority) :- Item >= "a", Item =< "z", Priority is Item - "a" + 1.
priority(Item, Priority) :- Item >= "A", Item =< "Z", Priority is Item - "A" + 27.
inBothCompartments(rucksack{first: First, second: Second}, Item) :- member(Item, First), member(Item, Second), !.

result(Rucksacks, PrioritySum) :- maplist(inBothCompartments, Rucksacks, Items), maplist(priority, Items, Priorities), sum_list(Priorities, PrioritySum).

/* required for loadData */
data_line(rucksack{first: Compartment1, second: Compartment2}, Line) :- string_chars(Line, Chars), maplist(atom_string, Chars, Items), length(Compartment1, L), length(Compartment2, L), append(Compartment1, Compartment2, Items).