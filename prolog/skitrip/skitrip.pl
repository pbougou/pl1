read_input(File, N, Steps) :-
    open(File, read, Stream),
    read_line(Stream, N1),
    read_line(Stream, Steps),
    head(N1,N).

/*
 * An auxiliary predicate that reads a line and returns the list of
 * integers that the line contains.
 */
read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    ( Line = [] -> List = []
    ; atom_codes(A, Line),
      atomic_list_concat(As, ' ', A),
      maplist(atom_number, As, List)
    ).

head([H|T],H).


createL([],_,_,[]).
createL([H|T],0,_,[(0,H1)|T1]):-
    H1 = H,
    createL(T,1,H,T1),!.
createL([H|T],I,H2,W):-
        (H2 > H -> W=[(I,H)|T1] , I1 is I+1 , createL(T,I1,H,T1)
        ;
        I1 is I+1 , createL(T,I1,H2,W)). 
    

createR([],_,_,_,[]).
createR([H|T],0,N,_,[(N,H1)|T1]):-
    H1 = H,
    N1 is N-1,
    createR(T,1,N1,H,T1),!.
createR([H|T],I,N,H2,W):-
        (H2 < H -> W=[(N,H)|T1] , I1 is I+1 ,N1 is N-1, createR(T,I1,N1,H,T1)
        ;
        I1 is I+1 ,N1 is N-1, createR(T,I1,N1,H2,W)). 


createLR(List,N,L,R):-
    reverse(List,List1),
    N1 is N-1,
    createR(List1,0,N1,0,R),
    createL(List,0,0,L).

skiptrip([],_,Temp,Max):- Max=Temp.
skiptrip(_,[],Temp,Max):- Max=Temp.
skiptrip([(L1,L2)|T1],[(R1,R2)|T2],Temp,Max):-
    ( R2 >= L2-> 
            (H3 is R1 - L1, Temp < H3 ->
                skiptrip([(L1,L2)|T1],T2,H3,Max)
            ;
                skiptrip([(L1,L2)|T1],T2,Temp,Max)
                )
        ; skiptrip(T1,[(R1,R2)|T2],Temp,Max)
        ).




skitrip(File,Max):-
    read_input(File, N, List),
    createLR(List,N,L,R1),
    reverse(R1,R),
    skiptrip(L,R,0,Max).

