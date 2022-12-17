:- include('17.common.prolog'). testResult(1514285714288).

result([Instructions], Height) :- simulate(1000000000000, Instructions, Height).
