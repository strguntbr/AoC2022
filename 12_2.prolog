 testResult(29).

:- include('12.common.prolog').

initNode("S", StartNode) :- !, assert(distance(StartNode, 0)), assert(node("S", StartNode)).
initNode("a", StartNode) :- !, assert(distance(StartNode, 0)), assert(node("a", StartNode)).
initNode(Height, Node) :- assert(node(Height, Node)).
