
let print_option l =
    print_string (List.nth l 0);
    print_string " = ";
    print_endline (List.nth l 1)

    
let do_this_file options fname =
    if fname <> "-" then begin
        let f = open_in fname in
        let eof = ref false in
        let num = ref 0 in
        while !eof = false do
            try
                let line = input_line f in
                incr num;
                User.for_each_func fname !num line
            with End_of_file ->
                eof := true
        done;
        close_in f
    end else begin
        let eof = ref false in
        let num = ref 0 in
        while !eof = false do
            try
                let line = read_line () in
                incr num;
                User.for_each_func fname !num line
            with End_of_file -> 
                eof := true
        done
    end


(* Call the function with (filename, relative lineno, line). *)

let process_lines files options =
    (* List.iter (fun x -> print_string ("file: " ^ x ^ "\n")) files *)
    List.iter (do_this_file options) files


let main =
    let num_args = Array.length Sys.argv - 1 in
    let option_list, file_list = Util.parse_args (Array.sub Sys.argv 1 num_args) in

    let options = Util.parse_options option_list in
    List.iter print_option options;

    User.first_func options;
    if file_list <> [] then
        process_lines file_list options
    else
        process_lines ["-"] options;
    User.last_func options


let () = main
