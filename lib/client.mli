module Json = Yojson.Basic

type conn

val using: (conn -> 'a) -> 'a

val initialize: string -> Json.t -> conn -> Json.t
val initialized : conn -> unit
val set_trace : string -> conn -> unit
val did_open : string -> conn -> unit

val document_symbol : string -> conn -> Json.t
val hover : Location.position -> string -> conn -> Json.t
val coq_getDocument : string -> conn -> Json.t
