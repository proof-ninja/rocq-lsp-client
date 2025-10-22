module Json = Yojson.Basic

type position = {line: int; character: int}
let position_of_json json =
  let open Json.Util in
  let line = member "line" json |> to_int in
  let character = member "character" json |> to_int in
  {line; character}
let json_of_position {line; character}: Json.t =
  `Assoc [("line", `Int line); ("character", `Int character)]

type range = {start: position; end_: position}
let range_of_json json =
  let open Json.Util in
  let start = member "start" json |> position_of_json in
  let end_ = member "end" json |> position_of_json in
  {start; end_}

type location = {uri: string; range: range}
