fun parse file =
    let
	(* a function to read an integer from an input stream *)
        fun next_int input =
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)


	(* open input file and read the two integers in the first line *)
        val stream = TextIO.openIn file
        val n =next_int stream

        fun scan 0 acc = acc
        |   scan i acc = scan (i-1) (next_int stream :: acc)  
    in 
    	rev(scan n [])
    end
	

fun createL a=
		let 
		fun help_create (x::xs) (y::ys) (z::zs) i  =

											if(x<z) then help_create xs (i::y::ys) (x::z::zs) (i+1) 
											else help_create xs (y::ys) (z::zs) (i+1)
				|   help_create (x::xs) [] [] i  = help_create xs [i] [x] (i+1)

				|   help_create []  acc acc2  i = (rev(acc),rev(acc2))
		in 
			help_create a [] [] 1
		end   

fun createR a=
		let 
		val a_rev =rev(a)
		val n =length(a_rev)
		fun help_create (x::xs) (y::ys) (z::zs) i  =

											if(x>z) then help_create xs (i::y::ys) (x::z::zs) (i-1) 
											else help_create xs (y::ys) (z::zs) (i-1)
				|   help_create (x::xs) [] [] i  = help_create xs [i] [x] (i-1)

				|   help_create []  acc acc2  i = (acc,acc2)
		in 
			help_create a_rev [] [] n
		end   


fun tlist (lst1,lst2) =
	let 
		fun help (x::xs) (y::ys) acc = help xs ys ((x,y)::acc)
		|   help []       []      acc  = acc
	in
	   rev(	help lst1 lst2 [] )
	end 


fun skitrip file =
	let 
		val d = parse file
		val n = length d
		val L1 = createL d
		val R1 = createR d
		val L = tlist L1
		val R = tlist R1
		fun help ((l1:int,l2:int)::ls) ((r1:int,r2:int)::rs) max n = if (r2 >= l2 ) then
																					if(max < (r1 - l1)) then help ((l1,l2)::ls) rs (r1-l1) n
																					else 	 			   help ((l1,l2)::ls) rs max n
										  							 else help ls ((r1,r2)::rs) max n
		|   help [] _ max _ = max
		|   help _ [] max _ = max
		in 
	 		
	 		 help L R 0 n 
		end




















