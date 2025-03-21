% Definindo o estado inicial
inicio(q0).

% Definindo o estado final
final(q2).

% Definindo as transições entre estados
p(q0, a, q0).     % Se estiver no estado q0 e ler o símbolo 'a', permaneça em q0
p(q0, ε, q1).     % Se estiver no estado q0 e ler a transição epsilon (sem consumir símbolo), vá para o estado q1
p(q1, b, q1).     % Se estiver no estado q1 e ler o símbolo 'b', permaneça em q1
p(q1, ε, q2).     % Se estiver no estado q1 e ler a transição epsilon (sem consumir símbolo), vá para o estado q2
p(q2, a, q2).     % Se estiver no estado q2 e ler o símbolo 'a', permaneça em q2

% Predicado principal que inicia o processo de teste
teste(X) :- 
    % Converte a string de entrada em uma lista de caracteres (Fita)
    string_chars(X, Fita),
    % Define o estado inicial
    inicio(No),
    % Chama o reconhecedor com o estado inicial e a fita
    reconhecedor(No, Fita), 
    % O '!' aqui significa que, caso o reconhecimento seja bem-sucedido, 
    % o processo é interrompido (não faz mais tentativas)
    !.

% Caso base do reconhecimento: se a fita estiver vazia e o estado atual for um estado final
reconhecedor(No, []) :- 
    final(No), 
    !. 

% Caso base do reconhecimento para transição epsilon: se a fita estiver vazia, 
% mas houver uma transição epsilon do estado atual para outro estado, faz a transição.
reconhecedor(De, []) :- 
    p(De, ε, Para),  % Se há uma transição epsilon de 'De' para 'Para'
    reconhecedor(Para, []).  % Chama recursivamente o reconhecedor com o novo estado

% Caso recursivo: se há uma transição a ser feita
reconhecedor(De, Fita) :- 
    % Aqui estamos considerando duas possibilidades de transição:
    % 1. Existe uma transição normal de 'De' para 'Para' consumindo o símbolo 'X'.
    % 2. Existe uma transição epsilon de 'De' para 'Para' (sem consumir símbolos da fita).
    (p(De, X, Para); p(De, ε, Para)), 
    % Se a transição for normal, consumimos o símbolo 'X' da fita e chamamos o reconhecedor recursivamente
    caminha(X, Fita, Nova_Fita),
    % A transição leva para o novo estado 'Para' e o resto da fita 'Nova_Fita' é processada.
    reconhecedor(Para, Nova_Fita).

% Função que simula o consumo do símbolo da fita
caminha(H, [H | T], T).  
% Quando o símbolo 'H' é lido da fita e ele corresponde ao próximo símbolo da fita (primeiro símbolo [H | T]), 
% o resto da fita (T) é passado adiante para processamento.

