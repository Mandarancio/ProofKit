import LogicKit

//Generator
let zero = Value("0")

func succ(x: Term) -> Map {
  return ["succ": x]
}

succ(x: zero)

func add(x: Term, y: Term) ->

func is_even(what: Term) -> Goal {
    return (what === zero) ||
           delayed (fresh { x in
             what === succ(x:succ(x:x)) &&
             is_even(what:x)
           })
}
