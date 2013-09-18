%% @author Sina Samavati <sina.samv@gmail.com>

-module(leptus).
-author("Sina Samavati <sina.samv@gmail.com>").

-export([start/0]).
-export([start_http/1]).


start() ->
    start_http({module, []}).

start_http({modules, Mods}) ->
    ensure_started(crypto),
    ensure_started(ranch),
    ensure_started(cowboy),
    Dispatch = cowboy_router:compile(leptus_router:dispatches(Mods)),
    {ok, _} = cowboy:start_http(http, 100, [{port, 8080}],
                                [{env, [{dispatch, Dispatch}]}]).


%% internal
ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.
