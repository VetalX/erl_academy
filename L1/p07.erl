-module(p07).
-export([flatten/1]).

flatten(L) ->
  p05:reverse(flatten(L, [])).

flatten([], Acc) ->
  Acc;

flatten([H | T], Acc) ->
  flatten(T, flatten(H, Acc));

flatten(H, Acc) ->
  flatten([] ,[H | Acc]).
