 testResult(1514285714288).

:- include('17.common.prolog').

result([Instructions], Height) :- simulate(1000000000000, Instructions, Height).
