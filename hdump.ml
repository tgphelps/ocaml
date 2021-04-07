
(** Traditional hex/ASCII file dump utility. *)

let dump_offset = ref 0
let dump_length = ref max_int
let dump_fname = ref ""


(** Print the nex/ASCII dump of the open file 'f'. *)
let rec print_formatted_dump offset len f =
  if len = 0 then
    ()
  else
    let buff = Bytes.create 16 in
    let bytes_this_time = min len 16 in
    let bytes_read = input f buff 0 bytes_this_time in
      match bytes_read with
      | 0 -> ()
      | _ ->
      Printf.printf "%06x " offset;
      print_endline (Hex.dump_line bytes_read buff);
      print_formatted_dump (offset + bytes_read) (len - bytes_this_time) f


(** Open file, seek if needed, print dump, and close it. *)
let dump_file file_name offset len = 
  let f = open_in_bin file_name in
  if offset > 0 then
    seek_in f offset;
  print_formatted_dump offset len f;
  close_in f;;

(* -------------- *)

let abort_need_filename () =
  raise (Arg.Bad "You must specify exactly one filename");;


let do_filename fname =
  match !dump_fname with
  | "" -> dump_fname := fname
  | _  -> abort_need_filename ();;


let main =
  let speclist = [
    ("-o", Arg.Set_int dump_offset, "Sets starting file offset");
    ("-n", Arg.Set_int dump_length, "Sets number of bytes to dump");
  ]
  in let usage_msg = "Hex (and ASCII) file dumper. Options available:"
  in Arg.parse speclist do_filename usage_msg;
    if !dump_fname = "" then
      abort_need_filename ();
    dump_file !dump_fname !dump_offset !dump_length


let () = main
