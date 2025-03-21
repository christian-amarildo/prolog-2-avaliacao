%Questão 01
:- dynamic lampada/1.
lampada(apagada).

liga :- retract(lampada(_)),
        asserta(lampada(acesa)).

desliga :- retract(lampada(_)),
            asserta(lampada(apagada)).

%Questão 02
:- dynamic lampada/1.
lampada(apagada).

liga :- retract(lampada(_)),
        memorize(lampada(acesa)).

desliga :- retract(lampada(_)),
            memorize(lampada(apagada)).

memorize(Predicado) :- \+ Predicado, asserta(Predicado).

% Questão 03: Configuração da casa
:- dynamic pos/2.

pos(tv, sala).
pos(bola, quarto).
pos(carteira, quarto).
pos(chave, garagem).
pos(robo, garagem).

% Questão 04: Movimentação do robô
ande(Destino) :-
    pos(robo, Origem),
    retract(pos(robo, Origem)),
    asserta(pos(robo, Destino)),
    format('Robô, ande de ~w para ~w~n', [Origem, Destino]).

% Questão 05: Localização do robô
onde :-
    pos(robo, X),
    format('O robô está na ~w~n', [X]).

% Questão 06: Objetos no ambiente
objetos :-
    pos(robo, Local),
    findall(Objeto, (pos(Objeto, Local), dif(Objeto, robo)), Objetos),
    write(Objetos), nl.

% Questão 07: Pegar objetos
:- dynamic mochila/1.

pegue(Objeto) :-
    pos(robo, Local),
    pos(Objeto, Local),
    dif(Objeto, robo),
    retract(pos(Objeto, Local)),
    assertz(mochila(Objeto)),
    format('O robô colocou a ~w na mochila~n', [Objeto]).

% Questão 08: Conteúdo da mochila
listar_mochila :-
    findall(X, mochila(X), Itens),
    write(Itens), nl.

% Questão 09: Soltar objetos
solte(Objeto) :-
    mochila(Objeto),
    pos(robo, Local),
    retract(mochila(Objeto)),
    assertz(pos(Objeto, Local)),
    format('O robô soltou a ~w na ~w~n', [Objeto, Local]).
