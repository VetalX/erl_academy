-module(bs03).
-export([split/2]).

split(Bin, Split) when is_binary(Split) ->
    SplitSize = byte_size(Split),
    split(Bin, SplitSize, Split, <<>>, []);

split(Bin, Split) when is_list(Split) ->
    SplitBin = list_to_binary(Split),
    SplitSize = byte_size(SplitBin),
    split(Bin, SplitSize, SplitBin, <<>>, []).

split(Bin, SplitSize, Split, Acc1, Acc2) ->
    case Bin of
        <<Split:SplitSize/binary, Rest/binary>> ->
            split(Rest, SplitSize, Split, <<>>, [Acc1 | Acc2]);
        <<B:1/binary, Rest/binary>> ->
            split(Rest, SplitSize, Split, <<Acc1/binary, B:1/binary>>, Acc2);
        <<>> ->
            lists:reverse([Acc1 | Acc2])
    end.