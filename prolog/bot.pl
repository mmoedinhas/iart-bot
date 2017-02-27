#!/usr/bin/swipl -f -q
:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).


:- set_prolog_flag(verbose, silent).
:- initialization main.

/*main :-
  read(X),
  current_prolog_flag(argv, Argv),
  format('Hello World, argv:~w\n', [Argv]),
  halt(0).
*/
/*main :-
  repeat,
  read_line_to_codes(user_input, List),
  string_to_list(String, List),
  response(String, Out),
  write(Out),
  flush_output(user_output),
  fail.

response(JSONIn, JSONOut) :-
  json_to_prolog(JSONIn, PrologIn),
  process_request(PrologIn, PrologOut),
  prolog_to_json(PrologOut, JSONOut),

process_request(PrologIn, PrologOut):-
  PrologIn = json(List),
  select(body=Text, List, List2),
  answer(Text, Answer),
  append(List2, [body=Answer], List3),
  PrologOut = json(List3).

answer(Text, Answer):-
  Text = Answer.
  */

main :-
  repeat,
  json_read(user_input, JSONIn),
  process_request(JSONIn, JSONOut),
  json_write(user_output, JSONOut),
  flush_output(user_output),
  fail.

process_request(JSONIn, JSONOut):-
  JSONIn = json(List),
  select(body=Message, List, _),
  select(senderID=Sender, List, _),
  answer(Sender, Message, Answer),
  JSONOut = json([senderID=Sender,body=Answer]).

answer(_Sender, Text, Answer):-
  Answer = Text.