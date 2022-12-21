 day(2). testResult(12).

:- use_module(lib/solve).

scoreShape(rock, 0). scoreShape(paper, 1). scoreShape(scissor, 2).
scoreShape(Opponent, Outcome, Score) :- scoreOutcome(Outcome, ScoreOutcome), scoreShape(Opponent, ScoreOpponent), Score is (ScoreOutcome + ScoreOpponent - 1) mod 3.
scoreOutcome(lose, 0). scoreOutcome(draw, 1). scoreOutcome(win, 2).
score(round{opponent: Opponent, outcome: Outcome}, Score) :- scoreOutcome(Outcome, ScoreOutcome), scoreShape(Opponent, Outcome, ScoreShape), Score is ScoreOutcome  * 3 + ScoreShape + 1.

result(StrategyGuide, Score) :- maplist(score, StrategyGuide, Scores), sum_list(Scores, Score).

/* required for loadData */
shape("A", rock). shape("B", paper). shape("C", scissor).
outcome("X", lose). outcome("Y", draw). outcome("Z", win).
data_line(round{opponent: OpponentShape, outcome: Outcome}, Line) :- split_string(Line, " ", "", [D1, D2]), shape(D1, OpponentShape), outcome(D2, Outcome).