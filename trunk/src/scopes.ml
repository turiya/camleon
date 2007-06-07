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

class horizontal_bargraph ?(barsize=80) ?(maxval=1.) ~labels data =
	object (self)
		(* an array of strings, with each string representing one horizontal bar in the graph *)
		val buffer = Array.init (Array.length labels) (fun i -> ((Printf.sprintf "%7.1f " labels.(i)) ^ (String.make (barsize) ' ') ^ "]"))
		
		method label_margin_width = 8 + 1
		method buffer_width = barsize + self#label_margin_width

		(* clears the bars in the display buffer *)
		method clear_buffer =
			for i = 0 to Array.length buffer - 1 do
				String.fill buffer.(i) 8 (barsize) ' '
			done

		(* this is what the buffer initializer should be calling... but I can't figure out
			how to use an object's methods in its field initializers
			
		method init_bar i =
			(Printf.sprintf "%7.1f " labels.(i)) ^ (String.make (barsize) ' ')
		*)

		(* draws all of the bars for the values currently in the data array *)
		method update = 
			for i = 0 to Array1.dim data - 1 do
				try 
					String.fill buffer.(i) 8 (self#calc_width data.{i}) '%'
				with Invalid_argument "Val_out_of_range" -> String.fill buffer.(i) 8 barsize '!'
			done
	
		(* calculates the appropriate width for the bar (the "filled" width) based on the given value *)
		method calc_width v =
			if (v > maxval) then
				invalid_arg "Val_out_of_range"
			else
				int_of_float ((v /. maxval) *. float_of_int barsize)

		(* prints out all of the labels (mostly used for debugging) *)
		method print_labels =
			for i = 0 to Array.length labels - 1 do
				Printf.printf "%7.1f\n" labels.(i)
			done
		
		(* accessor for the display buffer (mostly used for debugging) *)
		method buffer = buffer

		(* clears the graph, updates it with the current data, and prints it *)
		method print =
			self#clear_buffer;
			self#update;
			for i = 0 to Array.length buffer - 1 do
				Printf.printf "%s\n" buffer.(i)
			done
	end;;
	
	
class spectroscope ?(barsize=80) ?(maxval=1.) ~freq_map spectrum =
	object (self)
		inherit horizontal_bargraph ~barsize:barsize ~maxval:maxval ~labels:freq_map spectrum
	end;;
end;;