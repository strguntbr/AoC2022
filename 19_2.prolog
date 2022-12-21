 testResult(3472).

:- include('19.common.prolog').

geodes(Blueprint, Time, Geodes) :-
  retractall(currentMaximum(_)), assert(currentMaximum(0)),
  aggregate_all(max(X), simulate(Time, Blueprint, [0,0,0,0], [1,0,0,0], _, [_,_,_,X]), Geodes).

first(0, _, []) :- !.
first(_, [], []) :- !.
first(Number, [H|T], [H|THeads]) :- Number > 0, !, NextNumber is Number - 1, first(NextNumber, T, THeads).

product([], 1).
product([H|T], Product) :- product(T, TProduct), Product is H * TProduct.

result(Blueprints, Product) :-
  first(3, Blueprints, Frist3Blueprints),
  maplist([BP,G]>>geodes(BP, 32, G), Frist3Blueprints, Geodes),
  product(Geodes, Product).

/*result([BP1,BP2], Product) :- geodes(BP1, 32, G1), geodes(BP2, 32, G2), Product is G1*G2.
result([BP1,BP2,BP3|_], Product) :- geodes(BP1, 32, G1), geodes(BP2, 32, G2), geodes(BP3, 32, G3), Product is G1*G2*G3.*/
