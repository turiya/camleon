(* Testing the FFTW interface *)

open Bigarray;;
open Printf;;
open List;;

let complex a b = { Complex.re = a; Complex.im = b }

let n = 65536;;
let fft = Fftw.r_create Fftw.forward n ~normalize:true;;


let pi = 4. *. atan 1.;;

let convert_to_decibels a =
  20. *. (log10 a);;

let normalize a =
  log a;;

let sampling_rate = 22050.;;

let generate_sinusoid_sample a freq i =
  a *. (cos (a *. (freq /. sampling_rate) *. (float_of_int i) *. pi *. 2.));;

let spectralize samples spectrum ~sampling_rate ?(min=0) ?(max) =
  let n = Array1.dim spectrum in
  let fa = fft samples in
  for i = 0 to n - 1 do
    
  done;;
  
let 
  
let print_tuple (x,y) =
  printf "%f , %f\n" x y;;

let print_data data =
  List.iter print_tuple data;;

let () =
  let a = Array1.create float64 c_layout n in
  let () =
    for i = 0 to n - 1 do
      a.{i} <- (generate_sinusoid_sample 1. 1000. i) 
        +. (generate_sinusoid_sample 1. 5000. i) 
        +. (generate_sinusoid_sample 1. 10000. i)
        +. (generate_sinusoid_sample 1. 20. i)
    done in
  print_data (spectralize a);
    (*printf "%f, %f\n" ((sampling_rate *. float_of_int i) /. float_of_int n) ((abs_float fa.{i}))*)
    (*printf "%i, %f\n" i a.{i}*)
