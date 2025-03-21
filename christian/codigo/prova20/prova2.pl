:-dynamic vertice/1.
:-dynamic aresta/2.
:-dynamic obj/2.

:-dynamic lanterna/1.
:-dynamic energia/1.
:-dynamic mochila/1.

:-dynamic log/1.

log_query(Predicado):-assertz(log(Predicado)), call(Predicado).


energia(100).
lanterna(ligada).

desligar_lanterna:-retract(lanterna(_)), assertz(lanterna(desligada)).
ligar_lanterna:-retract(lanterna(_)), assertz(lanterna(ligada)).



add_vertice(Local):- \+vertice(Local), assertz(vertice(Local)), format('O Local ~w foi inserido ~n', [Local]), !.

add_vertice(_):- write('Local já existe ~n').

add_aresta(Local1, Local2):- \+aresta(Local1, Local2), assertz(aresta(Local1, Local2)),
 assertz(aresta(Local2, Local1)), format('A aresta entre ~w e ~w foi criada ~n', [Local1, Local2]), !.

add_vertice(_, _):- write('Aresta já existe ~n').

add_obj(Obj, Local):- vertice(Local), assertz(obj(Obj, Local)), format('O objeto ~w foi posto em ~w~n', [Obj, Local]), !.

add_obj(_, _):- write('Local não existe ~n').


inspecionar:- obj(robo, Local),  lanterna(ligada), reduzir_energia(10), findall(Obj, obj(Obj, Local), L), format('O robo está em ~w e neste local estão ~w',[Local,L]), !.

inspecionar:- write('Não foi possível inespecionar o comodo por falta de energia ou lanterna desligada').

reduzir_energia(A):- energia(Ener),Ener>= A,X is Ener - A, retract(energia(_)), assertz(energia(X)), !.

reduzir_energia(_):- write('O robo não tem mais energia para efeturar essa ação').

pegar(robo):- write('Ação não permitida'), !.
pegar(carregador):- write('Ação não permitida'), !.
pegar(Obj):- inspecionar, obj(robo, Local), obj(Obj, Local),
\+mochila(Obj), findall(C, mochila(C), L), length(L, Tam), 
Tam = 0,retract(obj(Obj, Local)), assertz(mochila(Obj)),reduzir_energia(5), write('~nO objeto foi coletado'),  !.

pegar(Obj):- inspecionar, obj(robo, Local), obj(Local, Obj),
\+mochila(Obj), findall(C, mochila(C), L), length(L, Tam), Tam=1,
mochila(chave),retract(obj(Local, Obj)), assertz(mochila(obj)),reduzir_energia(5),write('O objeto foi coletado'), !.

pegar(chave):- inspecionar, obj(robo, Local), obj(Local, Obj),
\+mochila(chave), findall(C, mochila(C), L), length(L, Tam), 
Tam=1,retract(obj(Local, Obj)),assertz(mochila(obj)),reduzir_energia(5),write('O objeto foi coletado'), !.

pegar(_):- write('Não foi possivel pegar o objeto').

soltar(Obj):- obj(robo, Local), mochila(Obj), retract(mochila(Obj)), assertz(obj(Obj, Local)),
reduzir_energia(5), write('Objeto solto no Local'), !.

soltar(_):- write('Não foi possivel deixar o objeto no local').


caminhar(Destino):- obj(robo, Local), caminhar(Local,Aux, Destino), format('A sequencia de caminhos foi ~w', [Aux]).

caminhar(Local,Aux, Destino):- aresta(Local, Destino), retract(obj(robo, Local)),  assertz(obj(robo, Destino)), ((lanterna(ligada), reduzir_energia(10)); reduzir_energia(5)), Aux = [Local,Destino],!.

caminhar(Local, Aux, Destino):- aresta(Local, NovoLocal), retract(obj(robo, Local)),  assertz(obj(robo, NovoLocal)), ((lanterna(ligada), reduzir_energia(10)); reduzir_energia(5)),
caminhar(NovoLocal, Aux2, Destino),Aux = [Local|Aux2],!.



carregar:- obj(carregador, Local), obj(robo, Local), retract(energia(_)), assertz(energia(100)).

status_robo:- lanterna(Estado), obj(robo, Local), findall(C, mochila(C), L), length(L, Quanti),
energia(Total), format('O robo está em ~w ~nA lanterna esta ~w~nA quantidade de energia é ~w~n
A quantidade de items na mochila é ~w', [Local, Estado, Total, Quanti]).




