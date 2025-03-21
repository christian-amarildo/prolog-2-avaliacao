% Transições de estado do autômato com pilha. 
% q(Estado, Símbolo lido, Símbolo a ser escrito, Símbolo retirado da pilha, Novo estado).
q(1, 'e', 'e', '$', 2).   % No estado 1, lê 'e', escreve 'e', retira '$' da pilha e vai para o estado 2.
q(2, '0', 'e', '0', 2).   % No estado 2, lê '0', escreve 'e', retira '0' da pilha e permanece no estado 2.
q(2, '1', '0', 'e', 3).   % No estado 2, lê '1', escreve '0', retira 'e' da pilha e vai para o estado 3.
q(3, '1', '0', 'e', 3).   % No estado 3, lê '1', escreve '0', retira 'e' da pilha e permanece no estado 3.
q(3, 'e', '$', 'e', 4).   % No estado 3, lê 'e', escreve '$', retira 'e' da pilha e vai para o estado 4.

% Estado inicial do autômato
inicio(1).

% Estado final do autômato
final(4).

% Predicado principal que testa se a entrada pode ser aceita pelo autômato
teste(X) :- 
    string_chars(X, Fita),    % Converte a string de entrada para uma lista de caracteres
    inicio(No),               % Define o estado inicial como o estado '1'
    reconhecedor(No, Fita, []), % Chama o reconhecedor com o estado inicial, a fita e uma pilha vazia
    !.                        % O '!' garante que, ao encontrar uma solução, o processo seja interrompido (não tenta mais caminhos).

% Caso base para quando a fita e a pilha estão vazias, e o estado final é alcançado
reconhecedor(No, [], []) :- 
    final(No),  % Se o estado atual for final, o processamento é aceito.
    !.

% Caso base para transição epsilon (não consome símbolo da fita, mas opera na pilha)
reconhecedor(De, [], Pilha) :- 
    q(De, e, L, E, Para),  % Se há uma transição epsilon (lê 'e') no estado De
    atualiza_pilha(Pilha, L, E, Nova_Pilha),  % Atualiza a pilha, retirando o elemento L e empurrando E
    reconhecedor(Para, [], Nova_Pilha).  % Faz a transição para o próximo estado 'Para', sem consumir a fita.

% Caso recursivo para consumir um símbolo da fita e também operar sobre a pilha
reconhecedor(De, Fita, Pilha) :- 
    q(De, X, L, E, Para),   % Se houver uma transição no estado 'De', lendo o símbolo 'X' da fita
    X \== e,                % Garante que 'X' não seja 'e' (não é transição epsilon)
    caminha(X, Fita, Nova_Fita),  % Consome o símbolo 'X' da fita, atualizando a fita para 'Nova_Fita'
    atualiza_pilha(Pilha, L, E, Nova_Pilha),  % Atualiza a pilha, retirando 'L' e empurrando 'E'
    reconhecedor(Para, Nova_Fita, Nova_Pilha). % Chama recursivamente o reconhecedor para o próximo estado 'Para' com a nova fita e pilha.

% Caso para transições epsilon, que operam apenas na pilha sem consumir símbolo da fita
reconhecedor(De, Fita, Pilha) :- 
    q(De, e, L, E, Para),   % Transição epsilon (lê 'e')
    atualiza_pilha(Pilha, L, E, Nova_Pilha),  % Atualiza a pilha removendo 'L' e empurrando 'E'
    reconhecedor(Para, Fita, Nova_Pilha).  % Chama o reconhecedor para o próximo estado 'Para', sem consumir a fita.

% Função para consumir o símbolo da fita e avançar
caminha(H, [H | T], T).  % Quando o símbolo 'H' da fita for lido, o primeiro símbolo de 'Fita' é consumido e o resto da fita 'T' é passado adiante.

% Função para atualizar a pilha com o símbolo retirado e o símbolo a ser escrito
atualiza_pilha(Pilha, L, D, Nova_Pilha) :- 
    atualiza_leitura(Pilha, L, P1),   % Atualiza a pilha retirando o símbolo L
    atualiza_escrita(P1, D, Nova_Pilha).  % Atualiza a pilha escrevendo o símbolo D no topo.

% Função para atualizar a pilha retirando o símbolo L
atualiza_leitura([L | Pilha], L, Pilha).  % Se o topo da pilha for L, retira L da pilha.
atualiza_leitura(Pilha, e, Pilha).  % Caso em que o símbolo 'e' (epsilon) não modifica a pilha.

% Função para atualizar a pilha escrevendo um símbolo no topo
atualiza_escrita(Pilha, e, Pilha) :- 
    !.  % Caso o símbolo a ser escrito seja 'e' (não escrever nada), a pilha não muda.

atualiza_escrita(Pilha, E, [E | Pilha]).  % Se o símbolo a ser escrito for diferente de 'e', empurra 'E' no topo da pilha.

