 day(19).

:- use_module(lib/solve).

assertCurrentMaximum(CurBest) :- currentMaximum(LastBest), (LastBest >= CurBest ; (retractall(currentMaximum(_)), assert(currentMaximum(CurBest)))).

sumRobots(Robots1, Robots2, AllRobots) :- maplist([R1,R2,R]>>(R is R1+R2), Robots1, Robots2, AllRobots).

geodeCapability(TimeLeft, [_, _, _, GeodeRobot], GeodeCapability) :- GeodeCapability is div((GeodeRobot*2+TimeLeft-1)*TimeLeft,2).
canWin(TimeLeft, [_, _, _, Geode], Robots) :-
  currentMaximum(CurBest),
  geodeCapability(TimeLeft, Robots, GeodeCapability),
  CurBest < Geode + GeodeCapability.

robotRequirements(Blueprint, Type, [Ore, Clay, Obsidian, 0]) :- member(r{t: Type, o: Ore, c: Clay, b: Obsidian}, Blueprint.r).

buildOnlyGeodeRobots(GeodeRequirements, Robots) :-
  maplist([G,R,D]>>(D is R-G), GeodeRequirements, Robots, Diff),
  foreach(member(D, Diff), (D >= 0)).

pickRobotToBuild(GeodeRequirements, _, Robots, geode) :- buildOnlyGeodeRobots(GeodeRequirements, Robots), !.
pickRobotToBuild(_, _, _, geode).
pickRobotToBuild(_, [MaxOreBots, _, _, _], [OreBots, _, _, _], ore) :- OreBots < MaxOreBots.
pickRobotToBuild(_, [_, MaxClayBots, _, _], [_, ClayBots, _, _], clay) :- ClayBots < MaxClayBots.
pickRobotToBuild(_, [_, _, MaxObsidianBots, _], [_, _, ObsidianBots, _], obsidian) :- ObsidianBots < MaxObsidianBots.

newRobots(ore, [1,0,0,0]). newRobots(clay, [0,1,0,0]). newRobots(obsidian, [0,0,1,0]). newRobots(geode, [0,0,0,1]).

divCeil(Z, 0, 0) :- 0 is Z, !.
divCeil(_, 0, _) :- !, fail.
divCeil(X, Y, Z) :- Z is div(X+Y-1, Y).

canBuildRobot(TimeLeft, Blueprint, Resources, Robots, RobotToBuild, TimeRequired, Requirements) :-
  robotRequirements(Blueprint, RobotToBuild, Requirements),
  maplist([Res,Rob,Req,Min]>>(divCeil(max(0,Req-Res),Rob,M), Min is M+1), Resources, Robots, Requirements, MinutesRequired),
  aggregate_all(max(X), member(X, MinutesRequired), TimeRequired), TimeRequired < TimeLeft.

cantBuildAnyRobot(TimeLeft, Blueprint, Resources, Robots) :- foreach(newRobots(RobotToBuild, _), \+ canBuildRobot(TimeLeft, Blueprint, Resources, Robots, RobotToBuild, _, _)).

buildRobot(TimeLeft, Blueprint, Resources, CurRobots, NextRobots, NextResources, NextTimeLeft) :-
  canWin(TimeLeft, Resources, CurRobots), /* abort if this branch can not beat the current maximum */
  pickRobotToBuild(Blueprint.geode, Blueprint.max, CurRobots, RobotToBuild),
  canBuildRobot(TimeLeft, Blueprint, Resources, CurRobots, RobotToBuild, TimeRequired, Requirements),
  newRobots(RobotToBuild, NewRobots), sumRobots(CurRobots, NewRobots, NextRobots),
  NextTimeLeft is TimeLeft - TimeRequired,
  maplist([OldRes,Rob,Req,NewRes]>>(NewRes is OldRes+Rob*TimeRequired-Req), Resources, CurRobots, Requirements, NextResources).
buildRobot(TimeLeft, Blueprint, Resources, CurRobots, CurRobots, NextResources, 0) :-
  canWin(TimeLeft, Resources, CurRobots), /* abort if this branch can not beat the current maximum */
  cantBuildAnyRobot(TimeLeft, Blueprint, Resources, CurRobots),
  maplist([OldRes,Rob,NewRes]>>(NewRes is OldRes+Rob*TimeLeft), Resources, CurRobots, NextResources).

simulate(0, _, [Ore,Clay,Obsidian,Geode], Robots, Robots, [Ore,Clay,Obsidian,Geode]) :- !, assertCurrentMaximum(Geode).
simulate(TimeLeft, Blueprint, Resources, Robots, FinalRobots, FinalResources) :-
  buildRobot(TimeLeft, Blueprint, Resources, Robots, NextRobots, NextResources, NextTimeLeft),
  simulate(NextTimeLeft, Blueprint, NextResources, NextRobots, FinalRobots, FinalResources).

/* required for loadData */
resetData :- retractall(currentMaximum(_)), assert(currentMaximum(0)).
data_line(bp{id: Id, r: Robots, geode: [OreRequired, ClayRequired, ObsidianRequired, 0], max: [MaxOreRobots, MaxClayRobots, MaxObsidianRobots, 10000]}, Line) :-
  split_string(Line, ":.", " ", [IdStr|RobotDefs]),
  id_string(Id, IdStr),
  findall(Def, (member(Def, RobotDefs), Def\==""), NonEmptyRobotDefs), maplist(robot_string, Robots, NonEmptyRobotDefs),
  member(r{t:geode, o:OreRequired, c: ClayRequired, b: ObsidianRequired}, Robots),
  aggregate_all(max(OreCost), member(r{t:_, o:OreCost, c:_, b:_}, Robots), MaxOreRobots),
  aggregate_all(max(ClayCost), member(r{t:_, o:_, c:ClayCost, b:_}, Robots), MaxClayRobots),
  aggregate_all(max(ObsidianCost), member(r{t:_, o:_, c:_, b:ObsidianCost}, Robots), MaxObsidianRobots).

id_string(Id, String) :- string_concat("Blueprint ", IdStr, String), number_string(Id, IdStr).
robot_string(r{t: Type, o: OreCost, c: ClayCost, b: ObsidianCost}, String) :-
  split_string(String, " ", " ", ["Each",TypeStr,"robot","costs"|Costs]),
  type_string(Type, TypeStr),
  parseCosts([OreCost,ClayCost,ObsidianCost], ["and"|Costs]).

type_string(ore, "ore"). type_string(clay, "clay"). type_string(obsidian, "obsidian"). type_string(geode, "geode").

parseCosts([0,0,0], []) :- !.
parseCosts(Resources, ["and",Amount,Type|OtherCosts]) :-
  maplist([Res,Cost]>>(cost(Res, Amount, Type, Cost)), [ore, clay, obsidian], ThisResources),
  parseCosts(OtherResources, OtherCosts),
  maplist([T,O,S]>>(S is T+O), ThisResources, OtherResources, Resources).

cost(ore, AmountStr, "ore", Amount) :- !, number_string(Amount, AmountStr).
cost(clay, AmountStr, "clay", Amount) :- !, number_string(Amount, AmountStr).
cost(obsidian, AmountStr, "obsidian", Amount) :- !, number_string(Amount, AmountStr).
cost(_, _, _, 0).
