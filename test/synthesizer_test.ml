#use "../synthesizer.ml"

open OUnit
open Synth

let synth = new Synth.synthesizer ~samples_per_second:20 ()

let cmp_float_abs ?(delta=1e-16) a b =
	abs_float (a -. b) <= delta

let test_generate_sinusoid_sample _ =
	assert_equal ~cmp:(cmp_float_abs) ~printer:(string_of_float) 1. (synth#generate_sinusoid_sample 1. 0 1.);
	assert_equal ~cmp:(cmp_float_abs) ~printer:(string_of_float) 0.5 (synth#generate_sinusoid_sample 0.5 0 1.);
	assert_equal ~cmp:(cmp_float_abs) ~printer:(string_of_float) 0. (synth#generate_sinusoid_sample 1. 5 1.);
	assert_equal ~cmp:(cmp_float_abs) ~printer:(string_of_float) (-1.) (synth#generate_sinusoid_sample 1. 10 1.)

let test_generate_sinusoid_sample_for_multiple_frequencies _ =
	assert_equal ~cmp:(cmp_float_abs) ~printer:(string_of_float) 2. (synth#generate_sinusoid_sample_for_multiple_frequencies ~freqs:[1.;2.] 0);
	assert_equal ~cmp:(cmp_float_abs) ~printer:(string_of_float) 0. (synth#generate_sinusoid_sample_for_multiple_frequencies ~freqs:[1.;2.] 10)

let test_generate_sinusoid_samples _ =
	assert_equal ~printer:(string_of_int) 8192 (Array1.dim (synth#generate_sinusoid_samples [1.;2.;0.5]));
	let data = synth#generate_sinusoid_samples [1.] in
	assert_equal ~cmp:(cmp_float_abs) ~printer:(string_of_float) (-1.) data.{10}

let test_generate_sinusoid_samples_into_array _ =
	let data = Array1.create float64 c_layout 1000 in
	synth#generate_sinusoid_samples ~data:data [1.];
	assert_equal ~cmp:(cmp_float_abs) ~printer:(string_of_float) (-1.) data.{10}


let suite = "synthesizer tests" >::: ["test_generate_sinusoid_sample" >:: test_generate_sinusoid_sample;
																			"test_generate_sinusoid_sample_for_multiple_frequencies" >:: test_generate_sinusoid_sample_for_multiple_frequencies;
																			"test_generate_sinusoid_samples" >:: test_generate_sinusoid_samples;
																			"test_generate_sinusoid_samples_into_array" >:: test_generate_sinusoid_samples_into_array]

let _ =
	run_test_tt ~verbose:false suite
