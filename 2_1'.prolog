 day(2). testResult(15).

:- use_module(lib/solve).

scoreShape(rock, 0). scoreShape(paper, 1). scoreShape(scissor, 2).
scoreOutcome(Opponent, Me, Score) :- scoreShape(Opponent, OpponentScore), scoreShape(Me, MyScore), Score is ((MyScore - OpponentScore + 1) mod 3).
score(round{opponent: Opponent, me: Me}, Score) :- scoreOutcome(Opponent, Me, ScoreOutcome), scoreShape(Me, ScoreShape), Score is ScoreOutcome  * 3 + ScoreShape + 1.

result(StrategyGuide, Score) :- maplist(score, StrategyGuide, Scores), sum_list(Scores, Score).

/* required for loadData */
shape("A", rock). shape("X", rock).
shape("B", paper). shape("Y", paper).
shape("C", scissor). shape("Z", scissor).
data_line(round{opponent: OpponentShape, me: MyShape}, Line) :- split_string(Line, " ", "", [D1, D2]), shape(D1, OpponentShape), shape(D2, MyShape).