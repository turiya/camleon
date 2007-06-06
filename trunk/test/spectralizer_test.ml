#use "synthesizer.ml"
#use "spectralizer.ml"

open OUnit
open Synth
open Analysis

let sr = 44100
let min_freq = 20.
let max_freq = 18000.
let bands = 32
let samples = 8192
let frequencies = [30.;800.;2000.;12000.]

let synth = new Synth.synthesizer ~samples_per_second:sr ()
let spect_factory = new Analysis.spectralizer ~min_freq:min_freq ~max_freq:max_freq ~bands:bands
let data = synth#generate_sinusoid_samples frequencies
let spect = spect_factory data

let cmp_float_abs ?(delta=1e-16) a b =
	abs_float (a -. b) <= delta

let test_spec_to_frequency_conversions _ =
	assert_equal ~printer:(string_of_int) 0 (spect#spec_of_frequency 0.);
	assert_equal ~printer:(string_of_int) samples (spect#spec_of_frequency (float_of_int sr))

let suite = "spectralizer tests" >::: ["test_spec_to_frequency_conversions" >:: test_spec_to_frequency_conversions]

let _ =
	run_test_tt ~verbose:false suite
