:- include('2.common.prolog'). testResult(15).

result(StrategyGuide, Score) :- maplist(score, StrategyGuide, Scores), sum_list(Scores, Score).

/* required for loadData */
myshape("X", rock). myshape("Y", paper). myshape("Z", scissor).
data_line(round{opponent: OpponentShape, me: MyShape}, Line) :- split_string(Line, " ", "", [D1, D2]), shape(D1, OpponentShape), myshape(D2, MyShape).