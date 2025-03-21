% Definindo os predicados dinâmicos para representar vértices (locais), arestas (conexões entre locais), objetos e outros elementos do robô
:-dynamic vertice/1.  % Define que os vértices (locais) são dinâmicos
:-dynamic aresta/2.    % Define que as arestas (conexões entre dois locais) são dinâmicas
:-dynamic obj/2.       % Define que os objetos no ambiente são dinâmicos (objeto e seu local)

:-dynamic lanterna/1.  % Define o estado da lanterna (ligada ou desligada) como dinâmico
:-dynamic energia/1.   % Define a energia do robô como dinâmico
:-dynamic mochila/1.   % Define os itens na mochila do robô como dinâmico

:-dynamic log/1.       % Define um histórico de ações realizadas (log)

% Predicado para registrar no log a execução de um predicado
log_query(Predicado):- 
    assertz(log(Predicado)),  % Adiciona o predicado no log
    call(Predicado).          % Chama o predicado executado

% Inicializa a energia do robô com 100 e a lanterna ligada
energia(100).
lanterna(ligada).

% Predicado para desligar a lanterna
desligar_lanterna:- 
    retract(lanterna(_)),        % Remove o estado atual da lanterna
    assertz(lanterna(desligada)). % Define a lanterna como desligada

% Predicado para ligar a lanterna
ligar_lanterna:- 
    retract(lanterna(_)),        % Remove o estado atual da lanterna
    assertz(lanterna(ligada)).   % Define a lanterna como ligada

% Predicado para adicionar um vértice (local) ao ambiente
add_vertice(Local):- 
    \+vertice(Local),                  % Verifica se o local não existe
    assertz(vertice(Local)),            % Adiciona o local
    format('O Local ~w foi inserido ~n', [Local]), !.  % Mensagem de sucesso

% Caso o local já exista
add_vertice(_):- 
    write('Local já existe ~n').  % Mensagem de erro

% Predicado para adicionar uma aresta (conexão) entre dois locais
add_aresta(Local1, Local2):- 
    \+aresta(Local1, Local2),                % Verifica se a aresta não existe
    assertz(aresta(Local1, Local2)),          % Cria a aresta entre Local1 e Local2
    assertz(aresta(Local2, Local1)),          % Cria a aresta no sentido contrário
    format('A aresta entre ~w e ~w foi criada ~n', [Local1, Local2]), !.  % Mensagem de sucesso

% Caso a aresta já exista
add_aresta(_, _):- 
    write('Aresta já existe ~n').  % Mensagem de erro

% Predicado para adicionar um objeto em um local do ambiente
add_obj(Obj, Local):- 
    vertice(Local),                             % Verifica se o local existe
    assertz(obj(Obj, Local)),                   % Adiciona o objeto no local
    format('O objeto ~w foi posto em ~w~n', [Obj, Local]), !.  % Mensagem de sucesso

% Caso o local não exista
add_obj(_, _):- 
    write('Local não existe ~n').  % Mensagem de erro

% Predicado para inspecionar o local onde o robô está
inspecionar:- 
    obj(robo, Local),  % Verifica onde o robô está
    lanterna(ligada),  % Verifica se a lanterna está ligada
    reduzir_energia(10),  % Reduz 10% da energia do robô para inspecionar
    findall(Obj, obj(Obj, Local), L),  % Lista todos os objetos no local
    format('O robo está em ~w e neste local estão ~w', [Local, L]), !.  % Mensagem de sucesso

% Caso a lanterna não esteja ligada ou não tenha energia suficiente
inspecionar:- 
    write('Não foi possível inspecionar o cômodo por falta de energia ou lanterna desligada').  % Mensagem de erro

% Predicado para reduzir a energia do robô
reduzir_energia(A):- 
    energia(Ener), Ener >= A, X is Ener - A,  % Verifica se a energia é suficiente
    retract(energia(_)), assertz(energia(X)), !.  % Atualiza a energia

% Caso o robô não tenha energia suficiente
reduzir_energia(_):- 
    write('O robo não tem mais energia para efetuar essa ação').  % Mensagem de erro

% Predicado para o robô pegar um objeto
pegar(robo):- 
    write('Ação não permitida'), !.  % Não pode pegar a si mesmo

pegar(carregador):- 
    write('Ação não permitida'), !.  % Não pode pegar o carregador

% Predicado para pegar um objeto comum
pegar(Obj):- 
    inspecionar, obj(robo, Local), obj(Obj, Local),  % Inspeciona e verifica se o objeto está no local
    \+mochila(Obj), findall(C, mochila(C), L), length(L, Tam), Tam = 0,  % Verifica se o robô já tem 1 item na mochila
    retract(obj(Obj, Local)), assertz(mochila(Obj)), reduzir_energia(5),  % Pega o objeto e coloca na mochila
    write('~nO objeto foi coletado'), !.

% Predicado para pegar um objeto somente se a chave estiver na mochila
pegar(Obj):- 
    inspecionar, obj(robo, Local), obj(Local, Obj), 
    \+mochila(Obj), findall(C, mochila(C), L), length(L, Tam), Tam = 1, mochila(chave),  % Verifica se há 1 item na mochila e a chave
    retract(obj(Local, Obj)), assertz(mochila(Obj)), reduzir_energia(5), 
    write('O objeto foi coletado'), !.

% Caso não consiga pegar o objeto
pegar(_):- 
    write('Não foi possível pegar o objeto').  % Mensagem de erro

% Predicado para soltar um objeto
soltar(Obj):- 
    obj(robo, Local), mochila(Obj),  % Verifica se o objeto está na mochila
    retract(mochila(Obj)), assertz(obj(Obj, Local)),  % Remove o objeto da mochila e coloca no local
    reduzir_energia(5), write('Objeto solto no Local'), !.  % Mensagem de sucesso

% Caso não consiga soltar o objeto
soltar(_):- 
    write('Não foi possível deixar o objeto no local').  % Mensagem de erro

% Predicado para o robô caminhar até um destino
caminhar(Destino):- 
    obj(robo, Local), caminhar(Local, Aux, Destino),  % Inicia a caminhada
    format('A sequência de caminhos foi ~w', [Aux]).

% Caminha entre dois locais diretamente
caminhar(Local, Aux, Destino):- 
    aresta(Local, Destino), retract(obj(robo, Local)), assertz(obj(robo, Destino)), 
    ((lanterna(ligada), reduzir_energia(10)); reduzir_energia(5)), Aux = [Local, Destino], !.

% Caminha entre locais através de uma série de conexões
caminhar(Local, Aux, Destino):- 
    aresta(Local, NovoLocal), retract(obj(robo, Local)), assertz(obj(robo, NovoLocal)), 
    ((lanterna(ligada), reduzir_energia(10)); reduzir_energia(5)),
    caminhar(NovoLocal, Aux2, Destino), Aux = [Local | Aux2], !.

carregar:- obj(carregador, Local), obj(robo, Local), retract(energia(_)), assertz(energia(100)).

status_robo:- lanterna(Estado), obj(robo, Local), findall(C, mochila(C), L), length(L, Quanti),
energia(Total), format('O robo está em ~w ~nA lanterna esta ~w~nA quantidade de energia é ~w~n
A quantidade de items na mochila é ~w', [Local, Estado, Total, Quanti]).

