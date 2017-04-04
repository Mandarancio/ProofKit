import LogicKit


public struct Nat{
  //Generator
  static public func zero() -> Value<Int>{
    return Value(0)
  }

  static public func succ(x: Term) -> Map {
    return ["succ": x]
  }

  //Modifieur
  static  public  func is_even(y: Term) -> Goal{
    return (y === Nat.zero()) ||
            delayed(fresh {x in
              y === Nat.succ(x:Nat.succ(x:x)) &&
              Nat.is_even(y:x)
            })
  }

}
