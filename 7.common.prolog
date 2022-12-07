:- include('lib/solve.prolog'). day(7).

recursiveSize(Node, Size) :- node(Node, _, NodeSize), aggregate_all(sum(ChildSize),  recursiveSize([_|Node], ChildSize), ChildSizes), Size is NodeSize + ChildSizes.
recursiveDirSize(Dir, Size) :- node(Dir, dir, _), recursiveSize(Dir, Size).

/* required for loadData */
resetData :- retractall(node(_, _, _)), setdir([]), listdir("/").

data_line(Line, Line) :- command(Line), !.
data_line(Line, Line) :- output(Line).

command("$ ls").
command("$ cd ..") :- curdir([_|ParentDir]), setdir(ParentDir).
command(Line) :- string_concat("$ cd ", Dir, Line), curdir(ParentDir), setdir([Dir|ParentDir]).

output(Line) :- string_concat("dir ", Dir, Line), !, listdir(Dir).
output(Line) :- split_string(Line, " ", "", [SizeStr, File]), number_string(Size, SizeStr), listfile(File, Size).

setdir(Dir) :- retractall(curdir(_)), assert(curdir(Dir)).
listdir(Dir) :- curdir(ParentDir), assert(node([Dir|ParentDir], dir, 0)).
listfile(File, Size) :- curdir(ParentDir), assert(node([File|ParentDir], file, Size)).