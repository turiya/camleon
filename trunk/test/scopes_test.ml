#use "scopes.ml"

open OUnit
open Scopes

let bars = 10;;
let width = 20;;

(* create data array with 10 elements *)
let data = Array1.create float64 c_layout bars;;

(* labels are consecutive numbers from 0.0 to 0.9 *)
let labels = Array.init (Array1.dim data) (fun i -> (float i));;

(* we use this to generate instances of the horizontal_bargraph *)
let hb_factory = new Scopes.horizontal_bargraph ~barsize:width ~maxval:1. ~labels:labels;;

(* populate data with consecutive floats from 0.0 to 1.0 *)
for i = 0 to Array1.dim data - 1 do 
	data.{i} <- ((float i) /. (float (Array1.dim data))) 
done;;

let cmp_float_abs ?(delta=1e-16) a b =
	abs_float (a -. b) <= delta

let assert_equal_strings expected actual =
	assert_equal ~msg:(expected ^ "' != '" ^ actual) expected actual

let test_buffer_init _ =
	let hb = hb_factory data in
	assert_equal ~printer:(string_of_int) bars (Array.length hb#buffer);
	assert_equal ~printer:(string_of_int) (width + hb#label_margin_width) (String.length hb#buffer.(0));
	for i = 0 to bars - 1 do
		let expected = "    " ^ (string_of_int i) ^ ".0                     ]" in 
		assert_equal_strings expected hb#buffer.(i);
	done
	
let test_calc_width _ =
	let hb = hb_factory data in
	assert_equal ~printer:(string_of_int) 0 (hb#calc_width 0.);
	assert_equal ~printer:(string_of_int) 20 (hb#calc_width 1.);
	assert_equal ~printer:(string_of_int) 10 (hb#calc_width 0.5)
	
let test_update _ =
	let hb = hb_factory data in
	hb#update;
	assert_equal_strings "    0.0                     ]" hb#buffer.(0);
	assert_equal_strings "    1.0 %%                  ]" hb#buffer.(1);
	assert_equal_strings "    9.0 %%%%%%%%%%%%%%%%%%  ]" hb#buffer.(9)
	

let suite = "spectralizer tests" >::: ["test_buffer_init" >:: test_buffer_init;
										"test_calc_width" >:: test_calc_width;
										"test_update" >:: test_update]

let _ =
	run_test_tt ~verbose:false suite
