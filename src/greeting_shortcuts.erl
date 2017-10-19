-module(greeting_shortcuts).
-compile(export_all).

render_ok(Req, TemplateModule, Params) ->
    render_ok(Req, [], TemplateModule, Params).

render_ok(Req, Headers, TemplateModule, Params) ->
    {ok, Output} = TemplateModule:render(Params),
    Req:ok({"text/html", Headers, Output}).

get_cookie_value(Req, Key, Default) ->
    case Req:get_cookie_value(Key) of
        undefined -> Default;
        Value -> Value
    end.