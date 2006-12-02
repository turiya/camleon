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

let sr = 44100.;;

let generate_sinusoid_sample ~amp:a ~freq:freq ~sample:i =
  a *. (cos (a *. (freq /. sr) *. (float_of_int i) *. pi *. 2.));;

(* rounds a float to the nearest integer *)
let round f =
	if (f -. (floor f)) >= 0.5 then
		int_of_float (ceil f)
	else
		int_of_float (floor f);;

let spec_of_frequency ~freq:freq ~samples_per_second:sr ~spec_count:sc =
  int_of_float (floor ((freq *. (float_of_int sc)) /. sr));;

let frequency_of_spec ~spec:i ~samples_per_second:sr ~spec_count:sc =
  ((sr *. float_of_int i) /. float_of_int sc);;

(* return the index of the spectral bucket that sample i would
	fall into  when the total number of buckets is bc and the total
	number of samples is sc *)
let bucket_of_spec ~spec_count:sc ~bucket_count:bc ~spec:i = 
	let i = float_of_int i in
	let sc = float_of_int sc in
	let bc = float_of_int bc in
  int_of_float (floor ((i *. bc) /. sc));;
	(*int_of_float (floor (sqrt ((float_of_int i) *. (float_of_int n))));;*)

let spec_of_bucket ?(min_spec=0) ~spec_count:sc ?(max_spec=sc) ~bucket_count:bc ~bucket:b =
  let b = float_of_int b in
  let sc = float_of_int sc in
  let bc = float_of_int bc in
  min_spec + (int_of_float (floor ((b *. sc) /. bc)));;

let frequency_of_bucket ?(min=18.) ?(max=20000.) ~spec_count:sc ~bucket_count:bc ~bucket:b ~samples_per_second:sr =
	let min_spec = spec_of_frequency ~freq:min ~samples_per_second:sr, ~spec_count:sc in
	let max_spec = spec_of_frequency ~freq:max ~samples_per_second:sr, ~spec_count:sc in
  frequency_of_spec ~spec:(spec_of_bucket ~spec_count:sc ~bucket_count:bc ~bucket:b ~min_spec:min_spec ~max_spec:max_spec) 
										~samples_per_second:sr 
										~spec_count:sc;;
	
let rec bucketize spectrum buckets =
	let n = (Array1.dim buckets) in
	let s = (Array1floa.dim spectrum) in
	let buck = bucket_of_spec ~spec_count:s ~bucket_count:n in
	for i = 0 to s - 1 do
		let b = buck ~spec:i in
		buckets.{b} <- buckets.{b} +. abs_float spectrum.{i}
	done;;

let clear_buckets buckets =
	for i = 0 to (Array1.dim buckets) - 1 do buckets.{i} <- 0. done;;

let spectralize data ?(min=18.) ?(max=20000.) buckets =
	clear_buckets buckets;
  let n = Array1.dim buckets in
  let fa = fft data in
  let s = Array1.dim fa in
  let spectrum = Array1.sub (fft data) (spec_of_frequency ~freq:min ~samples_per_second:sr ~spec_count:s) 
    ((spec_of_frequency ~freq:max ~samples_per_second:sr ~spec_count:s) - (spec_of_frequency ~freq:min ~samples_per_second:sr ~spec_count:s)) in
  bucketize spectrum buckets;;
  
let print_spectrum ?(min=18.) ?(max=20000.) buckets ~spec_count:s =
	let n = Array1.dim buckets in
	for b = 0 to n - 1 do
		Printf.printf "%f\t%f\n" (frequency_of_bucket ~spec_count:s ~bucket:b ~bucket_count:n ~samples_per_second:sr) buckets.{b};
	done;;
  
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
