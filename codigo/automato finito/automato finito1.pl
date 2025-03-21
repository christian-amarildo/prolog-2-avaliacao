inicio(q1).
final(q3).
p(q1,a,q2).
p(q2,a,q2).
p(q2,b,q2).
p(q2,b,q3).

teste(X):- string_chars(X,Fita),
    inicio(No),
    reconhecedor(No,Fita), !.

reconhecedor(No,[]) :- final(No), !.

reconhecedor(De, []) :- p(De,e,Para), reconhecedor(Para,[]).

reconhecedor(De, Fita) :- p(De,X,Para);p(De,e,Para),caminha(X,Fita,Nova_fita), reconhecedor(Para,Nova_fita).

caminha(H,[H | T], T).
