-module(p02).
-export([but_last/1]).

but_last(L = [_, _]) ->
  L;

but_last([_H|T]) ->
  but_last(T).
