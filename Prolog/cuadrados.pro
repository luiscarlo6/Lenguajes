diabolico([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P]):-

numero(A),  
numero(B), A \= B, 
numero(C), A \= C, B \= C,
numero(D), A \= D, B \= D, C \= D,
numero(E), A \= E, B \= E, C \= E, D \= E,
numero(F), A \= F, B \= F, C \= F, D \= F, E \= F,
numero(G), A \= G, B \= G, C \= G, D \= G, E \= G, F \= G,
numero(H), A \= H, B \= H, C \= H, D \= H, E \= H, F \= H, G \= H,
numero(I), A \= I, B \= I, C \= I, D \= I, E \= I, F \= I, G \= I, H \= I,
numero(J), A \= J, B \= J, C \= J, D \= J, E \= J, F \= J, G \= J, H \= J, I \= J,
numero(K), A \= K, B \= K, C \= K, D \= K, E \= K, F \= K, G \= K, H \= K, I \= K, J \= K,
numero(L), A \= L, B \= L, C \= L, D \= L, E \= L, F \= L, G \= L, H \= L, I \= L, J \= L, K \= L,
numero(M), A \= M, B \= M, C \= M, D \= M, E \= M, F \= M, G \= M, H \= M, I \= M, J \= M, K \= M, L \= M,
numero(N), A \= N, B \= N, C \= N, D \= N, E \= N, F \= N, G \= N, H \= N, I \= N, J \= N, K \= N, L \= N, M \= N,
numero(O), A \= O, B \= O, C \= O, D \= O, E \= O, F \= O, G \= O, H \= O, I \= O, J \= O, K \= O, L \= O, M \= O,
numero(P), A \= P, B \= P, C \= P, D \= P, E \= P, F \= P, G \= P, H \= P, I \= P, J \= P, K \= P, L \= P, M \= P, O \= P,

%chequeo filas.
ecuacion(A,B,C,D),
ecuacion(E,F,G,H),   
ecuacion(I,J,K,L),  
ecuacion(M,N,O,P),

%chequeo de columnas
ecuacion(A,E,I,M),
ecuacion(B,F,J,N),
ecuacion(C,G,K,O),
ecuacion(D,H,L,P),
 
%diagonales mayores
ecuacion(A,F,K,P),
ecuacion(M,J,G,D),

%diagonales menores
ecuacion(I,N,C,H),
ecuacion(B,G,L,M),
ecuacion(E,J,O,D).


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
numero(14).



ecuacion(A,B,C,D) :- A + B + C + D =:= 34.

%diabolico([1,8,13,12,14,11,2,7,4,5,16,9,15,10,3,6]).
%diabolico([1,12,7,14,8,13,2,11,10,3,16,5,15,6,9,4]).
%diabolico([1,8,11,14,12,13,2,7,6,3,16,9,15,10,5,4]).
