val using : string -> (in_channel * out_channel * in_channel -> 'a) -> 'a
val send : out_channel -> string -> unit
