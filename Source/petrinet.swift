import LogicKit

public struct Petrinet {
  //Generators
  static public func empty() -> Term {
    return Value<Int>(0)
  }

  static public func add_input(_ place: Term, _ transition: Term, _ weight: Term, _ subnet: Term) -> Term {
    return Map(["place": place, "transition": transition, "weight": weight, "subnet": subnet])
  }

  static public func add_output(_ transition: Term, _ place: Term, _ weight: Term, _ subnet: Term) -> Term {
    return Map(["transition": transition, "place": place, "weight": weight, "subnet": subnet])
  }

  //Modifiers

  static public func is_empty(_ x : Term) -> Goal{
    return x === Petrinet.empty()
  }

}

public func test_petrinets() {

  print("\nPetri Nets tests : \n")

  let net = Petrinet.add_input(Nat.n(1), Nat.n(1), Nat.n(1), Petrinet.empty())
  let x_net = Variable(named:"x_net")
  let goal_net = Petrinet.is_empty(x_net)

  print(net)

  for subs in solve (goal_net) {

    for (t, value) in subs.reified().prefix(100) {
      if (t == x_net){
        print("* \(t) \(value)")
      }
    }

  }
}
