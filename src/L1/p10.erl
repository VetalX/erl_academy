-module(p10).
-export([encode/1]).

encode(L) ->
  encode(p09:pack(L), []).

encode([L = [H1|_]|T2], Acc) ->
  encode(T2, [{p04:len(L), H1} | Acc]);

encode([], Acc) ->
  p05:reverse(Acc).
