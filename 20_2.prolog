 testResult(1623178306).

:- include('20.common.prolog').

applyDecryptionKey(Number, DecryptedNumber) :- DecryptedNumber is Number * 811589153.

result(Numbers, Coordinates) :-
  maplist(applyDecryptionKey, Numbers, DecryptedNumbers),
  initData(DecryptedNumbers),
  forall(between(1,10, _), encryptAll(0)),
  maplist(getNth, [1000, 2000, 3000], Values),
  aggregate_all(sum(V), member(V, Values), Coordinates).
