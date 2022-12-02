:- include('2.common.prolog'). testResult(12).

mapPlay(round{opponent: Shape, outcome: draw}, round{opponent: Shape, me: Shape}).
mapPlay(round{opponent: Opponent, outcome: lose}, round{opponent: Opponent, me: Me}) :- win(Opponent, Me).
mapPlay(round{opponent: Opponent, outcome: win}, round{opponent: Opponent, me: Me}) :- win(Me, Opponent).

result(StrategyGuide, Score) :- maplist(mapPlay, StrategyGuide, Plays), maplist(score, Plays, Scores), sum_list(Scores, Score).

/* required for loadData */
outcome("X", lose). outcome("Y", draw). outcome("Z", win).
data_line(round{opponent: OpponentShape, outcome: Outcome}, Line) :- split_string(Line, " ", "", [D1, D2]), shape(D1, OpponentShape), outcome(D2, Outcome).