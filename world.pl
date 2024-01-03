:- module(world,[]).

:- use_module(library(clpfd)).
:- use_module(library(yall)).
:- use_module(library(apply)).
:- use_module(library(apply_macros)).
:- use_module(library(random)).

create_world(Size, world{eternals: Eternals, fluents: Fluents}) :-
    init_eternals(Size, Rooms, Wumpus),
    Eternals = _{rooms: Rooms, wumpus: Wumpus}.

init_eternals(Size, Rooms, Wumpus) :-
    WorldSize #= (Size + 2) * (Size + 2),
	LimXInf #= 0, LimYInf #= 0,
	LimXSup #= Size + 1, LimYSup #= Size + 1,
    %NPits #= Size,
    length(Rooms, WorldSize),
    foldl(
        {LimXInf,LimXSup,LimYInf,LimYSup}/[Room, [X0,Y0], [X,Y]]>>(
            create_room(X0,LimXInf,LimXSup,Y0,LimYInf,LimYSup,Room),
            calc_coords(X0,Y0,LimXSup,X,Y)
        ),
        Rooms, [LimXInf,LimYInf], _
    ),
    create_wumpus(Size, Wumpus).

calc_coords(X0,Y0,LimXSup,X1,Y1) :-
	(( X0 #= LimXSup) #==> (X1 #= 0 #/\ Y1 #= Y0 + 1) ) #/\
	(( X0 #\=  LimXSup) #==> (X1 #= X0 +1 #/\ Y1 #= Y0)).

create_room(1, _, _, 1, _, _, exit(1,1)) :- !.
create_room(X, X, _, Y, _, _, wall(X,Y)) :- !.
create_room(X, _, X, Y, _, _, wall(X,Y)) :- !.
create_room(X, _, _, Y, Y, _, wall(X,Y)) :- !.
create_room(X, _, _, Y, _, Y, wall(X,Y)) :- !.
create_room(X, _, _, Y, _, _, pit(X,Y))  :-
    maybe(0.2), !.
create_room(X, _, _, Y, _, _, room(X,Y)) :- !.

create_wumpus(Size, Wumpus) :-
    random_between(1, Size, WumpusX),
    random_between(1, Size, WumpusY),
    ((WumpusX = 1, WumpusY = 1) -> (create_wumpus(Size,Wumpus)) ; (Wumpus = wumpus(WumpusX,WumpusY)) ).
