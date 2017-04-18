import LogicKit
import Foundation

public class Nat: ADT{
  public init(){
    super.init("Nat")
    self.add_generator("zero", Nat.zero)
    self.add_generator("false", Nat.succ,arity: 1)
    self.add_operator("+", Nat.add, [
      Rule(Nat.add(Variable(named: "+.0.$1"), Value(0)),
                  Variable(named: "+.0.$1")),
             Rule(Nat.add(Variable(named: "+.1.$1"), Nat.succ(x: Variable(named: "+.1.$2"))),
                  Nat.succ(x: Nat.add(Variable(named: "+.1.$1"),Variable(named:"+.1.$2"))))
    ])
  }
  
  //Generator
  static public func zero(_:Term...) -> Term{
    return Value<Int>(0)
  }

  static public func succ(x: Term...) -> Term {
    return Map(["succ": x[0]])
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
  public class override func belong(_ x: Term) -> Goal{
    return (x === Nat.zero() || delayed(fresh {y in x === Nat.succ(x:y) && Nat.belong(y)}))
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

  public static func add(_ operands: Term...) -> Term{
      let o =  Operator.n(operands[0], operands[1], "+")
      return o
  }
}
