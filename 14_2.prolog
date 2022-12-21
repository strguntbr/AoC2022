 testResult(93).

:- include('14.common.prolog').

result(Ys, SandCount) :- max_list(Ys, MaxY), FloorY is MaxY + 2, assert(filled(_, FloorY, rock)), fillWithSand(FloorY, SandCount).
