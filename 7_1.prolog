 testResult(95437).

:- include('7.common.prolog').

matchinDir(Dir, Size, MaxSize) :- recursiveDirSize(Dir, Size), Size =< MaxSize.

result(_, Sum) :- aggregate_all(sum(Size), matchinDir(_, Size, 100000), Sum).