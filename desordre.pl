% Pràctica de Prolog
% Copyright (c) 2025 Juan José Gómez Villegas (u1987338@campus.udg.edu), Guillem Pozo Sebastián (u1972840@campus.udg.edu)

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
    read(Accions),% llegeix la llista d'accions
    member(Accio, Accions), % i per cada accio de la llista, valida que estiguin entre les accions disponibles
    member(Accio, X),
    Res = Accions.

%escriure_llista_intercalada(+L,+Intercalats) ==> Intercalats és la llista d'elements que s'escriuran entre parèntesis
escriure_llista_intercalada([],_).
escriure_llista_intercalada([X],_) :- write(X).
escriure_llista_intercalada([X],Intercalats) :-
    member(X, Intercalats),
    format('(%d)',[X]).
escriure_llista_intercalada([X|L],Intercalats) :-
    member(X, Intercalats), !,
    format('(%d),',[X]),
    escriure_llista_intercalada(L,Intercalats).
escriure_llista_intercalada([X|L],Intercalats) :-
    format('%d,',[X]),escriure_llista_intercalada(L,Intercalats).

%escriure_llista(+L) ==> L és la llista que s'escriurà per pantalla
escriure_llista([]).
escriure_llista([X]) :- write(X).
escriure_llista([X|L]) :- format('%d,',[X]),escriure_llista(L).

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
    call(Elem1,LL,X1),
    call(Elem2,Fragment,X2),
    X1 < X2.
validar_fragment(Elem1,LL,Elem2,Fragment,ge) :- 
    call(Elem1,LL,X1),
    call(Elem2,Fragment,X2),
    X1 > X2.

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

%pas_a_capgirar(Pas,?L,+Tord) ==> L es la llista a ordenar, Pas es la tupla pas_capgirar, Tord és el tipus d'ordenació del Fragment (c creixent i d decreixent)
pas_a_capgirar(pas_capgirar(Prefix,Fragment,Sufix),L,Tord) :-
    ordenada(Fragment,Tord),
    capgira(Fragment,Fragment2),
    append_a_essim([Prefix,Fragment2,Sufix],L).

%a_capgirar_esquerra(L,L2,Pas,Op,Tord) ==> L i L2 són llistes, Pas és la tupla pas_capgirar, Op és un operador (ge > o le <), Tord és el tipus d'ordenació (c creixent i d decreixent)
a_capgirar_esquerra(L,L2,pas_capgirar(Prefix,Fragment,Sufix),Op,Tord) :- 
    append(Prefix,Resta1,L),
    Prefix\=[],
    append(Fragment,Sufix,Resta1),
    Fragment\=[],
    validar_fragment(ultimElem,Prefix,ultimElem,Fragment,Op),
    pas_a_capgirar(pas_capgirar(Prefix,Fragment,Sufix),L2,Tord).
%a_capgirar_dreta(L,L2,Pas,Op,Tord) ==> el mateix que a_capgirar_esquerra, amb la diferencia de que valida el Sufix i no el Prefix
a_capgirar_dreta(L,L2,pas_capgirar(Prefix,Fragment,Sufix),Op,Tord) :- 
    append(Resta1,Sufix,L),
    Sufix\=[],
    append(Prefix,Fragment,Resta1),
    Fragment\=[],
    validar_fragment(primerElem,Sufix,primerElem,Fragment,Op),
    pas_a_capgirar(pas_capgirar(Prefix,Fragment,Sufix),L2,Tord).

%a_capgirar(+L,?L2,Pas) ==> L2 es el resultat d'aplicar alguna de les subaccions de capgirar a L, i Pas conte la tupla pas_capgirar(Prefix,Fragment,Sufix)
a_capgirar([],[],_).
a_capgirar(L,L2,pas_capgirar(Prefix,Fragment,Sufix)) :- % capgira tot
    append(Prefix,Resta1,L),
    Prefix=[],
    append(Fragment,Sufix,Resta1),
    Sufix=[],
    Fragment\=[],
    pas_a_capgirar(pas_capgirar([],Fragment,[]),L2,d).
a_capgirar(L,L2,pas_capgirar(Prefix,Fragment,Sufix)) :- % capgira creix esquerra
    a_capgirar_esquerra(L,L2,pas_capgirar(Prefix,Fragment,Sufix),ge,c).
a_capgirar(L,L2,pas_capgirar(Prefix,Fragment,Sufix)) :- % capgira creix dreta
    a_capgirar_dreta(L,L2,pas_capgirar(Prefix,Fragment,Sufix),le,c).
a_capgirar(L,L2,pas_capgirar(Prefix,Fragment,Sufix)) :- % capgira decreix esquerra
    a_capgirar_esquerra(L,L2,pas_capgirar(Prefix,Fragment,Sufix),le,d).
a_capgirar(L,L2,pas_capgirar(Prefix,Fragment,Sufix)) :- % capgira decreix dreta
    a_capgirar_dreta(L,L2,pas_capgirar(Prefix,Fragment,Sufix),ge,d).

%validar_intercalat(+Lori,+Lres) ==> compara el valor de la metrica sum amb les dues llistes Lori (llista original) i Lres (llista resultant)
validar_intercalat(Lori,Lres) :- 
    suma_desplacaments(Lori,Sori),
    suma_desplacaments(Lres,Sres),
    Sres < Sori.

%pas_a_intercalar_div(+L,?Part1,?Part2) ==> Divideix L entre Part1 i Part2
pas_a_intercalar_div(L,Part1,Part2) :- 
    append(Part1,Part2,L),
    Part1 \= [],
    Part2 \= [].

%a_intercalar(+L,?L2,?Pas) ==> L2 es el resultat d'aplicar alguna de les subaccions d'intercalar a L, i Pas conte la tupla que representa l’accio aplicada
a_intercalar([],[],_).
a_intercalar(L,L2,pas_unir_esq(Esquerra,Dreta)) :- % Unir esquerra
    pas_a_intercalar_div(L,Esquerra,Dreta),
    append_a_intercalat(Esquerra,Dreta,L2),
    validar_intercalat(L,L2).
a_intercalar(L,L2,pas_unir_dre(Esquerra,Dreta)) :- % Unir dreta
    pas_a_intercalar_div(L,Esquerra,Dreta),
    append_a_intercalat(Dreta,Esquerra,L2),
    validar_intercalat(L,L2).
a_intercalar(L,L2,pas_separar_esq(Parells,Senars)) :- % Separar esquerra
    append_a_intercalat(Parells,Senars,L),
    append(Parells,Senars,L2),
    validar_intercalat(L,L2).
a_intercalar(L,L2,pas_separar_dre(Parells,Senars)) :- % Separar dreta
    append_a_intercalat(Parells,Senars,L),
    append(Senars,Parells,L2),
    validar_intercalat(L,L2).

% ordenacio_minima_i(+L, +Accions, +PassosActuals, +PasActual, ?L2, ?Pas, -LlistaPassos) ==>
% L és la llista d'entrada,
% Accions és la llista d'accions disponibles
% PassosActuals és la llista de passos aplicats fins ara
% PasActual és el nombre de passos aplicats fins ara
% L2 és la llista resultant
% Pas és el nombre total de passos aplicats
% LlistaPassos és la llista de passos aplicats.
ordenacio_minima_i(L, [], PassosActuals, PasActual, L, PasActual, PassosActuals).
ordenacio_minima_i(L, [Accio|_], PassosActuals, _, _, _, _) :-
    call(Accio, L, LIntermitja, _), % Apliquem l'acció a la llista
    member([_, LIntermitja], PassosActuals),
    fail.
ordenacio_minima_i(L, [Accio|RestAccions], PassosActuals, PasActual, L2, Pas, LlistaPassos) :-
    call(Accio, L, LIntermitja, PasAccio), % Apliquem l'acció a la llista
    PasSeguent is PasActual + 1,
    append(PassosActuals, [[PasAccio, LIntermitja]], NousPassos), % Afegim el nou pas al final de la llista, per tenir la llista de passos en ordre
    ordenacio_minima_i(LIntermitja, RestAccions, NousPassos, PasSeguent, L2, Pas, LlistaPassos). % Continuem amb la llista intermitja

%ordenacio_minima_rec(+L,+Accions, +PassosActuals, +PacActual, +MaxPassos,?L2,?Pas,−LlistaPassos) ==> Permete la ordenacio minima de la llista L, aplicant les accions disponibles a la llista d'accions Accions.
% L és la llista d'entrada,
% Accions és la llista d'accions disponibles
% PassosActuals és la llista de passos aplicats fins ara
% PasActual és el nombre de passos aplicats fins ara
% L2 és la llista resultant
% Pas és el nombre total de passos aplicats
% LlistaPassos és la llista de passos aplicats.
ordenacio_minima_rec(L, _, PassosActuals, PasActual, L, PasActual, PassosActuals) :-
    ordenada(L, c), !. % Si la llista està ordenada, retornem la solució.
ordenacio_minima_rec(L, Accions,PassosActuals, PasActual, _, _, _) :- % Si hem superat el límit de passos, no fem res
    ordenacio_minima_i(L, Accions, PassosActuals, PasActual, LIntermitja, _, _),
    member([_, LIntermitja], PassosActuals), % Comprovem si la llista intermitja ja ha estat aplicada
    fail.
ordenacio_minima_rec(L, Accions, PassosActuals, PasActual, L2, Pas, LlistaPassos) :-
    ordenacio_minima_i(L, Accions, PassosActuals, PasActual, LIntermitja, PasIntermedi, PassosIntermedis),
    ordenacio_minima_rec(LIntermitja, Accions, PassosIntermedis, PasIntermedi, L2, Pas, LlistaPassos).

%seleccionar_millor(+Solucions, ?MillorSolucio) ==> Donat una llista de solucions, retorna la millor solució segons el número de passos
seleccionar_millor([Solucio], Solucio). % Cas base: només hi ha una solució
seleccionar_millor([[_, PasActual, _]|Resta], MillorSolucio) :-
    seleccionar_millor(Resta, [_, PasMillor, _]), % Obtenim la millor solució de la resta
    PasActual < PasMillor, % Si la solució actual té menys passos que la millor
    MillorSolucio = [_, PasActual, _].
seleccionar_millor([_|Resta], MillorSolucio) :-
    seleccionar_millor(Resta, MillorSolucio). % Si la solució actual no és millor, mantenim la millor solució anterior

%ordenacio_minima(+L,+Accions,?L2,?Pas,−LlistaPassos) ==> L2 es la llista L ordenada.
%               S'ha ordenat amb una sequencia d'aplicacions de les accions dins de la llista Accions, que pot ser qualsevol subconjunt de {a_inserir, a_capgirar, a_intercalar}. El nombre de passos de la sequencia es el minim possible.
%               Pas es el nombre passos aplicats (metrica pas) LlistaPassos conte la llista de passos aplicats, per ordre.
%               El predicat ordenacio minima es demostra una sola vegada
ordenacio_minima([], _, [], 0, []). % Cas base: llista buida.
ordenacio_minima([X], _, [X], 0, []). % Cas base: llista d'un sol element.
ordenacio_minima(L, Accions, L2, Pas, LlistaPassos) :-
    findall([L2Temp, PasTemp, LlistaPassosTemp],
        ordenacio_minima_rec(L, Accions, [], 0, L2Temp, PasTemp, LlistaPassosTemp),Solucions),
        seleccionar_millor(Solucions, [L2, Pas, LlistaPassos]).

%mostrar_passos(+Passos) ==> Predicat recursiu per mostrar tots els passos aplicats
mostrar_passos([]).
mostrar_passos([[Pas, _]|Resta]) :-
    escriure_pas(Pas),
    mostrar_passos(Resta).

%escriure_passos(+L,p) ==> escriu tots els passos de la llista L, i p pot ser les opcions pas o pase
escriure_passos([],_).
escriure_passos(L,pas) :-
    preguntar_accio(Accions),
    ordenacio_minima(L,Accions,_,NPas,_),
    write('Solucio trobada amb '), write(NPas), write(' passos'), nl.
escriure_passos(L,pase) :-
    preguntar_accio(Accions),
    write('Llista original: '),
    print(L), nl,
    ordenacio_minima(L,Accions,L2,NPas,LlistaPassos),
    mostrar_passos(LlistaPassos), % Mostrem els passos aplicats
    nl, write('Llista ordenada: '),print(L2),nl,
    write('Solucio trobada amb '),write(NPas),write(' passos'),nl.

%escriure_pas(+Pas) ==> escriu el pas Pas, que es algun dels vistos en les accions inserir, capgirar i intercalar
escriure_pas(pas_capgirar(Prefix, Fragment, Sufix)) :-
    write('['), escriure_llista(Prefix), write('('), escriure_llista(Fragment), write(')'), escriure_llista(Sufix),
    write('] == Capgirar ==> ['),
    write('['), escriure_llista(Prefix), write('('), escriure_llista(Fragment), write(')'), escriure_llista(Sufix), write(')]'), nl.
escriure_pas(pas_inserir(Prefix1, Prefix2, Fragment, Sufix)) :-
    Sufix \= [],
    write('['), escriure_llista(Prefix1), write(','), escriure_llista(Prefix2), write(',('), escriure_llista(Fragment), write('),'), escriure_llista(Sufix),
    write('] == Inserir ==> ['),
    escriure_llista(Prefix1), write(',('), escriure_llista(Fragment), write('),'), escriure_llista(Prefix2), write(','), escriure_llista(Sufix), write(']'), nl.
escriure_pas(pas_inserir(Prefix1, Prefix2, Fragment, [])) :- % Evitem escriure un ',' extra al final
    write('['), escriure_llista(Prefix1), write(','), escriure_llista(Prefix2), write(',('), escriure_llista(Fragment), write(')'),
    write('] == Inserir ==> ['),
    escriure_llista(Prefix1), write(',('), escriure_llista(Fragment), write('),'), escriure_llista(Prefix2), write(']'), nl.
% Cas: Unir Esquerra
escriure_pas(pas_unir_esq(Esquerra, Dreta)) :-
    write('['), write('('), escriure_llista(Esquerra), write('),'), escriure_llista(Dreta),
    write('] == Intercalar ==> ['), append_a_intercalat(Esquerra, Dreta, L2), escriure_llista_intercalada(L2, Esquerra), write(']'), nl.
% Cas: Intercalar Dreta
escriure_pas(pas_unir_dre(Esquerra, Dreta)) :-
    write('['), write('('), escriure_llista(Dreta), write('),'), escriure_llista(Esquerra),
    write('] == Intercalar ==> ['), append_a_intercalat(Dreta, Esquerra, L2), escriure_llista_intercalada(L2, Dreta), write(']'), nl.
% Cas: Separar Esquerra
escriure_pas(pas_separar_esq(Esquerra, Dreta)) :-
    write('['), write('('), escriure_llista(Esquerra), write('),'), escriure_llista(Dreta),
    write('] == Intercalar ==> ['), append_a_intercalat(Esquerra, Dreta, L2), escriure_llista_intercalada(L2, Esquerra), write(']'), nl.
% Cas: Separar Dreta
escriure_pas(pas_separar_dre(Esquerra, Dreta)) :-
    write('['), write('('), escriure_llista(Esquerra), write('),'), escriure_llista(Dreta),
    write('] == Intercalar ==> ['), append_a_intercalat(Esquerra, Dreta , L2), escriure_llista_intercalada(L2, Dreta), write(']'), nl.
escriure_pas(_).

% PROGRAMA PRINCIPAL

%executarOperacio(+X,?L) :- X és una opció implementada, alguns valors de X (algunes opcions) fan servir la llista L, alguns no
executarOperacio(esc,L) :- escriure_llista(L),nl,!.
executarOperacio(des,L) :- nombre_desubicats(L,Des),print(Des),nl,!.
executarOperacio(sum,L) :- suma_desplacaments(L,Sum),print(Sum),nl,!.
executarOperacio(pas,L) :- escriure_passos(L, pas),nl,!.
executarOperacio(pase,L) :- escriure_passos(L, pase), nl,!.
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
	Opcio=sor,!.

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
    read(Tipus_llista),
    main1(Tipus_llista),!.
main.
