 testResult("CMZ").

:- include('5.common.prolog').

reorderForPush(Crates, ReversedCrates) :- reverse(Crates, ReversedCrates).