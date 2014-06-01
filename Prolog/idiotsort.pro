% Tarea de Prolog
% CI3661 - Taller de Lenguajes de Programación I
% Grupo # 9
% Jose Julian Prado 09-11006
% Luiscarlo Rivera  09-11020


%%idiotsort(?Lista,?Ordenada)
%
% *idiotsort/2 triunfa si Ordenada tiene todos los elementos de Lista ordenados
%  de forma ascendente caso la lista viene vacia.
% *El predicado puede usarse para dada una lista ordenada en Ordenada generar 
%  todas las posibles permutaciones de dicha lista.

%Caso que se desea generar todas las posibles permutaciones de Lista.
idiotsort(Lista,Ordenada):- 
  var(Lista),                   %chequea que lista sea una variable
  verificador(Ordenada), !,     %se verifica que Ordenada esta ordenada ascendentemente
  generador(Lista,Ordenada).    %genera todas las posibles permutaciones

%Caso en que se quiere generar la lista ordenada ascendentemente de Lista
idiotsort(Lista,Ordenada) :-  
  var(Ordenada),
  generador(Lista, Ordenada),
  verificador(Ordenada),
  !.
  
  
%%generador(?Lista,?Ordenar)
%
% *generador/2 triunfa si Ordenada es una permitacion de Lista pero con todos
%  sus elementos ordenados de forma ascendente.
%  de forma ascendente caso la lista viene vacia

%Caso que genera todas las permutaciones posibles con los elementos de Ordenar.
generador(Lista,Ordenar):-
  var(Lista),
  permutation(Ordenar,Lista).


%Caso que genera todas las permitaciones posibles de los elementos de Lista.
generador(Lista,Ordenar) :-
  var(Ordenar),
  permutation(Lista, Ordenar).

  
%%verificador(?Lista)
%
% *verificador/2 triunfa si todos los elementos de Lista estan ordenados de
%  forma ascendente.
verificador([]).

verificador([_]).

verificador([X,Y|Z]) :-
  X=<Y, 
  verificador([Y|Z]).
