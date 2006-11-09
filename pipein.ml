let twobyte_to_int c1 c2 =
	(* data is little endian, so small byte comes first *)
	((lsl) (int_of_char c1) 8) + int_of_char c2;;

let pipein () =
  let buf = String.create 256 in
	while true do
		let read = Unix.read Unix.stdin buf 0 256 in
			Printf.printf "%i\t%i\t%!" (int_of_char (String.get buf 0))(int_of_char (String.get buf 1));
			Printf.printf "%i\t%i\t%!" (int_of_char (String.get buf 2))(int_of_char (String.get buf 3));
			Printf.printf "%i\t%i\t%!" (int_of_char (String.get buf 4))(int_of_char (String.get buf 5));
			Printf.printf "%i\t%i\n%!" (int_of_char (String.get buf 6))(int_of_char (String.get buf 7))
	done;;

let () =
	pipein ();;
