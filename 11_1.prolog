 testResult(10605).

:- include('11.common.prolog').

relief(OldWorryLevel, NewWorryLevel) :- NewWorryLevel is div(OldWorryLevel, 3).

result(Data, Business) :- init(Data, MonkeySpecs), rounds(MonkeySpecs, 20), business(Business).
