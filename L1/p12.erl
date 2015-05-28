-module(p12).
-export([decode_modefied/1]).

decode_modefied(L) ->
  decode_modefied(L, []). 

decode_modefied([{0, _} | T], Acc) ->
  decode_modefied(T, Acc);

decode_modefied([{Len, El} | T], Acc) ->
  decode_modefied([{Len-1, El} | T], [El | Acc]);

decode_modefied([H|T], Acc) ->
  decode_modefied(T, [H | Acc]);

decode_modefied([], Acc) ->
  p05:reverse(Acc).

