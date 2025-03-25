% llista1(?L) 
% llista1(L) ==>  L es una llista d'un sol element
% llista1(L) :- L=[X].
% llista1(L) :- L=[X|[]].
% llista1([X]).
llista1([_]).
% un fet es mes eficient que un predicat
llista1([_,_]).
llista1([_|_]).

%sumatori(+L,?S)
%sumatori(L,S) ==> L es una llista de nombres i el seu sumatori és S
sumatori([],0).
sumatori([X|Ls],S) :- sumatori(Ls,S2),S is X+S2.

%producte(+L,?P)
%producte(L,P) ==> L es una llista de nombres i el seu producte és P
%nota: per definició, el producte d'un conjunt buit és 1
producte([],1).
producte([X|Lp],P) :- producte(Lp,P2),P is X*P2.

%llargada(?L,?N)
%llargada(L,N) ==> L es una llista de llargada N
llargada([],0).
llargada([_|L],N) :- llargada(L,N2),N is N2+1.

%pertany(?X,?L)
%pertany(X,L) ==> L es una llista que conté l'element X
%es demostra tantes vegades com L contingui X
pertany(X,[X|_]).
pertany(X, [_|L]) :- pertany(X,L).

%comptar(+X,+L,?N)
%comptar(X,L,N) ==> L es una llista que conté l'element X un total de N vegades
comptar(_,[],0).
comptar(X,[X|L],N) :- comptar(X,L,N2),N is N2+1.
comptar(X,[Y|L],N) :- X\=Y,comptar(X,L,N).

%afegirFinal(?X,?L1,?L2)
%afegirFinal(X,L1,L2) ==> L2 és la llista L1 amb X al final
afegirFinal(X,[],[X]).
afegirFinal(X,[Y|L1],[Y|L2]) :- afegirFinal(X,L1,L2).

%capgira(?L1,?L2)
%capgira(L1,L2) ==> L2 és la llista L1 capgirada
capgira([],[]).
capgira([X|L1],L2) :- capgira(L1,L3),afegirFinal(X,L3,L2).

%parells(+L1,?L2)
%parells(L1,L2) ==> L1 és una llista d'enters, i L2 és la llista L1 conservant només els nombres parells
parells([],[]).
parells([X|L1],[X|L2]) :- X mod 2 =:= 0,parells(L1,L2).
parells([X|L1],L2) :- X mod 2 =:= 1,parells(L1,L2).

%concatenar(?L1,?L2,?L3)
%concatenar(L1,L2,L3) ==> L3 és el resultat de concatenar les llistes L1 i L2
concatenar([],L,L).
concatenar([X|A],B,[X|C]) :- concatenar(A,B,C).

%ordenada(+L)
%ordenada(L) ==> L és una llista de nombres ordenada de menor a major
ordenada([]).
ordenada([_]).
ordenada([X,Y|L]) :- X=<Y,ordenada([Y|L]).

%inserir(+X,+L1,?L2)
%inserir(X,L1,L2) ==> L2 és el resultat d'inserir X a la posició corresponent de la llista de nombres ordenada L1
inserir(X,[],[X]).
inserir(X,[Y|L1],[X,Y|L1]) :- X=<Y.
inserir(X,[Y|L1],[Y|L2]) :- X>Y,inserir(X,L1,L2).

%ordenar(+L1,?L2)
%ordenar(L1,L2) ==> L2 és la llista de nombres L1 ordenada
ordenar([],[]).
ordenar([X|L1],L2) :- ordenar(L1,L3),inserir(X,L3,L2).

%treu(+X,+L1,?L2) ==> L2 és L1 sense X
treu(_,[],[]).
treu(X,[X|L1],L2) :- treu(X,L1,L2).
treu(X,[Y|L1],[Y|L2]) :- X\=Y,treu(X,L1,L2).

%member_a(?X,?L) ==> Z pertany a L
member_a(X,L) :- append(_,[X|_],L),!.

%permutacio(+L1,?L2) ==> L2 és una permutació de L1
permutacio([],[]).
permutacio(L,[X|Xs]) :- append(V,[X|P],L),append(V,P,W),permutacio(W,Xs).

%invers(+L,?I) ==> Y és L invertida
invers([],[]).
invers([X|Xs],I) :- invers(Xs,Ps),append(Ps,[X],I),!.

%prefix(?P,?L) ==> P és prefix de L
prefix_(P,L) :- append(P,_,L).

%sufix(?S,?L) ==> S és sufix de L
sufix_(S,L) :- append(_,S,L).

%subllista(?Lp,?L) ==> Lp es una subllista (elements consecutius) de la llista 
subllista(Lp,L) :- prefix_(P,L),sufix_(Lp,P).

%fact(+N,F) => F és el factorial del natural N
fact(0,1).
fact(N,F) :- N>0,
             Np is N-1,
             fact(Np,F1),
             F is F1*N.

%parteix(X,L,Men,Maj) => Men son els elements de L menors que X, Maj els majors
parteix(_,[],[],[]).
parteix(X,[Y|L],[Y|Mn],Mj) :- Y=<X,parteix(X,L,Mn,Mj).
parteix(X,[Y|L],Mn,[Y|Mj]) :- Y>X,parteix(X,L,Mn,Mj).

%quicksort(L1,L2) => L2 es la llista L1 ordenada
quicksort([],[]).
quicksort([X|Xs],L) :- parteix(X,Xs,Mn,Mj),
                       quicksort(Mn,Mno),
                       quicksort(Mj,Mjo),
                       append(Mno,[X|Mjo],L).

%hanoi(N,A,B,C,M) => M son els moviments per passar N discos de A a B usant C.
hanoi(s(0),A,B,_,[de_a_(A,B)]).
hanoi(s(N),A,B,C,[Mv]) :- 
  hanoi(N,A,C,B,Mv1),
  hanoi(N,C,B,A,Mv2),
  append(Mv1,[de_a_(A,B)|Mv2],Mv).

%obtenirBool(0Consulta,-resposta) ==> si la consulta es satisfà, resposta és si, altrament resposta és no
obtenirBool(Consulta,si):-call(Consulta),!.
obtenirBool(_,no).

main:-mainAux,!.
main.

mainAux:-
  write('Llista: '),
	read(Llista),
  write(Llista), nl,
  write('Nivell de comprovacions {1,2,3}: '),
	read(Nivell),
  write(Nivell), nl,
	write('Sumatori: '), !, sumatori(Llista,Sum), write(Sum),nl,
  write('Producte: '), !, producte(Llista,Prod),write(Prod),nl,
  write('Llargada: '), !, llargada(Llista,Ll), write(Ll),nl,
  !,Nivell >= 2, 
  X=2, Y=4,
  format('Conte el ~d? ',[X]),!, obtenirBool(pertany(X,Llista),Pertany), write(Pertany), nl,
  format('Quantes vegades conte el ~d? ',[Y]),!, comptar(Y,Llista,Recompte), write(Recompte), nl,
  write('Capgirada: '),!, capgira(Llista,Capgirada), write(Capgirada), nl,
  write('Membres parells: '),!, parells(Llista,Parells), write(Parells), nl,
  !,Nivell>=3,
  write('Esta ordenada? '),!, obtenirBool(ordenada(Llista),Ordenada), write(Ordenada), nl,
  write('Concatena amb ella mateixa: '), !, concatenar(Llista,Llista,Conc), write(Conc),nl,
  write('Concatena amb ella mateixa i ordena: '), !, ordenar(Conc,Ord), write(Ord),nl,
  !.

menu:-menuAux,!.
menu.

menuAux:-
	write('Benvingut al menu d\'opcions: \n'),
	write('esc S’escriu la llista desordenada L amb la que treballem.\n'), 
	write('des S’escriu la m`etrica des de L.\n'), 
	write('sum S’escriu la m`etrica sum de L.\n'), 
	write('pas S’escriu la m`etrica pas de L.\n'), 
	write('pase Fa el mateix que l’opció pas.\n'), 
	write('sor S’acaba el programa.\n'), 
	write('\n| :- '), 
	read(opcio),
	!.
