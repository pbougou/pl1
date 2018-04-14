datatype 'd tree = Empty | Leaf of 'd | Node of 'd * 'd tree * 'd tree;
val t1 = Node(4, Node(3, Leaf 2, Leaf 1), Node(3, Leaf 1, Leaf 2));
val t2 = Node(4, Node(3, Node(2, Node(4, Leaf 2, Leaf 3), Leaf 8), Leaf 1), Node(3, Leaf 1, Leaf 2));

fun is_AVL (Leaf n)         = true
  | is_AVL Empty            = true
  | is_AVL (Node (n,t1,t2)) = 
  let 
	fun max n m = if(n > m) then n else m
	  
    fun height Empty = 0
	  | height (Leaf n) = 1 
  	  | height (Node (n,t1,t2)) = 
	      1 + max (height (t1))  (height (t2))
        
    fun min n m = if(n <= m) then n else m
            
    val h1  = height t1
    val h2  = height t2
    val res = (max h1 h2) - (min h1 h2)

  in
      if(res < 1 andalso is_AVL t1 andalso is_AVL t2) then true else false   
  end
