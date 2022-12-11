:- include('11.common.prolog'). testResult(2713310158).

relief(OldWorryLevel, NewWorryLevel) :- maxWorryLevel(MaxWorryLevel), NewWorryLevel is mod(OldWorryLevel, MaxWorryLevel).

maxWorryLevel([], 1) :- !.
maxWorryLevel([[_, _, Divisible, _, _]|OtherMonkeySpecs], MaxWorryLevel) :- maxWorryLevel(OtherMonkeySpecs, OtherMaxWorryLevel), MaxWorryLevel is OtherMaxWorryLevel * Divisible.
setMaxWorryLevel(MonkeySpecs) :- maxWorryLevel(MonkeySpecs, MaxWorryLevel), retractall(maxWorryLevel(_)), assert(maxWorryLevel(MaxWorryLevel)).

result(Data, Business) :- init(Data, MonkeySpecs), setMaxWorryLevel(MonkeySpecs), rounds(MonkeySpecs, 10000), business(Business).
