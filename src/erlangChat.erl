%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc erlangChat.

-module(erlangChat).
-author("Mochi Media <dev@mochimedia.com>").
-export([start/0, stop/0]).

ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.


%% @spec start() -> ok
%% @doc Start the erlangChat server.
start() ->
    erlangChat_deps:ensure(),
    ensure_started(crypto),
    application:start(erlangChat),
    application:start(tables),
    ensure_started(mnesia).


%% @spec stop() -> ok
%% @doc Stop the erlangChat server.
stop() ->
    application:stop(erlangChat).
