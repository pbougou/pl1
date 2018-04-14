read_and_return(File, N, Weights) :-
    open(File, read, Stream),
    read_line(Stream, [M, N]),
    read_line(Stream, Weights),
    length(Weights, L),
    ( L =:= M -> close(Stream)  %% just a check for for sanity
    ; format("Error: expected to read ~d weights but found ~d", [M, L]),
      close(Stream), fail
    ).

read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    atom_codes(A, Line),
    atomic_list_concat(As, ' ', A),
    maplist(atom_number, As, List).

% Make a list with duplicate '1' with length I.
dupl(L,L,0) :- !.
dupl(Acc,L,K) :- K1 is K-1,dupl([1|Acc],L,K1).

findLeft(L,K,Left) :- max_member(M,L),sum_list(L,S),L1 is S//K,Left is max(L1,M).

% P18 from 99 prolog problems
slice([X|_],1,1,[X]).
slice([X|Xs],1,K,[X|Ys]) :- K > 1, 
   K1 is K - 1, slice(Xs,1,K1,Ys).
slice([_|Xs],I,K,Ys) :- I > 1, 
   I1 is I - 1, K1 is K - 1, slice(Xs,I1,K1,Ys).

findRight(L,K,N,Right) :- sum_list(L,S),K1 is K-1,slice(L,1,K1,L1),max_member(M,L1),slice(L,K,N,L2),sum_list(L2,S1),R1 is max(S1,M),Right is min(S,R1).


inner([H],Mydist,Days,X,Temp) :- (Mydist+H)=<X,!,Temp is Days.
inner([H],Mydist,Days,X,Temp) :- (Mydist+H)>X,!,Days1 is Days+1,Temp is Days1.
inner([H|T],Mydist,Days,X,Temp) :- (Mydist+H)=<X,!,Mydist1 is Mydist+H,inner(T,Mydist1,Days,X,Temp).
inner([H|T],Mydist,Days,X,Temp) :- (Mydist+H)>X,!,Days1 is Days+1,Mydist1 is H,inner(T,Mydist1,Days1,X,Temp).


outer(_,_,Left,Right,_,_,Result) :- Right=<Left,Result is Left.
outer(L,K,Left,Right,Days,Mydist,Result) :- Left<Right,X is (Right+Left)//2,inner(L,Mydist,Days,X,Temp),Temp=<K,!,Right1 is X,outer(L,K,Left,Right1,Days,Mydist,Result)
                     ;  Left<Right,X is (Right+Left)//2,inner(L,Mydist,Days,X,Temp),Temp>K,!,X1 is X+1,Left1 is X1,outer(L,K,Left1,Right,Days,Mydist,Result).	

minmax(L,K,Result) :- findLeft(L,K,Left),length(L,Len),findRight(L,K,Len,Right),outer(L,K,Left,Right,1,0,Result).

countss([],_,_,_,CountList,CountList) :- !.
countss([H],Result,Sumw,Counter,CountList,Acc) :- Sumw1 is Sumw+H,Sumw1=<Result,Counter1 is Counter+1,countss([],Result,Sumw1,Counter1,CountList,[Counter1|Acc]).
countss([H|T],Result,Sumw,Counter,CountList,Acc) :- Sumw1 is Sumw+H,Sumw1>Result,countss([H|T],Result,0,0,CountList,[Counter|Acc]). 
countss([H|T],Result,Sumw,Counter,CountList,Acc) :- not(T=[]),Sumw1 is Sumw+H,Sumw1=<Result,Counter1 is Counter+1,countss(T,Result,Sumw1,Counter1,CountList,Acc).

% I is K spaces - length(CountList).
correct1([H|T],0,[H|T]) :- !.
correct1([H|T],I,New) :- H>I,H1 is H-I,correct1([H1|T],0,New).

corr2(L,0,New,New,L) :- !.
corr2([H|T],I,Acc,New,L) :- I<0,H1 is H-I,corr2([H|T],0,[H1|Acc],New,L). 
corr2([H|T],I,Acc,New,L) :- I>0,I1 is I-H+1,corr2(T,I1,[1|Acc],New,L).

correall(CountList,I,New) :- [H|_] = CountList, H>I,!, correct1(CountList,I,New); [H|_] = CountList, H=<I,!, corr2(CountList,I,[],New1,L),append(New1,L,New). 

% It gives as reversed result. We only have to reverse New to take fair_parts.
listoflists([],[],_,New,New) :- !.
listoflists(L,[Hc|Tc],Acc,Lacc,New) :- Hc=:=0,!,reverse(Acc,Racc),listoflists(L,Tc,[],[Racc|Lacc],New).
listoflists([H|T],[Hc|Tc],Acc,Lacc,New) :- Hc>0,!,Hc1 is Hc-1,listoflists(T,[Hc1|Tc],[H|Acc],Lacc,New).

compute_counters(L,K,Counters) :- minmax(L,K,Result),reverse(L,RevL),countss(RevL,Result,0,0,CountList,[]),length(CountList,J),I is K-J,not(I=:=0),!,correall(CountList,I,New),dupl([],L1,I),append(L1,New,Counters).
compute_counters(L,K,Counters) :- minmax(L,K,Result),reverse(L,RevL),countss(RevL,Result,0,0,Counters,[]),length(Counters,Len),Len=:=K.

fair_parts(File,Parts) :- read_and_return(File,K,L),compute_counters(L,K,Counters),listoflists(L,Counters,[],[],RevParts),reverse(RevParts,Parts)
                            ;read_and_return(File,K,L),K=:=1, Parts = [L]. 