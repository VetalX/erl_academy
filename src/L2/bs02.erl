-module(bs02).
-export([words/1]).

words(Bin) ->
    words(Bin, <<>>, []).

words(<<" ", Rest/binary>>, Acc1, Acc2) ->
    words(Rest, <<>>, [Acc1 | Acc2]);

words(<<B:1/binary, Rest/binary>>, Acc1, Acc2) ->
     words(Rest, <<Acc1/binary, B:1/binary>>, Acc2);
 
 words(<<>>, Acc1, Acc2) ->
     lists:reverse([Acc1 | Acc2]).