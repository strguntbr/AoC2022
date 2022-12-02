:- include('lib/solve.prolog'). day(2).

win(rock, scissor). win(scissor, paper). win(paper, rock).

scoreShape(rock, 0). scoreShape(paper, 1). scoreShape(scissor, 2).
scoreOutcome(Opponent, Me, 2) :- win(Me, Opponent), !.
scoreOutcome(Opponent, Me, 0) :- win(Opponent, Me), !.
scoreOutcome(_, _, 1).
score(round{opponent: Opponent, me: Me}, Score) :- scoreOutcome(Opponent, Me, ScoreOutcome), scoreShape(Me, ScoreShape), Score is ScoreOutcome * 3 + ScoreShape + 1.

/* required for loadData */
shape("A", rock). shape("B", paper). shape("C", scissor).