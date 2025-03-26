% Pràctica de Prolog
% Copyright (c) 2025 Juan José Gómez Villegas (u1987338),Guillem Pozo Sebastián (u1972840)

% CONSTANTS I VARIABLES

constant_m_rand(65537).
constant_a_rand(75).
constant_c_rand(74).

% PREDICATS JA IMPLEMENTATS PEL PROFESSOR

%treure_nessim(?L,+N,?X,?L2) ==> L2 es la llista L despres d'eliminar el N-essim element, que es X
treure_nessim([X|L],0,X,L):-!.
treure_nessim([X|L],N,Y,[X|L2]):- Nm1 is N-1, treure_nessim(L,Nm1,Y,L2).

%llista_enumerada(+Mida,?L) ==> L = [0,1,2,...,Mida-1]
llista_enumerada(Mida,L):- Nm1 is Mida-1, findall(X,between(0,Nm1,X),L).

%llista_aleatoria(+N,+Llavor,-L)
% L es una permutacio aleatoria de la llista [1,2,...,N], construida a partir de la llavor Llavor
llista_aleatoria(Mida,Llavor,Llista):-
    llista_enumerada(Mida,LlistaOrdenada),
    llista_aleatoria_(Mida,LlistaOrdenada,Llista,Llavor).

%Auxiliar per llista_aleatoria, NO UTILITZAR
llista_aleatoria_(0,[],[],_):-!.
llista_aleatoria_(N,Llista,[X|RestaPermutats],Llavor):-
    Pos is Llavor mod N,
    treure_nessim(Llista,Pos,X,LlistaPermutada),
    constant_m_rand(M),
    constant_a_rand(A),
    constant_c_rand(C),
    RandNext is (A * Llavor + C) mod M,
    Nm1 is N-1,
    llista_aleatoria_(Nm1,LlistaPermutada,RestaPermutats,RandNext).

% PREDICATS PROPIS

%escriure_llista(-L) ==> L serà la llista que demanarem (L és un paràmetre de sortida)
escriure_llista(L) :-
    print('Entra la llista: '),nl,
	read(L).

%generar_llista(-L) ==> L serà la llista que generarem (L és un paràmetre de sortida)
generar_llista(L) :-
    print('Entra la mida de la llista: '),nl,
	read(N),
	print('Entra la llavor: '),nl,
	read(R),
    llista_aleatoria(N,R,L).

%preguntar_accio ==> Pregunta a l'usuari quines accions vol realitzar. Si l'acció és vàlida (Res és un paràmetre de sortida).
preguntar_accio(Res) :-
    print('Entra llista accions: '),nl,
    read(Accions),
    member(Accion, Accions),
    member(Accion, [a_inserir, a_capgirar, a_intercalar]),
    Res = Accions.

%nombre_desubicats_i(+L,+Pos,+Count,?Des) ==> Per cada element de la llista L, Pos correspon a la posició que hauria d'ocupar, i Count és el comptador de nombres desubicats
nombre_desubicats_i([],_,Count,Count). % Aquí és on es fa l'assignació Des=Count
nombre_desubicats_i([X|Xs],Pos,Count,Des) :- % Cas si l'element X esta desubicat a la llista L, si X != Pos
    X =\= Pos,
    Count1 is Count + 1, % s'incrementa el Count de nombres desubicats
    Pos1 is Pos + 1,
    nombre_desubicats_i(Xs,Pos1,Count1,Des).
nombre_desubicats_i([X|Xs],Pos,Count,Des) :- % Cas si l'element X esta ben ubicat a la llista L, si X == Pos
    X == Pos,
    Pos1 is Pos + 1,
    nombre_desubicats_i(Xs,Pos1,Count,Des).

%suma_desplacaments_i(+L,+Pos,+Acum,?Sum) ==> Per cada element de la llista L, fem lleugerament diferent que nombre_desubicats_i, amb la diferencia de que ara calculem la diferencia entre cada element i Pos i l'acumulem a Acum
suma_desplacaments_i([],_,Acum,Acum). % Aquí és on es fa l'assignació Sum=Acum
suma_desplacaments_i([X|Xs],Pos,Acum,Sum) :- % Cas si l'element X esta desubicat a la llista L, si X != Pos
    X =\= Pos, 
    Diff is abs(X - Pos), 
    Acum1 is Acum + Diff, 
    Pos1 is Pos + 1, 
    suma_desplacaments_i(Xs,Pos1,Acum1,Sum).
suma_desplacaments_i([X|Xs],Pos,Acum,Sum) :- % Cas si l'element X esta ben ubicat a la llista L, si X == Pos
    X == Pos, 
    Pos1 is Pos + 1, 
    suma_desplacaments_i(Xs,Pos1,Acum,Sum).

%nombre_desubicats(+L,?Des) ==> Des és el nombre d'elements desubicats que no es troben a la posició correcte de la llista L
nombre_desubicats(L,Des) :- nombre_desubicats_i(L,0,0,Des).

%suma_desplacaments(+L,?Sum) ==> Sum és la suma de diferencies (en valor absolut) entre la posicio que ocupa un nombre a L i la posicio que hauria d'ocupar
suma_desplacaments(L,Sum) :- suma_desplacaments_i(L,0,0,Sum).

%a_inserir(+L,?L2,?Pas) ==> L2 es el resultat d'aplicar l'accio inserir a L, i Pas conte la tupla pas_inserir(Prefix1,Prefix2,Fragment,Sufix)

%a_capgirar(+L,?L2,Pas) ==> L2 es el resultat d'aplicar alguna de les subaccions de capgirar a L, i Pas conte la tupla pas_capgirar(Prefix,Fragment,Sufix)

%a_intercalar(+L,?L2,Pas) ==> L2 es el resultat d'aplicar alguna de les subaccions d'intercalar a L, i Pas conte la tupla que representa l’accio aplicada

%ordenacio_minima(+L,+Accions,?L2,?Pas,−LlistaPassos) ==> L2 es la llista L ordenada.
%               S'ha ordenat amb una sequencia d'aplicacions de les accions dins de la llista Accions, que pot ser qualsevol subconjunt de {a_inserir, a_capgirar, a_intercalar}. El nombre de passos de la sequencia es el minim possible.
%               Pas es el nombre passos aplicats (metrica pas) LlistaPassos conte la llista de passos aplicats, per ordre.
%               El predicat ordenacio minima es demostra una sola vegada

%escriure_passos(+L) ==> escriu tots els passos de la llista L

%escriure_pas(+Pas) ==> escriu el pas Pas, que es algun dels vistos en les accions inserir, capgirar i intercalar

% PROGRAMA PRINCIPAL

%executarOperacio(+X,?L) :- X és una opció implementada, alguns valors de X (algunes opcions) fan servir la llista L, alguns no
executarOperacio(esc,L) :- write(L),nl,!.
executarOperacio(des,L) :- nombre_desubicats(L,Des),print(Des),nl,!.
executarOperacio(sum,L) :- suma_desplacaments(L,Sum),print(Sum),nl,!.
executarOperacio(pas,L) :- print(L),!.
executarOperacio(pase,L) :- print(L),!.
executarOperacio(sor,_) :- !.
executarOperacio(_,_) :- print('opcio incorrecte'),nl.

%main2(+L) ==> L és la llista amb la que treballarem
main2(L) :- repeat,
	print('Entrar opcio:'),nl,
	print('- Escriure llista: esc'),nl,
	print('- Calcular desordre amb nombre de desubicats: des'),nl,
	print('- Calcular desordre amb suma de desplacaments: sum'),nl,
	print('- Calcular desordre amb nombre minim de passos: pas'),nl,
	print('- Calcular desordre amb nombre minim de passos i escriure passos: pase'),nl,
	print('- Sortir: sor'),nl,
	read(Opcio),
    executarOperacio(Opcio,L),
	Opcio=sor,
    !.

%main1(+X,-L) ==> L és una llista generada segons el valor de X (pot ser m|a)
main1(a) :- 
	generar_llista(L),nl,
    main2(L),!.
main1(m) :- 
	escriure_llista(L),nl,
    main2(L),!.
main1(_) :- print('opcio incorrecte'),nl.

%main ==> programa principal sense cap paràmetre
main :- 
    print('Llista manual (m) o aleatoria (a) ? '), 
    read(Lt),
    main1(Lt),
    !.
main.
