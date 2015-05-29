-module(bs01).
-export([fw/1, fw1/1, fw2/1, fw3/1]).

fw(Bin) when is_binary(Bin) -> fw(Bin, <<>>).
fw(<<" ", _Rest/binary>>, Acc)-> Acc;
fw(<<B, Rest/binary>>,  Acc)-> fw(Rest, <<Acc/binary, B>>);
fw(<<>>,  Acc)-> Acc.


fw1(Bin) when is_binary(Bin) ->
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

fw2(Bin) when is_binary(Bin) ->
    Self = self(),
    [begin
         Reg = lists:member(spawn_fw, registered()),
         if not Reg ->
                Foo = fun(Fun, Acc, P) -> 
                              receive
                                  {msg, B1} -> 
                                      Fun(Fun, <<Acc/binary, B1/binary>>, P);
                                  stop -> 
                                      P ! Acc;
                                  _ -> exit
                              end
                      end,
                Start = fun() -> Foo(Foo, <<>>, Self) end,
                Pid = spawn(Start),
                register(spawn_fw, Pid);
            true -> do_nothing
         end,
         if <<B>> == <<" ">> -> spawn_fw ! stop; true -> spawn_fw ! {msg, <<B>>} end 
     end || <<B>> <= Bin ],
    receive
        Msg -> Msg
    after
        1000 -> timeout
    end.


fw3(Bin) when is_binary(Bin) ->
    put(space, false),
    << << (begin 
         Space = get(space),
         case <<B>> of
             <<" ">> when Space == false -> put(space, true), <<>>;
             <<B>> when Space == false -> <<B>>;
             _ -> <<>>
          end
    end)/binary >> || <<B>> <= Bin >>.
