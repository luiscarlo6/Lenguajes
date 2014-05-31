diabolico([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P]) :-

    crear([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P],[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]).

verificacion(A,B,C,D) :- 34 is A+B+C+D.

%Texto citado de Wikipedia.org:"In any 4×4 pandiagonal magic square,
%any two numbers at the opposite corners of a 3×3 square add up to 17.".
%Esto es que los numeros en esquinas opuestas en las submatrices 3x3 suman como máximo 17. 
%Se usa esta verificacion junto a las 16 sumas de la constante magica 34 para resolver el problema.
crear([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P], Base0) :-
    select(E,Base0,Base1),
    select(O,Base1,Base2),
    
    17 >= E + O, %Opuestos
    
    select(J,Base2,Base3),
    select(D,Base3,Base4),
    
    17 >= J + D,

    verificacion(E,O,J,D),

    select(M,Base4,Base5),
    select(G,Base5,Base6),

    17 >= M + G,
    
    verificacion(D,G,J,M),
    
    select(B,Base6,Base7),
    select(L,Base7,Base8),

    17 >= B + L,

    verificacion(B,G,L,M),
    verificacion(E,B,O,L),

    select(A,Base8,Base9),
    select(K,Base9,Base10),

    17 >= A + K,

    select(I,Base10,Base11),
    select(C,Base11,Base12),

    17 >= I + C,

    verificacion(A,B,C,D),
    verificacion(A,E,I,M),
    verificacion(I,J,K,L),
    verificacion(C,G,K,O),

    select(H,Base12,Base13),
    select(N,Base13,Base14),

    17 >= H + N,

    verificacion(A,H,K,N),
    verificacion(C,H,I,N),

    select(F,Base14,Base15),
    select(P,Base15,_),
    
    17 >= F + P,
    
    verificacion(E,F,G,H),
    verificacion(M,N,O,P),
    verificacion(B,F,J,N),
    verificacion(D,H,L,P),
    verificacion(C,I,F,P),
    verificacion(A,F,K,P).

 
consultar([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P],[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P]).

stopwatch(Predicate) :-
    real_time(Start),
    call(Predicate),
    real_time(Finish),
    Elapsed is (Finish - Start) / 1000,
    format('~4f seg~N',[Elapsed]), !.
