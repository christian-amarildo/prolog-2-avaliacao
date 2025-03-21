% Questão 1
p(q0,a,q1).
p(q1,a,q1).
p(q1,b,q1).
p(q1,b,q2).

inicio(q0).
final(q2).

teste(X) :- string_chars(X, Fita),
 			inicio(No),
 			reconhecedor(No, Fita), !.

reconhecedor(No,[]) :- final(No), !.
reconhecedor(De,[]) :- p(De, ε, Para),
 						reconhecedor(Para, []).

reconhecedor(De,Fita) :- (p(De, X, Para); p(De, ε, Para)),
 						caminha(X, Fita, Nova_Fita),
 						reconhecedor(Para, Nova_Fita).

caminha(H,[H | T],T).

% Questão 2
p(q0,'1',q1).
p(q1,'0',q1).
p(q1,'1',q1).
p(q1,'0',q2).
p(q2,'0',q2).
p(q2,'0',q3).

inicio(q0).
final(q3).

teste(X) :- string_chars(X, Fita),
 			inicio(No),
 			reconhecedor(No, Fita), !.

reconhecedor(No,[]) :- final(No), !.
reconhecedor(De,[]) :- p(De, ε, Para),
 						reconhecedor(Para, []).

reconhecedor(De,Fita) :- (p(De, X, Para); p(De, ε, Para)),
 						caminha(X, Fita, Nova_Fita),
 						reconhecedor(Para, Nova_Fita).

caminha(H,[H | T],T).

% Questão 3
p(q0,'0',q0).
p(q0,'1',q1).
p(q1,'0',q1).

inicio(q0).
final(q1).

teste(X) :- string_chars(X, Fita),
 			inicio(No),
 			reconhecedor(No, Fita), !.

reconhecedor(No,[]) :- final(No), !.
reconhecedor(De,[]) :- p(De, ε, Para),
 						reconhecedor(Para, []).

reconhecedor(De,Fita) :- (p(De, X, Para); p(De, ε, Para)),
 						caminha(X, Fita, Nova_Fita),
 						reconhecedor(Para, Nova_Fita).

caminha(H,[H | T],T).

% Questão 4
p(q0,'0',q0).
p(q0,'1',q0).
p(q0,'1',q1).
p(q1,'0',q1).
p(q1,'1',q1).

inicio(q0).
final(q1).

teste(X) :- string_chars(X, Fita),
 			inicio(No),
 			reconhecedor(No, Fita), !.

reconhecedor(No,[]) :- final(No), !.
reconhecedor(De,[]) :- p(De, ε, Para),
 						reconhecedor(Para, []).

reconhecedor(De,Fita) :- (p(De, X, Para); p(De, ε, Para)),
 						caminha(X, Fita, Nova_Fita),
 						reconhecedor(Para, Nova_Fita).

caminha(H,[H | T],T).

% Questão 5
p(q0, '0', q0).
p(q0, '1', q1).
p(q0, ε, q1).
p(q1, '0', q1).

inicio(q0).
final(q1).

teste(X) :- string_chars(X, Fita),
 			inicio(No),
 			reconhecedor(No, Fita), !.

reconhecedor(No,[]) :- final(No), !.
reconhecedor(De,[]) :- p(De, ε, Para),
 						reconhecedor(Para, []).

reconhecedor(De,Fita) :- (p(De, X, Para); p(De, ε, Para)),
 						caminha(X, Fita, Nova_Fita),
 						reconhecedor(Para, Nova_Fita).

caminha(H,[H | T],T).

% Questão 6
p(q0,'0',q1).
p(q0,'1',q1).
p(q1,'0',q2).
p(q1,'1',q2).
p(q2,'0',q3).
p(q2,'1',q3).
p(q3,'0',q3).
p(q3,'1',q3).

inicio(q0).
final(q3).

teste(X) :- string_chars(X, Fita),
 			inicio(No),
 			reconhecedor(No, Fita), !.

reconhecedor(No,[]) :- final(No), !.
reconhecedor(De,[]) :- p(De, ε, Para),
 						reconhecedor(Para, []).

reconhecedor(De,Fita) :- (p(De, X, Para); p(De, ε, Para)),
 						caminha(X, Fita, Nova_Fita),
 						reconhecedor(Para, Nova_Fita).

caminha(H,[H | T],T).
