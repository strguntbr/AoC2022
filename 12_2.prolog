:- include('12.common.prolog'). testResult(29).

initNode("S", StartNode) :- !, assert(distance(StartNode, 0)), assert(node("S", StartNode)).
initNode("a", StartNode) :- !, assert(distance(StartNode, 0)), assert(node("a", StartNode)).
initNode(Height, Node) :- assert(node(Height, Node)).
