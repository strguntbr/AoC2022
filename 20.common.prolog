 day(20).

:- use_module(lib/solve).

initData(_, _, []).
initData(I, L, [H|T]) :- Next is mod(I + 1, L), assert(number(I, H, Next)), initData(Next, L, T).
initData(Numbers) :- retractall(number(_, _, _)), length(Numbers, L), initData(0, L, Numbers).

move(Next, 0, Next) :- !.
move(Next, I, NewNext) :-
  I > 0,
  NextI is I - 1,
  number(Next, _, NextNext),
  move(NextNext, NextI, NewNext).

remove(I, IValue, INext) :-
  number(I, IValue, INext),
  number(IPrev, PrevValue, I),
  retractall(number(I, IValue, INext)),
  retractall(number(IPrev, PrevValue, I)),
  assert(number(IPrev, PrevValue, INext)).

insert(I, IValue, INext) :-
  number(IPrev, PrevValue, INext),
  retractall(number(IPrev, PrevValue, INext)),
  assert(number(IPrev, PrevValue, I)),
  assert(number(I, IValue, INext)).

getNth(Start, 0, Value) :- !, number(Start, Value, _).
getNth(Start, N, Value) :- N > 0, NextN is N - 1, number(Start, _, NextStart), getNth(NextStart, NextN, Value).
getNth(N, Value) :- number(Start, 0, _), getNth(Start, N, Value).

encrypt1(I) :- aggregate_all(count, number(_,_,_), L), encrypt1(I, L).
encrypt1(I, L) :- remove(I, IValue, INext), Move is mod(IValue, L-1), move(INext, Move, NewNext), insert(I, IValue, NewNext).
  
encryptAll(L, L) :- !.
encryptAll(I, L) :- encrypt1(I, L), INext is I + 1, encryptAll(INext, L).
encryptAll(I) :- aggregate_all(count, number(_,_,_), L), encryptAll(I, L).

/* required for loadData */
data_line(Number, Line) :- number_string(Number, Line).