module Math.Poly2.Lemmas_i

let lemma_zero_define () =
  FStar.Classical.forall_intro lemma_zero_define_i

let lemma_zero_degree () =
  lemma_degree zero;
  lemma_zero_define ()

let lemma_degree_negative a =
  let f (i:int) : Lemma (not a.[i]) =
    lemma_index_i a i
    in
  FStar.Classical.forall_intro f;
  lemma_zero_define ();
  lemma_equal a zero

let lemma_add_define a b =
  FStar.Classical.forall_intro (lemma_add_define_i a b)

let lemma_add_define_all () =
  FStar.Classical.forall_intro_2 lemma_add_define

let lemma_mul_distribute_left a b c =
  lemma_mul_commute (a +. b) c;
  lemma_mul_commute a c;
  lemma_mul_commute b c;
  lemma_mul_distribute c a b

let lemma_mul_distribute_right a b c = lemma_mul_distribute a b c

let lemma_mul_smaller_is_zero a b =
  lemma_mul_degree a b;
  (if degree a < 0 then lemma_degree_negative a);
  lemma_mul_zero b;
  lemma_mul_commute a b;
  ()

let lemma_mod_distribute a b c =
  let ab = a +. b in
  let a' = a /. c in
  let b' = b /. c in
  let ab' = ab /. c in
  let a'' = a %. c in
  let b'' = b %. c in
  let ab'' = ab %. c in
  lemma_div_mod a c;
  lemma_div_mod b c;
  lemma_div_mod ab c;
  lemma_mod_degree a c;
  lemma_mod_degree b c;
  lemma_mod_degree ab c;
  // (a +. b) == (a) +. (b)
  assert ((ab' *. c +. ab'') == (a' *. c +. a'') +. (b' *. c +. b''));
  lemma_add_define_all ();
  lemma_equal (ab' *. c +. a' *. c +. b' *. c) (ab'' +. a'' +. b'');
  lemma_mul_distribute_left ab' a' c;
  lemma_mul_distribute_left (ab' +. a') b' c;
  assert ((ab' +. a' +. b') *. c == ab'' +. a'' +. b'');
  lemma_add_degree ab'' a'';
  lemma_add_degree (ab'' +. a'') b'';
  lemma_mul_smaller_is_zero (ab' +. a' +. b') c;
  assert (ab'' +. a'' +. b'' == zero);
  lemma_zero_define ();
  lemma_equal ab'' (a'' +. b'');
  ()

let lemma_div_mod_unique a b x y =
  let x' = a /. b in
  let y' = a %. b in
  lemma_div_mod a b;
  lemma_mod_degree a b;
  assert (x *. b +. y == x' *. b +. y');
  lemma_add_define_all ();
  lemma_equal (x *. b +. x' *. b) (y +. y');
  lemma_mul_distribute_left x x' b;
  assert ((x +. x') *. b == y +. y');
  lemma_add_degree y y';
  lemma_mul_smaller_is_zero (x +. x') b;
  assert (y +. y' == zero);
  lemma_zero_define ();
  lemma_equal x x';
  lemma_equal y y';
  ()

let lemma_div_mod_exact a b =
  // (a *. b == a *. b +. zero)
  lemma_add_zero (a *. b);
  lemma_zero_degree ();
  lemma_div_mod_unique (a *. b +. zero) b a zero

let lemma_mod_small a b =
  lemma_mul_zero b;
  lemma_mul_commute b zero;
  lemma_add_zero a;
  lemma_add_commute a zero;
  lemma_div_mod_unique a b zero a

let lemma_mod_mod a b =
  lemma_mod_degree a b;
  lemma_mod_small (a %. b) b

let lemma_mod_cancel a =
  lemma_mul_one a;
  lemma_mul_commute a one;
  lemma_div_mod_exact one a

let lemma_mod_mul_mod a b c =
  let ab = a %. b in
  let abc = ab *. c in
  let ac = a *. c in
  let x = abc /. b in
  let y = abc %. b in
  let x' = ac /. b in
  let y' = ac %. b in
  lemma_div_mod abc b;
  lemma_div_mod ac b;
  lemma_mod_degree abc b;
  lemma_mod_degree ac b;
  // ab *. c == x *. b +. y
  // a *. c == x' *. b +. y'
  assert ((ab *. c) +. (a *. c) == (x *. b +. y) +. (x' *. b +. y'));
  lemma_mul_distribute_left ab a c;
  assert ((ab +. a) *. c == (x *. b +. y) +. (x' *. b +. y'));

  // prove that ab +. a is a multiple of b by proving (ab +. a) %. b == zero
  lemma_mod_distribute ab a b;
  lemma_mod_mod a b;
  lemma_add_cancel ab;
  lemma_div_mod (ab +. a) b;
  let z = (ab +. a) /. b in
  lemma_add_zero (z *. b);
  assert (ab +. a == z *. b);

  assert ((z *. b) *. c == (x *. b +. y) +. (x' *. b +. y'));
  lemma_mul_associate z b c;
  lemma_mul_commute b c;
  lemma_mul_associate z c b;
  assert ((z *. c) *. b == (x *. b +. y) +. (x' *. b +. y'));
  lemma_add_define_all ();
  lemma_equal ((z *. c) *. b +. x *. b +. x' *. b) (y +. y');
  lemma_mul_distribute_left (z *. c) x b;
  lemma_mul_distribute_left (z *. c +. x) x' b;
  assert ((z *. c +. x +. x') *. b == y +. y');
  lemma_add_degree y y';
  lemma_mul_smaller_is_zero (z *. c +. x +. x') b;
  lemma_add_cancel_eq y y';
  ()
