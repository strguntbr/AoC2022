:- include('20.common.prolog'). testResult(3).

result(Numbers, Coordinates) :- 
  initData(Numbers),
  encryptAll(0),
  maplist(getNth, [1000, 2000, 3000], Values),
  aggregate_all(sum(V), member(V, Values), Coordinates).
