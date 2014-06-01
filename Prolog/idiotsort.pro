idiotsort(Lista,Ordenada):- 
  var(Lista),
  estaordenada(Ordenada), !,
  permutation(Ordenada,Lista).

idiotsort(Lista,Ordenada) :-  
  var(Ordenada),
  permutation(Lista, Ordenada),
  estaordenada(Ordenada), !.

estaordenada([]).
estaordenada([_]).
estaordenada([X,Y|Z]) :- X=<Y, estaordenada([Y|Z]).
