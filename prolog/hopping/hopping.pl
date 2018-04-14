% this is prolog
 
:- use_module(library(apply_macros)).
:- use_module(library(assoc)).
:- use_module(library(lists)).
:- use_module(library(readutil)).

current_time(H,M,S) :-
    get_time(TS),
    stamp_date_time(TS,Date9,'local'),
    arg(4,Date9,H),
    arg(5,Date9,M),
    arg(6,Date9,S).

read_input(File, N, K, B, Steps, Broken) :-
    open(File, read, Stream),
    read_line(Stream, [N, K, B]),
	(
		K > 0 ->
			read_line(Stream, Steps) 
		;
			Steps = []
	),
	(
		B > 0 ->
			read_line(Stream, Broken) 
		;
			Broken = []
	).


read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    ( Line = [] -> List = []
    ; atom_codes(A, Line),
      atomic_list_concat(As, ' ', A),
      maplist(atom_number, As, List)
    ).



add_and_mod(I, J, Result) :-
	Result is ((I + J) mod 1000000009).


outer(I, N, Steps, Sol, Answer) :-
	inner(I, Steps, Sol, Partial),
	SuccI is I + 1,
	(
	    I < N,
		outer(SuccI, N, Steps, Partial, Answer),
		!
	 ;
		I =:= N,
		Pos is N-1,
		get_assoc(Pos, Sol, Answer),
		!
	).


inner(I, List     , FinalWays, FinalWays) :-
		List = [], 
		! 
	;
		List = [H | _],
		I =< H,
		!.
inner(I, [S|Steps], Solution, FinalWays) :-
	I > S, 
	J is I - S, 
	get_assoc(J, Solution, Val),
	Val = (Ways_J, Br), 
	( 
		Br =:= 1,
		inner(I, Steps, Solution, FinalWays),
		!
	;
		get_assoc(I, Solution, (Ways_I, X)),
		add_and_mod(Ways_I, Ways_J, Result),
		put_assoc(I, Solution, (Result, X), NewSol),
		inner(I, Steps, NewSol, FinalWays),
		!
	).


create_ways(N, Assoc) :-
	create_ways_aux(Pairs, [], N),
	ord_list_to_assoc(Pairs, Assoc0),
	put_assoc(1, Assoc0, (1,0), Assoc).

create_ways_aux(Sol, Sol, -1).
create_ways_aux(Sol, Pairs, N) :-
	SuccN is N - 1,
	create_ways_aux(Sol, [N-(0,0) | Pairs], SuccN),
	!.

construct_assoc_structs([], Solution, Solution).
construct_assoc_structs([H | T], Assoc, Solution) :-
	get_assoc(H, Assoc, (Val, _)),
	put_assoc(H, Assoc, (Val, 1), NewAssoc),
	construct_assoc_structs(T, NewAssoc, Solution).


create_association_list(N, Broken, Solution) :-
	create_ways(N, WaysAssoc),
	construct_assoc_structs(Broken, WaysAssoc, Solution).

compute_sol(M, SortedSteps, Solution, Answer) :-
	outer(2, M, SortedSteps, Solution, Ans),
	Ans = (Answer, _).


hopping(File, Answer) :- 
	read_input(File, N, _, _, Steps, Broken),
	M is N + 1,
	sort(Steps, SortedSteps),
	create_association_list(M, Broken, Solution),
	outer(2, M, SortedSteps, Solution, Ans),
	Ans = (Answer, _),
	!.


