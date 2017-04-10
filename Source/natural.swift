import LogicKit

fileprivate func add_zero_left(_ x: Term,_ lhs: Term,_ rhs: Term) -> Goal {
   return Nat.is_nat(lhs) && rhs === Nat.zero()
}

fileprivate func add_zero_right(_ x: Term,_ lhs: Term,_ rhs: Term) -> Goal {
   return x === lhs
}

fileprivate func add_succ_left(_ x: Term,_ lhs: Term,_ rhs: Term) -> Goal {
   return Nat.is_nat(lhs) && delayed(fresh {y in rhs === Nat.succ(x: y)})
}

fileprivate func add_succ_right(_ x: Term,_ lhs: Term,_ rhs: Term) -> Goal {
   return delayed(fresh {
             y in rhs === Nat.succ(x: y) && delayed(fresh {
                   z in x === Nat.succ(x: z) && operation(z,lhs,y, Nat.Add.axioms)
               })
             })
}

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

  struct Add {
    public static let axioms : [[String: (Term, Term, Term) -> Goal]] = [
      [
        "left" : add_zero_left,
        "right": add_zero_right
      ],
      [
        "left" : add_succ_left,
        "right": add_succ_right
      ]
    ]
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

public func operation(_ z: Term, _ lhs: Term, _ rhs: Term,_ axioms:[[String: (Term, Term, Term) -> Goal]]) -> Goal{
  var g = (axioms[0]["left"]!(z,lhs,rhs) && axioms[0]["right"]!(z,lhs,rhs))
  for i in 1...axioms.count-1 {
    g = g || (axioms[i]["left"]!(z,lhs,rhs) && axioms[i]["right"]!(z,lhs,rhs))
  }
  return g
}
