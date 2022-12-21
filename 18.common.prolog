 day(18).

:- use_module(lib/solve).

neighbor([X,Y,Z], [XN,Y,Z]) :- XN is X - 1 ; XN is X + 1. 
neighbor([X,Y,Z], [X,YN,Z]) :- YN is Y - 1 ; YN is Y + 1. 
neighbor([X,Y,Z], [X,Y,ZN]) :- ZN is Z - 1 ; ZN is Z + 1. 

sidesExposed([X,Y,Z], Count) :- cube(X,Y,Z), aggregate_all(count, (neighbor([X,Y,Z], [Xn,Yn,Zn]), \+ cube(Xn,Yn,Zn)), Count).
countExposedSides(ExposedSides) :- aggregate_all(sum(C), sidesExposed(_, C), ExposedSides).

/* required for loadData */
resetData :- retractall(cube(_, _, _)).
data_line([X,Y,Z], Line) :- split_string(Line, ",", "", Coordinates), maplist(number_string, [X,Y,Z], Coordinates), assert(cube(X, Y, Z)).
