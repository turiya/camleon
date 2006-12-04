open Bigarray;;
open Printf;;
open Fftw;;

module Analysis =
struct

class spectralizer ?(logarithmic=true) ?(min_freq=20.) ?(max_freq=18000.) ?(bands=32) ?(samples_per_second=44100) data =
	object (self)
		val sr = float_of_int samples_per_second (* samples_per_second (i.e. the sampling rate), as a flaot, for convenience *)

		val sc = Array1.dim data (* total number of discrete frequency components ("specs") that the fft will return, which happens to
																		be the same as the total size of the pcm_data input array *)

		(*val specs = Array1.create float64 c_layout sc;;*) (* the array where the result of the fast fourier transform will be placed *)

		val buckets = Array1.create float64 c_layout bands (* after the specs array is filled by the fft operation, the data is then 
																														aggregated, normalized, scaled, and filled into this array; in other
																														words this is where the final product of the spectralizer analysis is placed *)

		val bucket_to_freq_map = Array.make bands 0. (* mapping of the frequencies stored in each bucket -- each element here corresponds
																											to the floor frequency of each bucket; that is, if bucket_frequencies.(3) = 20. and 
																											bucket_frequencies.(4) = 80., then buckets.{3} represents the aggregated fft value for 
																											frequencies between 20 and 80 Hz (>= 20 and < 80) *)

		val fft = Fftw.r_create Fftw.forward (Array1.dim data) ~normalize:true

		initializer self#map_buckets

		method bucket_to_frequency_mapper i =
			if logarithmic then self#logarithmic_bucket_to_frequency_mapper i else self#linear_bucket_to_frequency_mapper i

		method logarithmic_bucket_to_frequency_mapper i =
				(* this is a simplified version of the more general formula: 
					(bands^(curve-1)floor(i))^(1/curve) * ((max_freq - min_freq) / bands) + min_freq *)
				(float_of_int (i * i)) *. ((max_freq -. min_freq) /. (float_of_int (bands * bands))) +. min_freq

		method linear_bucket_to_frequency_mapper i =
				((float_of_int i) *. ((max_freq -. min_freq) /. (float_of_int bands))) +. min_freq
		
		(* the frequency in Hz represented by the discrete frequency component -- the "spec" -- at index i *)
		method frequency_of_spec i =
			(sr *. float_of_int i) /. float_of_int sc

		(* the index of the discrete frequency component ("spec") that corresponds to the given frequency *)
		method spec_of_frequency freq =
			int_of_float (floor ((freq *. (float_of_int sc)) /. sr))

		(* the minimum frequency represented by the bucket at the given index *)
		method frequency_of_bucket i =
			let f = self#bucket_to_frequency_mapper in
			f i

		(* searches the bucket_to_freq_map for the index of the bucket that represents the given frequency *)
		method bucket_of_frequency ?(i=bands-1) freq =
			assert (i >= 0);
			assert (i < bands);
			if bucket_to_freq_map.(i) <= freq then
				i
			else
				self#bucket_of_frequency freq ~i:(i-1)

		(* the index of the bucket that would aggregate the value of the spec at the given index *)
		method bucket_of_spec i =
			self#bucket_of_frequency (self#frequency_of_spec i)

		method map_buckets =
			for i = 0 to bands - 1 do
				let freq = self#frequency_of_bucket i in
				bucket_to_freq_map.(i) <- freq;
			done

		method clear_buckets =
			for i = 0 to (Array1.dim buckets) - 1 do buckets.{i} <- 0. done

		method spectralize =
			self#clear_buckets;
			let specs = fft data in
			let first_spec_uncorrected = self#spec_of_frequency min_freq in
			let first_spec = if (self#frequency_of_spec first_spec_uncorrected) < (self#frequency_of_bucket 0)
												then first_spec_uncorrected + 1 
												else first_spec_uncorrected in
			for i = first_spec to self#spec_of_frequency max_freq do
				let b = self#bucket_of_spec i in
				buckets.{b} <- buckets.{b} +. (abs_float specs.{i})
			done

		method bucket_to_freq_map = bucket_to_freq_map

		method buckets = buckets

		method print_bucket_to_freq_map =
			for i = 0 to bands - 1 do
				Printf.printf "%i\t%f\n" (i) (bucket_to_freq_map.(i))
			done

		method print_bands =
			for i = 0 to bands - 1 do
				Printf.printf "%f\t%f\n" (self#frequency_of_bucket i) buckets.{i}
			done

		method spectrum_as_tuples ?(i=0) () =
			if i < Array.length bucket_to_freq_map then
				(bucket_to_freq_map.(i), buckets.{i}) :: self#spectrum_as_tuples ~i:(i+1) ()
			else []
				

	end;;
end;;
