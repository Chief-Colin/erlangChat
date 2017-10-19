
%%Author CollinsAdomako, 2017
%% me@collinsadomko.org

-module(tablesdb).
-compile(export_all).

-include("records.hrl").
-include_lib("stdlib/include/qlc.hrl").

reset() ->
    mnesia:stop(),
    mnesia:delete_schema([node()]),
    mnesia:create_schema([node()]),
    mnesia:start(),

    mnesia:create_table(user, [{disc_copies, [node()]}, {attributes, record_info(fields, user)}]),
    mnesia:create_table(chat, [{disc_copies, [node()]}, {attributes, record_info(fields, chat)}]).

find(Q) ->
    F = fun() ->
            qlc:e(Q)
    end,
    transaction(F).

count(Q) ->
    F = fun() ->
            length(qlc:e(Q))
    end,
    transaction(F).

limit(Table, Offset, Number) -> 
    TH = qlc:keysort(2, mnesia:table(Table)), 
    QH = qlc:q([Q || Q <- TH]), 
    QC = qlc:cursor(QH), 
    %% Change initial resuls. Handling of Offset =:= 0 not shown. 
    qlc:next_answers(QC, Offset - 1), 
    Results = qlc:next_answers(QC, Number), 
    qlc:delete_cursor(QC), 
    Results.

transaction(F) ->
    case mnesia:transaction(F) of
        {atomic, Result} ->
            Result;
        {aborted, _Reason} ->
            []
    end.

