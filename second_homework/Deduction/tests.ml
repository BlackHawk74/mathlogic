open Parser ;;
open Reader ;;

let failed_count = ref 0;;

let test test_num func =
	print_string ("Test" ^ string_of_int(test_num) ^ "\n");
	try
		func ();
		print_string "Test passed\n";
		();
	with Assert_failure e ->
			failed_count := !failed_count + 1;
			print_string "Test failed\n";
			();;

(* Propositional vars *)
test 1 (fun () ->
				assert (parse_expr "A" = PropositionalVariable('A')) ;
				assert (parse_expr "A" != PropositionalVariable('B')) ;
				assert ("A" = string_of_expression (PropositionalVariable('A')));)
;;

(* Implication *)
test 2 (fun () ->
				assert (parse_expr "A->B" = Implication(PropositionalVariable('A'), PropositionalVariable('B')));
				assert (parse_expr "A->B->C" =
					Implication(
						PropositionalVariable('A'),
						Implication(PropositionalVariable('B'), PropositionalVariable('C')))) ;
				assert ("(A->B)" = string_of_expression (Implication(PropositionalVariable('A'), PropositionalVariable('B')))) ;);;

(* Disjunction *)
test 3 (fun () ->
				assert (parse_expr "A|B" = Disjunction(PropositionalVariable('A'), PropositionalVariable('B'))) ;
				assert ("(A|B)" = string_of_expression (Disjunction(PropositionalVariable('A'), PropositionalVariable('B')))) ;
	);;

(* Conjunction *)
test 4 (fun () ->
				assert (parse_expr "A&B" = Conjunction(PropositionalVariable('A'), PropositionalVariable('B'))) ;
				assert ("(A&B)" = string_of_expression (Conjunction(PropositionalVariable('A'), PropositionalVariable('B')))) ;
	);;

(* Negation *)
test 5 (fun () ->
				assert (parse_expr "!A" = Negation(PropositionalVariable('A'))) ;
				assert ("!A" = string_of_expression (Negation(PropositionalVariable('A')))) ;
	);;

(* Brackets *)
test 6 (fun () ->
				assert (parse_expr "(A->B)->C" =
					Implication(
						Implication(PropositionalVariable('A'), PropositionalVariable('B')),
						PropositionalVariable('C')
					)) ;
	);;

(* Combination *)
test 7 (fun () ->
				assert (parse_expr "A->(!(B&C|D->A)|A&!C->!X)" =
					Implication(
						PropositionalVariable('A'),
						Implication(
							Disjunction(
								Negation(
									Implication(
										Disjunction(
											Conjunction(
												PropositionalVariable('B'),
												PropositionalVariable('C')),
											PropositionalVariable('D')),
										PropositionalVariable('A')
									)
								),
								Conjunction(
									PropositionalVariable('A'),
									Negation(PropositionalVariable('C')))
							),
							Negation(PropositionalVariable('X'))
						)
					)
				);
	);;

(* Problem parser *)
test 8 (fun () ->
				assert (parse_problem "A -> B, B -> C :- A -> C" = ("A->C", ["B->C"; "A->B"]));
	);;

print_string ("Testing finished. Failed: " ^ (string_of_int !failed_count));;