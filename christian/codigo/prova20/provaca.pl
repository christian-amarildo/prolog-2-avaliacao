add_vertice(V) :- \+ vertice(V), assertz(vertice(V)), format('Vertice ~w adicionado.~n', V), assertz(msg_log('Adicionou vertice.')), !.
add_vertice(V) :- vertice(V), format('Vertice ~w ja existe.~n', V), assertz(msg_log('Nao foi possivel adicionar o vertice.')).

add_aresta(D, P) :- vertice(D), vertice(P), \+ aresta(D, P), assertz(aresta(D, P)), assertz(aresta(P, D)), format('Aresta de ~w para ~w adicionada.~n', [D, P]), assertz(msg_log('Adicionou aresta.')),!.
add_aresta(D, P) :- (\+ vertice(D) ; \+ vertice(P) ; aresta(D, P)), format('Pontos nao existem ou aresta de ~w para ~w ja existe.~n', [D, P]) ,assertz(msg_log('Nao foi possivel adicionar a aresta.')).

add_objeto(O, L) :- vertice(L), assertz(obj(O, L)), format('Objeto ~w adicionado.~n', O), assertz(msg_log('Adicionou objeto.')), !.
add_objeto(_, L) :- \+ vertice(L), format('Local ~w nao existe.~n', L), assertz(msg_log('Nao foi possivel adicionar objeto.')).

inspecionar :- lanterna(ligada), energia(X), X >= 10, X1 is X - 10, 
                retract(energia(X)), assertz(energia(X1)), 
                format('Energia de ~w para ~w.~n', [X, X1]), ((X1 =< 0, format('Energia esgotada. Robo nao pode mais atuar no ambiente!~n'), ! ); true),
                obj(robo, P), findall(O, (obj(O, P), O \== robo), R), 
                format('Robo esta em ~w.~nObjetos no local: ~w.~n', [P, R]), assertz(msg_log('Inspecao.')), !.

inspecionar :- format('Robo nao pode inspecionar.~n'), assertz(msg_log('Nao foi possivel inspecionar.')).

pegar(O) :- obj(robo, P), obj(O, P), O \== robo, O \== carregador, lanterna(ligada), inspecionar, energia(X), X >= 5, X1 is X - 5, 
            retract(energia(X)), assertz(energia(X1)),
            format('Energia de ~w para ~w.~n', [X, X1]), ((X1 =< 0, format('Energia esgotada. Robo nao pode mais atuar no ambiente!~n'), ! ); true),
            findall(A, mochila_item(A), R), length(R, N), 
            ((N is 0, retract(obj(O, P)), assertz(mochila_item(O)));
            (N is 1, ((member(chave, R), O \== chave, retract(obj(O, P)), assertz(mochila_item(O))) ;
                    (\+ member(chave, R), O == chave, retract(obj(O, P)), assertz(mochila_item(O)))))),
            format('Robo pegou ~w em ~w.~n', [O, P]), assertz(msg_log('Pegou objeto.')),!.

pegar(O) :- format('Nao foi possivel pegar ~w.~n', O), assertz(msg_log('Nao foi possivel pegar objeto.')).


soltar(O) :- mochila_item(O), energia(X), X >= 5, X1 is X - 5,
                retract(energia(X)), assertz(energia(X1)),
                format('Energia de ~w para ~w.~n', [X, X1]), ((X1 =< 0, format('Energia esgotada. Robo nao pode mais atuar no ambiente!~n'), !); true),
                obj(robo, P), assertz(obj(O, P)), retract(mochila_item(O)), 
                format('~w soltado em ~w.~n', [O, P]), assertz(msg_log('Soltou objeto.')), !.

soltar(O) :- format('Nao foi possivel soltar ~w.~n', O), assertz(msg_log('Nao foi possivel soltar objeto.')).

caminhar(Para) :- obj(robo, De), vertice(Para), aresta(De, Para), energia(X), 
                    ((X >= 5, lanterna(desligada), X1 is X - 5) ; (X >= 10, lanterna(ligada), X1 is X - 10)), 
                    retract(energia(X)), assertz(energia(X1)),
                    format('Energia de ~w para ~w.~n', [X, X1]), ((X1 =< 0, format('Energia esgotada. Robo nao pode mais atuar no ambiente!~n'), !) ; true),
                    retract(obj(robo, De)), assertz(obj(robo, Para)),
                    format('Robo foi de ~w para ~w.~n', [De, Para]), assertz(msg_log('Caminhou.')),!.

caminhar(Para) :- obj(robo, De), format('Nao foi possivel andar de ~w para ~w.~n', [De, Para]), assertz(msg_log('Nao foi possivel caminhar.')).

ligar_lanterna :- retract(lanterna(_)), assertz(lanterna(ligada)), format('Lanterna ligada!~n'), assertz(msg_log('Ligou lanterna.')).
desligar_lanterna :- retract(lanterna(_)), assertz(lanterna(desligada)), format('Lanterna desligada!~n'), assertz(msg_log('Desligou lanterna.')).

mochila :- findall(O, mochila_item(O), []), format('Mochila vazia!~n'), assertz(msg_log('Mochila esta vazia.')), !.
mochila :- findall(O, mochila_item(O), R), format('Objetos na mochila: ~w.~n', R), assertz(msg_log('Ver objetos na mochila.')).

carregar :- obj(robo, P), obj(carregador, P), retract(energia(_)), assertz(energia(100)), format('Robo carregado! Energia 100%.~n'), assertz(msg_log('Robou recarregou.')), !.
carregar :- format('Nao foi possivel carregar o Robo.~n'), assertz(msg_log('Nao foi possivel recarregar o robo.')).

status_robo :- obj(robo, P), lanterna(L), energia(E), findall(O, mochila_item(O), R), length(R, N), format('Local: ~w.~nLanterna: ~w.~nEnergia: ~w %.~nMochila: ~w item(s).~n', [P, L, E, N]), assertz(msg_log('Ver status do robo.')).

log :- findall(X, msg_log(X), Logs), listar_logs(Logs).

listar_logs([]) :- !.
listar_logs([H|T]) :- format('- ~w ~n', H), listar_logs(T).

salvar(Arquivo) :- tell(Arquivo), listing(vertice), listing(aresta), listing(obj), listing(lanterna), listing(energia), listing(mochila_item), listing(msg_log), told.