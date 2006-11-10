(* Testing the FFTW interface *)

open Bigarray;;
open Printf;;

let complex a b = { Complex.re = a; Complex.im = b }

let n = 64;;
let fft = Fftw.r_create Fftw.forward n;;

let pi = 4. *. atan 1.;;

let () =
  let a = Array1.create float64 c_layout n in
  let () =
    for i = 0 to n - 1 do
      a.{i} <- (cos ((float_of_int i) *. 0.5))
    done in
  let fa = fft a in
    for i = 0 to n - 1 do
      printf "%f, %f\n" (1. /. float_of_int i) (abs_float fa.{i})
			(*printf "%i, %f\n" i a.{i}*)
    done;
