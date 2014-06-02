periodo(Dividendo, Divisor,Periodo):-
    0 =< Dividendo,
    0 < Divisor,
    mcd(Dividendo, Divisor,Mcd),
    N is Dividendo//Mcd,
    D is Divisor//Mcd,
    R is N/D,
    calcularP(R,D,Periodo),!.

%Caso donde la descomposicion en factores primos del denominador
%solo contiene 2 y 5, Fraccion Exacta
%En este caso el periodo siempre es 0.
calcularP(_,D,Periodo):-
    descomponer(D,L),
    revisar(L),
    Periodo = [0],! .


%Si la lista contiene un numero diferente a 2 y 5, entonces
%es un decimal periodico puro o mixto
calcularP(R,_,Periodo):-
%    descomponer(D,L),
%    revisar(L),
    construir(R,[],Periodo).

construir(_,L, Periodo):-
    length(L,T),
    3 < T,
    consultar(L,Periodo),!.
construir(R,L,Periodo):-
    E is truncate(R),
    D is R - E, 
    R1 is D*10,
    E1 is truncate(R1),
    append(L,[E1],L1),
    construir(R1,L1,Periodo).

consultar([A|B],Periodo) :- 
    append(Pri,Res,[A|B]),
    append(Pri,[],Res),
    \+ Res=[A|B],
    append(Res,[],Periodo),!. 
consultar([_|B],Periodo) :- 
    consultar(B,Periodo).

    

%Revisa si una lista es vacia o solo tiene 2 y 5
revisar([]).
revisar([2|L]):- revisar1(L),!.
revisar([5|L]):- revisar1(L),!.


descomponer(N,L):- descomponer_aux(N,L,2).

descomponer_aux(1,[],_):- !.
descomponer_aux(N,[P|L],P):-
    R is N rem P, R is 0,C is N // P, !, descomponer_aux(C,L,P).
descomponer_aux(N,L,P):-
    P1 is P+1, !, descomponer_aux(N,L,P1).

%%Maximo Comun divisor para simplificar fracciones.
%%Calculo mediante algoritmo de euclides
mcd(X,X,X).
mcd(X,Y,M):- X < Y, Y1 is Y - X, mcd(X,Y1,M). 
mcd(X,Y,M):- X > Y, mcd(Y,X,M).
