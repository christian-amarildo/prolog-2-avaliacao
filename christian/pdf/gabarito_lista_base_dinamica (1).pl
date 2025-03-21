%questão 01

:- dynamic lampada/1.

lampada(apagada).

liga :- retract(lampada(_)),
        asserta(lampada(acesa)).
        
desliga :- retract(lampada(_)),
	   asserta(lampada(apagada)).
	  
%questão 02

memorize(Predicado) :- \+ Predicado, asserta(Predicado).	  


%questão 03

pos(tv, sala).
pos(bola, quarto).
pos(carteira, quarto).
pos(chave, garagem).
pos(robo, garagem).

%questão 4

:- dynamic pos/2.
ande(Destino) :- retract(pos(robo, Origem)),
           	 asserta(pos(robo, Destino)),
           	 format('Robô, ande da ~w até a ~w', [Origem,Destino]).

%questão 05

onde :- pos(robo, Local),
	format('O robô está na ~w', [Local]).
	

%questão 06

objetos :- pos(robo, Local),
	   findall(Obj, (pos(Obj, Local), Obj \== robo), L),
	   format('~w', [L]).

%questão 07

pegue(Objeto) :- pos(robo, Local),
		 pos(Objeto, Local),
		 retract(pos(Objeto, Local)),		
		 asserta(mochila(Objeto)),
		 format('Pegue a ~w', [Objeto]).
		 
%questão 08

:- dynamic mochila/1.
mochila :- findall(Obj, mochila(Obj), L),
	   format('~w', [L]).
	   
%questão 09

solte(Objeto) :- retract(mochila(Objeto)),
		 pos(robo, Local),
		 asserta(pos(Objeto, Local)),
		 format('Solte a ~w no ~w', [Objeto, Local]).
	  

