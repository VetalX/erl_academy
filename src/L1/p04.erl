-module(p04).
-export([len/1]).

len(L) ->
  len(L, 0).

len([_H|T], A) ->
  len(T, A+1);

len([], Acc) ->
  Acc.
