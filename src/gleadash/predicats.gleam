import gleam/dynamic
import gleam/dynamic/decode
import gleam/result

pub fn is_boolean(value: dynamic.Dynamic) -> Bool {
  decode.run(value, decode.bool) |> result.is_ok
}
