module Arch.Types

open FStar.Mul
open Types_s
open Words_s
open Words.Four_s
open Words.Two_s

unfold let add_wrap32 (x:nat32) (y:nat32) : nat32 = add_wrap x y
unfold let add_wrap64 (x:nat64) (y:nat64) : nat64 = add_wrap x y

unfold let iand32 (a:nat32) (b:nat32) : nat32 = iand a b
unfold let ixor32 (a:nat32) (b:nat32) : nat32 = ixor a b
unfold let ior32 (a:nat32) (b:nat32) : nat32 = ior a b
unfold let inot32 (a:nat32) : nat32 = inot a
unfold let ishl32 (a:nat32) (s:int) : nat32 = ishl a s
unfold let ishr32 (a:nat32) (s:int) : nat32 = ishr a s

unfold let iand64 (a:nat64) (b:nat64) : nat64 = iand a b
unfold let ixor64 (a:nat64) (b:nat64) : nat64 = ixor a b
unfold let ior64 (a:nat64) (b:nat64) : nat64 = ior a b
unfold let inot64 (a:nat64) : nat64 = inot a
unfold let ishl64 (a:nat64) (s:int) : nat64 = ishl a s
unfold let ishr64 (a:nat64) (s:int) : nat64 = ishr a s

let lo64 (q:quad32) : nat64 = two_to_nat 32 (two_select (four_to_two_two q) 0)
let hi64 (q:quad32) : nat64 = two_to_nat 32 (two_select (four_to_two_two q) 1)
