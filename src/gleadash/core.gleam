pub fn identity(e: e) -> e {
  e
}

pub fn constant(e: e) -> fn(b) -> e {
  fn(_: b) { e }
}

pub fn noop() -> Nil {
  Nil
}
