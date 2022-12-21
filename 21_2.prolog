 day(21). testResult(301).

:- use_module(lib/solve).
:- use_module(library(clpq)).

result(Equations, Result) :-
    findall(E, (member(Et, Equations), \+ re_match("^HUMN", Et), re_replace("^ROOT= (.+)[*+-/](.+)$", "$1=$2", Et, E)), FilteredEquations), /* Remove HUMN line and replace ROOT line with 'lhs=rhs' */
    foldl([L,R,F]>>foldl(string_concat,[L,",",R], "", F), FilteredEquations, "", FoldedEquations), /* Concatenate all the lines separated with ',' */
    foldl(string_concat, ["}", FoldedEquations, "{Result=HUMN"], "", AllEquations), /* Predend the concatenated lines with 'Result=HUMN' (to have the result in the first variable) and wrap everything in '{' ... '}' */
    term_string(Term, AllEquations), term_variables(Term, [Result|_]), Term. /* Convert the string to a term, evaluate it and return the value of the first variable */

/* required for loadData */
data_line(Term, Line) :- re_replace(":", "=", Line, T), string_upper(T, Term). /* Replace ':' with '=' and make everything uppercase to make prolog recognize the variables */
