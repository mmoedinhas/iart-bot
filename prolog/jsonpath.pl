:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).

%:- open('teste.json', read, Str), json_read(Str, Result), Result = json([Name, Test|_]), Test = (created=json(Test2)), write(Test2).
%get_json(Stream, String) :- open(Stream, read, Str), json_read(Str, String).

%teste :- get_json('teste.json', JSON), JSONPath = "$.store.book[1].price", compute_jsonpath(JSON, JSONPath, Out).

compute_jsonpath(JSON, JSONPath, Result) :- jsonpath_to_prolog(JSONPath, List), !, interpreter(JSON, List, Result).

jsonpath_to_prolog("", []).
jsonpath_to_prolog(String, [Elem|Result]) :- sub_string(String, Before, _, _, "."),
										sub_string(String, 0, Before, _, Elem),
										NewStringBeg is Before + 1,
										sub_string(String, NewStringBeg, _, 0, NewString),
										jsonpath_to_prolog(NewString, Result).
jsonpath_to_prolog(String, [String|Result]) :- jsonpath_to_prolog("", Result).


interpreter(JSONString, [], JSONString).
interpreter(JSONString, [Path|JSONPath], Result) :- interpreter_aux(JSONString, Path, ResultAux), interpreter(ResultAux, JSONPath, Result).

interpreter_aux(JSON, "$", JSON).
interpreter_aux(JSON, JSONPath, Result) :- sub_string(JSONPath, Before, _, Begin, "["), sub_string(JSONPath, _, _, End, "]"), Length is Begin - End - 1,
											Start is Before + 1, sub_string(JSONPath, Start, Length, _, BetweenBracketsStr), between_brackets(JSON, JSONPath, BetweenBracketsStr, Before, Result).
interpreter_aux(JSON, JSONPath, Result) :- JSON = json(List), atom_string(AtomJPath, JSONPath), member(AtomJPath=Result, List).

between_brackets(JSON, JSONPath, BetweenBracketsStr, BeforeBrackets, Result) :- atom_string(IndexAtom, BetweenBracketsStr),
											atom_number(IndexAtom, Index), sub_string(JSONPath, 0, BeforeBrackets, _, Id), atom_string(AtomJPath, Id),
											JSON = json(List), member(AtomJPath=ResultList, List), nth0(Index, ResultList, Result).

%between_brackets(JSON, JSONPath, BetweenBracketsStr, BeforeBrackets, Result) :- sub_string(BetweenBracketsStr, 0, 1, After, "?"), Length is After - 1
%																				sub_string(BetweenBracketsStr, 2, Length, 1, Result), write(Result).