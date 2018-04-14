(* epanaliptiki 2016a *)
exception N_is_Even
fun mangle (f_init, g_init, lst) = 
let

  fun mangle_acc (_, _, [])               acc = acc
    | mangle_acc (f, g, [v])              acc = raise N_is_Even
    | mangle_acc (f, g, (v1 :: v2 :: vs)) acc = 
  let 
    fun function_acc f1 f2 x = f1 (f2 x)
    val facc                 = function_acc f_init f 
    val gacc                 = function_acc g_init g
  
  in
    mangle_acc (facc, gacc, vs) ((g v2) :: (f v1) :: acc)
  end
in
  rev (mangle_acc (f_init, g_init, lst) [])
end


(* epanaliptiki 2016b mapAllPairs *)
local
  fun cartesian []        _   acc = acc
    | cartesian (x :: xs) lst acc = 
  let 
   val res = List.map (fn y => (x,y)) lst
  in
   rev (cartesian xs lst (res :: acc))
  end

  fun flatten []       acc = acc
   | flatten (x :: xs) acc = 
   let 
     fun aux []        acc = acc
       | aux (t :: ts) acc = aux ts (t :: acc)
  
     val new_acc = aux x acc

   in
     rev (flatten xs new_acc)
   end

in
  fun mapAllPairs f lst =
  let 
    val cartes = cartesian lst lst []
    val res    = (*flatten cartes []*) List.concat cartes
  in
    List.map f res
  end
end

(* kanoniki 2016a *)
fun listify lst = 
let
  fun aux []        _  acc1 acc2 = rev ((rev acc1) :: acc2)
    | aux (x :: xs) el acc1 acc2 =
    if(x >= el) then aux xs        x (x :: acc1) acc2
                else aux (x :: xs) 0 []          ((rev acc1) :: acc2)

in
  aux lst 0 [] []
end

(* kanoniki 2016b  *)
local 
fun count_len []        acc = rev acc
  | count_len (x :: xs) acc = count_len xs ((length x, x) :: acc)

fun quickSort [] = []
  | quickSort ((x1,y1) :: xs) = 
  let
    val (left, right) = List.partition (fn (y,_) => y < x1) xs
  in
    quickSort left @ [(x1,y1)] @ quickSort right
  end

fun pack lst = 
let
  fun aux []        _         acc1 acc2 = rev ((rev acc1) :: acc2)
    | aux (x :: xs) (len:int) acc1 acc2 = 
    let 
      val (curr_len, curr_list) = x
    in
      if(curr_len = len) then aux xs        len      (curr_list :: acc1) acc2 
                         else aux (x :: xs) curr_len []  ((rev acc1) :: acc2)
    end
in
  aux lst (#1(hd lst)) [] []
end

in
  fun lenfreqsort lst = 
  let
    val list_len    = count_len lst []
    val sorted      = quickSort list_len
    val packed      = pack sorted
    val list_freq   = count_len packed []
    val sorted_freq = quickSort list_freq

    fun makelist []               acc = acc 
      | makelist ((x1,y1) :: xs)  acc = 
    let
      fun aux []  acc = acc
        | aux (x :: xs) acc = aux xs (x :: acc)

      val new_acc = (aux y1 acc)
   in
      makelist xs new_acc
   end

  in
    rev (makelist sorted_freq [])
  end
end

(* kanoniki 2013 2a *)
fun altSum lst = 
let
fun aux []               acc = acc
  | aux [x]              acc = acc + x
  | aux (x1 :: x2 :: xs) acc = aux xs (x1 - x2 + acc)
in
  aux lst 0
end


(* 2011 2a  *)
fun curry f x y = f (x,y)
fun uncurry f (x,y) = f x y


(* kanoniki 2013-14 2a *)
datatype 'd bst = Empty | Leaf of 'd | Node of 'd * 'd bst * 'd bst
val t1 = Node(4, Node(3, Leaf 2, Leaf 1), Node(3, Leaf 1, Leaf 2));

fun is_symmetric Empty Empty                             = true
  | is_symmetric (Leaf (v1:int)) (Leaf (v2:int))         = (v1 = v2)
  | is_symmetric (Node (v1, l1, r1))  (Node(v2, l2, r2)) = 
        if(v1 = v2) 
        then is_symmetric l1 r2 andalso is_symmetric r1 l2 
        else false
  | is_symmetric _ _ = false



(* kanoniki 2013-14 2b,forum *)
exception Empty_list
fun combinations 0 _ = [[]]
  | combinations k (l::ls) =
    if k > (length (l::ls)) then []
    else if k = (length (l::ls)) then [l::ls]
    else (map (fn x => (l::x)) (combinations (k-1) ls)) @ (combinations k ls)
  | combinations _ [] = raise Empty_list

fun siever k lst = List.filter (fn x => x mod k <> 0) lst

(* 2011 7b  *)  
exception Impossible
fun take k (x :: xs) acc = 
  if(k = 0) then (acc, (x :: xs)) 
  else if(k <= length (x :: xs)) 
  then take (k - 1) xs (x :: acc) 
  else ( (x::xs), [])
  | take _ _ _ = raise Impossible

fun windows k lst = 
let
  val (first, rest) = take k lst []

  fun aux _ []        acc = acc  
    | aux k (x :: xs) acc = 
    let
      val (next, _) = take (k-1) (hd acc) []
    in
      aux k xs ((x :: (rev next)) :: acc)
    end
in
  List.map (rev) (rev (aux k rest [first]))
end

fun munge (f, g, ls) = 
let
  (*lists have same length, no worries *)
  fun aux []      []      acc = acc
    | aux (x::xs) (y::ys) acc =
    let 
      val f1   = f x
      val g1   = g y
      val nacc = g1 :: f1 :: acc
    in
      aux xs ys nacc
    end
    | aux _ _ _ = raise Impossible
in
  rev (aux ls (rev ls) [])
end

fun zipmany lst = 
let
  val lens = List.map length lst
  val SOME max = Int.maxInt 
  fun min []        acc = acc
    | min (x :: xs) acc = 
    if x < acc then min xs x 
    else min xs acc

  val min_len = min lens max

  fun aux lst acc times = 
  let
    val next = if times > 0 then List.map hd lst else []
    val rest = if times > 0 then List.map tl lst else lst
  in
    if times > 0 then aux rest (next :: acc) (times-1)
    else acc
  end

in 
  rev (aux lst [] min_len)
end





















