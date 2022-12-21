 testResult(31).

:- include('12.common.prolog').

initNode("S", StartNode) :- !, assert(distance(StartNode, 0)), assert(node("S", StartNode)).
initNode(Height, Node) :- assert(node(Height, Node)).
