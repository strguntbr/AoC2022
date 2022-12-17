:- include('17.common.prolog'). testResult(3068).

result([Instructions], Height) :- simulate(2022, Instructions, Height).
