:- module(wumpus, []).
%%% Wumpus world simulator
%%% IAS 4A - ESIEA
%%% By: Camilo Correa Restrepo
%%%

%%% Entrypoint - Generate the world state
init(Request, Response) :-
    _{size:Size} :< Request,
    create_world(Size).

%% handle sim request
sim_step(Request, Response) :-
    _{action:Action} :< Request,
    sim(Action, Response).