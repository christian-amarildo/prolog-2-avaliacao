% Exercícios de Autômatos em Prolog (expressões regulares)

% ER1: a(a|b)*b
inicio(q0).
final(q2).
p(q0,a,q1).
p(q1,a,q1).
p(q1,b,q1).
p(q1,b,q2).

% ER2: 1(1|0)*0 + 0
inicio(er2_q0).
final(qf).
p(er2,q0,'1',q1).
p(q0,'0',q3).
p(q1,'0',q2).
p(q1,'1',q1).
p(q2,'0',q2).
p(q2,'1',q1).
p(q3,'0',q4).
p(q3,'1',q4).
p(q4,'0',q4).
p(q4,'1',q4).
final(q2).
final(q3).

% ER2: 1(1|0)*0 + 0 (resumido como acima)

% ER3: 0*10*
inicio(q0_er3).
final(q1_er3).
p(q0_er3,'0',q0_er3).
p(q0_er3,'1',q1_er3).
p(q1_er3,'0',q1_er3).

% ER4: (0|1)*1(0|1)*
inicio(q0_er4).
final(q1_er4).
p(q0_er4,'0',q0_er4).
p(q0_er3,'1',q1_er4).
p(q1_er3,'0',q1_er3).
p(q1_er3,'1',q1_er3).

% ER5: 0*(1|ε)0*
inicio(q0_er5).
final(q0_er5).
final(q1_er5).
p(q0_er5,'0',q0_er5).
p(q0_er5,'1',q1_er5).
p(q1_er5,'0',q1_er5).

% ER6: (0|1)(0|1)(0|1)
inicio(q0_er6).
final(q3_er6).
p(q0_er6,'0',q1_er6).
p(q0_er6,'1',q1_er6).
p(q1_er6,'0',q2_er6).
p(q1_er6,'1',q2_er6).
p(q2_er6,'0',q3_er6).
p(q2_er6,'1',q3_er6).

% Predicado geral para testes
teste(Fita) :-
    inicio(No),
    reconhecedor(No, Fita).

% Reconhecedor genérico para autômatos
reconhecedor(No,[]) :-
    final(No), !.
reconhecedor(De,Fita) :-
    p(De,X,Para),
    caminha(X,Fita,Nova_Fita),
    reconhecedor(Para,Nova_Fita).

caminha(H,[H|T],T).

% Exemplos de consultas:
% ER1: ?- teste(['a','b']). % Aceita
% ER2: teste("1010"). % Aceita
% ER3: teste("000100"). % aceita
% ER4: reconhece qualquer cadeia com pelo menos um 1.
% ER5: reconhece cadeia vazia ou com apenas um único 1 cercado por zeros.
% ER6: reconhece cadeias de tamanho exatamente 3.

% Exemplo consulta tamanho 7 aceita ER1: teste(['a','a','b','a','a','a','b']).
% Exemplo consulta tamanho 7 rejeitada ER6: teste(['1','0','1','0','0','1','0']).
