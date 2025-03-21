% --- PRIMEIRO AUTÔMATO (AFD) ---

% Estado inicial do autômato
inicio(q1).

% Estado final (aceitação)
final(q2).

% Transições (estado atual, símbolo lido, próximo estado)
p(q1,0,q1).
p(q1,1,q2).
p(q2,0,q3).
p(q2,1,q2).
p(q3,0,q2).
p(q3,1,q2).

% Predicado principal para testar a aceitação da fita
teste(Fita) :-
    inicio(No),                % Obtém o estado inicial
    reconhecedor(No, Fita), !. % Chama o reconhecedor

% Caso base: aceita se estiver num estado final e não houver mais símbolos
reconhecedor(No,[]) :-
    final(No), !.

% Caso recursivo: realiza uma transição e continua reconhecendo o resto da fita
reconhecedor(De,Fita) :-
    p(De, X, Para),            % Procura uma transição válida
    caminha(X, Fita, Nova_Fita), % Avança na fita (consome o símbolo X)
    reconhecedor(Para, Nova_Fita). % Continua a execução no próximo estado

% Predicado para consumir um símbolo da fita (H é o símbolo consumido)
caminha(H,[H | T],T).


% --- SEGUNDO AUTÔMATO (AFD usando caracteres) ---

% Estado inicial
dois_inicio(q1).

% Estado final (aceitação)
dois_final(q2).

% Transições com caracteres ('0' e '1')
p(q1,'0',q1).
p(q1,'1',q2).
p(q2,'0',q3).
p(q2,'1',q2).
p(q3,'0',q2).
p(q3,'1',q2).

% Predicado principal usando uma string como entrada
teste(X) :-
    string_chars(X, Fita),     % Converte string em lista de caracteres
    dois_inicio(No),           % Obtém o estado inicial
    reconhecedor(No, Fita), !. % Chama reconhecedor

% O reconhecedor e caminha são os mesmos definidos acima


% --- TERCEIRO AUTÔMATO (AFN com ε-transições) ---

% Estado inicial
inicio(q0).

% Estado final (aceitação)
final(q2).

% Transições (ε é transição sem consumir símbolo algum)
p(q0,a,q0).
p(q0,ε,q1).
p(q1,b,q1).
p(q1,ε,q2).
p(q2,a,q2).

% Predicado principal usando strings
% Usa string_chars para converter a entrada em lista de caracteres
teste(X) :-
    string_chars(X, Fita),    % Converte a entrada
    inicio(No),               % Estado inicial
    reconhecedor(No, Fita), !.% Chama reconhecedor

% Caso base: aceita se não houver mais símbolos e estiver em um estado final
reconhecedor(No,[]) :-
    final(No), !.

% Caso especial: transições por ε (sem consumir símbolos)
reconhecedor(De,[]) :-
    p(De, ε, Para),           % Transição por ε
    reconhecedor(Para, []).   % Continua reconhecimento sem consumir símbolos

% Caso geral: transições normais ou ε-transições com símbolos disponíveis
reconhecedor(De,Fita) :-
    (p(De, X, Para); p(De, ε, Para)), % Escolhe transição com símbolo ou ε
    caminha(X, Fita, Nova_Fita),      % Consome símbolo (X pode ser ε, falhando caso contrário)
    reconhecedor(Para, Nova_Fita).    % Continua reconhecimento

% Predicado auxiliar para consumir símbolo
caminha(H,[H | T],T).
