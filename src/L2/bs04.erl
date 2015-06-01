-module(bs04).
-export([decode_xml/1]).

decode_xml(BinXml) ->
    decode_xml(BinXml, start_open_tag, <<>>, <<>>, []).


decode_xml(<<"<", Rest/binary>>, start_open_tag, Acc, Acc1, Acc2) ->
    decode_xml(Rest, open_tag, Acc, Acc1, Acc2);

decode_xml(<<">", Rest/binary>>, open_tag, Acc, Acc1, Acc2) ->
    decode_xml(Rest, start_close_tag, <<>>, Acc1, [Acc | Acc2]);

decode_xml(<<B:1/binary, Rest/binary>>, open_tag, Acc, Acc1, Acc2) ->
    decode_xml(Rest, open_tag, <<Acc/binary, B:1/binary>>, Acc1, Acc2);

decode_xml(<<"</", Rest/binary>>, start_close_tag, Acc, Acc1, Acc2) ->
    decode_xml(Rest, close_tag, Acc, Acc1, Acc2);

decode_xml(<<">", Rest/binary>>, close_tag, Acc, Acc1, Acc2) ->
    decode_xml(Rest, start_open_tag, <<>>, Acc1, [Acc | Acc2]);

decode_xml(<<B:1/binary, Rest/binary>>, close_tag, Acc, Acc1, Acc2) ->
    decode_xml(Rest, close_tag, <<Acc/binary, B:1/binary>>, Acc1, Acc2);

decode_xml(<<B:1/binary, Rest/binary>>, start_close_tag, Acc, Acc1, Acc2) ->
    decode_xml(Rest, start_close_tag, Acc, <<Acc1/binary, B:1/binary>>, Acc2);

decode_xml(<<>>, _, Acc, Acc1, Acc2) ->
    [Acc, Acc1, Acc2].

