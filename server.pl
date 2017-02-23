:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(lists)).

:- http_handler(root(api), handle, []).	


server(Port) :-						% (2)
        http_server(http_dispatch, [port(Port)]).

handle(Request) :-
        http_read_json(Request, JSONIn),
        json_to_prolog(JSONIn, PrologIn),
        process_request(PrologIn, PrologOut),
        prolog_to_json(PrologOut, JSONOut),
        reply_json(JSONOut).

process_request(PrologIn, PrologOut):-
        PrologIn = json(List),
        select(message=Text, List, List2),
        answer(Text, Answer),
        append(List2, [message=Answer], List3),
        PrologOut = json(List3).         % application body

answer(Text, Answer):-
    Text = Answer.

:- server(5001).