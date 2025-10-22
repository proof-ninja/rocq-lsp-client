open Common

let send o input =
  output_string o input; flush o

let warn msg = prerr_endline msg

let close command ioe =
  match Unix.close_process_full ioe with
  | Unix.WEXITED 0 -> ()
  | WEXITED other ->
     warn (!%"Command '%s': exit %d" command other)
  | WSIGNALED signal ->
     warn (!%"Command '%s': killed by a signal:%d" command signal)
  | WSTOPPED signal ->
     warn (!%"Command '%s': stopped by a signal:%d" command signal)

let using command f =
  let env = Unix.environment () in
  let (i, o, e) = Unix.open_process_full command env in
  try
    let y = f (i, o, e) in
    close command (i, o, e);
    y
  with
  | exn ->
     close command (i, o, e);
     raise exn
