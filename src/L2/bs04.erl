-module(bs04).
-export([decode_xml/1]).

decode_xml(BinXml) ->
    decode_xml(BinXml, open_tag, <<>>, []).

decode_xml(<<"</", _Rest/binary>> = Bin, open_tag, Acc1, Acc2) ->
    decode_xml(Bin, close_tag, Acc1, Acc2);

decode_xml(<<"<", Rest/binary>>, open_tag, Acc1, Acc2) ->
    decode_xml(Rest, open_tag, Acc1, Acc2);

decode_xml(<<">", Rest/binary>>, open_tag, Acc1, Acc2) ->
    decode_xml(Rest, body, <<>>, [{Acc1, [], []} | Acc2]);  %%open_tag

decode_xml(<<B:1/binary, Rest/binary>>, open_tag, Acc1, Acc2) ->
    decode_xml(Rest, open_tag, <<Acc1/binary, B:1/binary>>, Acc2);

decode_xml(<<"<", _Rest/binary>> = Bin, body, <<>>, Acc2) ->
    decode_xml(Bin, open_tag, <<>>, Acc2);

decode_xml(<<"</", _Rest/binary>> = Bin, body, Acc1, Acc2) ->
    NewAcc2 = push_text_body(Acc1, Acc2),
    decode_xml(Bin, close_tag, <<>>, NewAcc2); %% save body

decode_xml(<<B:1/binary, Rest/binary>>, body, Acc1, Acc2) ->
    decode_xml(Rest, body, <<Acc1/binary, B:1/binary>>, Acc2);

decode_xml(<<"</", Rest/binary>>, close_tag, Acc1, Acc2) ->
    decode_xml(Rest, close_tag, Acc1, Acc2);

decode_xml(<<">", Rest/binary>>, close_tag, Acc1, Acc2) ->
    NewAcc2 = push_close_tag(Acc1, Acc2),
    decode_xml(Rest, open_tag, <<>>, NewAcc2); %% close_tag

decode_xml(<<B:1/binary, Rest/binary>>, close_tag, Acc1, Acc2) ->
    decode_xml(Rest, close_tag, <<Acc1/binary, B:1/binary>>, Acc2);

decode_xml(_, _, <<>>, Acc2) ->
    lists:reverse(Acc2).

push_text_body(Text, [{TagName, [], []} | T]) ->
    [{TagName, [], [Text]} | T].

push_close_tag(TagName, [{TagName, [], Body}]) -> %% root element
    [{TagName, [], lists:reverse( Body )}];

push_close_tag(TagName, [{TagName, [], TagBody} | [{ParentTag, [], ParentBody} | ParentTail ]]) ->
    [{ParentTag, [], [{TagName, [], lists:reverse(TagBody) } | ParentBody] } | ParentTail].