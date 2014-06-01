diabolico([A,B,C,D, E,F,G,H, I,J,K,L, M,N,O,P]):- verificarNum([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P]),!,
A \= B, 
A \= C, B \= C,
A \= D, B \= D, C \= D,
A \= E, B \= E, C \= E, D \= E,
A \= F, B \= F, C \= F, D \= F, E \= F,
A \= G, B \= G, C \= G, D \= G, E \= G, F \= G,
A \= H, B \= H, C \= H, D \= H, E \= H, F \= H, G \= H,
A \= I, B \= I, C \= I, D \= I, E \= I, F \= I, G \= I, H \= I,
A \= J, B \= J, C \= J, D \= J, E \= J, F \= J, G \= J, H \= J, I \= J,
A \= K, B \= K, C \= K, D \= K, E \= K, F \= K, G \= K, H \= K, I \= K, J \= K,
A \= L, B \= L, C \= L, D \= L, E \= L, F \= L, G \= L, H \= L, I \= L, J \= L, K \= L,
A \= M, B \= M, C \= M, D \= M, E \= M, F \= M, G \= M, H \= M, I \= M, J \= M, K \= M, L \= M,
A \= N, B \= N, C \= N, D \= N, E \= N, F \= N, G \= N, H \= N, I \= N, J \= N, K \= N, L \= N, M \= N,
A \= O, B \= O, C \= O, D \= O, E \= O, F \= O, G \= O, H \= O, I \= O, J \= O, K \= O, L \= O, M \= O,
A \= P, B \= P, C \= P, D \= P, E \= P, F \= P, G \= P, H \= P, I \= P, J \= P, K \= P, L \= P, M \= P, O \= P,

%chequeo filas.
verificar([A,B,C,D]),
verificar([E,F,G,H]), 
verificar([I,J,K,L]),
verificar([M,N,O,P]),

%chequeo de columnas
verificar([A,E,I,M]),
verificar([B,F,J,N]),
verificar([C,G,K,O]),
verificar([D,H,L,P]),

%diagonales mayores
verificar([A,F,K,P]),

verificar([M,J,G,D]),


%diagonales menores
verificar([B,G,L,M]),
verificar([C,H,I,N]),
verificar([D,E,J,O]),

verificar([N,K,H,A]),
verificar([O,L,E,B]),
verificar([P,I,F,C]),!.




diabolico(Evil):- 
%verificarVar(Evil),
generarMatriz([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],Evil),

Evil = [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P],

%aqui no hace falta chequear las columnas debido a que
%generarMatriz genera las filas correctamente

%chequeo de columnas
verificar([A,E,I,M]),
verificar([B,F,J,N]),
verificar([C,G,K,O]),
verificar([D,H,L,P]),

%diagonales mayores
verificar([A,F,K,P]),

verificar([M,J,G,D]),


%diagonales menores
verificar([B,G,L,M]),
verificar([C,H,I,N]),
verificar([D,E,J,O]),

verificar([N,K,H,A]),
verificar([O,L,E,B]),
verificar([P,I,F,C]).



% diabolico([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P]):- 
% A \= B, 
% A \= C, B \= C,
% A \= D, B \= D, C \= D,
% A \= E, B \= E, C \= E, D \= E,
% A \= F, B \= F, C \= F, D \= F, E \= F,
% A \= G, B \= G, C \= G, D \= G, E \= G, F \= G,
% A \= H, B \= H, C \= H, D \= H, E \= H, F \= H, G \= H,
% A \= I, B \= I, C \= I, D \= I, E \= I, F \= I, G \= I, H \= I,
% A \= J, B \= J, C \= J, D \= J, E \= J, F \= J, G \= J, H \= J, I \= J,
% A \= K, B \= K, C \= K, D \= K, E \= K, F \= K, G \= K, H \= K, I \= K, J \= K,
% A \= L, B \= L, C \= L, D \= L, E \= L, F \= L, G \= L, H \= L, I \= L, J \= L, K \= L,
% A \= M, B \= M, C \= M, D \= M, E \= M, F \= M, G \= M, H \= M, I \= M, J \= M, K \= M, L \= M,
% A \= N, B \= N, C \= N, D \= N, E \= N, F \= N, G \= N, H \= N, I \= N, J \= N, K \= N, L \= N, M \= N,
% A \= O, B \= O, C \= O, D \= O, E \= O, F \= O, G \= O, H \= O, I \= O, J \= O, K \= O, L \= O, M \= O,
% A \= P, B \= P, C \= P, D \= P, E \= P, F \= P, G \= P, H \= P, I \= P, J \= P, K \= P, L \= P, M \= P, O \= P,
% 
% %chequeo filas.
% verificar([A,B,C,D]),
% verificar([E,F,G,H]), 
% verificar([I,J,K,L]),
% verificar([M,N,O,P]),
% 
% %chequeo de columnas
% verificar([A,E,I,M]),
% verificar([B,F,J,N]),
% verificar([C,G,K,O]),
% verificar([D,H,L,P]),
% 
% %diagonales mayores
% verificar([A,F,K,P]),
% 
% verificar([M,J,G,D]),
% 
% 
% %diagonales menores
% verificar([B,G,L,M]),
% verificar([C,H,I,N]),
% verificar([D,E,J,O]),
% 
% verificar([N,K,H,A]),
% verificar([O,L,E,B]),
% verificar([P,I,F,C]),!.
% 
% 







verificarNum([A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P]) :-
number(A),
number(B),
number(C),
number(D),
number(E),
number(F),
number(G),
number(H),
number(I),
number(J),
number(K),
number(L),
number(M),
number(N),
number(O),
number(P).


verificarVar(L) :- L = [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P],
\+ atomic(A),
\+ atomic(B),
\+ atomic(C),
\+ atomic(D),
\+ atomic(E),
\+ atomic(F),
\+ atomic(G),
\+ atomic(H),
\+ atomic(I),
\+ atomic(J),
\+ atomic(K),
\+ atomic(L),
\+ atomic(M),
\+ atomic(N),
\+ atomic(O),
\+ atomic(P),
write('Hola').




verificar([A,B,C,D]) :- sum_list([A,B,C,D],X), X==34.


%diabolico([1,8,13,12,14,11,2,7,4,5,16,9,15,10,3,6]).
%diabolico([1,12,7,14,8,13,2,11,10,3,16,5,15,6,9,4]).
%diabolico([1,8,11,14,12,13,2,7,6,3,16,9,15,10,5,4]).



generarFilas(L,[A,B,C,D]):- member(A,L),
                            member(B,L), A \= B,
                            member(C,L), C \= A, C \= B,
                            member(D,L), D \= A, D \= B, D \= C,
                            A + B + C + D =:= 34.

                              
generarFilas(L,[A,B,C,D],H):- member(A,L),
                              member(B,L), A \= B,
                              member(C,L), C \= A, C \= B,
                              member(D,L), D \= A, D \= B, D \= C,
                              A + B + C + D =:= 34,
                              eliminar(L,[A,B,C,D],H).

                      
                      
eliminar(L,[A,B,C,D],P):- select(A,L,H), select(B,H,I),
                          select(C,I,J),  select(D,J,P).
                          

generarMatriz(L,P) :- length(L,Num), %busco el tamaño
            Num == 16, 
            generarFilas(L,A1,Aux1),/*Asigno ABCD*/
            generarFilas(Aux1,A2,Aux2),
            generarFilas(Aux2,A3,Aux3),
            generarFilas(Aux3,A4),
            append(A1,A2,S1),
            append(A3,A4,S2),
            append(S1,S2,P).

            
stopwatch(Predicate) :-
        real_time(Start),
        call(Predicate),
        real_time(Finish),
        Elapsed is (Finish - Start) / 1000,
        format('~4f seg~N',[Elapsed]), !.
