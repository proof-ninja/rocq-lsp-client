open Common

(*https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#messageType *)
type t = Error | Warning | Info | Log | Debug [@@deriving show]

let of_int = function
  | 1 -> Error
  | 2 -> Warning
  | 3 -> Info
  | 4 -> Log
  | 5 -> Debug
  | other -> failwith (!%"unknown log message type: %d" other)
