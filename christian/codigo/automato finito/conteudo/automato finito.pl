inicio(q0).
final(q2).
p(q0,a,q0).
p(q0,ε,q1).
p(q1,b,q1).
p(q1,ε,q2).
p(q2,a,q2).

teste(X) :- string_chars(X, Fita), inicio(No), reconhecedor(No, Fita), !.

reconhecedor(No,[]) :- final(No), !.

reconhecedor(De,[]) :- p(De, ε, Para),

reconhecedor(Para, []).

reconhecedor(De,Fita) :- (p(De, X, Para); p(De, ε, Para)), caminha(X, Fita, Nova_Fita), reconhecedor(Para, Nova_Fita).

caminha(H,[H | T],T).