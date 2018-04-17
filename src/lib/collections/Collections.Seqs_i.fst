module Collections.Seqs_i

let lemma_slice_first_exactly_in_append (#a:Type) (x y:seq a) :
  Lemma (slice (append x y) 0 (length x) == x) =
  let xy = append x y in
  let xy_slice = slice xy 0 (length x) in
  let x_slice = slice x 0 (length x) in
  assert(equal xy_slice x_slice);   // OBSERVE: extensionality
  ()

let lemma_all_but_last_append (#t:Type) (a:seq t) (b:seq t{length b > 0}) :
  Lemma (all_but_last (append a b) == append a (all_but_last b)) =
  let ab = all_but_last (append a b) in
  let app_a_b = append a (all_but_last b) in
  assert (equal ab app_a_b)  // OBSERVE: extensionality

let reverse_seq_append (#a:eqtype) (s:seq a) (t:seq a) : 
  Lemma(ensures reverse_seq (append s t) == append (reverse_seq t) (reverse_seq s))
  =
  assert (equal (reverse_seq (append s t)) (append (reverse_seq t) (reverse_seq s)))

let reverse_reverse_seq (#a:Type) (s:seq a) : 
  Lemma(ensures reverse_seq (reverse_seq s) == s)
  =
  assert (equal (reverse_seq (reverse_seq s)) s)

let rec seq_map_i_indexed (#a:Type) (#b:Type) (f:int->a->b) (s:seq a) (i:int) : 
  Tot (s':seq b { length s' == length s /\
                  (forall j . {:pattern index s' j} 0 <= j /\ j < length s ==> index s' j == f (i + j) (index s j))
                }) 
      (decreases (length s))
  =
  if length s = 0 then createEmpty
  else cons (f i (head s)) (seq_map_i_indexed f (tail s) (i + 1))

let seq_map_i (#a:Type) (#b:Type) (f:int->a->b) (s:seq a) : 
  Tot (s':seq b { length s' == length s /\
                  (forall j . {:pattern index s' j} 0 <= j /\ j < length s ==> index s' j == f j (index s j))
                })   
  = 
  seq_map_i_indexed f s 0

let seq_map_internal_associative (#a:Type) (#b:eqtype) (f:int->a->b) (s:seq a) (pivot:int{0 <= pivot /\ pivot < length s}) :
  Lemma (let left,right = split s pivot in
         seq_map_i f s == seq_map_i_indexed f left 0 @| seq_map_i_indexed f right pivot )
  =
  let left,right = split s pivot in
  let full_map = seq_map_i f s in
  let part1 = seq_map_i_indexed f left 0 in
  let part2 = seq_map_i_indexed f right pivot in
  assert (equal (seq_map_i f s) (seq_map_i_indexed f left 0 @| seq_map_i_indexed f right pivot));
  ()
