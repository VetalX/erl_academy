-module(bs01).
-export([first_word/1, fw/1]).

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

fw(Bin) ->
    Self = self(),
    Foo = fun(Fun, Acc, P) -> 
                  receive
                      {msg, B} -> 
                          Fun(Fun, <<Acc/binary, B/binary>>, P);
                      stop -> 
                          P ! Acc;
                      _ -> exit
                  end
          end,
    [begin
         Reg = lists:member(spawn_fw, registered()),
         if not Reg ->
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
