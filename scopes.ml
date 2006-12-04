open Bigarray
open Printf

module Scopes =
struct

class oscilloscope ?(barsize=80) ?(maxval=32767) () =
	object (self)
		val mutable bar = String.create barsize
		
		method clear_bar =
			String.fill bar 0 barsize ' '

		method set v =
			self#clear_bar;
			let halfbarsize = int_of_float ((float_of_int barsize) /. 2.0) in
			let width = int_of_float (((float_of_int v) /. float_of_int maxval) *. float_of_int halfbarsize) in
			let start = halfbarsize + width in 
			begin
				try
					String.fill bar (if start < halfbarsize then start else halfbarsize) (abs width) '%';
				with Invalid_argument e -> 
					String.fill bar 0 barsize '!';
			end;
			String.fill bar halfbarsize 1 '|'

		method bar = bar

		(* the default transformer here assumes that incoming values are floats in the range 0. to 1. *)
		method print_data ?(transform=fun v -> int_of_float (32767. *. v)) (data : (float, Bigarray.float64_elt, Bigarray.c_layout) Bigarray.Array1.t) =
			for i = 0 to Array1.dim data - 1 do
				self#set (transform data.{i});
				Printf.printf "%s\n" self#bar
			done

	end;;

class spectroscope ?(barsize=80) ?(maxval=1.) ~freq_map spectrum =
	object (self)
		val display = Array.init (Array.length freq_map) (fun i -> ((Printf.sprintf "%7.1f " freq_map.(i)) ^ (String.make (barsize) ' ') ^ "]"))
		val display_width = barsize + 8 + 1

		method clear_display =
			for i = 0 to Array.length display - 1 do
				String.fill display.(i) 8 (barsize) ' '
			done

		method init_bar i =
			(Printf.sprintf "%7.1f " freq_map.(i)) ^ (String.make (barsize) ' ')

		method update = 
			for i = 0 to Array1.dim spectrum - 1 do
				try 
					String.fill display.(i) 8 (self#calc_width spectrum.{i}) '%'
				with Invalid_argument "Val_out_of_range" -> String.fill display.(i) 8 barsize '!'
			done
	
		method calc_width v =
			if (v > maxval) then
				invalid_arg "Val_out_of_range"
			else
				int_of_float ((v /. maxval) *. float_of_int barsize)

		method print_freq_map =
			for i = 0 to Array.length freq_map - 1 do
				Printf.printf "%7.1f\n" freq_map.(i)
			done

		method print =
			self#clear_display;
			self#update;
			for i = 0 to Array.length display - 1 do
				Printf.printf "%s\n" display.(i)
			done

	end;;
end;;
