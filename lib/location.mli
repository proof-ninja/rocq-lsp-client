module Json = Yojson.Basic

type position = {line: int; character: int}

type range = {start: position; end_: position}

val range_of_json : Json.t -> range

type location = {uri: string; range: range}

val json_of_position : position -> Json.t
