 testResult(3068).

:- include('17.common.prolog').

result([Instructions], Height) :- simulate(2022, Instructions, Height).
