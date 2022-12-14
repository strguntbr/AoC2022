:- include('14.common.prolog'). testResult(93).

result(Ys, SandCount) :- max_list(Ys, MaxY), FloorY is MaxY + 2, assert(filled(_, FloorY, rock)), fillWithSand(FloorY, SandCount).
