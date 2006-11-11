(* Testing the FFTW interface *)

open Bigarray;;
open Printf;;

let complex a b = { Complex.re = a; Complex.im = b }

let n = 256;;
let fft = Fftw.r_create Fftw.forward n ~normalize:true;;

let pi = 4. *. atan 1.;;

let convert_to_decibels a =
  20. *. (log10 a);;

let normalize a =
  log a;;

let sampling_rate = 44100;;

let sinusoid a freq i =
  amp *. (cos (sampling_rate *. a *. freq *. (float_of_int i) *. pi *. 2.));;
   

let () =
  let a = Array1.create float64 c_layout n in
  let () =
    for i = 0 to n - 1 do
      a.{i} <- (cos ((float_of_int i) *. (1. /. 2.) *. pi *. 2.))
        +. (cos ((float_of_int i) *. (1. /. 8.) *. pi *. 2.))
        +. (1.0 *. (cos ((float_of_int i) *. (1. /. 4.) *. pi *. 2.)))
    done in
  let fa = fft a in
    for i = 0 to (n - 1) do
      printf "%f, %f\n" (float_of_int i /. float_of_int n) ((abs_float fa.{i}))
			(*printf "%i, %f\n" i a.{i}*)
    done;
