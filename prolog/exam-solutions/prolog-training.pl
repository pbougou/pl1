% this is a prolog file
/* Flatten list elements  */
/* my_flatten(+list1, -list2). kanoniki 2013 8a*/
my_flatten(X, [X]) :- \+ is_list(X).
my_flatten([],[]).
my_flatten([X|Xs], Zs) :- my_flatten(X, Y), my_flatten(Xs, Ys), append(Y, Ys, Zs).

/* P08-99 prolog problems */
compress([],[]).
compress([X], [X]).
compress([X,X|Xs], Zs) :- compress([X|Xs], Zs).
compress([X,Y|Xs], [X|Zs]) :- X \= Y, compress([Y|Xs], Zs).

% September 2015 - 7b
sum([], 0).
sum([H|T], Sum) :- sum(T, Sum1), Sum is (Sum1 + H).

takeout(X,[X|R],R).  
takeout(X,[F |R],[F|S]) :- takeout(X,R,S).

perm([X|Y],Z) :- perm(Y,W), takeout(X,Z,W).  
perm([],[]).

magic(Puzzle) :- 
Generator = [1,2,3,4,5,6,7,8,9],
perm(Generator, Solution),

Puzzle = [V1, V2, V3,
		  V4, V5, V6,
		  V7, V8, V9],

Solution = Puzzle,

R1 = [V1, V2, V3],
R2 = [V4, V5, V6],
R3 = [V7, V8, V9],

C1 = [V1, V4, V7],
C2 = [V2, V5, V8],
C3 = [V3, V6, V9],

D1 = [V1, V5, V9],
D2 = [V3, V5, V7],

sum(R1, Sum_r1),
sum(R2, Sum_r2),
sum(R3, Sum_r3),
sum(C1, Sum_c1),
sum(C2, Sum_c2),
sum(C3, Sum_c3),
sum(D1, Sum_d1),
sum(D2, Sum_d2),

Sum_r1 = Sum_r2,
Sum_r2 = Sum_r3,
Sum_r3 = Sum_c1,
Sum_c1 = Sum_c2,
Sum_c2 = Sum_c3,
Sum_c3 = Sum_d1,
Sum_d1 = Sum_d2.

% September 2016 7b

friend(kostis, maria).
friend(kostis, vickie).
friend(kostis, nickie).
friend(kostis, jenny).
friend(kostis, giannis).

friend(nickie,kostis).
friend(nickie, katerina).

friend(katerina, nickie).

friend(vickie, kostis).
friend(vickie, giannis).
friend(vickie, lena).

friend(giannis, kostis).
friend(giannis, vickie).
friend(giannis, jenny).

friend(lena, andreas).

friend(andreas, akis).
friend(andreas, lena).

friend(maria, kostis).

friend(jenny, kostis).
friend(jenny, giannis).

% not very flexible, it can' t be used as fb2(X, Y, L)
fb2(A, B, L) :-
	A \= B, friend(A,B), L = [A,B]; 
	A \= B, friend(A,C), friend(C,B), L = [A,C,B];
	A \= B, A \= D, B \= C, friend(A,C), friend(C,D), friend(D,B), L = [A, C, D, B].

% a more flexible predicate
fb3(A, B, [A, B])       :- friend(A, B).
fb3(A, B, [A, C, B])    :- friend(A, C), friend(C, B), A \= B.
fb3(A, B, [A, C, D, B]) :- friend(A, C), friend(C, D), friend(D, B), A \= B, A \= D, B \= C.

% September 2016 7a
% warning we have duplicates in use mingle(X,Y,known)
mingle(X, [], X).
mingle([], X, X).
mingle([H|T], X, [H|RT]) :- mingle(T, X, RT).
mingle(X, [H|T], [H|RT]) :- mingle(X, T, RT).

% kanoniki 2013 2a, this was ml problem in 2013
altSum([], 0).
altSum([X], Res) :- altSum([], Res1), Res is Res1 + X, !.
altSum([H1,H2|T], Res) :- altSum(T, Res1), Res is Res1 + H1 - H2.

% kanoniki 2013 8b(found on forum)
is_letter('a').
is_letter('b').

match([],[]).
match([],'?').
match([_],'?').
match([_],'+').
match([_|Xs], '+'):- match(Xs,'+').
match([X|Xs],[X|Ys]):- match(Xs,Ys).
match(List,[Y|Ys]):- \+(is_letter(Y)), append(T1,T2,List), match(T1,Y), match(T2,Ys).

% kanoniki 2013: thema 2b
transfer_inc1(X,[],[],[X]).
transfer_inc1(X,[Y|Ys],[Y|Ys],[X]) :- Y1 is X + 1, Y \= Y1.
transfer_inc1(X,[Y|Xs],Ys,[X|Zs])  :- Y1 is X + 1, Y =:= Y1, transfer_inc1(Y,Xs,Ys,Zs).

inc1Seqs([],[]).
inc1Seqs([X|Xs],[Z|Zs]) :- transfer_inc1(X,Xs,Ys,Z), inc1Seqs(Ys, Zs).

% epanaliptiki 2011 6a
/*
	is_list([]).
	is_list([H|T]) :- \+is_list(H), is_list(T).
*/

same_leaves([],[])            :- !.
same_leaves(X,X)              :- !.
same_leaves([H1|T1], [H2|T2]) :- is_list(H1), is_list(H2), !, my_flatten(H1,H11), my_flatten(H2,H22), 
									append(H11,T1, L1), append(H22, T2, L2), same_leaves(L1,L2).
same_leaves([H1|T1], L2)      :- is_list(H1), !, my_flatten(H1,H11),  
									append(H11,T1, L1), same_leaves(L1,L2).
same_leaves(L1, [H2|T2])      :- is_list(H2), !, my_flatten(H2,H22), 
									append(H22, T2, L2), same_leaves(L1,L2).
same_leaves([H1|T1], [H1|T2]) :- same_leaves(T1, T2).

% epanaliptiki 2011 6b
transfer(X,[X],[],1).
transfer(X,[X,Y|Ys],[Y|Ys],1) :- X \= Y.
transfer(X,[X,X|Xs],Ys,Z)  :- transfer(X,[X|Xs],Ys,Z1), Z is Z1+1.

next([], []).
next([X|Xs], [Zs,X|Res]) :- next(Ys, Res), once(transfer(X, [X|Xs], Ys, Zs)).

% oddsize: no need to compute length, webber ex.19.12
odssize([_]).
oddsize([_|T]) :- not(oddsize(T)).

% duplicate
duplicate([], []).
duplicate([H|T], [H,H|Res]) :- duplicate(T, Res).

% webber 19.15
isMember(X,[X|_]).
isMember(X,[_|T]) :- isMember(X,T).
% one-line predicate
isMember1(X,[Y|T]) :- X = Y ; isMember1(X,T).

% epanaliptiki 2012-13

zeros_ones(n(0,0,0), [0,0,0], []).
zeros_ones(n(0,0,1), [0,0], [1]).
zeros_ones(n(0,1,0), [0,0], [1]).
zeros_ones(n(0,1,1), [0], [1,1]).
zeros_ones(n(1,0,0), [0,0], [1]).
zeros_ones(n(1,0,1), [0], [1,1]).
zeros_ones(n(1,1,0), [0], [1,1]).
zeros_ones(n(1,1,1), [], [1,1,1]).
zeros_ones(1, [], [1]).
zeros_ones(0, [0], []).
zeros_ones(n(X, Y, Z), Zs, Os) :- zeros_ones(X, Z1, O1), zeros_ones(Y, Z2, O2), zeros_ones(Z, Z3, O3), 
								  append(Z1, Z2, Z4), append(Z4, Z3, Zs), !, 
								  append(O1, O2, O4), append(O4, O3, Os), !.

% subseq, lec17,p.56

subseq([], []).
subseq([Item|RestX], [Item|RestY]) 
	:- subseq(RestX, RestY).
subseq(X, [_|RestY])
	:- subseq(X, RestY).

% kanoniki 2013-14 7a
group234(L, G2, G3, G4) :-
	length(G2, 2), subseq(G2, L), subtract(L, G2, L1),
	length(G3, 3), subseq(G3, L1), subtract(L1, G3, L2),
	length(G4, 4), subseq(G4, L2).

% kanoniki 2013-14 7b
group([], [], []).
group(L, [H|T], [G|Gs]) :-
	length(G, H),
	subseq(G, L),
	subtract(L, G, L1), 
	group(L1, T, Gs).

% epanaliptiki 2012-13 7, forum
normsum(X,X):- X= +(A,B),atomic(A),atomic(B).
normsum(X,Y):- X= +(A,B),atomic(B),not(atomic(A)),normsum(A,Ys),Y= +(Ys,B).
normsum(X,Y):- X= +(A,B),atomic(A),not(atomic(B)),B= +(B1,B2),C= +(+(A,B1),B2),normsum(C,Y).
normsum(X,Y):- X= +(A,B),not(atomic(A)),not(atomic(B)),B= +(B1,B2),normsum(A,A1),C= +(+(A1,B1),B2),normsum(C,Y).

% epanaliptiki 2012-13 8b
is_one_zero(0).
is_one_zero(1).

aperito(0, 0).
aperito(1, 1). 
aperito(n(X, Y, Z), Res) :- 
	fix(n(X, Y, Z), Res1),
	last_one(Res1, Res), 
	!.

fix(0, 0).
fix(1, 1).
fix(n(X, Y, Z), 0) :-
	is_one_zero(X),
	is_one_zero(Y),
	is_one_zero(Z),
	(X+Y+Z) mod 2 =:= 1.
fix(n(X, Y, Z), n(X,Y,Z)) :-
	is_one_zero(X),
	is_one_zero(Y),
	is_one_zero(Z),
	(X+Y+Z) mod 2 =:= 0, !.
fix(n(X, Y, Z), n(ResX, ResY, ResZ)) :-
	fix(X, X1), fix(X1, ResX), 
	fix(Y, Y1), fix(Y1, ResY),
	fix(Z, Z1), fix(Z1, ResZ).

last_one(n(X1,Y1,Z1), 0) :- 
	is_one_zero(X1),
	is_one_zero(Y1),
	is_one_zero(Z1),
	(X1+Y1+Z1) mod 2 =:= 1.
last_one(X, X).

% combinations
combinations(K, InpL, L) :- 
	length(L, K),
	subseq(L, InpL).

combinations_list(K, InpL, Full) :- findall(L, combinations(K, InpL, L), Full).

% epanaliptiki 2014
mkpairs([], []).
mkpairs([H|T], [L-p(H)|RT]) :-
	mkpairs(T, RT),
	length(H, L).

unmkpairs([], []).
unmkpairs([_-p(H)|T], [H|RT]) :-
	unmkpairs(T, RT).

lensort([], []).
lensort(L, Res) :-
	mkpairs(L, Pairs),
	keysort(Pairs, Sorted),
	unmkpairs(Sorted, Res).
/*
	transfer_sm_len(L-X, [], [], [L-X]).
	transfer_sm_len(L-X, [L1-Y|Ys], [L1 - Y | Ys], [X]) :- X \= Y.
	transfer_sm_len(X, [X|Xs], Ys, [X|Zs]) :-
		transfer(X, Xs, Ys, Zs).
*/
all_vars([],[]).
all_vars([H|T], Res) :-
	var(H) -> all_vars(T, TR), Res = [H|TR] ;
	all_vars(T, TR), Res = TR.

assign([], _).
assign([H|T], List) :-
	( var(H) -> select(One, List, Rest), H = One, assign(T, Rest) ;
	  assign(T, List)).

list_to_dec([], 0).
list_to_dec([H|T], Dec) :- 
	length([H|T], L), 
	L1 is L-1, 
	MUL is 10**L1, 
	R is H*MUL, 
	list_to_dec(T, Dec1), 
	Dec is Dec1 + R.

all_integers([]).
all_integers([H|T]) :-
	integer(H),
	all_integers(T).

is_vars([]).
is_vars([H|T]) :-
	var(H),
	is_vars(T).

send_more(X, Y, Z) :-
	all_integers(X),
	all_integers(Y),
	all_integers(Z),
	ResX = X,
	ResY = Y,
	ResZ = Z,
	list_to_dec(ResX, NumX),
	list_to_dec(ResY, NumY),
	XY is NumX + NumY,
	list_to_dec(ResZ, NumZ),
	XY = NumZ.
send_more(X, Y, Z) :-
	List = [0,1,2,3,4,5,6,7,8,9],
	all_vars(X, VarsX),
	all_vars(Y, VarsY),
	all_vars(Z, VarsZ),
	is_vars(VarsX),
	is_vars(VarsY),
	is_vars(VarsZ),
	append(VarsX, VarsY, Temp),
	append(Temp, VarsZ, All),
	assign(All, List),
	send_more(X,Y,Z).
	
% prolog
middle([],[]).
middle([A],[A]) :- !.
middle([A,B],[A,B]) :- !.
middle([X|Xs],[X,Middle,Last]) :- append(M,[Last],Xs), middle(M,Middle).

mytextify(_,_,[],[]).
mytextify(LTR,NC,IL,OL) :-
   append(X,Y,IL),
   append(Z,LTR,X),
   append(Z,[NC],NX),
   mytextify(LTR,NC,Y,NY),
   append(NX,NY,OL),
   !.
































