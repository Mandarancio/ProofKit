import LogicKit
import Foundation

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
  static public func is_nat(_ x: Term) -> Goal{
    return (x === Nat.zero() || delayed(fresh {y in x === Nat.succ(x:y) && Nat.is_nat(y)}))
  }

  static public func count(_ x: Term) -> String{
   	if x.equals(Nat.zero()){
   		return "0"
   	}
   	if let map = (x as? Map){
      let k = Nat.count(map["succ"]!)
      let f = k.components(separatedBy:"+")
      if f.count == 1{
        return String(1+Int(k)!)
      }
      if f[0].characters.count == 0 {
   		   return "1+"+f[1]
      }
      return String(1+Int(f[0])!)+"+"+f[1]
   	}
    if x is Variable {
      return "+"+(x as! Variable).description
    }
   	return "+?"
  }

  public static func add(_ l: Term, _ r: Term) -> Map{
      let o =  Operator.n(l, r, "N+")
      return o
  }
}
