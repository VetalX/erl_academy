-module(p13).
-export([decode/1]).

decode(L) ->
  decode(L, []). 

decode([{0, _} | T], Acc) ->
  decode(T, Acc);

decode([{Len, El} | T], Acc) ->
  decode([{Len-1, El} | T], [El | Acc]);

decode([], Acc) ->
  p05:reverse(Acc).

