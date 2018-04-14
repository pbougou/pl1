fun inc1Seqs [] = []
   | inc1Seqs (l :: ls) =
let
   	fun add_list f n = n :: f
   	fun keep_searching (l::s) [] = (rev (l::s), [])
   	  | keep_searching (l::s) (h::t) = 
   	      if l = h-1 then keep_searching (h::l::s) t else (rev (l::s), (h::t))
   	      
   	fun search (l::ls) fl = 
   	let
   	   val (nl, rest) = keep_searching [l] ls
   	in
   	   if null rest then add_list fl nl
   	   else search rest (add_list fl nl)
   	end
in
   List.rev (search (l::ls) [])
end

