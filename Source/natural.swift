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
  static  public func is_even(x: Term) -> Goal{
    return (x === Nat.zero()) ||
            delayed(fresh {y in
              x === Nat.succ(x:Nat.succ(x:y)) &&
              Nat.is_even(x:y)
            })
  }

  static public func is_nat(x: Term) -> Goal{
  	return (x === Nat.zero() || delayed(fresh {y in x === Nat.succ(x:y) && Nat.is_nat(x:y)}))
  }

  static public func count(_ x: Term) -> Int{
 	if x.equals(Nat.zero()){
 		return 0
 	}
 	if let map = (x as? Map){
 		return 1+Nat.count(map["succ"]!)
 	}
 	return -1
  }
  
}
