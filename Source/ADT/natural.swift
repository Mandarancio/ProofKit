import LogicKit


let zero = Value("0")

func succ(_ x: Term) -> Map {
  return ["succ": x]
}

func is_even(what: Term) -> Goal {
    return (what === zero) ||
           delayed (fresh { x in
             what === succ(succ(x)) &&
             is_even(what:x)
           })
}
