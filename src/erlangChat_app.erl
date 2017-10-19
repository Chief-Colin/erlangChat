%% @author Mochi Media <dev@mochimedia.com>
%% @copyright erlangChat Mochi Media <dev@mochimedia.com>

%% @doc Callbacks for the erlangChat application.

-module(erlangChat_app).
-author("Mochi Media <dev@mochimedia.com>").

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for erlangChat.
start(_Type, _StartArgs) ->
    erlangChat_deps:ensure(),
    erlangChat_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for erlangChat.
stop(_State) ->
    ok.
