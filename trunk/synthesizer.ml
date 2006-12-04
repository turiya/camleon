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

		method generate_sinusoid_samples ?(normalize=true) ?(data=Array1.create float64 c_layout 8192) frequencies =
			let n = Array1.dim data in
			let f = self#generate_sinusoid_sample_for_multiple_frequencies ~freqs:frequencies in
			for i = 0 to n - 1 do data.{i} <- f i done;
			if normalize then self#normalize data;
			data

		method normalize (data : (float, Bigarray.float64_elt, Bigarray.c_layout) Bigarray.Array1.t) =
			let m = self#find_max data in
			if m != 0. then
				for i = 0 to Array1.dim data - 1 do
					data.{i} <- data.{i} /. m
				done

			
		method find_max data =
			let rec loop data size i m =
				if i > (size - 1) then m
				else loop data size (i+1) (max m data.{i}) in
			loop data (Array1.dim data) 0 0.

				
	end;;
end;;
