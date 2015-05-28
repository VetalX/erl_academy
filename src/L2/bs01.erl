-module(bs01).
-export([first_word/1]).

first_word(Bin) ->
    Len = first_one([ if <<B>> == <<" ">> -> 1; true -> 0 end || <<B>> <= Bin]),
    <<Word:Len/binary, _Rest/binary>> = Bin,
    Word.

first_one(L) ->
    first_one(L, 0).

first_one([1|_T], Acc) ->
    Acc;

first_one([_|T], Acc) ->
    first_one(T, Acc+1);

first_one([], Acc) ->
    Acc.