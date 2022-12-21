 testResult(24933642).

:- include('7.common.prolog').

requiredSpace(RequiredSpace) :- recursiveDirSize(["/"], RootSize), RequiredSpace is RootSize - (70000000 - 30000000).
matchingDir(Dir, Size, MinSize) :- recursiveDirSize(Dir, Size), Size >= MinSize.

result(_, DirSize) :- requiredSpace(RequiredSpace), aggregate_all(min(Size), matchingDir(_, Size, RequiredSpace), DirSize).