import gleam/result{Result}

pub fn is_boolean(v: v) -> Bool {
  let v = Result(v)

  case v {
    Bool -> True
    _ -> False
  }
}
