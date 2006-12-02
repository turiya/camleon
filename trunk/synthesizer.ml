open Bigarray

module Synth =
struct

class synthesizer ?(samples_per_second=44100) () =
	object (self)
		
		val pi = 4. *. atan 1.


		method generate_sinusoid_sample amp i freq =
			amp *. (cos (amp *. (freq /. float_of_int samples_per_second) *. (float_of_int i) *. pi *. 2.))

		method generate_sinusoid_sample_for_multiple_frequencies ~freqs i =
			List.fold_left (+.) 0. (List.map (self#generate_sinusoid_sample 1.0 i) freqs)

		method generate_sinusoid_samples ?(n=8192) frequencies =
			let a = Array1.create float64 c_layout n in
			let f = self#generate_sinusoid_sample_for_multiple_frequencies ~freqs:frequencies in
			for i = 0 to n - 1 do a.{i} <- f i done;
			a

				
	end;;
end;;
