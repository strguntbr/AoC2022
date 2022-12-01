:- include('lib/solve.prolog'). day(1). testResult(24000). groupData.

compactReport(CaloriesReport, CompactReport) :- maplist(sum_list, CaloriesReport, CompactReport).
result(CaloriesReport, MostCalories) :- compactReport(CaloriesReport, CompactReport), aggregate_all(max(X), member(X, CompactReport), MostCalories).

/* required for loadData */
data_line(Data, Line) :- number_string(Data, Line).