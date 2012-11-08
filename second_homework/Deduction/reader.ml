let read_lines filename =
	let lines = ref [] in
	let fi = open_in filename in
	try
		while true do
			let line = input_line fi in
			if not(line = "") then
				lines := (input_line fi) :: !lines
		done; ("", [])
	with End_of_file ->
			close_in fi;
			match !lines with
			| x::xs -> (x, List.rev xs)
			| [] -> failwith "File is empty"
;;

let parse_problem str =
	let replaced = Str.global_replace (Str.regexp " ") "" str in
	if not(Str.string_match (Str.regexp "^\\([A-Z|&>-]+\\(,[A-Z|&>-]+\\)*\\)?:-[A-Z|&>-]+$") replaced 0) then
		raise (Failure "String does not match the rule")
	else
		let splitted = List.rev (Str.split (Str.regexp "\\(,\\|:-\\)") replaced) in
		match splitted with
			| x::xs -> (x, xs)
			| [] -> failwith "O_o"
;;