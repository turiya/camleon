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
	end;;
end;;
