%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc Web server for erlangChat.

-module(erlangChat_web).
-author("Mochi Media <dev@mochimedia.com>").

-export([start/1, stop/0, loop/2, get_value/2]).
-include_lib("kernel/include/file.hrl").

%% External API

start(Options) ->
    {DocRoot, Options1} = get_option(docroot, Options),
    Loop = fun (Req) ->
                   ?MODULE:loop(Req, DocRoot)
           end,
    mochiweb_http:start([{name, ?MODULE}, {loop, Loop} | Options1]).

stop() ->
    mochiweb_http:stop(?MODULE).

loop(Req, DocRoot) ->
    "/" ++ Path = Req:get(path),
    try
        case Req:get(method) of
            Method when Method =:= 'GET'; Method =:= 'HEAD' ->
                case Path of
                  "hello_world" ->
                    Req:respond({200, [{"Content-Type", "text/plain"}],
                    "Hello world!\n"});
                    _ ->
                        Req:serve_file(Path, DocRoot)
                end;
            'POST' ->
                case Path of
                    _ ->
                         Data = Req:parse_post(),
                        Json = proplists:get_value("json", Data),
                        Struct = mochijson2:decode(Json),
                        
                        
                        io:format("~nStruct : ~p~n", [Data]),
                        
                       Username= struct:get_value(<<"username">>, Struct),
                       Course= struct:get_value(<<"course">>, Struct),
                      Year_Admitted= struct:get_value(<<"year_admitted">>, Struct),
                      Password = struct:get_value(<<"password">>, Struct),
                       Action = list_to_atom(binary_to_list(A)),

                       tables:insert(Username, Course, Year_Admitted, Password);
                       Req:respond({200, [{"Content-Type", "text/plain"}],
                    "YOU HAVE SUCCESSFUL REGISTERED!!\n"})
                end;
            _ ->
                Req:respond({501, [], []})
        end
    catch
        Type:What ->
            Report = ["web request failed",
                      {path, Path},
                      {type, Type}, {what, What},
                      {trace, erlang:get_stacktrace()}],
            error_logger:error_report(Report),
            Req:respond({500, [{"Content-Type", "text/plain"}],
                         "request failed, sorry\n"})
    end.

    %% @spec get_value(path() | key(), struct()) -> value()
get_value(Path, Struct) when is_tuple(Path) ->
  L = tuple_to_list(Path),
  get_val(L, Struct);
get_value(Key, Struct) ->
  {struct, L} = Struct,
  proplists:get_value(Key, L).

  get_val(_, undefined) ->
  undefined;
get_val([Key], Struct) ->
  get_value(Key, Struct);
get_val([Key | T], Struct) ->
  NewStruct = get_value(Key, Struct),
  get_val(T, NewStruct).


%% Internal API

get_option(Option, Options) ->
    {proplists:get_value(Option, Options), proplists:delete(Option, Options)}.

%%
%% Tests
%%
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

you_should_write_a_test() ->
    ?assertEqual(
       "No, but I will!",
       "Have you written any tests?"),
    ok.

-endif.
