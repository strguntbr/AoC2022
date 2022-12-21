 day(1). testResult(45000). groupData.

:- use_module(lib/solve).

/* top(List, Top, Remaining) where */
/*   - List is a list */
/*   - Top is an member of List such that all other members of List are smaller or equal to Top */
/*   - Remaining is List without Top */
top([H], H, []).
top([H|T], TopT, [H|RemainingT]) :- top(T, TopT, RemainingT), TopT >= H, !.
top([H|T], H, T).

/* topN(List, TopN) where */
/*   - List is a list */
/*   - TopN is a list such that all elements of TopN are greater than or equal to all elements of List that are not in TopN */
topN(_, []).
topN(List, [TopH|TopT]) :- top(List, TopH, Rest), topN(Rest, TopT).

compactReport(RawReport, CompactReport) :- maplist(sum_list, RawReport, CompactReport).
result(CaloriesReport, MostCalories) :- compactReport(CaloriesReport, CompactReport), length(Top3, 3), topN(CompactReport, Top3), sum_list(Top3, MostCalories).

/* required for loadData */
data_line(Data, Line) :- number_string(Data, Line).