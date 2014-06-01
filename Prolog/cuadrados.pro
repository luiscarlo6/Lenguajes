% Tarea de Prolog
% CI3661 - Taller de Lenguajes de Programación I
% Grupo # 9
% Jose Julian Prado 09-11006
% Luiscarlo Rivera  09-11020


%%diabolico(?Evil)
%
% *diabolico/1 triunfa si Evil es una lista con 16 elementos [1 .. 16] diferentes
%  tal que dichos elementos representan un Cuadrado magico pandiagonal
% *El predicado puede usarse para generar todos los posibles Cuadrado Magicos
%  Pandiagonal

diabolico([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P]) :-

    crear([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P],[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]).

    
%%magic(A,B,C,D)
%
% *magic/4 triunfa si A + B + C + D es igual a 34

magic(A,B,C,D) :- 34 is A + B + C + D.


%%crear(Lista, Base0).
% 
% *crear/2 triunfa si lista es un cuadrado magico pandiagonal
% *Base0 es la lista de todos los posibles numeros que pueden ser usados en el
%  predicado
% *Se emplea como heuristica la idea de "In any 4×4 pandiagonal magic square,
%  any two numbers at the opposite corners of a 3×3 square add up to 17." 
%  Texto citado de Wikipedia.org:
%  http://en.wikipedia.org/wiki/Pandiagonal_magic_square
% *Adicionalmente se usa magic para hacer los 16 chequeos necesarios para verificar
%  que la solucion sea correcta.
crear([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P], Base0) :-
    select(A,Base0,Base1),
    select(K,Base1,Base2),
    
    17 >= A + K, %Opuestos
    
    select(F,Base2,Base3),
    select(P,Base3,Base4),
    
    17 >= F + P, %Opuestos

    magic(A,F,K,P),

    select(N,Base4,Base5),
    select(H,Base5,Base6),

    17 >= N + H,  %Opuestos
    
    magic(A,H,K,N),
    
    select(C,Base6,Base7),
    select(I,Base7,Base8),

    17 >= C + I,  %Opuestos

    magic(C,F,I,P),
    magic(C,H,I,N),

    select(B,Base8,Base9),
    select(L,Base9,Base10),

    17 >= B + L,  %Opuestos

    select(D,Base10,Base11),
    select(J,Base11,Base12),

    17 >= D + J,  %Opuestos

    magic(A,B,C,D),
    magic(D,H,L,P),
    magic(I,J,K,L),
    magic(B,F,J,N),

    select(E,Base12,Base13),
    select(O,Base13,Base14),

    17 >= E + O,  %Opuestos

    magic(D,E,J,O),
    magic(E,B,O,L),

    select(G,Base14,Base15),
    select(M,Base15,_),
    
    17 >= G + M,  %Opuestos
    
    magic(E,F,G,H),
    magic(M,N,O,P),
    magic(A,E,I,M),
    magic(C,G,K,O),
    magic(B,G,L,M),
    magic(D,G,J,M).


    
%%stopwatch(Predicate)
%
% *stopwatch/1 triunfa si Predicate triunfa
% *El predicado "stopwatch" se emplea para saber el tiempo que tarda otro 
%  predicado en triunfar.

stopwatch(Predicate) :-
    real_time(Start),
    call(Predicate),
    real_time(Finish),
    Elapsed is (Finish - Start) / 1000,
    format('~4f seg~N',[Elapsed]), !.
