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

  //operation
  // + * - / %
  // struct add {
  // }
  // Add
  // Nat + Nat -> Nat
  // x+0=x
  // Term + nat.zero() = x
  // x+s(y)=s(x+y)

  // y = lhs+rhs
  // nat = nat + nat
  // if rhs == 0 => y === lhs ?
  // else y ===
  static public func add(_ y: Term,_ lhs: Term,_ rhs: Term) -> Goal{
      return Nat.is_nat(y) && Nat.is_nat(lhs) && Nat.is_nat(rhs) &&
        ((rhs === Nat.zero() && y === lhs) ||
        delayed(fresh {x in y === Nat.succ(x:x) && delayed(fresh {
          z in rhs === Nat.succ(x:z) && Nat.add(x,lhs,z)
        })
      }))
  }

  static public func is_nat(_ x: Term) -> Goal{
    // x == 0 || exists y such that (x == s(y) and y is nat)
  	return (x === Nat.zero() || delayed(fresh {y in x === Nat.succ(x:y) && Nat.is_nat(y)}))
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
