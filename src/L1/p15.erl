-module(p15).
-export([replicate/2]).

replicate(L, Len) ->
  replicate(L, Len, Len, []).

replicate([_|T], InitLen, 0, Acc) ->
  replicate(T, InitLen, InitLen, Acc);

replicate(L = [H|_], InitLen, Len, Acc) ->
  replicate(L, InitLen, Len-1, [H | Acc]);

replicate([], _, _, Acc) ->
  p05:reverse(Acc).
