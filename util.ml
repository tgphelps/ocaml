
let split_pat = Str.regexp "[ \t]+"


let split_option s =
    if String.contains s '=' then
        String.split_on_char '=' s
    else
        [s; ""]


let split s =
    Str.split split_pat s


let is_option arg =
    arg.[0] = '-' && (String.length arg) > 1


let parse_args program_args =
let arg_list = Array.to_list program_args in
List.partition is_option arg_list


let parse_options option_list =
    List.map split_option option_list

