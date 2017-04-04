import LogicKit


public struct Nat: Term{

  fileprivate let value: Int

  private init(_ val: Int) {
    self.value = val
  }

  public func getValue() -> Int{
    return self.value
  }

  //Generator
  static public func zero() -> Nat{
    return Nat(0)
  }

  static public func succ(x: Nat) -> Nat {
    return Nat(x.getValue()+1)
  }

  //Modifieur
  public func is_even() -> Goal{
    return (self === Nat.zero()) ||
            delayed(fresh {x in
              self === Nat.succ(x:Nat.succ(x:x)) &&
              x.is_even()
            })
  }

  // public func is_even() -> Bool {
  //
  //   if x.getValue() == 0 {
  //     return true
  //   }
  //   else{
  //     return !self.is_even(x:dec(x:x))
  //   }
  // }

  public func equals(_ other: Term) -> Bool {
      if let rhs = (other as? Nat) {
          return rhs.value == self.value
      }
      return false
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
