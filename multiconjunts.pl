%unio(+Xs, +Ys, ?Zs) => Zs = Xs unio Ys
unio(Xs,Ys,Zs) :- msort(Xs,Xs2),msort(Ys,Ys2),unio2(Xs2,Ys2,Zs).

unio2([],[],[]).
unio2([X|Xs],[],[X|Xs]).
unio2([],[Y|Ys],[Y|Ys]).
unio2([X|Xs],[X|Ys],[X|Zs]) :- unio2(Xs,Ys,Zs).
unio2([X|Xs],[Y|Ys],[X|Zs]) :- X<Y,unio2(Xs,[Y|Ys],Zs).
unio2([X|Xs],[Y|Ys],[Y|Zs]) :- X>Y,unio2([X|Xs],Ys,Zs).

%interseccio(+Xs, +Ys, ?Zs) => Zs = Xs interseccio Ys
interseccio(Xs, Ys, Zs) :- msort(Xs,Xs2),msort(Ys,Ys2),interseccio2(Xs2,Ys2,Zs).

interseccio2([],[],[]).
interseccio2([_|_],[],[]).
interseccio2([],[_|_],[]).
interseccio2([X|Xs],[X|Ys],[X|Zs]) :- interseccio2(Xs,Ys,Zs).
interseccio2([X|Xs],[Y|Ys],Zs) :- X<Y,interseccio2(Xs,[Y|Ys],Zs).
interseccio2([X|Xs],[Y|Ys],Zs) :- X>Y,interseccio2([X|Xs],Ys,Zs).

% diferencia(+Xs, +Ys, ?Zs) => Zs = Xs \ Ys
diferencia(Xs, Ys, Zs) :- msort(Xs,Xs2),msort(Ys,Ys2),diferencia2(Xs2,Ys2,Zs).

diferencia2([],[],[]).
diferencia2([X|Xs],[],[X|Xs]).
diferencia2([],_,[]).
diferencia2([X|Xs],[X|Ys],Zs) :- diferencia2(Xs,Ys,Zs).
diferencia2([X|Xs],[Y|Ys],[X|Zs]) :- X<Y,diferencia2(Xs,[Y|Ys],Zs).
diferencia2([X|Xs],[Y|Ys],Zs) :- X>Y,diferencia2([X|Xs],Ys,Zs).

% multiconjunt_a_conjunt(+Xs, ?Zs) => Zs es Xs sense repeticions
multiconjunt_a_conjunt(Xs, Zs) :- msort(Xs,Xs2),multiconjunt_a_conjunt2(Xs2,Zs).

multiconjunt_a_conjunt2([],[]).
multiconjunt_a_conjunt2([X],[X]).
multiconjunt_a_conjunt2([X,X|Xs],Zs) :- multiconjunt_a_conjunt2([X|Xs],Zs).
multiconjunt_a_conjunt2([X,Y|Xs],[X|Zs]) :- X\=Y,multiconjunt_a_conjunt2([Y|Xs],Zs).

% mcd(+A, +B, ?M) => M es el maxim comu divisor de A i B
mcd(A,B,_) :- A mod B =:= 0.
mcd(A,B,M) :- R is A mod B,R\=0,mcd(B,R,M).

% camins(+E,+X,+Y,?P) 
% E son les arestes d'un graf dirigit aciclic.
% La llista P conte un cami de X a Y.
camins(E,X,Y,[X,Y]) :- member(ar(X,Y),E).
camins(E,X,Y,[X|Xs]) :- member(ar(X,Z),E),camins(E,Z,Y,Xs).

%Exemple d'execucio, graf sessio 1
%camins([ar(1,2),ar(1,3),ar(2,5),ar(3,5),ar(3,6),ar(4,3),ar(4,7),ar(5,6)],3,6,P).
%P = [3,6] ? ;
%P = [3,5,6] ? ;
%no
