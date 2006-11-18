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

let `SamplesPerSecond sr = 44100.;;

let generate_sinusoid_sample a `Hz freq i =
  a *. (cos (a *. (freq /. sr) *. (float_of_int i) *. pi *. 2.));;

(* rounds a float to the nearest integer *)
let round f =
	if (f -. (floor f)) >= 0.5 then
		int_of_float (ceil f)
	else
		int_of_float (floor f);;

let index_of_frequency `Hz freq `SamplesPerSecond sr n =
  int_of_float (floor ((freq *. (float_of_int n)) /. sr));;

let frequency_of_index `SampleIndex i `SamplesPerSecond sr n =
  ((sr *. float_of_int i) /. float_of_int n);;

(* return the index of the spectral bucket that sample i would
	fall into  when the total number of buckets is n and the total
	number of samples is s *)
let bucket_of_index `SampleCount s `BucketCount n `SampleIndex i = 
	let i = float_of_int i in
	let s = float_of_int s in
	let n = float_of_int n in
  `BucketIndex int_of_float ((floor ((i *. n) /. s)));;
	(*int_of_float (floor (sqrt ((float_of_int i) *. (float_of_int n))));;*)

let index_of_bucket `SampleCount s `BucketCount n `BucketIndex b =
  let b = float_of_int b in
  let s = float_of_int s in
  let n = float_of_int n in
  `SampleIndex int_of_float ((floor ((b *. s) /. n)));;

let frequency_of_bucket `SampleCount s `BucketCount n `BucketIndex b `SamplesPerSecond sr =
  `Hz frequency_of_index (index_of_bucket s n b) sr n;;
	
let rec bucketize spectrum buckets =
	let n = `BucketCount Array1.dim buckets in
	let s = `SampleCount Array1.dim spectrum in
	let buck = bucket_of_index s n in
	for i = 0 to s - 1 do
		let b = buck i in
		buckets.{b} <- buckets.{b} +. abs_float spectrum.{i}
	done;;

let clear_buckets buckets =
	for i = 0 to (Array1.dim buckets) - 1 do buckets.{i} <- 0. done;;

let spectralize data ?(min=18.) ?(max=20000.) buckets =
	clear_buckets buckets;
  let n = Array1.dim buckets in
  let fa = fft data in
  let s = Array1.dim fa in
  let spectrum = Array1.sub (fft data) (index_of_frequency min sampling_rate s) 
    ((index_of_frequency max sampling_rate s) - (index_of_frequency min sampling_rate s)) in
  bucketize spectrum buckets;;
  
let print_spectrum ?(min=18.) ?(max=20000.) buckets s =
	let n = Array1.dim buckets in
	for b = 0 to n - 1 do
		Printf.printf "%f\t%f\n" (frequency_of_bucket s b n sampling_rate n ~min:min ~ax:max) spectrum.{i};
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
