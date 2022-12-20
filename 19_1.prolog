:- include('19.common.prolog'). testResult(33).

qualityLevel(Blueprint, QualityLevel) :-
  retractall(currentMaximum(_)), assert(currentMaximum(0)),
  aggregate_all(max(X), simulate(24, Blueprint, [0,0,0,0], [1,0,0,0], _, [_,_,_,X]), Geodes), QualityLevel is Geodes * Blueprint.id.

result(Blueprints, QualityLevels) :- aggregate_all(sum(QualityLevel), (member(Blueprint, Blueprints), qualityLevel(Blueprint, QualityLevel)), QualityLevels).
