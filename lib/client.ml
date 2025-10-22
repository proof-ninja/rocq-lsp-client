open Common
module Json = Yojson.Basic

type conn = in_channel * out_channel * in_channel

let request_id_data = ref 0
let request_id () =
  incr request_id_data; !request_id_data

type response =
  | NotificationResponse of {method_: string; params: Json.t}
  | ResultResponse of {request_id: int; result: Json.t}

let response_of_json json =
  let open Json.Util in
  match member "method" json |> to_string_option with
  | Some method_ ->
     let params = member "params" json in
     NotificationResponse {method_; params}
  | None ->
     let request_id = member "id" json |> to_int in
     let result = member "result" json in
     ResultResponse {request_id; result}

let show_response = function
  | NotificationResponse r ->
     !%"[%s]: %s" r.method_ (Json.pretty_to_string r.params)
  | ResultResponse r ->
     !%"[%d]: %s" r.request_id (Json.pretty_to_string r.result)

let wait_response (i, _o, _e) =
  let line = input_line i in (* Content-Length: N\r\n *)
  Scanf.sscanf line "Content-Length: %d" (fun len ->
      input_line i |> ignore; (* empty line *)
      let s = really_input_string i len in
      Json.from_string s
      |> response_of_json)

let rec wait_result_response ?(verbose=false) conn =
  match wait_response conn with
  | NotificationResponse _ as res ->
     if verbose then prerr_endline (show_response res);
     wait_result_response conn
  | ResultResponse r -> (r.request_id, r.result)


let send json (_i, o, _e) =
  let content = Json.to_string json in
  let len = String.length content in
  !%"Content-Length: %d\r\nContent-Type: \"application/vscode-jsonrpc; charset=utf8\"\r\n\r\n%s"
    len content
  |> Stdlib.output_string o;
  flush o

let send_notification method_ params conn =
  let message: Json.t =
    `Assoc [
        "jsonrpc", `String "2.0";
        "method",  `String method_;
        "params",  params;
      ]
  in
  send message conn

let send_request method_ params conn =
  let req_id = request_id () in
  let message : Json.t =
    `Assoc [
        "jsonrpc", `String "2.0";
        "method",  `String method_;
        "id",      `Int req_id;
        "params",  params;
      ]
  in
  send message conn;
  let (id, result) = wait_result_response conn in
  if id <> req_id then prerr_endline (!%"Unexpected id: (expected)%d <> %d" req_id id);
  result

let initialize rootpath options conn =
  let params: Json.t = `Assoc [
(*                           "processId", `Int 123;*)
                           "rootUri", `String ("file://" ^ rootpath);
                           "initializationOptions", options;
                         ]
  in
  send_request "initialize" params conn

let initialized conn =
  send_notification "initialized" (`Assoc []) conn

let did_open filepath conn =
  let code = read_lines filepath |> String.concat "\n" in
  let params = `Assoc [
                   "textDocument", `Assoc [
                                       "uri", `String ("file://" ^ filepath);
                                       "languageId", `String "coq";
                                       "version", `Int 1;
                                       "text", `String code;
                                     ]
                 ]
  in
  send_notification "textDocument/didOpen" params conn

let hover position filepath conn =
  let uri = "file://" ^ filepath in
  let params: Json.t = `Assoc [
                           "textDocument", `Assoc ["uri", `String uri];
                           "position", Location.json_of_position position;
                         ]
  in
  send_request "textDocument/hover" params conn

let document_symbol filepath conn =
  let uri = "file://" ^ filepath in
  let params: Json.t = `Assoc [
                           "textDocument", `Assoc ["uri", `String uri];
                         ]
  in
  send_request "textDocument/documentSymbol" params conn


let coq_getDocument filepath conn =
  let versionedTextDocumentIdentifier : Json.t =
    `Assoc[("uri", `String (!%"file://%s" filepath)); ("version", `Int 1)]
  in
  let params = `Assoc ["textDocument", versionedTextDocumentIdentifier] in
  send_request "coq/getDocument" params conn

let set_trace trace_mode conn =
  let params  = `Assoc ["value", `String trace_mode] in
  send_notification "$/setTrace" params conn

let coq_lsp_command = "coq-lsp --lsp_trace"

let using f = Command.using coq_lsp_command f
