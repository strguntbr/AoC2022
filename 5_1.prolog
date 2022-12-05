:- include('5.common.prolog'). testResult("CMZ").

reorderForPush(Crates, ReversedCrates) :- reverse(Crates, ReversedCrates).