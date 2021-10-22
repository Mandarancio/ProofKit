import SwiftKanren
import Foundation

public class Nat: ADT{
  public init(){
    super.init("Nat")

    self.add_generator("zero", Nat.zero)
    self.add_generator("succ", Nat.succ,arity: 1)

    self.add_operator("+", Nat.add, [
      Rule(Nat.add(Variable(named: "x"), Nat.zero()),
                  Variable(named: "x")),
             Rule(Nat.add(Variable(named: "x"), Nat.succ(Variable(named: "y"))),
                  Nat.succ(Nat.add(Variable(named: "x"),Variable(named:"y"))))
    ],["nat", "nat"])
    self.add_operator("*", Nat.mul,[
      Rule(
        Nat.mul(Variable(named: "x"), Nat.zero()),
        Nat.zero()
      ),
      Rule(
        Nat.mul(Variable(named: "x"), Nat.succ(Variable(named: "y"))),
        Nat.add(Variable(named: "x"), Nat.mul(Variable(named: "x"), Variable(named: "y")))
      )
    ],["nat", "nat"])
    self.add_operator("-", Nat.sub,[
      Rule(
        Nat.sub(Variable(named: "x"), Nat.zero()),
        Variable(named: "x")
      ),
      Rule(
        Nat.sub(Nat.zero(), Variable(named: "x")),
        Nat.zero()
      ),
      Rule(
        Nat.sub(Nat.succ(Variable(named: "x")), Nat.succ(Variable(named: "y"))),
        Nat.sub(Variable(named: "x"), Variable(named: "y"))
      )
    ],["nat", "nat"])
    self.add_operator("<", Nat.lt,[
      Rule(
        Nat.lt(Variable(named: "x"), Nat.zero()),
        Boolean.False()
      ),
      Rule(
        Nat.lt(Nat.zero(), Variable(named: "x")),
        Boolean.True()
      ),
      Rule(
        Nat.lt(Nat.succ(Variable(named: "x")), Nat.succ(Variable(named: "y"))),
        Nat.lt(Variable(named: "x"), Variable(named: "y"))
      )
    ],["nat", "nat"])
    self.add_operator(">", Nat.gt,[
      Rule(
        Nat.gt(Nat.zero(), Variable(named: "x")),
        Boolean.False()
      ),
      Rule(
        Nat.gt(Variable(named: "x"), Nat.zero()),
        Boolean.True()
      ),
      Rule(
        Nat.gt(Nat.succ(Variable(named: "x")), Nat.succ(Variable(named: "y"))),
        Nat.gt(Variable(named: "x"), Variable(named: "y"))
      )
    ],["nat", "nat"])
    self.add_operator("==", Nat.eq,[
      Rule(
        Nat.eq(Nat.zero(), Nat.zero()),
        Boolean.True()
      ),
      Rule(
        Nat.eq(Variable(named: "x"), Nat.zero()),
        Boolean.False()
      ),
      Rule(
        Nat.eq(Nat.zero(), Variable(named: "x")),
        Boolean.False()
      ),
      Rule(
        Nat.eq(Nat.succ(Variable(named: "x")), Nat.succ(Variable(named: "y"))),
        Nat.eq(Variable(named: "x"), Variable(named: "y"))
      )
    ],["nat", "nat"])
    self.add_operator("%", Nat.mod,[
      Rule(
        Nat.mod(Variable(named: "x"), Nat.zero()),
        vFail
      ),
      Rule(
        Nat.mod(Nat.zero(),  Variable(named: "x")),
        Nat.zero()
      ),
      Rule(
        Nat.mod(Variable(named: "x"), Variable(named: "y")),
        Variable(named: "x"),
        Nat.lt(Variable(named: "x"), Variable(named: "y"))
      ),
      Rule(
        Nat.mod(Variable(named: "x"), Variable(named: "y")),
        Nat.mod(Nat.sub(Variable(named: "x"), Variable(named: "y")), Variable(named: "y"))
      )
    ],["nat", "nat"])
    self.add_operator("gcd", Nat.gcd,[
      Rule(
        Nat.gcd(Nat.zero(), Variable(named: "x")),
        vFail
      ),
      Rule(
        Nat.gcd(Variable(named: "x"), Nat.zero()),
        vFail
      ),
      Rule(
        Nat.gcd(Variable(named: "x"), Variable(named: "x")),
        Variable(named: "x")
      ),
      Rule(
        Nat.gcd(Variable(named: "x"), Variable(named: "y")),
        Nat.gcd(Nat.sub(Variable(named: "x"), Variable(named: "y")), Variable(named: "y")),
        Nat.gt(Variable(named: "x"), Variable(named: "y"))
      ),
      Rule(
        Nat.gcd(Variable(named: "x"), Variable(named: "y")),
        Nat.gcd(Variable(named: "x"), Nat.sub(Variable(named: "y"), Variable(named: "x"))),
        Nat.gt(Variable(named: "y"), Variable(named: "x"))
      )
    ],["nat", "nat"])
    self.add_operator("/", Nat.div,[
      Rule(
        Nat.div(Variable(named: "x"), Nat.zero()),
        vFail
      ),
      Rule(
        Nat.div(Variable(named: "x"), Variable(named: "y")),
        Nat.zero(),
        Nat.lt(Variable(named: "x"), Variable(named: "y"))
      ),
      Rule(
        Nat.div(Variable(named: "x"), Variable(named: "y")),
        Nat.succ(
          Nat.div(
            Nat.sub(
              Variable(named: "x"),
              Variable(named: "y")
            ),
              Variable(named: "y")
          )
        ),
        Boolean.or(
          Nat.gt(Variable(named: "x"), Variable(named: "y")),
          Nat.eq(Variable(named: "x"), Variable(named: "y"))
        )

      )
    ],["nat", "nat"])
  }

  //Generator
  static public func zero(_:Term...) -> Term{
    return new_term(Value<Int>(0),"nat")
  }

  static public func succ(_ x: Term...) -> Term {
    return new_term(Map(["succ": x[0]]),"nat")
  }

  static public func n(_ x: Int) -> Term {
    if x==0{
      return Nat.zero()
    }
    var t = Nat.zero()
    for _ in 1..<x+1 {
      t = Nat.succ(t)
    }
    return t
  }

  static public func to_int(_ term:Term) -> Int {
    if let map = (value(term) as? Map){
      if map["succ"] != nil{
        let k = Nat.to_int(map["succ"]!)
        return k+1
      }
    }
    return 0
  }

  public class override func belong(_ x: Term) -> Goal{
    return (x === Nat.zero() || delayed(fresh {y in x === Nat.succ(y) && Nat.belong(y)}))
  }

  public override func pprint(_ term: Term) -> String{
    return Nat.to_string(term)
  }


  static public func to_string(_ x: Term) -> String{
     if x.equals(Nat.zero()){
       return "0"
     }
     if let map = (value(x) as? Map){
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
        if f[0].count == 0 {
            return "succ("+f[1]+")"
        }
        if let i = (Int(f[0])){
          return String(1+i)+" + "+f[1]
        }
        return "succ(\(k))"
      }
      return ADTm.pprint(map)
     }
    if x is Variable {
      return "+"+ADTm.pprint(x)
    }
     return ADTm.pprint(x)
  }

  public static func add(_ operands: Term...) -> Term{
      return Operator.n("+",operands[0], operands[1])
  }
  public static func mul(_ operands: Term...)-> Term{
    return Operator.n("*",operands[0], operands[1])
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
  public class func eq(_ operands: Term...) -> Term{
    return Operator.n("==", operands[0], operands[1])
  }
  public class func gcd(_ operands: Term...) -> Term{
    return Operator.n("gcd", operands[0], operands[1])
  }
}
