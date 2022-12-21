 testResult(33).

:- include('19.common.prolog').

qualityLevel(Blueprint, QualityLevel) :-
  retractall(currentMaximum(_)), assert(currentMaximum(0)),
  aggregate_all(max(X), simulate(24, Blueprint, [0,0,0,0], [1,0,0,0], _, [_,_,_,X]), Geodes), QualityLevel is Geodes * Blueprint.id.

result(Blueprints, QualityLevels) :- aggregate_all(sum(QualityLevel), (member(Blueprint, Blueprints), qualityLevel(Blueprint, QualityLevel)), QualityLevels).
