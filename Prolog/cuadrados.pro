diabolico(Evil):- temp([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],Evil),
                  Evil = [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P],

% prueba([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],[A,B,C,D],X),
% prueba(X,[E,F,G,H],Y), 
% prueba(Y,[I,J,K,L],Z), 
% prueba(Z,[M,N,O,P],W),
% 
% append([],[A,B,C,D], AA),
% append(AA,[E,F,G,H], BB),
% append(BB,[I,J,K,L], CC),
% append(CC,[M,N,O,P], L).


% numero(A),  
% numero(B), A \= B, 
% numero(C), A \= C, B \= C,
% numero(D), A \= D, B \= D, C \= D,
% numero(E), A \= E, B \= E, C \= E, D \= E,
% numero(F), A \= F, B \= F, C \= F, D \= F, E \= F,
% numero(G), A \= G, B \= G, C \= G, D \= G, E \= G, F \= G,
% numero(H), A \= H, B \= H, C \= H, D \= H, E \= H, F \= H, G \= H,
% numero(I), A \= I, B \= I, C \= I, D \= I, E \= I, F \= I, G \= I, H \= I,
% numero(J), A \= J, B \= J, C \= J, D \= J, E \= J, F \= J, G \= J, H \= J, I \= J,
% numero(K), A \= K, B \= K, C \= K, D \= K, E \= K, F \= K, G \= K, H \= K, I \= K, J \= K,
% numero(L), A \= L, B \= L, C \= L, D \= L, E \= L, F \= L, G \= L, H \= L, I \= L, J \= L, K \= L,
% numero(M), A \= M, B \= M, C \= M, D \= M, E \= M, F \= M, G \= M, H \= M, I \= M, J \= M, K \= M, L \= M,
% numero(N), A \= N, B \= N, C \= N, D \= N, E \= N, F \= N, G \= N, H \= N, I \= N, J \= N, K \= N, L \= N, M \= N,
% numero(O), A \= O, B \= O, C \= O, D \= O, E \= O, F \= O, G \= O, H \= O, I \= O, J \= O, K \= O, L \= O, M \= O,
% numero(P), A \= P, B \= P, C \= P, D \= P, E \= P, F \= P, G \= P, H \= P, I \= P, J \= P, K \= P, L \= P, M \= P, O \= P,

% %chequeo filas.
% ecuacion(A,B,C,D),
% ecuacion(E,F,G,H),   
% ecuacion(I,J,K,L),  
% ecuacion(M,N,O,P).%,

%chequeo de columnas
ecuacion([A,E,I,M]),
ecuacion([B,F,J,N]),
ecuacion([C,G,K,O]),
ecuacion([D,H,L,P]),
%  
%diagonales mayores
ecuacion([A,F,K,P]),

ecuacion([M,J,G,D]),
 

%diagonales menores
ecuacion([B,G,L,M]),
ecuacion([C,H,I,N]),
ecuacion([D,E,J,O]),

ecuacion([N,K,H,A]),
ecuacion([O,L,E,B]),
ecuacion([P,I,F,C]).
/*
numero(1).
numero(8).
numero(12).
numero(13).

numero(2).
numero(7).
numero(10).
numero(15).

numero(3).
numero(6).
numero(9).
numero(16).

numero(4).
numero(5).
numero(11).
numero(14).*/



ecuacion([A,B,C,D]) :- sum_list([A,B,C,D],X), X==34.


%diabolico([1,8,13,12,14,11,2,7,4,5,16,9,15,10,3,6]).
%diabolico([1,12,7,14,8,13,2,11,10,3,16,5,15,6,9,4]).
%diabolico([1,8,11,14,12,13,2,7,6,3,16,9,15,10,5,4]).

% aux(L) = prueba([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],[A,B,C,D],X),
%           prueba(X,[E,F,G,H],Y), 
%           prueba(Y,[I,J,K,L],Z), 
%           prueba(Z,[M,N,O,P],W),
% 
%           append([],[A,B,C,D], AA),
%           append(AA,[E,F,G,H], BB),
%           append(BB,[I,J,K,L], CC),
%           append(CC,[M,N,O,P], L).

          
prueba(L,[A,B,C,D],H):- member(A,L),
                        member(B,L), A \= B,
                        member(C,L), C \= A, C \= B,
                        member(D,L), D \= A, D \= B, D \= C,
                        A + B + C + D =:= 34,
                        eliminar(L,[A,B,C,D],H).
                      
                      
eliminar(L,[A,B,C,D],P):- select(A,L,H), select(B,H,I),
                          select(C,I,J),  select(D,J,P).
                          

temp(L,P) :- length(L,Num), %busco el tamaño
             Num == 16, 
             prueba(L,A1,Aux1),/*Asigno ABCD*/
             prueba(Aux1,A2,Aux2),
             prueba(Aux2,A3,Aux3),
             prueba(Aux3,A4,Aux4),
             append(A1,A2,S1),
             append(A3,A4,S2),
             append(S1,S2,P).


             
stopwatch(Predicate) :-
        real_time(Start),
        call(Predicate),
        real_time(Finish),
        Elapsed is (Finish - Start) / 1000,
        format('~4f seg~N',[Elapsed]), !.
