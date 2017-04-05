import LogicKit


public struct Nat{
  //Generator
  static public func zero() -> Term{
    return Value<Int>(0)
  }

  static public func succ(x: Term) -> Term {
    return Map(["succ": x])
  }

  static public func n(_ x: Int) -> Term {
  	if x==0{
  		return Nat.zero()
  	}
  	
    var t = Nat.zero()
	for _ in 1..<x+1 {
		t = Nat.succ(x: t)
	}
	return t
  	
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
