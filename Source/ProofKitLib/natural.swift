import LogicKit
import Foundation

public class Nat: ADT{
  public init(){
    super.init("Nat")
    self.add_generator("zero", Nat.zero)
    self.add_generator("succ", Nat.succ,arity: 1)
    self.add_operator("+", Nat.add, [
      Rule(Nat.add(Variable(named: "+.0.$0"), Value(0)),
                  Variable(named: "+.0.$0")),
             Rule(Nat.add(Variable(named: "+.1.$0"), Nat.succ(x: Variable(named: "+.1.$1"))),
                  Nat.succ(x: Nat.add(Variable(named: "+.1.$0"),Variable(named:"+.1.$1"))))
    ])
    self.add_operator("*", Nat.mul,[
      Rule(
        Nat.mul(Variable(named: "*.0.$0"), Nat.zero()),
        Nat.zero()
      ),
      Rule(
        Nat.mul(Variable(named: "*.1.$0"), Nat.succ(x: Variable(named: "*.1.$1"))),
        Nat.add(Variable(named: "*.1.$0"), Nat.mul(Variable(named: "*.1.$0"), Variable(named: "*.1.$1")))
      )
    ])
    self.add_operator("pre", Nat.pre,[
      Rule(
        Nat.pre(Nat.zero()),
        Nat.zero()
      ),
      Rule(
        Nat.pre(Nat.succ(x: Variable(named: "*.1.$0"))),
        Variable(named: "*.1.$0")
      )
    ])
    self.add_operator("-", Nat.sub,[
      Rule(
        Nat.sub(Variable(named: "*.0.$0"), Nat.zero()),
        Variable(named: "*.0.$0")
      ),
      Rule(
        Nat.sub(Nat.zero(), Variable(named: "*.1.$0")),
        Nat.zero()
      ),
      Rule(
        Nat.sub(Variable(named: "*.2.$0"), Nat.succ(x: Variable(named: "*.2.$1"))),
        Nat.pre(Nat.sub(Variable(named: "*.2.$0"), Variable(named: "*.2.$1")))
      )
    ])
    self.add_operator("<", Nat.lt,[
      Rule(
        Nat.lt(Variable(named: "*.0.$0"), Nat.zero()),
        Boolean.False()
      ),
      Rule(
        Nat.lt(Nat.zero(), Variable(named: "*.1.$0")),
        Boolean.True()
      ),
      Rule(
        Nat.lt(Nat.succ(x: Variable(named: "*.2.$0")), Nat.succ(x: Variable(named: "*.2.$1"))),
        Nat.lt(Variable(named: "*.2.$0"), Variable(named: "*.2.$1"))
      )
    ])
    self.add_operator(">", Nat.gt,[
      Rule(
        Nat.gt(Nat.zero(), Variable(named: "*.0.$0")),
        Boolean.False()
      ),
      Rule(
        Nat.gt(Variable(named: "*.1.$0"), Nat.zero()),
        Boolean.True()
      ),
      Rule(
        Nat.gt(Nat.succ(x: Variable(named: "*.2.$0")), Nat.succ(x: Variable(named: "*.2.$1"))),
        Nat.gt(Variable(named: "*.2.$0"), Variable(named: "*.2.$1"))
      )
    ])
    self.add_operator("%", Nat.mod,[
      Rule(
        Nat.mod(Variable(named: "*.0.$0"), Nat.zero()),
        vFail
      ),
      Rule(
        Nat.mod(Nat.zero(),  Variable(named: "*.1.$0")),
        Nat.zero()
      ),
      Rule(
        Nat.mod(Variable(named: "*.2.$0"), Variable(named: "*.2.$1")),
        Variable(named: "*.2.$0"),
        Nat.lt(Variable(named: "*.2.$0"), Variable(named: "*.2.$1"))
      ),
      Rule(
        Nat.mod(Variable(named: "*.3.$0"), Variable(named: "*.3.$1")),
        Nat.mod(Nat.sub(Variable(named: "*.3.$0"), Variable(named: "*.3.$1")), Variable(named: "*.3.$1"))
      )
    ])
    self.add_operator("/", Nat.div,[
      Rule(
        Nat.div(Variable(named: "*.0.$0"), Nat.zero()),
        vFail
      ),
      Rule(
        Nat.div(Variable(named: "*.1.$0"), Nat.succ(x: Variable(named: "*.1.$1"))),
        Nat.add(Variable(named: "*.1.$0"), Nat.mul(Variable(named: "*.1.$0"), Variable(named: "*.1.$1")))
      )
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

  public override func pprint(_ term: Term) -> String{
    return Nat.to_string(term)
  }

  public override func check(_ term: Term) -> Bool{
    if term.equals( Nat.zero()){
      return true
    }
    if let m = (term as? Map){
      return m["succ"] != nil
    }
    return false
  }

  public override func eval(_ t: Term) -> Term{
    if t.equals(Nat.zero()){
      return t
    }
    if let m = (t as? Map){
      let data = m["succ"]!
      return Nat.succ(x: ADTs.eval(data))
    }
    return t
  }

  static public func to_string(_ x: Term) -> String{
   	if x.equals(Nat.zero()){
   		return "0"
   	}
   	if let map = (x as? Map){
      if map["succ"] != nil{
        let k = Nat.to_string(map["succ"]!)
        let f = k.components(separatedBy:"+")
        if f.count == 0{
          return k
        }
        if f.count == 1{
          if let i = Int(k){
            return String(1+i)
          }
          return "succ(\(k))"
        }
        if f[0].characters.count == 0 {
     		   return "succ("+f[1]+")"
        }
        if let i = (Int(f[0])){
          return String(1+i)+" + "+f[1]
        }
        return "succ(\(k))"
      }
      return ADTs.pprint(map)
   	}
    if x is Variable {
      return "+"+ADTs.pprint(x)
    }
   	return ADTs.pprint(x)
  }

  public static func add(_ operands: Term...) -> Term{
      return Operator.n("+",operands[0], operands[1])
  }
  public static func mul(_ operands: Term...)-> Term{
    return Operator.n("*",operands[0], operands[1])
  }
  public static func pre(_ operands: Term...) -> Term{
    return Operator.n("pre", operands[0])
  }
  public static func sub(_ operands: Term...) -> Term{
    return Operator.n("-", operands[0], operands[1])
  }
  public static func div(_ operands: Term...) -> Term{
    return Operator.n("/", operands[0], operands[1])
  }
  public static func mod(_ operands: Term...) -> Term{
    return Operator.n("%", operands[0], operands[1])
  }
  public static func lt(_ operands: Term...) -> Term{
    return Operator.n("<", operands[0], operands[1])
  }
  public static func gt(_ operands: Term...) -> Term{
    return Operator.n(">", operands[0], operands[1])
  }
}
