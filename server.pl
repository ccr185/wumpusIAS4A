:- use_module(library(http/http_server)).

:- initialization http_server(http_dispatch, [port(8080)]).

:- http_handler(root(sim), handle_sim_request, []).