import gleadash/predicats
import gleam/dynamic
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn is_boolean_predicate_test() {
  let true_dyn = dynamic.bool(True)
  let false_dyn = dynamic.bool(False)
  let int_dyn = dynamic.int(42)
  let str_dyn = dynamic.string("ok")
  let nil_dyn = dynamic.nil()

  assert predicats.is_boolean(true_dyn)
  assert predicats.is_boolean(false_dyn)
  assert predicats.is_boolean(int_dyn) == False
  assert predicats.is_boolean(str_dyn) == False
  assert predicats.is_boolean(nil_dyn) == False
}

pub fn is_int_predicate_test() {
  let int_dyn = dynamic.int(42)
  let zero_dyn = dynamic.int(0)
  let str_dyn = dynamic.string("false")
  let nil_dyn = dynamic.nil()

  assert predicats.is_number(int_dyn) == True
  assert predicats.is_number(zero_dyn) == True
  assert predicats.is_number(str_dyn) == False
  assert predicats.is_number(nil_dyn) == False
}
