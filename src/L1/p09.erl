-module(p09).
-export([pack/1]).

pack(L) ->
  pack(L, [], []).

pack([H|T], [], A2) ->
  pack(T, [H], A2);

pack([H|T], [H|_] = A1, A2) ->
  pack(T, [H | A1], A2);

pack([H|T], A1, A2) ->
  pack(T, [H], [A1 | A2]);

pack([], A1, A2) ->
  p05:reverse([A1 | A2]).

