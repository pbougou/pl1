(* Find method for union-find  *)
fun find parents2 pos = 
let
  val parent_pos = Array.sub (parents2, pos)
  val no_op      = if(parent_pos <> pos) 
                   then Array.update (parents2, pos, parent_pos) 
                   else () 
  
in
  if(parent_pos <> pos) then find parents2 parent_pos else parent_pos
end

(* Union method for union-find *)
fun union pars ranks x y = 
let 
  val xRoot = find pars x
  val yRoot = find pars y

  val rank_xroot = Array.sub (ranks, xRoot)
  val rank_yroot = Array.sub (ranks, yRoot)
  
  val no_op  = if(rank_xroot < rank_yroot) 
               then Array.update (pars, xRoot, yRoot)
               else()

  val no_op1 = if(rank_yroot < rank_xroot)
               then Array.update(pars, yRoot, xRoot)
               else()

  val no_op2 = if(rank_yroot = rank_xroot)
               then (
                      Array.update(pars, yRoot, xRoot);
                      Array.update(ranks, xRoot, rank_xroot + 1)
                    )
               else()
in
  if(xRoot = yRoot) then () else ()
end

(* A function to parse input file *)
fun parse file = 
let 
  fun next_int input = 
    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

  val stream = TextIO.openIn file
  val N      = next_int stream
  val M      = next_int stream
  val K      = next_int stream
  val _      = TextIO.inputLine stream
  fun scanner 0 acc = acc
    | scanner i acc =
      let
        val nd_one = next_int stream
        val nd_two = next_int stream
      in
        scanner (i - 1) ((nd_one, nd_two) :: acc)
      end
in
  (N, M, K, rev (scanner M []))
end

(* Define how many sets there are from the first M edges  *)
fun init_sets []        parents ranks = ()
  | init_sets (x :: xs) parents ranks = 
let 
  val (nd1, nd2) = x

  val f1 = find parents (nd1-1)
  val f2 = find parents (nd2-1)

  val no_op = if(f1 <> f2) 
                     then union parents ranks (nd1-1) (nd2-1) 
                     else () 
  
in
  init_sets xs parents ranks
end

(* Count different components  *)
fun count sets index res N =
let
  val par = Array.sub(sets, index) 
  val new_res = if(index = par) then res+1 else res
  val i = index+1
in
  if(i < N) then count sets i new_res N else new_res 
end


fun villages input = 
let
  val (N, M, K, edges) = parse input
  val rank_array       = Array.array (N, 0)
  val node_list        = List.tabulate (N, fn x => x)
  val node_array       = Array.fromList node_list
  val no_op1           = init_sets edges node_array rank_array
  val result           = count node_array 0 0 N 
in
  if(K < result) then result - K else 1 
end


