:- include('lib/solve.prolog'). day(17).

disjoint(Set1, Set2) :- foreach(member(X, Set1), \+ member(X, Set2)).
getHeight(TowerOrRock, Height) :- aggregate_all(max(X), member([X,_], TowerOrRock), H), Height is H + 1.

rock(0, [[3,2],[3,3],[3,4],[3,5]]).
rock(1, [[3,3],[4,2],[4,3],[4,4],[5,3]]).
rock(2, [[3,2],[3,3],[3,4],[4,4],[5,4]]).
rock(3, [[3,2],[4,2],[5,2],[6,2]]).
rock(4, [[3,2],[3,3],[4,2],[4,3]]).
newRock(Count, Height, Rock) :- Type is mod(Count, 5), rock(Type, R), moveRock(R, [Height,0], Rock).

validPos(Rock, Tower) :- forall(member([X,Y],Rock), (between(0, 6, Y), X>=0)), disjoint(Rock, Tower).

tryMoveRock(CurPos, Move, Tower, NewPos) :- moveRock(CurPos, Move, T), (validPos(T, Tower) -> NewPos = T ; NewPos = CurPos).
moveRock(OldPos, [XMove,YMove], NewPos) :- maplist([[Ox,Oy],[Nx,Ny]]>>(Nx is Ox+XMove, Ny is Oy+YMove), OldPos, NewPos).

instruction(Tick, Instructions, [0,-1]) :- nth0(Tick, Instructions, '<').
instruction(Tick, Instructions, [0,1]) :- nth0(Tick, Instructions, '>').
instruction(Tick, Instructions, Instruction) :- length(Instructions, L), Tick >= L, I is mod(Tick, L), instruction(I, Instructions, Instruction).

trySkip(Tick, FirstColHeight, RockCount, RockType, MaxRocks, InstructionCount, SkippedRocks, SkippedHeight) :-
  surfaceHistory(OldTick, OldHeight, OldRockCount, RockType), 0 is mod(Tick-OldTick, InstructionCount),
  0 is mod(MaxRocks-1-RockCount, RockCount-OldRockCount), 
  Skip is div(MaxRocks-RockCount, RockCount-OldRockCount), Skip > 0, !,
  SkippedRocks is Skip * (RockCount-OldRockCount), SkippedHeight is Skip * (FirstColHeight-OldHeight).
trySkip(_, _, _, _, _, _, 0, 0).

placeRock(Tower, Tick, Rock, RockCount, MaxRocks,InstructionCount, SkippedRocks, SkippedHeight, NewTower) :-
  append(Rock, Tower, NewTower),
  (member([FirstColHeight,0], Tower), !; FirstColHeight=0), RockType is mod(RockCount, 5),
  trySkip(Tick, FirstColHeight, RockCount, RockType, MaxRocks, InstructionCount, SkippedRocks, SkippedHeight),
  assert(surfaceHistory(Tick, FirstColHeight, RockCount, RockType)).

fall(Tick, RockCount, MaxRocks, Instructions, CurRock, Tower, TowerHeight, FinalHeight) :-
  moveRock(CurRock, [-1,0], NextRockPos), validPos(NextRockPos, Tower), !,
  push(Tick, RockCount, MaxRocks, Instructions, NextRockPos, Tower, TowerHeight, FinalHeight).
fall(Tick, RockCount, MaxRocks, Instructions, CurRock, Tower, TowerHeight, FinalHeight) :-
  length(Instructions, InstructionsCount), placeRock(Tower, Tick, CurRock, RockCount, MaxRocks, InstructionsCount, SkippedRocks, SkippedHeight, NewTower),
  getHeight(CurRock, RockHeight), NewTowerHeight is max(RockHeight, TowerHeight),
  NewRockCount is RockCount + SkippedRocks + 1, newRock(NewRockCount, NewTowerHeight, NewRock),
  push(Tick, NewRockCount, MaxRocks, Instructions, NewRock, NewTower, NewTowerHeight, NextHeight),
  FinalHeight is NextHeight + SkippedHeight.
  
push(_, MaxRocks, MaxRocks, _, _, _, TowerHeight, TowerHeight).
push(Tick, RockCount, MaxRocks, Instructions, CurRock, Tower, TowerHeight, FinalHeight) :-
  instruction(Tick, Instructions, Move),
  tryMoveRock(CurRock, Move, Tower, NewPos),
  NextCycle is Tick + 1,
  fall(NextCycle, RockCount, MaxRocks, Instructions, NewPos, Tower, TowerHeight, FinalHeight).

simulate(Count, Instructions, FinalHeight) :- retractall(surfaceHistory(_,_,_,_)), assert(surfaceHistory(0, 0, 0, [0,0,0,0,0,0,0])),
  newRock(0, 0, FirstRock), push(0, 0, Count, Instructions, FirstRock, [], 0, FinalHeight).

/* required for loadData */
data_line(Instructions, Line) :- string_chars(Line, Instructions).
