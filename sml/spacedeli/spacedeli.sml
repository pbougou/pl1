local
(* Read input and wrap it in a list of lists containing each line' s chars *)
fun parse input_file =
let

  fun read_chars (infile: string) =
  let
    val ins = TextIO.openIn infile
    fun helper (copt: char option) acc u =
        case copt of
          NONE =>(TextIO.closeIn ins; rev(acc))
        | SOME(c) => (helper (TextIO.input1 ins) (c::acc) u)
  in
     helper (TextIO.input1 ins) [] 1
  end

  val input_list = read_chars input_file

  fun create2D []        _    acc2    = rev acc2
   | create2D ((#"\n") :: xs) acc1 L  = create2D xs [] ((rev acc1) :: L)
   | create2D  (x :: xs)      acc1 L  = create2D xs (x :: acc1) L

  val list_of_lists = create2D input_list [] []
in
  (*Array2.fromList*) list_of_lists
end


(* Find coordinates of special chars in list of lists  *)  
fun find_s_or_e (ch :char) (x :: xs) line_cnt column_cnt =
let
  fun line (y : char) []        cnt = ~1
    | line y (x :: xs) cnt = if(x = y) then cnt else line y xs (cnt+1)
  
  val check_line = line ch x 0
in
  if (check_line < 0) then find_s_or_e ch xs (line_cnt+1) 0 else (line_cnt, check_line)
end

(* Some spagghetti code for dijkstra's algorithm *)
fun dijkstra map1 n m i_start j_start=
    let
        val queue          = Queue.mkQueue();
        val start_queue    = Queue.enqueue(queue,(i_start,j_start,true));
        val labels_w       = Array2.array(n,m,10000000);
        val labels_n       = Array2.array(n,m,10000000);
        val parents_n      = Array2.array(n,m,(10000000,1000000,false));
        val parents_w      = Array2.array(n,m,(10000000,1000000,false));
        val init_parents_w = Array2.update(parents_w, i_start, j_start, (~1,~1,true));
        val init           = Array2.update(labels_w,i_start,j_start,0);

        fun visit map  q labels_w labels_n parents_w parents_n n m=
            if (Queue.isEmpty q) then (labels_w, labels_n, parents_w, parents_n)
            else
                 let
                    val (i ,j, state ) = Queue.dequeue(q);
                    val (temp, temp1, cost, cost2, parents, parents2) = 
                      if(state = true) 
                      then (labels_w, labels_n, 2, 1, parents_w, parents_n) 
                      else (labels_n, labels_w, 1, 2, parents_n, parents_w)
                    val value          = Array2.sub(temp,i,j);
                    val value1         = Array2.sub(temp1,i,j);
(* No wormhole considered  *)
                    val neighboour     = if (i+1 < n andalso  (Array2.sub(temp,i+1,j) >Array2.sub(temp,i,j)+cost) andalso Array2.sub(map,i+1,j) <> #"X")
                                         then ( 
                                               Queue.enqueue(q,(i+1,j, state));
                                               Array2.update(temp,i+1,j,value+cost);
                                               Array2.update(parents,i+1,j,(i,j, state))
                                              )
                                         else()

                    val neighboour     = if (i-1 >= 0 andalso (Array2.sub(temp,i-1,j)> Array2.sub(temp,i,j)+cost) andalso Array2.sub(map,i-1,j) <> #"X")
                                         then( 
                                               Queue.enqueue(q,(i-1,j, state)); 
                                               Array2.update(temp,i-1,j,value+cost);
                                               Array2.update(parents,i-1,j,(i,j, state))
                                             )
                                         else()

                    val neighboour     = if (j+1 < m andalso (Array2.sub(temp,i,j+1)> Array2.sub(temp,i,j)+cost) andalso Array2.sub(map,i,j+1) <> #"X")  
                                         then( 
                                              Queue.enqueue(q,(i,j+1,state)); 
                                              Array2.update(temp,i,j+1,value+cost);
                                              Array2.update(parents,i,j+1,(i,j, state))
                                             )
                                         else()

                    val neighboour     = if (j-1 >= 0 andalso (Array2.sub(temp,i,j-1)> Array2.sub(temp,i,j)+cost) andalso Array2.sub(map,i,j-1) <> #"X")  
                                         then( 
                                              Queue.enqueue(q,(i,j-1,state)); 
                                              Array2.update(temp,i,j-1,value+cost);
                                              Array2.update(parents,i,j-1,(i,j, state))
                                             )
                                         else()
(* Wormhole considered *)
                    val which = Array2.sub(map, i, j)
                    val nothing = if(which = #"W") 
                                  then
										let

                    					val neighboour     = if (i+1 < n andalso  (Array2.sub(temp1,i+1,j) >Array2.sub(temp,i,j)+1+cost2 ) andalso Array2.sub(map,i+1,j) <> #"X")
                                           					 then ( 
                                                 					Queue.enqueue(q,(i+1,j, not state));
                                                 					Array2.update(temp1,i+1,j,value+1+cost2);
                                                                    Array2.update(parents2,i+1,j,(i,j, state))
                                                				  )
                                           					 else()
  
                      					val neighboour     = if (i-1 >= 0 andalso (Array2.sub(temp1,i-1,j)> Array2.sub(temp,i,j)+1+cost2) andalso Array2.sub(map,i-1,j) <> #"X")
                                           					 then( 
                                                 					Queue.enqueue(q,(i-1,j, not state)); 
                                                 					Array2.update(temp1,i-1,j,value+1+cost2);
                                                                    Array2.update(parents2,i-1,j,(i,j, state))
                                               					 )
                                           					 else()
  
                      					val neighboour     = if (j+1 < m andalso (Array2.sub(temp1,i,j+1)> Array2.sub(temp,i,j)+1+cost2) andalso Array2.sub(map,i,j+1) <> #"X")  
                                           					 then( 
                                                					Queue.enqueue(q,(i,j+1,not state)); 
                                                					Array2.update(temp1,i,j+1,value+1+cost2);
                                                                    Array2.update(parents2,i,j+1,(i,j,state))
                                               					 )
                                           					 else()
  
                      					val neighboour     = if (j-1 >= 0 andalso (Array2.sub(temp1,i,j-1)> Array2.sub(temp,i,j)+1+cost2) andalso Array2.sub(map,i,j-1) <> #"X")  
                                           					 then( 
                                                					Queue.enqueue(q,(i,j-1,not state)); 
                                                					Array2.update(temp1,i,j-1,value+1+cost2);
                                                                    Array2.update(parents2,i,j-1,(i,j,state))
                                               					 )
                                           					else()
										in 
											()
										end

                                  else()
                in
                    visit map q labels_w labels_n parents_w parents_n n m
                end

    in
        visit map1 queue labels_w labels_n parents_w parents_n n m
    end
(* Unravelling parents' arrays to find th movements  *)
fun unravel pw pn parents i_start j_start current res = 
let
  val (i, j, state) = current
  (* val parents = pw *)
  val par = Array2.sub(parents, i, j)
  val (par_i, par_j, par_state) = par
  val res1 = if(par_i = i-1 andalso par_j = j)
             then (#"D") :: res 

             else if(par_i = i+1 andalso par_j = j)
             then (#"U") :: res

             else if(par_i = i andalso par_j = j-1)
             then (#"R") :: res

             else if(par_i = i andalso par_j = j+1)
             then (#"L") :: res

			 else res

  val res2 = if(state <> par_state) then (#"W") :: res1 else res1
  val curr = (par_i, par_j, par_state)
  val parents = if(par_state = true) then pw else pn

in
  if(i = i_start andalso j = j_start andalso state = true) then res
  else unravel pw pn parents i_start j_start curr res2

end
in
fun spacedeli input_file =
let
    val inp_list = parse input_file
    val map = Array2.fromList inp_list
    val (i_start, j_start) = find_s_or_e (#"S") inp_list 0 0
    val (i_end, j_end) = find_s_or_e (#"E") inp_list 0 0
    val (n,m) = Array2.dimensions map
	val (w, n, par_w, par_n) = dijkstra map n m i_start j_start
    val current = (i_end, j_end, true)
	val char_list = unravel par_w par_n par_w i_start j_start current []
    val answer_string = implode char_list
in
	(Array2.sub(w, i_end, j_end), answer_string)
end
end
