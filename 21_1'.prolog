 day(21). testResult(152).

:- use_module(lib/solve).
:- use_module(library(clpq)).


result(Equations, Result) :-
    foldl([L,R,F]>>foldl(string_concat,[L,",",R], "", F), Equations, "", FoldedEquations), /* Concatenate all the lines separated with ',' */
    foldl(string_concat, ["}", FoldedEquations, "{Result=ROOT"], "", AllEquations), /* Predend the concatenated lines with 'Result=ROOT' (to have the result in the first variable) and wrap everything in '{' ... '}' */
    term_string(Term, AllEquations), term_variables(Term, [Result|_]), Term. /* Convert the string to a term, evaluate it and return the value of the first variable */

/* required for loadData */
data_line(Term, Line) :- re_replace(":", "=", Line, T), string_upper(T, Term). /* Replace ':' with '=' and make everything uppercase to make prolog recognize the variables */
