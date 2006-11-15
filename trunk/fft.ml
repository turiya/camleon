(* Testing the FFTW interface *)

open Bigarray;;
open Printf;;
open List;;

let complex a b = { Complex.re = a; Complex.im = b }

let n = 8192;;
let fft = Fftw.r_create Fftw.forward n ~normalize:true;;


let pi = 4. *. atan 1.;;

let convert_to_decibels a =
  20. *. (log10 a);;

let normalize a =
  log a;;

let sampling_rate = 44100.;;

let generate_sinusoid_sample a freq i =
  a *. (cos (a *. (freq /. sampling_rate) *. (float_of_int i) *. pi *. 2.));;

(* return the index of the spectral bucket that sample i would
	fall into  when the total number of buckets is n and the total
	number of samples is s *)
let which_bucket i s n = 
  ((floor (float_of_int i /. float_of_int n) *. (s /. n)) ;;
	(*int_of_float (floor (sqrt ((float_of_int i) *. (float_of_int n))));;*)
	
let rec freq_bucket linear_spectrum i n =
	let s = Array1.dim linear_spectrum in
	let b = which_bucket i n in
	if b != which_bucket (i+1) n then
		linear_spectrum.{b}
	else
		linear_spectrum.{b} +. abs_float (freq_bucket linear_spectrum (i+1) n);;

let spectralize data spectrum ?(min=0) ?(max=(Array1.dim data)-1) =
  let n = Array1.dim spectrum in
  let linear_spectrum = fft data in(*Array1.sub (fa) min (max - min) in*)
	(* now we get logarithmic! *)
  for i = 0 to n - 1 do
    spectrum.{i} <- freq_bucket linear_spectrum i n
  done;;
  
let print_spectrum spectrum =
	let n = Array1.dim spectrum in
	for i = 0 to n - 1 do
		Printf.printf "%f\t%f\n" ((sampling_rate *. float_of_int i) /. float_of_int n) spectrum.{i};
	done;;


  
let print_tuple (x,y) =
  printf "%f , %f\n" x y;;

let print_data data =
  List.iter print_tuple data;;

(*let () =
  let a = Array1.create float64 c_layout n in
  let () =
    for i = 0 to n - 1 do
      a.{i} <- (generate_sinusoid_sample 1. 1000. i) 
        +. (generate_sinusoid_sample 1. 5000. i) 
        +. (generate_sinusoid_sample 1. 10000. i)
        +. (generate_sinusoid_sample 1. 20. i)
    done in
  print_data (spectralize a);*)
    (*printf "%f, %f\n" ((sampling_rate *. float_of_int i) /. float_of_int n) ((abs_float fa.{i}))*)
    (*printf "%i, %f\n" i a.{i}*)
