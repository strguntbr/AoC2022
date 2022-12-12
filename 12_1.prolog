:- include('12.common.prolog'). testResult(31).

initNode("S", StartNode) :- !, assert(distance(StartNode, 0)), assert(node("S", StartNode)).
initNode(Height, Node) :- assert(node(Height, Node)).
