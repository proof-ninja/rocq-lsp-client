open Rocq_lsp_client
open Client

let print_json json = print_endline @@ Json.pretty_to_string json

let () =
  Client.using begin fun conn ->
      let rootpath = Sys.getcwd() ^ "/sample/resources" in
      let filepath = rootpath ^ "/Foo.v" in

      initialize rootpath (`Assoc[]) conn |> print_json;
      initialized conn;
      set_trace "verbose" conn;
      did_open filepath conn;

      document_symbol filepath conn |> print_json;
      hover {line=0; character=11} filepath conn |> print_json;
      hover {line=0; character=12} filepath conn |> print_json;
      hover {line=1; character=7} filepath conn |> print_json;

      ()
    end
