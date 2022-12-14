:- include('14.common.prolog'). testResult(24).

result(Ys, SandCount) :- max_list(Ys, VoidY), fillWithSand(VoidY, SandCount).
