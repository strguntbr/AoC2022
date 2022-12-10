:- include('lib/solve.prolog'). day(10).
testResult(["##..##..##..##..##..##..##..##..##..##..",
            "###...###...###...###...###...###...###.",
            "####....####....####....####....####....",
            "#####.....#####.....#####.....#####.....",
            "######......######......######......####",
            "#######.......#######.......#######....."]).

updateSpritePos(noop, Pos, Pos).
updateSpritePos(add{v: V}, Pos, NextPos) :- NextPos is Pos + V.

curPixel(Pixel, SpritePos, "#") :- abs(Pixel - SpritePos) =< 1, !.
curPixel(_, _, ".").

process(Instructions, 40, SpritePos, SpritePos, Instructions, _).
process([H|T], Pixel, SpritePos, NextSpritePos, RemainingInstructions, [CurPixel|Line]) :-
  curPixel(Pixel, SpritePos, CurPixel),
  NextPixel is Pixel + 1,
  updateSpritePos(H, SpritePos, FinalSpritePos),
  process(T, NextPixel, FinalSpritePos, NextSpritePos, RemainingInstructions, Line).

flattenInstructions([], []).
flattenInstructions([noop|T], [noop|NextT]) :- flattenInstructions(T, NextT).
flattenInstructions([add{v: V}|T], [noop,add{v: V}|NextT]) :- flattenInstructions(T, NextT).

processLines([], _, []).
processLines(Instructions, X, [Line|OtherLines]) :- process(Instructions, 0, X, NextX, NextInstructions, Line), processLines(NextInstructions, NextX, OtherLines).

line([], "").
line([H|T], Line) :- line(T, NextLine), string_concat(H, NextLine, Line).
screen(RawScreen, Screen) :- maplist(line, RawScreen, Screen).

result(RawInstructions, Screen) :-
  flattenInstructions(RawInstructions, Instructions),
  processLines(Instructions, 1, RawScreen),
  screen(RawScreen, Screen)/*, concatLines(ScreenLines, Screen)*/.

/* required for loadData */
data_line(noop, "noop").
data_line(add{v: V}, Line) :- split_string(Line, " ", "", ["addx", Value]), number_string(V, Value).

formatLine(Line, FormattedLine) :- re_replace("\\."/g, " ", Line, T), re_replace("#"/g, "█", T, FormattedLine).
formatResult([], []).
formatResult([Line|OtherLines], [FormattedLine|OtherFormattedLines]) :- formatLine(Line, FormattedLine), formatResult(OtherLines, OtherFormattedLines).