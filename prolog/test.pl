#!/usr/bin/swipl -f -q


:- set_prolog_flag(verbose, silent).
:- initialization main.

main :-
  current_prolog_flag(argv, Argv),
  format('Hello World, argv:~w\n', [Argv]),
  halt(0).

response(X, X).