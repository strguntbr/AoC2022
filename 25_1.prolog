 day(25). testResult("2=-1=0").

:- use_module(lib/solve).

snafu_digit(S, D) :- number_string(D, S), between(0, 2, D).
snafu_digit("-", -1).
snafu_digit("=", -2).

snafu_number("", 0) :- !.
snafu_number(Snafu, Number) :- number(Number), !,
  LastDigit is mod(Number+2, 5) - 2, RemainingNumber is div(Number+2, 5),
  snafu_digit(LastSnafuDigit, LastDigit), snafu_number(OtherSnafuDigits, RemainingNumber),
  string_concat(OtherSnafuDigits, LastSnafuDigit, Snafu).
snafu_number(Snafu, Number) :-
  sub_string(Snafu, _, 1, 0, LastSnafuDigit), sub_string(Snafu, 0, _, 1, OtherSnafuDigits),
  snafu_digit(LastSnafuDigit, LastDigit), snafu_number(OtherSnafuDigits, RemainingNumber),
  Number is LastDigit + 5*RemainingNumber.
  
result(Snafus, Result) :-
  maplist(snafu_number, Snafus, Numbers), sumlist(Numbers, Sum),
  snafu_number(Result, Sum).
