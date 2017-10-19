-module(greeting_views).
-compile(export_all).
-import(greeting_shortcuts, [render_ok/3, render_ok/4, get_cookie_value/3]).

urls() -> [
      {"^hello/?$", hello},
      {"^hello/(.+?)/?$", hello}
    ].

% Return username input if present, otherwise return username cookie if
% present, otherwise return "Anonymous"
get_username(Req, InputData) ->
    proplists:get_value("username", InputData,
        get_cookie_value(Req, "username", "Collins")).

make_cookie(Username) ->
    mochiweb_cookies:cookie("username", Username, [{path, "/"}]).

handle_hello(Req, InputData) ->
    Username = get_username(Req, InputData),
    Cookie = make_cookie(Username),
    render_ok(Req, [Cookie], erlangChat_dtl, [{username, Username}]).

hello('GET', Req) ->io:format("~nUser : ~p~n", [Req:parse_qs()]),
    handle_hello(Req, Req:parse_qs());
hello('POST', Req) ->io:format("~nUser : ~p~n", [Req:parse_post()]),
    handle_hello(Req, Req:parse_post()).

hello('GET', Req, Username) -> io:format("~nUser : ~p~n", [Username]),
    Cookie = make_cookie(Username), 
    render_ok(Req, [Cookie], erlangChat_dtl, [{username, Username}]);
hello('POST', Req, Username) ->io:format("~nUser : ~p~n", [Username]),
Cookie = make_cookie(Username),
   render_ok(Req, [Cookie], greeting_dtl, [{username, Username}]).