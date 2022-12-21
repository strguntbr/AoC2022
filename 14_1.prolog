 testResult(24).

:- include('14.common.prolog').

result(Ys, SandCount) :- max_list(Ys, VoidY), fillWithSand(VoidY, SandCount).
