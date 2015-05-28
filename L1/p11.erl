-module(p11).
-export([encode_modified/1]).

encode_modified(L) ->
  encode_modified(p09:pack(L), []).

encode_modified([[H]|T], Acc) ->
  encode_modified(T, [H | Acc]);

encode_modified([H = [H1|_] |T], Acc) ->
  encode_modified(T, [{p04:len(H), H1} | Acc]);

encode_modified([], Acc) ->
  p05:reverse(Acc).
