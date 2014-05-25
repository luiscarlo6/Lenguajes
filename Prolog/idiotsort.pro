idiotsort(Lista,Ordenada) :- permutation(Lista, Ordenada),
                             estaordenada(Ordenada), !.

estaordenada([]).
estaordenada([_]).
estaordenada([X,Y|Z]) :- X=<Y, estaordenada([Y|Z]).
