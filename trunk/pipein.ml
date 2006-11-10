open Scopes;;

let unsigned_twobyte_to_signed b =
	if b > 32767 then ((b - 65536)) else b;;

let twobyte_to_int c1 c2 =
	(* data is little endian, so the first byte is the small one *)
  unsigned_twobyte_to_signed	
	(((int_of_char c2) lsl 8) lor int_of_char c1);;

let read_frame i buf =
	(twobyte_to_int (String.get buf i) (String.get buf (i+1)),
	 twobyte_to_int (String.get buf (i+2)) (String.get buf (i+3)));;

let oscilloscope_left =
	let osc = ref (new Scopes.oscilloscope ()) in !osc;;
let oscilloscope_right =
	let osc = ref (new Scopes.oscilloscope ()) in !osc;;
	
let visualize_frame (left,right) =
	oscilloscope_left#set left;
	oscilloscope_right#set right;
	print_string (oscilloscope_left#bar ^ oscilloscope_right#bar ^ "\n");;

let rec visualize_buffer buf pos =
	if (pos < ((String.length buf) - 4)) then begin 
		visualize_frame (read_frame pos buf);
		visualize_buffer buf (pos + 4*8)
	end;;

let pipein () =
  let buf = String.create 256 in
	
	while true do
		let _ = Unix.read Unix.stdin buf 0 256 in
		visualize_buffer buf 0;
	done;;

let () =
	pipein ();;
