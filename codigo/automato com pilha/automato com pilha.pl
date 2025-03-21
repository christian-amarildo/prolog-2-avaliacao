q(1,'e','e','$',2).
q(2,'0','e','0',2).
q(2,'1','0','e',3).
q(3,'1','0','e',3).
q(3,'e','$','e',4).

teste(X) :- string_chars(X,Fita), inicio(No), reconhecedor(No,Fita,[]),!.


reconhecedor(No,[],[]):- final(No),!.

reconhecedor(De,[],Pilha):- q(De,e,D,E,Para), atualiza_pilha(Pilha,D,E,Nova_Pilha),
    reconhecedor(Para,[],Nova_pilha).

atualiza_pilha(Pilha,D,E,Nova_Pilha):- atualiza_leitura(Pilha,D,P1), atualiza_escrita(P1,E,Nova_pilha).

atualiza_leitura([D|Pilha],D,Pilha).
atualiza_leitura(Pilha,e,Pilha).

atualiza_escrita(Pilha,e,Pilha)!.
atualiza_escrita(Pilha,E,[E|Pilha]).

reconhecedor(De,Fita,Pilha):-q(De,X,D,E,Para),
    X\==e,
    caminha(X,Fita,Nova_Fita),
    atualiza_pilha(Pilha,D,E,Nova_Pilha),
    reconhecedor(Para,Nova_Fita,Nova_Pilha).

caminha(H,[H|T],T).


