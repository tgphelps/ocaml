
let max_bytes = 16
let buff_len = 3 * max_bytes

let hc = "0123456789abcdef"

(** Convert a char to its printable representation. *)
let asciify c =
  if Char.code c < 32 || Char.code c > 126 then '.' else c


(** Return a printable hex representation of a buffer. *)
let hex_bytes len s =
  let buffer = Bytes.make buff_len ' ' in
    for n = 0 to (len - 1) do
(*
    This old code was MUCH slower.
    let c = Char.code (Bytes.get s n) in
    let h = Printf.sprintf "%02x " c in
*)
      let h = Bytes.make 3 ' ' in
      let code = Char.code (Bytes.get s n) in
        Bytes.set h 0 (hc.[code lsr 4]);
        Bytes.set h 1 (hc.[code land 15]);
        Bytes.blit h 0 buffer (n * 3) 3
    done;
  Bytes.to_string buffer


(** Convert a buffer to its printable ASCII representation. *)
let ascii_bytes len s =
  if len = max_bytes then
    Bytes.map asciify s
  else
    Bytes.map asciify (Bytes.sub s 0 len)


(** Create a printable line of hex and ASCII for a buffer. *)
let dump_line len s = 
  assert (len > 0);
  assert (len <= 16);
  (hex_bytes len s)^ "   " ^ (Bytes.to_string (ascii_bytes len s));;
