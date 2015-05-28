-module(bs03).
-export([split/2]).

split(Bin, Split) ->
    split(Bin, Split, <<>>, []).

split(<<B:1/binary, Rest/binary>>, Split, <<Acc1, Split/binary>>, Acc2) ->
    split(Rest, Split, <<B:1/binary>>, [Acc1 | Acc2]);

split(<<B:1/binary, Rest/binary>>, Split, Acc1, Acc2) ->
    io:format("Acc1 ~p~n", [Acc1]),
    split(Rest, Split, <<Acc1/binary, B:1/binary>>, Acc2);

split(<<>>, _, Acc1, Acc2) ->
    lists:reverse([Acc1 | Acc2]).