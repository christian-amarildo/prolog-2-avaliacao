:- dynamic vertice/1
:- dynamic aresta/2
:- dynamic obj/2


:- add_vertice(local):- \+vertice(local),assertz(local),format('O Local ~w foi inserido ~n', [local]), !.
:- add_vertice(_):- write('Local já existe ñ').


:- add_aresta(local1,Local2):- \+vertice(local1,Local2),assertz(local1,local2),assertz(local2,local1),format('a aresta ~w foi inserido ~n', [local1,local2]), !.
:- add_aresta(_):- write('Aresta já existe ñ').

:- add_obj(local,objeto):- \+vertice(local), assertz(obj(objeto,local)), format('O objeto ~w foi posto em ~w~n', [objeto, Local]), !.
:- add_obj(_):- write('Local não existe ñ').

:- inspecionar:- obj(robo, Local), 