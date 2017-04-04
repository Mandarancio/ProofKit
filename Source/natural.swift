import LogicKit



class Nat{

  //Generator
  static let zero = Value("0")

  static func succ(x: Term) -> Map {
    return ["succ": x]
  }

}

//print(lol)

//func add(x: Term, y: Term) ->

/*func is_even(what: Term) -> Goal {
    return (what === zero) ||
           delayed (fresh { x in
             what === succ(x:succ(x:x)) &&
             is_even(what:x)
           })
}*/
