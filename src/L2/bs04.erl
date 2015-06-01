-module(bs04).
-export([decode_xml/1]).

decode_xml(BinXml) ->
    decode_xml(BinXml, open_tag, <<>>, []).

decode_xml(<<"</", _Rest/binary>> = Bin, open_tag, Acc1, Acc2) ->
    decode_xml(Bin, close_tag, Acc1, Acc2);

decode_xml(<<"<", Rest/binary>>, open_tag, Acc1, Acc2) ->
    decode_xml(Rest, open_tag, Acc1, Acc2);

decode_xml(<<">", Rest/binary>>, open_tag, Acc1, Acc2) ->
    decode_xml(Rest, body, <<>>, [<<"open_tag_", Acc1/binary>> | Acc2]);

decode_xml(<<B:1/binary, Rest/binary>>, open_tag, Acc1, Acc2) ->
    decode_xml(Rest, open_tag, <<Acc1/binary, B:1/binary>>, Acc2);

decode_xml(<<"<", _Rest/binary>> = Bin, body, <<>>, Acc2) ->
    decode_xml(Bin, open_tag, <<>>, Acc2);

decode_xml(<<"</", _Rest/binary>> = Bin, body, Acc1, Acc2) ->
    decode_xml(Bin, close_tag, <<>>, [<<"body_", Acc1/binary>> | Acc2]);

decode_xml(<<"<", _Rest/binary>> = Bin, body, Acc1, Acc2) ->
    decode_xml(Bin, open_tag, <<>>, [<<"body_", Acc1/binary>> | Acc2]);

decode_xml(<<B:1/binary, Rest/binary>>, body, Acc1, Acc2) ->
    decode_xml(Rest, body, <<Acc1/binary, B:1/binary>>, Acc2);

decode_xml(<<"</", Rest/binary>>, close_tag, Acc1, Acc2) ->
    decode_xml(Rest, close_tag, Acc1, Acc2);

decode_xml(<<">", Rest/binary>>, close_tag, Acc1, Acc2) ->
    decode_xml(Rest, open_tag, <<>>, [<<"close_tag_", Acc1/binary>> | Acc2]);

decode_xml(<<B:1/binary, Rest/binary>>, close_tag, Acc1, Acc2) ->
    decode_xml(Rest, close_tag, <<Acc1/binary, B:1/binary>>, Acc2);

decode_xml(_, _, Acc1, Acc2) ->
    {Acc1, lists:reverse(Acc2)}.