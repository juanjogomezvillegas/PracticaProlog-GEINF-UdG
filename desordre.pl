% Pràctica de Prolog
% Copyright (c) 2025 Juan José Gómez Villegas (u1987338),Guillem Pozo Sebastián (u1972840)

% CONSTANTS I VARIABLES

constant_m_rand(65537).
constant_a_rand(75).
constant_c_rand(74).
accions_disp([a_inserir, a_capgirar, a_intercalar]).

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

%llegir_llista(-L) ==> L serà la llista que demanarem (L és un paràmetre de sortida)
llegir_llista(L) :-
    write('Entra la llista: '),nl,
	read(L).

%generar_llista(-L) ==> L serà la llista que generarem (L és un paràmetre de sortida)
generar_llista(L) :-
    write('Entra la mida de la llista: '),nl,
	read(N),
    write('Entra la llavor: '),nl,
	read(R),
    llista_aleatoria(N,R,L).

%preguntar_accio(-Res) ==> Res la llista d'accions que l'usuari vol realitzar
preguntar_accio(Res) :-
    accions_disp(X),
    write('Entra llista accions: '),nl,
    read(Accions),
    member(Accio, Accions),
    member(Accio, X),
    Res = Accions.

%escriure_llista(+L) ==> L és la llista que s'escriurà per pantalla
escriure_llista([]).
escriure_llista([X]) :- write(X).
escriure_llista([X|L]) :- format('%d,',[X]), escriure_llista(L).

%es_parell(+N) ==> valida si N és parell
es_parell(N) :- N mod 2 =:= 0.

%es_senar(+N) ==> valida si N és senar
es_senar(N) :- N mod 2 =:= 1.

%capgira(?L1,?L2)
%capgira(L1,L2) ==> L2 és la llista L1 capgirada
capgira([],[]).
capgira([X|Xs],L2) :- capgira(Xs,Ys),append(Ys,[X],L2).

%nessim(?L,+N,?X) ==> X apareix a la posició N de L
nessim([X|_],0,X).
nessim([_|Xs],N,X) :- N>0,Np is N - 1,nessim(Xs,Np,X).

%ultimElem(?L,?X) ==> X apareix a la ultima posició de L
ultimElem(L,X) :- length(L,N),Np is N - 1,nessim(L,Np,X),!.

%primerElem(?L,?X) ==> X apareix a la primera posició de L
primerElem(L,X) :- nessim(L,0,X),!.

%append_a_essim(+[L1,...,Ln],?Res) ==> Res és la concatenació de com a mínim dues llistes
append_a_essim([L1],L1).
append_a_essim([L1,L2|Ls],Res) :- append(L1,L2,La),append_a_essim([La|Ls],Res).

%append_a_intercalat(?L1,?L2,?Res) ==> Res és el resultat d'intercalar elements de L1 amb els de L2
append_a_intercalat([],[],[]).
append_a_intercalat([X|Xs],[Y|Ys],[X,Y|Res]) :- append_a_intercalat(Xs,Ys,Res).

%ordenada(+L,+T) ==> L és una llista de nombres ordenada T, T pot ser creixentment (c) o decreixentment (d)
ordenada([],_).
ordenada([_],_).
ordenada([X,Y|L],c) :- X=<Y,ordenada([Y|L],c),!.
ordenada([X,Y|L],d) :- X>=Y,ordenada([Y|L],d),!.

%inserir_ultim(?X,?L1,?L2) ==> L2 és la llista L1 amb X al final
inserir_ultim(X,[],[X]).
inserir_ultim(X,[Y|L1],[Y|L2]) :- inserir_ultim(X,L1,L2).

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

%validar_fragment(0elem1,+LL,0elem2,+Fragment,+[le|ge]) ==> Obté l'element elem1 de LL, i l'element elem2 de Fragment, i els compara com: le menor o igual, i ge major o igual
validar_fragment(_,[],_,_,_).
validar_fragment(Elem1,LL,Elem2,Fragment,le) :- 
    Fragment \= [],
    call(Elem1,LL,X1),
    call(Elem2,Fragment,X2),
    X1 =< X2.
validar_fragment(Elem1,LL,Elem2,Fragment,ge) :- 
    Fragment \= [],
    call(Elem1,LL,X1),
    call(Elem2,Fragment,X2),
    X1 >= X2.

%a_inserir(+L,?L2,?Pas) ==> L2 es el resultat d'aplicar l'accio inserir a L, i Pas conte la tupla pas_inserir(Prefix1,Prefix2,Fragment,Sufix)
a_inserir([],[],_).
a_inserir(L, L2, pas_inserir(Prefix1, Prefix2, Fragment, Sufix)) :-
    % Construim la tupla pas_inserir (Separem les llistes d'esquerra a dreta Prefix1, Prefix2, Fragment i Sufix)
    append(Prefix1, Resta1, L),
    append(Prefix2, Resta2, Resta1),
	Prefix2 \= [],
    append(Fragment, Sufix, Resta2),
	Fragment \= [],
    ordenada(Fragment,c),
    validar_fragment(ultimElem,Prefix1,primerElem,Fragment,le),
    validar_fragment(primerElem,Prefix2,ultimElem,Fragment,ge),
    append(Prefix1, Prefix2, Prefix), % Concatenem Prefix1 i Prefix2 i el resultat ha de ser una llista ordenada
    ordenada(Prefix, c),
    % Construeix la llista resultant L2
    append_a_essim([Prefix1, Fragment, Prefix2, Sufix], L2).

%pas_a_capgirar(?L,Pas) ==> L es la llista a dividir, i Pas es la tupla a construir
pas_a_capgirar(L,pas_capgirar(Prefix,Fragment,Sufix)) :-
    append(Prefix,Resta1,L),
    append(Fragment,Sufix,Resta1).

%a_capgirar(+L,?L2,Pas) ==> L2 es el resultat d'aplicar alguna de les subaccions de capgirar a L, i Pas conte la tupla pas_capgirar(Prefix,Fragment,Sufix)
a_capgirar([],[],_).
a_capgirar(L,L2,pas_capgirar(Prefix,Fragment,Sufix)) :- % capgira tot
    pas_a_capgirar(L,pas_capgirar(Prefix,Fragment,Sufix)),
    Prefix=[],
    Sufix=[],
    ordenada(Fragment,d),
    capgira(Fragment,Fragment2),
    L2=Fragment2,!.
a_capgirar(L,L2,pas_capgirar(Prefix,Fragment,Sufix)) :- % capgira creix esquerra
    pas_a_capgirar(L,pas_capgirar(Prefix,Fragment,Sufix)),
    Prefix\=[],
    ordenada(Fragment,c),
    validar_fragment(ultimElem,Prefix,ultimElem,Fragment,ge),
    capgira(Fragment,Fragment2),
    append_a_essim([Prefix,Fragment2,Sufix],L2).
a_capgirar(L,L2,pas_capgirar(Prefix,Fragment,Sufix)) :- % capgira creix dreta
    pas_a_capgirar(L,pas_capgirar(Prefix,Fragment,Sufix)),
    Sufix\=[],
    ordenada(Fragment,c),
    validar_fragment(primerElem,Sufix,primerElem,Fragment,le),
    capgira(Fragment,Fragment2),
    append_a_essim([Prefix,Fragment2,Sufix],L2).
a_capgirar(L,L2,pas_capgirar(Prefix,Fragment,Sufix)) :- % capgira decreix esquerra
    pas_a_capgirar(L,pas_capgirar(Prefix,Fragment,Sufix)),
    Prefix\=[],
    ordenada(Fragment,d),
    validar_fragment(ultimElem,Prefix,ultimElem,Fragment,le),
    capgira(Fragment,Fragment2),
    append_a_essim([Prefix,Fragment2,Sufix],L2).
a_capgirar(L,L2,pas_capgirar(Prefix,Fragment,Sufix)) :- % capgira decreix dreta
    pas_a_capgirar(L,pas_capgirar(Prefix,Fragment,Sufix)),
    Sufix\=[],
    ordenada(Fragment,d),
    validar_fragment(primerElem,Sufix,primerElem,Fragment,ge),
    capgira(Fragment,Fragment2),
    append_a_essim([Prefix,Fragment2,Sufix],L2).

%validar_intercalat(+Lori,+Lres) ==> compara el valor de la metrica sum amb les dues llistes Lori (llista original) i Lres (llista resultant)
validar_intercalat(Lori,Lres) :- 
    suma_desplacaments(Lori,Sori),
    suma_desplacaments(Lres,Sres),
    Sres<Sori,!.

%pas_a_intercalar_div(+L,?Pas) ==> Divideix L entre Esquerra i Dreta
pas_a_intercalar_div(L,pas_unir(Esquerra,Dreta)) :- 
    append(Esquerra,Dreta,L),
    Esquerra \= [],
    Dreta \= [].

%a_intercalar(+L,?L2,?Pas) ==> L2 es el resultat d'aplicar alguna de les subaccions d'intercalar a L, i Pas conte la tupla que representa l’accio aplicada
a_intercalar([],[],_).
a_intercalar(L,L2,pas_unir_esq(Esquerra,Dreta)) :- 
    pas_a_intercalar_div(L,pas_unir(Esquerra,Dreta)),
    append_a_intercalat(Esquerra,Dreta,L2),
    validar_intercalat(L,L2),!.
a_intercalar(L,L2,pas_unir_dre(Esquerra,Dreta)) :- 
    pas_a_intercalar_div(L,pas_unir(Esquerra,Dreta)),
    append_a_intercalat(Dreta,Esquerra,L2),
    validar_intercalat(L,L2),!.
a_intercalar(L,L2,pas_separar_esq(Parells,Senars)) :- 
    append_a_intercalat(Parells,Senars,L),
    append_a_intercalat(Parells,Senars,L2),
    validar_intercalat(L,L2),!.
a_intercalar(L,L2,pas_separar_dre(Parells,Senars)) :- 
    append_a_intercalat(Parells,Senars,L),
    append_a_intercalat(Senars,Parells,L2),
    validar_intercalat(L,L2),!.

%ordenacio_minima(+L,+Accions,?L2,?Pas,−LlistaPassos) ==> L2 es la llista L ordenada.
%               S'ha ordenat amb una sequencia d'aplicacions de les accions dins de la llista Accions, que pot ser qualsevol subconjunt de {a_inserir, a_capgirar, a_intercalar}. El nombre de passos de la sequencia es el minim possible.
%               Pas es el nombre passos aplicats (metrica pas) LlistaPassos conte la llista de passos aplicats, per ordre.
%               El predicat ordenacio minima es demostra una sola vegada
ordenacio_minima([], _, [], 0, []). % Cas base: llista buida.
ordenacio_minima([X], _, [X], 0, []). % Cas base: llista d'un sol element.
ordenacio_minima(L, Accions, L2, Pas, LlistaPassos) :-
    ordenacio_minima_rec(L, Accions, [], 0, L2, Pas, LlistaPassos).

%ordenacio_minima_rec(+L,+Accions,?L2,?Pas,−LlistaPassos) ==> Permete la ordenacio minima de la llista L, aplicant les accions disponibles a la llista d'accions Accions.
ordenacio_minima_rec(L, _, PassosActuals, PasActual, L, PasActual, PassosActuals) :-
    ordenada(L, c), % Si la llista està ordenada, retornem la solució.
    !.
ordenacio_minima_rec(L, Accions, PassosActuals, PasActual, L2, Pas, LlistaPassos) :-
    ordenacio_minima_i(L, Accions, PassosActuals, PasActual, LIntermedia, PasIntermedi, PassosIntermedis),
    ordenacio_minima_rec(LIntermedia, Accions, PassosIntermedis, PasIntermedi, L2, Pas, LlistaPassos).

% ordenacio_minima_i(+L, +Accions, +PassosActuals, +PasActual, ?L2, ?Pas, -LlistaPassos) ==>
% L és la llista d'entrada,
% Accions és la llista d'accions disponibles
% PassosActuals és la llista de passos aplicats fins ara
% PasActual és el nombre de passos aplicats fins ara
% L2 és la llista resultant
% Pas és el nombre total de passos aplicats
% LlistaPassos és la llista de passos aplicats.
ordenacio_minima_i(L, [], PassosActuals, PasActual, L, PasActual, PassosActuals).
ordenacio_minima_i(L, [Accio|RestAccions], PassosActuals, PasActual, L2, Pas, PassosActuals) :-
    call(Accio, L, LIntermedia, _), % Apliquem l'acció a la llista
    member((LIntermedia, _), PassosActuals),
    ordenacio_minima_i(LIntermedia, RestAccions, PassosActuals, PasActual, L2, Pas, PassosActuals). % Continuem amb la llista intermitja
ordenacio_minima_i(L, [Accio|RestAccions], PassosActuals, PasActual, L2, Pas, LlistaPassos) :-
    call(Accio, L, LIntermedia, PasAccio), % Apliquem l'acció a la llista
    PasSeguent is PasActual + 1,
    append(PassosActuals, [PasAccio], NousPassos), % Afegim el nou pas al final de la llista, per tenir la llista de passos en ordre
    ordenacio_minima_i(LIntermedia, RestAccions, NousPassos, PasSeguent, L2, Pas, LlistaPassos). % Continuem amb la llista intermitja

%millor_resultat(+Solucions, ?MillorSolucio) ==> Donat una llista de solucions, retorna la millor solució segons el número de passos
% Solucio és una llista composada per L2 (la llista ordenada), Pas (el nombre de passos aplicats) i Passos (la llista de passos aplicats)
millor_resultat([], _) :- fail. % No hi ha solucions, falla.
millor_resultat([Solucio], Solucio) :- !. % Si només hi ha una solució, és la millor.
millor_resultat([[L2, 0, LlistaPassos] | _], [L2, 0, LlistaPassos]) :- !. % Si hi ha una solució amb 0 passos, és la millor.
millor_resultat([[L2_1, Pas1, LlistaPassos1], [_, Pas2, _] | Resta], MillorSolucio) :-
    Pas1 =< Pas2,
    millor_resultat([[L2_1, Pas1, LlistaPassos1] | Resta], MillorSolucio).
millor_resultat([[_, Pas1, _], [L2_2, Pas2, LlistaPassos2] | Resta], MillorSolucio) :-
    Pas1 > Pas2,
    millor_resultat([[L2_2, Pas2, LlistaPassos2] | Resta], MillorSolucio).

%mostrar_passos(+Passos) ==> Predicat recursiu per mostrar tots els passos aplicats
mostrar_passos([]).
mostrar_passos([Pas|Resta]) :-
    escriure_pas(Pas),
    mostrar_passos(Resta).

%escriure_passos(+L) ==> escriu tots els passos de la llista L
escriure_passos([]).
escriure_passos(L) :-
    preguntar_accio(Accions),
    write('Llista original: '),
    print(L), nl,
    findall([L2, Pas, LlistaPassos], ordenacio_minima(L, Accions, L2, Pas, LlistaPassos), Solucions),
    millor_resultat(Solucions, [L2, NPas, LlistaPassos]), % NPas és el nombre de passos aplicats en la millor solució
    mostrar_passos(LlistaPassos), % Mostrem els passos aplicats
    nl, write('Llista ordenada: '), print(L2), nl,
    write('Solucio trobada amb '), write(NPas), write(' passos'), nl.

%escriure_pas(+Pas) ==> escriu el pas Pas, que es algun dels vistos en les accions inserir, capgirar i intercalar
escriure_pas(pas_capgirar(Prefix, Fragment, Sufix)) :-
    write('['), escriure_llista(Prefix), write('('), escriure_llista(Fragment), write(')'), escriure_llista(Sufix),
    write('] == Capgirar ==> ['),
    write('['), escriure_llista(Prefix), write('('), escriure_llista(Fragment), write(')'), escriure_llista(Sufix), write(')]'), nl.
escriure_pas(pas_inserir(Prefix1, Prefix2, Fragment, Sufix)) :-
    write('['), escriure_llista(Prefix1), write(','), escriure_llista(Prefix2), write(',('), escriure_llista(Fragment), write('),'), escriure_llista(Sufix),
    write('] == Inserir ==> ['),
    escriure_llista(Prefix1), write(',('), escriure_llista(Fragment), write('),'), escriure_llista(Prefix2), write(','), escriure_llista(Sufix), write(']'), nl.
% Cas: Unir Esquerra
escriure_pas(pas_unir_esq(Esquerra, Dreta)) :-
    print('('), print(Esquerra), print(') + ('), print(Dreta),
    print(') == Unir Esquerra ==> ('),
    a_intercalar([_],L2,pas_unir_esq(Esquerra, Dreta)),
    %pas_intercalar(Esquerra, Dreta, L2),
    print(L2),
    print(')'), nl.
% Cas: Unir Dreta
escriure_pas(pas_unir_dre(Esquerra, Dreta)) :-
    print('('), print(Esquerra), print(') + ('), print(Dreta),
    print(') == Unir Dreta ==> ('),
    a_intercalar([_],L2,pas_unir_dre(Esquerra, Dreta)),
    %intercalar_dreta(Esquerra, Dreta, L2),
    print(L2),
    print(')'), nl.
% Cas: Separar Esquerra
escriure_pas(pas_separar_esq(Parells, Senars)) :-
    print('('), print(Parells), print(') + ('), print(Senars),
    print(') == Separar Esquerra ==> ('),
    a_intercalar([_],L2,pas_separar_esq(Parells, Senars)),
    %append(Parells, Senars, L2),
    print(L2),
    print(')'), nl.
% Cas: Separar Dreta
escriure_pas(pas_separar_dre(Senars, Parells)) :-
    print('('), print(Senars), print(') + ('), print(Parells),
    print(') == Separar Dreta ==> ('),
    a_intercalar([_],L2,pas_separar_dre(Parells, Senars)),
    %append(Senars, Parells, L2),
    print(L2),
    print(')'), nl.
escriure_pas(_).

% PROGRAMA PRINCIPAL

%executarOperacio(+X,?L) :- X és una opció implementada, alguns valors de X (algunes opcions) fan servir la llista L, alguns no
executarOperacio(esc,L) :- escriure_llista(L),nl,!.
executarOperacio(des,L) :- nombre_desubicats(L,Des),print(Des),nl,!.
executarOperacio(sum,L) :- suma_desplacaments(L,Sum),print(Sum),nl,!.
executarOperacio(pas,L) :- preguntar_accio(Accions),print(Accions),print(L),nl,!.
executarOperacio(pase,L) :- escriure_passos(L), nl,!.
executarOperacio(sor,_) :- nl,!.
executarOperacio(_,_) :- nl,write('Opcio incorrecte'),nl.

%main2(+L) ==> L és la llista amb la que treballarem
main2(L) :- repeat,
    write('Entrar opcio:'),nl,
    write('- Escriure llista: esc'),nl,
    write('- Calcular desordre amb nombre de desubicats: des'),nl,
    write('- Calcular desordre amb suma de desplacaments: sum'),nl,
    write('- Calcular desordre amb nombre minim de passos: pas'),nl,
    write('- Calcular desordre amb nombre minim de passos i escriure passos: pase'),nl,
    write('- Sortir: sor'),nl,
	read(Opcio),
    executarOperacio(Opcio,L),
	Opcio=sor,
    !.

%main1(+X,-L) ==> L és una llista generada segons el valor de X (pot ser m|a)
main1(a) :- 
    generar_llista(L),
    main2(L),!.
main1(m) :- 
	llegir_llista(L),
    main2(L),!.
main1(_) :- write('Opcio incorrecte'),nl.

%main ==> programa principal sense cap paràmetre
main :- 
    write('Llista manual (m) o aleatoria (a) ? '),
    read(Lt),
    main1(Lt),
    !.
main.
