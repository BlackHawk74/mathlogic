type expression = 
	| PropositionalVariable of char
	| Implication of expression * expression
	| Conjunction of expression * expression
	| Disjunction of expression * expression
	| Negation of expression 
	;;



type parse_tuple = {end_pos: int; result: expression}

let parse_expr input_string = 
	let rec parse_impl pos = 
		(* print_string ("parse_impl " ^ string_of_int(pos) ^ "\n"); *)
		let p2 = parse_disjunction pos in
		if (String.length input_string > p2.end_pos + 2) && (input_string.[p2.end_pos + 1] = '-') && (input_string.[p2.end_pos + 2] = '>') then
			let p3 = parse_impl (p2.end_pos + 3) in
			{end_pos = p3.end_pos; result = Implication(p2.result, p3.result)}
		else
			p2
	and
	parse_disjunction pos =
		(* print_string ("parse_disj " ^ string_of_int(pos) ^ "\n"); *)
		let p2 = parse_conjunction pos in
		if (String.length input_string > p2.end_pos + 1) && (input_string.[p2.end_pos + 1] = '|') then
			let p3 = parse_disjunction (p2.end_pos + 2) in
			{end_pos = p3.end_pos; result = Disjunction(p2.result, p3.result)}
		else
			p2
	and
	parse_conjunction pos = 
		(* print_string ("parse_conj " ^ string_of_int(pos) ^ "\n"); *)
		let p2 = parse_term pos in
		if (String.length input_string > p2.end_pos + 1) && (input_string.[p2.end_pos + 1] = '&') then
			let p3 = parse_conjunction (p2.end_pos + 2) in
			{end_pos = p3.end_pos; result = Conjunction(p2.result, p3.result)}
		else
			p2
	and
	parse_term pos = 
		(* print_string ("parse_term " ^ string_of_int(pos) ^ "\n"); *)
		if (input_string.[pos] >= 'A') && (input_string.[pos] <= 'Z') then begin
			(* print_string "PropVar\n"; *)
			{end_pos = pos; result = PropositionalVariable(input_string.[pos])} end
		else if input_string.[pos] = '!' then
			let p2 = parse_term (pos + 1) in
			{end_pos = p2.end_pos; result = Negation(p2.result)}
		else if input_string.[pos] = '(' then
			let p2 = parse_impl (pos + 1) in
			if input_string.[p2.end_pos + 1] = ')' then
				{end_pos = p2.end_pos + 1; result = p2.result}
			else
				raise (Failure ("Syntax error in expression, position: " ^ string_of_int(p2.end_pos)))
		else
			raise (Failure ("Syntax error in expression, position: " ^ string_of_int(pos)))
	in
	let parse_result = parse_impl 0 in
	if parse_result.end_pos = (String.length input_string - 1) then
		parse_result.result
	else raise (Failure ("Syntax error in expression, position: " ^ string_of_int(parse_result.end_pos)))
	;;