% Tarea de Prolog
% CI3661 - Taller de Lenguajes de Programación I
% Grupo # 9
% José Julián Prado 09-11006
% Luiscarlo Rivera  09-11020


%%periodo(Dividendo,Divisor,Periodo)
%
% *periodo/3 triunfa si Periodo contiene el periodo decimal obtenido de dividir
%  Dividendo entre Divisor

periodo(Dividendo, Divisor,Periodo):-
    0 =< Dividendo,
    0 < Divisor,
    mcd(Dividendo, Divisor,Mcd),
    N is Dividendo//Mcd,
    D is Divisor//Mcd,
    R is N/D,
    calcularP(R,D,Periodo),
    !.

    
%%calcularP(?R,?L,?Periodo)
%
% *calcularP/3 triunfa si triunfa si el numero R tiene periodo Periodo.


%Caso donde la descomposición en factores primos del denominador
%solo contiene 2 y 5, Fracción Exacta
%En este caso el periodo siempre es 0.
calcularP(_,D,Periodo):-
    descomponer(D,L),
    revisar(L),
    Periodo = [0],
    !.

%Si la lista contiene un numero diferente a 2 y 5, entonces
%es un decimal periódico puro o mixto
calcularP(R,_,Periodo):-
    construir(R,[],Periodo).


%%construir(?R,?L,?Periodo)
%
% *construir/3 triunfa si L contiene parte del periodo de R y P es el periodo.

construir(_,L, Periodo):-
    length(L,T),
    2 < T,
    consultar(L,Periodo),
    !.

construir(R,L,Periodo):-
    E is truncate(R),
    D is R - E, 
    R1 is D*10,
    E1 is truncate(R1),
    append(L,[E1],L1),
    construir(R1,L1,Periodo).


%%consultar(Lista,?Periodo)
%
% *consultar/2 triunfa si encuentra el periodo en Lista

consultar([A|B],Periodo) :- 
    append(Pri,Res,[A|B]),
    append(Pri,[],Res),
    \+ Res=[A|B],
    append(Res,[],Periodo),
    !.
    
consultar([_|B],Periodo) :- 
    consultar(B,Periodo).

    

%%revisar(?L)
%
% *revisar/1 triunfa si L tiene solo 2 y 5
revisar([]).

revisar([2|L]):- 
  revisar(L),
  !.

revisar([5|L]):- 
  revisar(L),
  !.


%%descomponer(N,L)
%
% *descomponer/2  triunfa si la lista tiene un periodo
descomponer(N,L):- 
  descomponer_aux(N,L,2).


%%descomponer_aux(N,L,?P)
%
% *descomponer_aux/3 triunfa si la lista tiene todos los factores primos del
%  numero N
descomponer_aux(1,[],_):- !.

descomponer_aux(N,[P|L],P):-
    R is N rem P, 
    R is 0,
    C is N // P,
    !,
    descomponer_aux(C,L,P).
    
descomponer_aux(N,L,P):-
    P1 is P+1,
    !,
    descomponer_aux(N,L,P1).

    
%%mcd(X,Y,M)
%
% *mcd/3 triunfa si M es el Máximo Común divisor de X y Y
% *Calculo mediante algoritmo de euclides
mcd(X,X,X).

mcd(X,Y,M):- 
  X < Y,
  Y1 is Y - X, 
  mcd(X,Y1,M).
  
mcd(X,Y,M):- 
  X > Y,
  mcd(Y,X,M).
